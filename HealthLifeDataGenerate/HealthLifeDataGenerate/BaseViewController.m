//
//  BaseViewController.m
//  HealthLifeDataGenerate
//
//  Created by ShengQiang on 5/27/14.
//  Copyright (c) 2014 Ping An Health Insurance Company of China, Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "NSData+EncodeData.h"

#define kLastSelectDirectory @"kLastSelectDirectory"

@interface BaseViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *logResultView;
@property (weak) IBOutlet NSScrollView *logScrollView;


@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Initialization code here.
    }
    return self;
}

- (void) loginfo:(NSString *) log
{
    self.logResultView.string = [self.logResultView.string stringByAppendingString:@"\n"];
    self.logResultView.string = [self.logResultView.string stringByAppendingString:log];
}

- (NSString *) generateUUIDString
{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *) uuidStringRef;
    return uniqueId;
}

- (void) checkupdateListUpdateInfoAboutRootPath:(NSString *) rootpath type:(NSString *) type
{
    NSString *checkUpdatelistPath = [[rootpath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"CheckUpdateList.plist"];
    NSDictionary *checkUpdateList = [NSDictionary dictionaryWithContentsOfFile:checkUpdatelistPath];
    
    NSDictionary *categry = checkUpdateList[type];
    if (categry == nil)
    {
        [self loginfo:[NSString stringWithFormat:@"!!!!!!!!!!!!The [%@] desnot exsit in the checkupdateList.plist", type]];
    }
    else
    {
        // 目前每一个分类只支持一个key，比如Seeds下面只能有一个key
        NSString *key = [[categry allKeys] lastObject];
        NSString *urlPath = categry[key];
        NSMutableDictionary *resultCategry = [NSMutableDictionary dictionaryWithDictionary:categry];
        [resultCategry removeObjectForKey:key];
        [resultCategry setObject:urlPath forKey:[@([[NSDate date] timeIntervalSince1970]) stringValue]];
        NSMutableDictionary *resultChectupdatelist = [NSMutableDictionary dictionaryWithDictionary:checkUpdateList];
        resultChectupdatelist[[rootpath lastPathComponent]] = resultCategry;
        [resultChectupdatelist writeToFile:checkUpdatelistPath atomically:YES];
        [self loginfo:[NSString stringWithFormat:@"-----The [%@] in the checkupdateList.plist update successfully.", type]];
    }

}

#pragma mark - generate seed resource.

- (IBAction)GenerateSeedsBase64:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt:@"Choose"];
    [openPanel setMessage:@"Seeds must save at the same path with config plist."];
    [openPanel setTitle:@"Choose seeds config plist"];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    
    // default location is the user's Pictures folder
    NSString *defaultPath = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectDirectory];
    NSArray *desktopDirectory = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    if (defaultPath == nil)
    {
        defaultPath = [desktopDirectory objectAtIndex:0];
    }
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:defaultPath]];
    
    NSInteger result = [openPanel runModal];
    if (result == NSOKButton)
    {
        NSString *configPath = [[[openPanel URLs] objectAtIndex:0] path];
        NSString *basePath = [configPath stringByDeletingLastPathComponent];
        [[NSUserDefaults standardUserDefaults] setObject:basePath forKey:kLastSelectDirectory];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loginfo:[NSString stringWithFormat:@"\n\n\n\n>>>>>>>>pick seeds config plist:%@<<<<<<<<<", configPath]];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self generateSeedsFromConfigPlist:configPath];
//        });
//        [self generateSeedsFromConfigPlist:configPath];
        [self performSelector:@selector(generateSeedsFromConfigPlist:) withObject:configPath afterDelay:.5f];
    }
}

