//
//  SQDataCenter.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/5/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import "SQDataCenter.h"
#import "NSString+MD5.h"

NSString *const HLArticlesDidUpdateNotification = @"HLArticlesDidUpdateNotification";
NSString *const HLJokesDidUpdateNotification = @"HLJokesDidUpdateNotification";
NSString *const HLNovelsDidUpdateNotification = @"HLNovelsDidUpdateNotification";
NSString *const HLSeedsDidUpdateNotification = @"HLSeedsDidUpdateNotification";
NSString *const HLPhotosDidUpdateNotification = @"HLPhotosDidUpdateNotification";

#define kCheckUpdateListURL @"http://115.29.18.185/Resources/ProjectAA/CheckUpdateList.plist"

@interface SQDataCenter ()

@property (nonatomic, retain) ASINetworkQueue *downloadQueue;

@end

@implementation SQDataCenter

#pragma mark - Instance Methods

- (void) checkUpdateList
{
    [self getResourcesFromURL:kCheckUpdateListURL resourceType:HLResourceAddresses resourceInfo:nil];
}

- (NSString *) downloadDictionaryTmpFolder
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"TmpFiles"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO)
    {
        NSError *err = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        if (err != nil)
        {
            PAError(@"%@.", err);
        }
    }
    return path;
}

- (NSString *) workspace
{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"workspace"];
}

- (NSString *) articlesFullPath
{
    return [[[self workspace] stringByAppendingPathComponent:@"articles"] stringByAppendingPathComponent:@"articles.plist"];
}

- (NSString *) jokesFullPath
{
    return [[[self workspace] stringByAppendingPathComponent:@"jokes"] stringByAppendingPathComponent:@"jokes.plist"];
}

- (NSString *) novelsFullPath
{
    return [[[self workspace] stringByAppendingPathComponent:@"novels"] stringByAppendingPathComponent:@"novels.plist"];
}

- (NSString *) seedsFullPath
{
    return [[self workspace] stringByAppendingPathComponent:@"seeds"];
}

- (NSString *) photosFullPath
{
    return [[self workspace] stringByAppendingPathComponent:@"photos"];
}

- (NSString *) localResourceVersionPath
{
    return [[self workspace] stringByAppendingPathComponent:@"localResourceVersionInfo"];
}

- (NSDictionary *) localResourcesVersionInfo
{
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:[self localResourceVersionPath]];
    return info;
}

- (void) setLocalResourcesVersionInfo:(NSDictionary *) info
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self localResourceVersionPath]])
    {
        [[NSFileManager defaultManager] removeItemAtPath:[self localResourceVersionPath] error:NULL];
    }
    [info writeToFile:[self localResourceVersionPath] atomically:YES];
}

- (void) getResourcesFromURL:(NSString *) urlString resourceType:(HLResourceType) resourceType resourceInfo:(NSObject *) info;
{
    NSString *path = [self downloadDictionaryTmpFolder];
    NSString *downloadPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[NSString md5HashValueWithString:urlString]]];
    NSString *tempPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.tmp",[NSString md5HashValueWithString:urlString]]];
    NSURL *url = [NSURL URLWithString:urlString];
    //创建请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;//代理
    [request setDownloadDestinationPath:downloadPath];//下载路径
    [request setTemporaryFileDownloadPath:tempPath];//缓存路径
    [request setAllowResumeForFileDownloads:NO];//断点续传
    request.downloadProgressDelegate = self;//下载进度代理
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    [self.downloadQueue addOperation:request];//添加到队列，队列启动后不需重新启动
    if (nil != info)
    {
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:urlString,@"url", @(resourceType), @"resourceType", info, @"info", nil];
    }
    else
    {
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:urlString,@"url", @(resourceType), @"resourceType", nil];
    }
}

