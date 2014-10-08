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
    [self getResourcesFromURL:kCheckUpdateListURL resourceType:nil resourceInfo:nil];
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
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Workspace"];
}

- (NSString *) articlesFullPath
{
    return [[[self workspace] stringByAppendingPathComponent:@"Articles"] stringByAppendingPathComponent:@"Articles.plist"];
}

- (NSString *) jokesFullPath
{
    return [[[self workspace] stringByAppendingPathComponent:@"Jokes"] stringByAppendingPathComponent:@"Jokes.plist"];
}

- (NSString *) novelsFullPath
{
    return [[[self workspace] stringByAppendingPathComponent:@"Novels"] stringByAppendingPathComponent:@"Novels.plist"];
}

- (NSString *) seedsFullPath
{
    return [[self workspace] stringByAppendingPathComponent:@"Seeds"];
}

- (NSString *) photosFullPath
{
    return [[self workspace] stringByAppendingPathComponent:@"Photos"];
}

- (NSString *) favoriteResourcesPath
{
    return [[self workspace] stringByAppendingPathComponent:@"Favorites"];
}

- (NSString *) favoriteSeedsResourcesFullPath
{
    return [[self favoriteResourcesPath] stringByAppendingPathComponent:@"Seeds"];
}

- (NSString *) favoritePhotosResourcesFullPath
{
    return [[self favoriteResourcesPath] stringByAppendingPathComponent:@"Photos"];
}

- (NSString *) localResourceVersionPath
{
    return [[self workspace] stringByAppendingPathComponent:@"LocalResourceVersionInfo"];
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

- (void) getResourcesFromURL:(NSString *) urlString resourceType:(NSString *) resourceType resourceInfo:(NSObject *) info;
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
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:urlString,@"url", resourceType, @"resourceType", info, @"info", nil];
    }
    else
    {
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:urlString,@"url", nil];
    }
}

- (void) saveStringResourceFromRequest:(ASIHTTPRequest *) request
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destPath = nil;
    NSString *resourceKey = nil;
    NSString *type = request.userInfo[@"resourceType"];
    NSString *notificationName = nil;
    if ([type isEqualToString:kResourceArticleType])
    {
        destPath = [self articlesFullPath];
        resourceKey = kResourceArticleType;
        notificationName = HLArticlesDidUpdateNotification;
    }
    else if ([type isEqualToString:kResourceJokeType])
    {
        destPath = [self jokesFullPath];
        resourceKey = kResourceJokeType;
        notificationName = HLJokesDidUpdateNotification;
    }
    else if ([type isEqualToString:kResourceNovelType])
    {
        destPath = [self novelsFullPath];
        resourceKey = kResourceNovelType;
        notificationName = HLNovelsDidUpdateNotification;
    }
    else
    {
        return;
    }
    if ([fileManager fileExistsAtPath:destPath])
    {
        [fileManager removeItemAtPath:destPath error:nil];
    }
    
    NSArray *resources = [NSArray arrayWithContentsOfFile:request.downloadDestinationPath];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
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
    NSString *type = request.userInfo[@"resourceType"];

    if ([type isEqualToString:kResourceSeedType])
    {
        destPath = [self seedsFullPath];
        resourceKey = kResourceSeedType;
    }
    else if ([type isEqualToString:kResourcePhotoType])
    {
        destPath = [self photosFullPath];
        resourceKey = kResourcePhotoType;
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

- (void) favoriteSeed:(NSDictionary *) seedItem
{
    NSString *favoritePath = [self favoriteSeedsResourcesFullPath];
    BOOL isDir = YES;
    if ( !(YES == [[NSFileManager defaultManager] fileExistsAtPath:favoritePath isDirectory:&isDir] && isDir == YES))
    {
        NSError *err = nil;
        if (NO == [[NSFileManager defaultManager] createDirectoryAtPath:favoritePath withIntermediateDirectories:YES attributes:nil error:&err])
        {
            PAError(@"create favorite seed folder failed with error:%@", err);
            return;
        }
    }
    
    NSArray *allSeeds = seedItem[kResourceFilesTypeSeeds];
    NSString *sourceRootPath = [self seedsFullPath];
    NSString *destRootPath = [self favoriteSeedsResourcesFullPath];
    NSError *err = nil;
    for (NSString *path in allSeeds)
    {
        err = nil;
        if (NO == [[NSFileManager defaultManager] copyItemAtPath:[sourceRootPath stringByAppendingPathComponent:path] toPath:[destRootPath stringByAppendingPathComponent:path] error:&err])
        {
            PAError(@"Copy seed file from %@ to %@ failed error:%@. the seed full info:\n", [sourceRootPath stringByAppendingPathComponent:path], [destRootPath stringByAppendingPathComponent:path], err, seedItem);
        }
    }
    
    NSArray *allImages = seedItem[kResourceFilesTypeImages];
    for (NSString *path in allImages)
    {
        err = nil;
        if (NO == [[NSFileManager defaultManager] copyItemAtPath:[sourceRootPath stringByAppendingPathComponent:path] toPath:[destRootPath stringByAppendingPathComponent:path] error:&err])
        {
            PAError(@"Copy image file from %@ to %@ failed error:%@. the seed full info:\n", [sourceRootPath stringByAppendingPathComponent:path], [destRootPath stringByAppendingPathComponent:path], err, seedItem);
        }
    }
    [self saveItemInfoInUserDefault:seedItem];
}

- (void) cancelFavoriteSeed:(NSDictionary *) seedItem
{
    [self removeItemInfoFromUserDefault:seedItem];
    NSArray *allSeeds = seedItem[kResourceFilesTypeSeeds];
    NSString *destRootPath = [self favoriteSeedsResourcesFullPath];
    for (NSString *path in allSeeds)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[destRootPath stringByAppendingPathComponent:path] error:NULL];
    }
    
    NSArray *allImages = seedItem[kResourceFilesTypeImages];
    for (NSString *path in allImages)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[destRootPath stringByAppendingPathComponent:path] error:NULL];
    }
}