- (void) generateSeedsFromConfigPlist:(NSString *) configPlistPath
{
    NSString *rootpath = [configPlistPath stringByDeletingLastPathComponent];
    NSString *resultSeeds = [rootpath stringByAppendingPathComponent:[rootpath lastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultSeeds])
    {
        [[NSFileManager defaultManager] removeItemAtPath:resultSeeds error:NULL];
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:resultSeeds withIntermediateDirectories:YES attributes:nil error:NULL];
    NSArray *seeds = [NSArray arrayWithContentsOfFile:configPlistPath];;
    NSMutableArray *base64Seeds = [NSMutableArray arrayWithCapacity:[seeds count]];
    for (NSDictionary *seed in seeds)
    {
        //generate seed files
        NSArray *seedfiles = seed[kResourceFilesTypeSeeds];
        NSMutableArray *genSeedfiles = [NSMutableArray arrayWithCapacity:[seedfiles count]];
        for (NSString *seedname in seedfiles)
        {
            NSData *data = [NSData dataWithContentsOfFile:[rootpath stringByAppendingPathComponent:seedname]];
            if (0 == [data length])
            {
                [self loginfo:[NSString stringWithFormat:@"!!!!!the file:%@ does not exist.", seedname]];
            }
            NSString *base64Str = [data base64Encoded];
            NSError *err = nil;
            if (NO == [base64Str writeToFile:[resultSeeds stringByAppendingPathComponent:seedname] atomically:YES encoding:NSUTF8StringEncoding error:&err])
            {
                [self loginfo:[NSString stringWithFormat:@"save base64 seed file[%@] failed with error:%@.", seedname, err]];
            }
            [genSeedfiles addObject:seedname];
        }
        
        
        //generate images files.
        NSArray *imagefiles = seed[kResourceFilesTypeImages];
        NSMutableArray *genImagefiles = [NSMutableArray arrayWithCapacity:[imagefiles count]];
        for (NSString *imagename in imagefiles)
        {
            NSData *data = [NSData dataWithContentsOfFile:[rootpath stringByAppendingPathComponent:imagename]];
            if (0 == [data length])
            {
                [self loginfo:[NSString stringWithFormat:@"!!!!!the file:%@ does not exist.", imagename]];
            }
            NSString *base64Str = [data base64Encoded];
            NSError *err = nil;
            if (NO == [base64Str writeToFile:[resultSeeds stringByAppendingPathComponent:imagename] atomically:YES encoding:NSUTF8StringEncoding error:&err])
            {
                [self loginfo:[NSString stringWithFormat:@"save base64 image file[%@] failed with error:%@.", imagename, err]];
            }
            [genImagefiles addObject:imagename];
        }

        
        NSDictionary *genDict = @{kResourceID : [self generateUUIDString],
                                  kResourceTitle : seed[kResourceTitle],
                                  kResourceFilesTypeSeeds : genSeedfiles,
                                  kResourceFilesTypeImages : genImagefiles,
                                  kResourceType : kResourceSeedType,
                                  kResourceSubType : seed[kResourceSubType]};
        [base64Seeds addObject:genDict];
        [self loginfo:[NSString stringWithFormat:@"-----generate seed:%@ successfully.", [seed objectForKey:kResourceTitle]]];
    }
    
    if (NO == [base64Seeds writeToFile:[resultSeeds stringByAppendingPathComponent:[configPlistPath lastPathComponent]] atomically:YES])
    {
        [self loginfo:[NSString stringWithFormat:@"save base64 config plist[%@] failed", [resultSeeds stringByAppendingPathComponent:[configPlistPath lastPathComponent]]]];
    }
    else
    {
        [self loginfo:[NSString stringWithFormat:@"generate base64 from config plist[%@] successfully.", configPlistPath]];
        [self checkupdateListUpdateInfoAboutRootPath:rootpath type:kResourceSeedType];
    }
}

#pragma mark - generate photo resources

- (IBAction)generatePhotosBase64Resource:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt:@"Choose"];
    [openPanel setMessage:@"Photos must save at the same path with config plist."];
    [openPanel setTitle:@"Choose photos config plist"];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    
    // default location is the user's Pictures folder
    NSString *defaultPath = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectDirectory];
    NSArray *desktopDirectory = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    if (defaultPath == nil)
    {
        defaultPath = [desktopDirectory objectAtIndex:0];
    }
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:defaultPath]];
    
    NSInteger result = [openPanel runModal];
    if (result == NSOKButton)
    {
        NSString *configPath = [[[openPanel URLs] objectAtIndex:0] path];
        NSString *basePath = [configPath stringByDeletingLastPathComponent];
        [[NSUserDefaults standardUserDefaults] setObject:basePath forKey:kLastSelectDirectory];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loginfo:[NSString stringWithFormat:@"\n\n\n\n>>>>>>>>pick photos config plist:%@<<<<<<<<<", configPath]];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self generatePhotosFromConfigPlist:configPath];
//        });
        [self generatePhotosFromConfigPlist:configPath];

    }
}