- (void) saveStringResourceFromRequest:(ASIHTTPRequest *) request
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destPath = nil;
    NSString *resourceKey = nil;
    int type = [[request.userInfo objectForKey:@"resourceType"] intValue];
    if (HLResourceArticles == type)
    {
        destPath = [self articlesFullPath];
        resourceKey = @"Articles";
    }
    else if (HLResourceJokes == type)
    {
        destPath = [self jokesFullPath];
        resourceKey = @"Jokes";
    }
    else if (HLResourceNovels == type)
    {
        destPath = [self novelsFullPath];
        resourceKey = @"Novels";
    }
    else
    {
        return;
    }
    if ([fileManager fileExistsAtPath:destPath])
    {
        [fileManager removeItemAtPath:destPath error:nil];
    }
    
    NSDictionary *resources = [NSDictionary dictionaryWithContentsOfFile:request.downloadDestinationPath];
    if (nil == resources)
    {
        PAWarning(@"the %@ download from server is invalied, server's url is:%@", resourceKey, request.url);
    }
    else
    {
        [fileManager createDirectoryAtPath:[destPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        if ([resources writeToFile:destPath atomically:YES])
        {
            NSMutableDictionary *localInfo = [NSMutableDictionary dictionaryWithDictionary:[self localResourcesVersionInfo]];
            [localInfo setObject:[request.userInfo objectForKey:@"info"] forKey:resourceKey];
            [self setLocalResourcesVersionInfo:localInfo];
        }
        else
        {
            PAWarning(@"save %@ to dest path:[%@] failed !", resourceKey, destPath);
        }
    }
}

- (void) saveZipResourceFromRequest:(ASIHTTPRequest *) request
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destPath = nil;
    NSString *resourceKey = nil;
    int type = [[request.userInfo objectForKey:@"resourceType"] intValue];

    if (HLResourceSeeds == type)
    {
        destPath = [self seedsFullPath];
        resourceKey = @"Seeds";
    }
    else if (HLResourcePhotos == type)
    {
        destPath = [self photosFullPath];
        resourceKey = @"Photos";
    }
    
    if ([fileManager fileExistsAtPath:destPath])
    {
        [fileManager removeItemAtPath:destPath error:nil];
    }
    NSString *zipPath = request.downloadDestinationPath;
    ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:zipPath];
    if (1 != [archive inflateToDirectory:[destPath stringByAppendingPathComponent:@"tmp"] usingResourceFork:YES])
    {
        PAError(@"unzrchive %@ files occur an error.", resourceKey);
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HLSeedsDidUpdateNotification object:nil];
    NSMutableDictionary *localInfo = [NSMutableDictionary dictionaryWithDictionary:[self localResourcesVersionInfo]];
    [localInfo setObject:[request.userInfo objectForKey:@"info"] forKey:resourceKey];
    [self setLocalResourcesVersionInfo:localInfo];
}

#pragma mark - ASIHTTPRequestDelegate:

- (void) requestStarted:(ASIHTTPRequest *) request
{
    int flag = [[request.userInfo objectForKey:@"resourceType"] intValue];
    if (HLResourceAddresses == flag)
    {
    }
    else if (HLResourceArticles == flag)
    {
        
    }
    else if (HLResourcePhotos == flag)
    {
        
    }
    else if (HLResourceJokes == flag)
    {
        
    }
    else if (HLResourceNovels == flag)
    {
        
    }
    else if (HLResourceSeeds == flag)
    {
        
    }
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    int flag = [[request.userInfo objectForKey:@"resourceType"] intValue];
    if (HLResourceAddresses == flag)
    {
        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:request.downloadDestinationPath];
        if (nil == info)
        {
            PAError(@"the resourceVersionInfo from server is invalid!");
            return;
        }
        PAInfo(@"get new version Info:\n", info);
        NSDictionary *localInfo = [self localResourcesVersionInfo];
        // check Articles
        NSDictionary *articles = [info objectForKey:@"Articles"];
        NSString *newArticles = [[articles allKeys] lastObject];
        NSString *oldArticles = [[[localInfo objectForKey:@"Articles"] allKeys] lastObject];
        if (NO == [newArticles isEqualToString:oldArticles])
        {
            NSString *url = [articles objectForKey:newArticles];
            PAInfo(@"Articles did update on server, version:%@", newArticles);
            [self getResourcesFromURL:url resourceType:HLResourceArticles resourceInfo:articles];
        }
        
        // check Jokes
        NSDictionary *jokes = [info objectForKey:@"Jokes"];
        NSString *newJokes = [[jokes allKeys] lastObject];
        NSString *oldJokes = [[[localInfo objectForKey:@"Jokes"] allKeys] lastObject];
        if (NO == [newJokes isEqualToString:oldJokes])
        {
            NSString *url = [jokes objectForKey:newJokes];
            PAInfo(@"Jokes did update on server, version:%@", newJokes);
            [self getResourcesFromURL:url resourceType:HLResourceJokes resourceInfo:jokes];
        }
        
        // check Novels
        NSDictionary *novels = [info objectForKey:@"Novels"];
        NSString *newNovels = [[novels allKeys] lastObject];
        NSString *oldNovels = [[[localInfo objectForKey:@"Novels"] allKeys] lastObject];
        if (NO == [newNovels isEqualToString:oldNovels])
        {
            NSString *url = [novels objectForKey:newNovels];
            PAInfo(@"Novels did update on server, version:%@", newNovels);
            [self getResourcesFromURL:url resourceType:HLResourceNovels resourceInfo:novels];
        }
        
        // check seeds
        NSDictionary *seeds = [info objectForKey:@"Seeds"];
        NSString *newSeeds = [[seeds allKeys] lastObject];
        NSString *oldSeeds = [[[localInfo objectForKey:@"Seeds"] allKeys] lastObject];
        if (NO == [newSeeds isEqualToString:oldSeeds])
        {
            NSString *url = [seeds objectForKey:newSeeds];
            PAInfo(@"Seeds did update on server, version:%@", newSeeds);
            [self getResourcesFromURL:url resourceType:HLResourceSeeds resourceInfo:seeds];
        }
        
        // check photos
        NSDictionary *photos = [info objectForKey:@"Photos"];
        NSString *newPhotos = [[photos allKeys] lastObject];
        NSString *oldPhotos = [[[localInfo objectForKey:@"Photos"] allKeys] lastObject];
        if (NO == [newPhotos isEqualToString:oldPhotos])
        {
            NSString *url = [photos objectForKey:newPhotos];
            PAInfo(@"Photos did update on server, version:%@", newPhotos);
            [self getResourcesFromURL:url resourceType:HLResourcePhotos resourceInfo:photos];
        }
    }
    else if (HLResourceArticles == flag ||
             HLResourceNovels == flag ||
             HLResourceJokes == flag)
    {
        [self saveStringResourceFromRequest:request];
    }
    else if (HLResourceSeeds == flag ||  
             HLResourcePhotos == flag)
    {
        [self saveZipResourceFromRequest:request];
    }
}

- (void) requestFailed:(ASIHTTPRequest *) request
{
    int flag = [[request.userInfo objectForKey:@"resourceType"] intValue];
    PAError(@"download %d failed with error:%@, useinfo:%@", flag, request.error, request.userInfo);
}

#pragma mark - Singleton Methods

static SQDataCenter *_shareDataCenter = nil;

+ (void) initialize
{
	if (nil == _shareDataCenter && self == [SQDataCenter class])
	{
		_shareDataCenter = [[self alloc] init];
        
	}
}

+ (SQDataCenter *) shareDataCenter
{
	return _shareDataCenter;
}

+ (id) allocWithZone:(NSZone *) zone
{
	@synchronized(self)
	{
		if (_shareDataCenter)
		{
			return [_shareDataCenter retain];
		}
		else
		{
			return [super allocWithZone:zone];
		}
	}
	return nil;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.downloadQueue = [[[ASINetworkQueue alloc] init] autorelease];
        [self.downloadQueue setShowAccurateProgress:YES];
        [self.downloadQueue go];
    }
    
    return self;
}

- (id) copyWithZone:(NSZone *) zone
{
	return self;
}

- (id) retain
{
	return self;
}

- (NSUInteger) retainCount
{
	return UINT_MAX;
}

- (oneway void) release
{
	// do nothing;
}

- (id) autorelease
{
	return self;
}

@end