- (void) favoritePhoto:(NSDictionary *) photoItem
{
    NSString *favoritePath = [self favoritePhotosResourcesFullPath];
    BOOL isDir = YES;
    if ( !(YES == [[NSFileManager defaultManager] fileExistsAtPath:favoritePath isDirectory:&isDir] && isDir == YES))
    {
        NSError *err = nil;
        if (NO == [[NSFileManager defaultManager] createDirectoryAtPath:favoritePath withIntermediateDirectories:YES attributes:nil error:&err])
        {
            PAError(@"create favorite photo folder failed with error:%@", err);
            return;
        }
    }
    
    NSString *sourceRootPath = [self seedsFullPath];
    NSString *destRootPath = [self favoriteSeedsResourcesFullPath];
    NSError *err = nil;
    NSArray *allImages = photoItem[kResourceFilesTypeImages];
    for (NSString *path in allImages)
    {
        err = nil;
        if (NO == [[NSFileManager defaultManager] copyItemAtPath:[sourceRootPath stringByAppendingPathComponent:path] toPath:[destRootPath stringByAppendingPathComponent:path] error:&err])
        {
            PAError(@"Copy image file from %@ to %@ failed error:%@. the seed full info:\n", [sourceRootPath stringByAppendingPathComponent:path], [destRootPath stringByAppendingPathComponent:path], err, photoItem);
        }
    }
    [self saveItemInfoInUserDefault:photoItem];

}

- (void) cancelFavoritePhoto:(NSDictionary *) photoItem
{
    [self removeItemInfoFromUserDefault:photoItem];
    NSString *destRootPath = [self favoriteSeedsResourcesFullPath];
    NSArray *allImages = photoItem[kResourceFilesTypeImages];
    for (NSString *path in allImages)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[destRootPath stringByAppendingPathComponent:path] error:NULL];
    }
}