- (void) generatePhotosFromConfigPlist:(NSString *) configPlistPath
{
    NSString *rootpath = [configPlistPath stringByDeletingLastPathComponent];
    NSString *resultPhotos = [rootpath stringByAppendingPathComponent:[rootpath lastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultPhotos])
    {
        [[NSFileManager defaultManager] removeItemAtPath:resultPhotos error:NULL];
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:resultPhotos withIntermediateDirectories:YES attributes:nil error:NULL];
    NSArray *photos = [NSArray arrayWithContentsOfFile:configPlistPath];;
    NSMutableArray *base64Photos = [NSMutableArray arrayWithCapacity:[photos count]];
    for (NSDictionary *seed in photos)
    {
        //generate images files.
        NSArray *imagefiles = seed[kResourceFilesTypeImages];
        NSMutableArray *genImagefiles = [NSMutableArray arrayWithCapacity:[imagefiles count]];
        for (NSString *imagename in imagefiles)
        {
            NSData *data = [NSData dataWithContentsOfFile:[rootpath stringByAppendingPathComponent:imagename]];
            if (0 == [data length])
            {
                [self loginfo:[NSString stringWithFormat:@"!!!!!the file:%@ does not exist.", imagename]];
            }
            NSString *base64Str = [data base64Encoded];
            NSError *err = nil;
            if (NO == [base64Str writeToFile:[resultPhotos stringByAppendingPathComponent:imagename] atomically:YES encoding:NSUTF8StringEncoding error:&err])
            {
                [self loginfo:[NSString stringWithFormat:@"save base64 image file[%@] failed with error:%@.", imagename, err]];
            }
            [genImagefiles addObject:imagename];
        }
        
        
        NSDictionary *genDict = @{kResourceID : [self generateUUIDString],
                                  kResourceTitle : seed[kResourceTitle],
                                  kResourceFilesTypeImages : genImagefiles,
                                  kResourceType : kResourcePhotoType,
                                  kResourceSubType : seed[kResourceSubType]};
        [base64Photos addObject:genDict];
        [self loginfo:[NSString stringWithFormat:@"-----generate photo:%@ successfully.", seed[kResourceTitle]]];
    }
    
    if (NO == [base64Photos writeToFile:[resultPhotos stringByAppendingPathComponent:[configPlistPath lastPathComponent]] atomically:YES])
    {
        [self loginfo:[NSString stringWithFormat:@"save base64 config plist[%@] failed", [resultPhotos stringByAppendingPathComponent:[configPlistPath lastPathComponent]]]];
    }
    else
    {
        [self loginfo:[NSString stringWithFormat:@"generate base64 from config plist[%@] successfully.", configPlistPath]];
        [self checkupdateListUpdateInfoAboutRootPath:rootpath type:kResourcePhotoType];
    }
}

#pragma mark - generate articles resources

- (IBAction)generateArticlesID:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt:@"Choose"];
    [openPanel setMessage:@"support articles, novels, jokes and so on."];
    [openPanel setTitle:@"Choose articles config plist"];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    
    // default location is the user's Pictures folder
    NSString *defaultPath = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectDirectory];
    NSArray *desktopDirectory = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    if (defaultPath == nil)
    {
        defaultPath = [desktopDirectory objectAtIndex:0];
    }
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:defaultPath]];
    
    NSInteger result = [openPanel runModal];
    if (result == NSOKButton)
    {
        NSString *configPath = [[[openPanel URLs] objectAtIndex:0] path];
        NSString *basePath = [configPath stringByDeletingLastPathComponent];
        [[NSUserDefaults standardUserDefaults] setObject:basePath forKey:kLastSelectDirectory];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loginfo:[NSString stringWithFormat:@"\n\n\n\n>>>>>>>>pick articles config plist:%@<<<<<<<<<", configPath]];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self generateArticlesIDAbout:configPath];
//        });
        [self generateArticlesIDAbout:configPath];

    }
}

- (void) generateArticlesIDAbout:(NSString *) configPlistPath
{
    NSString *rootpath = [configPlistPath stringByDeletingLastPathComponent];
    NSString *resultArticlesName = [rootpath stringByAppendingPathComponent:[rootpath lastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resultArticlesName])
    {
        [[NSFileManager defaultManager] removeItemAtPath:resultArticlesName error:NULL];
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:resultArticlesName withIntermediateDirectories:YES attributes:nil error:NULL];
    NSArray *articles = [NSArray arrayWithContentsOfFile:configPlistPath];;
    NSMutableArray *resultArticles = [NSMutableArray arrayWithCapacity:[articles count]];
#warning 逻辑不好～～～～
    NSString *type = nil;
    for (NSDictionary *article in articles)
    {
        NSDictionary *genDict = @{kResourceID : [self generateUUIDString],
                                  kResourceTitle : article[kResourceTitle],
                                  kResourceContent : article[kResourceContent],
                                  kResourceType : article[kResourceType],
                                  kResourceSubType : article[kResourceSubType]};
        [resultArticles addObject:genDict];
        [self loginfo:[NSString stringWithFormat:@"-----generate photo:%@ successfully.", article[kResourceTitle]]];
        type = article[kResourceType];
    }
    
    if (NO == [resultArticles writeToFile:[resultArticlesName stringByAppendingPathComponent:[configPlistPath lastPathComponent]] atomically:YES])
    {
        [self loginfo:[NSString stringWithFormat:@"save base64 config plist[%@] failed", [resultArticlesName stringByAppendingPathComponent:[configPlistPath lastPathComponent]]]];
    }
    else
    {
        [self loginfo:[NSString stringWithFormat:@"generate base64 from config plist[%@] successfully.", configPlistPath]];
        [self checkupdateListUpdateInfoAboutRootPath:rootpath type:type];
    }
}

@end