- (void) saveItemInfoInUserDefault:(NSDictionary *) itemInfo
{
    NSDictionary *allFavorites = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteResourcesUserDefaultKey];
    if (nil == allFavorites)
    {
        allFavorites = @{[@([[NSDate date] timeIntervalSince1970]) stringValue]: itemInfo};
    }
    else
    {
        NSMutableDictionary *resultFavorites = [NSMutableDictionary dictionaryWithDictionary:allFavorites];
        [resultFavorites setObject:itemInfo forKey:[@([[NSDate date] timeIntervalSince1970]) stringValue]];
        allFavorites = resultFavorites;
    }
    [[NSUserDefaults standardUserDefaults] setObject:allFavorites forKey:kFavoriteResourcesUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void) removeItemInfoFromUserDefault:(NSDictionary *) itemInfo
{
    NSDictionary *allFavorite = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteResourcesUserDefaultKey];
    NSArray *arr = [allFavorite allValues];
    NSDictionary *currentDoc = nil;
    for (NSDictionary *document in arr)
    {
        if (YES == [itemInfo[kResourceID] isEqualToString:document[kResourceID]])
        {
            currentDoc = document;
            break;
        }
    }
    if (nil != currentDoc)
    {
        NSArray *relativeKeys = [allFavorite allKeysForObject:currentDoc];
        NSMutableDictionary *resultAllFavorites = [NSMutableDictionary dictionaryWithDictionary:allFavorite];
        [resultAllFavorites removeObjectsForKeys:relativeKeys];
        [[NSUserDefaults standardUserDefaults] setObject:resultAllFavorites forKey:kFavoriteResourcesUserDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


#pragma mark - ASIHTTPRequestDelegate:

- (void) requestStarted:(ASIHTTPRequest *) request
{
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *type = request.userInfo[@"resourceType"];
    
    if ([type isEqualToString:kResourceArticleType] ||
        [type isEqualToString:kResourceJokeType] ||
        [type isEqualToString:kResourceNovelType])
    {
        [self saveStringResourceFromRequest:request];
    }
    else if ([type isEqualToString:kResourceSeedType] ||
             [type isEqualToString:kResourcePhotoType])
    {
        [self saveZipResourceFromRequest:request];
    }
    else if (type == nil)
    {
        // 如果没有type 则说明是check update list。
        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:request.downloadDestinationPath];
        if (nil == info)
        {
            PAError(@"the resourceVersionInfo from server is invalid!");
            return;
        }
        PAInfo(@"get new version Info:\n%@", info);
        NSDictionary *localInfo = [self localResourcesVersionInfo];
        // check Articles
        NSDictionary *articles = [info objectForKey:kResourceArticleType];
        NSString *newArticles = [[articles allKeys] lastObject];
        NSString *oldArticles = [[[localInfo objectForKey:kResourceArticleType] allKeys] lastObject];
        if (NO == [newArticles isEqualToString:oldArticles])
        {
            NSString *url = [articles objectForKey:newArticles];
            PAInfo(@"Articles did update on server, version:%@", newArticles);
            [self getResourcesFromURL:url resourceType:kResourceArticleType resourceInfo:articles];
        }
        
        // check Jokes
        NSDictionary *jokes = info[kResourceJokeType];
        NSString *newJokes = [[jokes allKeys] lastObject];
        NSString *oldJokes = [[localInfo[kResourceJokeType] allKeys] lastObject];
        if (NO == [newJokes isEqualToString:oldJokes])
        {
            NSString *url = [jokes objectForKey:newJokes];
            PAInfo(@"Jokes did update on server, version:%@", newJokes);
            [self getResourcesFromURL:url resourceType:kResourceJokeType resourceInfo:jokes];
        }
        
        // check Novels
        NSDictionary *novels = info[kResourceNovelType];
        NSString *newNovels = [[novels allKeys] lastObject];
        NSString *oldNovels = [[localInfo[kResourceNovelType] allKeys] lastObject];
        if (NO == [newNovels isEqualToString:oldNovels])
        {
            NSString *url = [novels objectForKey:newNovels];
            PAInfo(@"Novels did update on server, version:%@", newNovels);
            [self getResourcesFromURL:url resourceType:kResourceNovelType resourceInfo:novels];
        }
        
        // check seeds
        NSDictionary *seeds = info[kResourceSeedType];
        NSString *newSeeds = [[seeds allKeys] lastObject];
        NSString *oldSeeds = [[localInfo[kResourceSeedType] allKeys] lastObject];
        if (NO == [newSeeds isEqualToString:oldSeeds])
        {
            NSString *url = [seeds objectForKey:newSeeds];
            PAInfo(@"Seeds did update on server, version:%@", newSeeds);
            [self getResourcesFromURL:url resourceType:kResourceSeedType resourceInfo:seeds];
        }
        
        // check photos
        NSDictionary *photos = info[kResourcePhotoType];
        NSString *newPhotos = [[photos allKeys] lastObject];
        NSString *oldPhotos = [[localInfo[kResourcePhotoType] allKeys] lastObject];
        if (NO == [newPhotos isEqualToString:oldPhotos])
        {
            NSString *url = [photos objectForKey:newPhotos];
            PAInfo(@"Photos did update on server, version:%@", newPhotos);
            [self getResourcesFromURL:url resourceType:kResourcePhotoType resourceInfo:photos];
        }
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
