//
//  SQDataCenter.h
//  SQHealthLife
//
//  Created by ShengQiang on 5/5/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const HLArticlesDidUpdateNotification;
extern NSString *const HLJokesDidUpdateNotification;
extern NSString *const HLNovelsDidUpdateNotification;
extern NSString *const HLSeedsDidUpdateNotification;
extern NSString *const HLPhotosDidUpdateNotification;

@interface SQDataCenter : NSObject

+ (SQDataCenter *) shareDataCenter;

- (void) checkUpdateList;
// 通知push 流程：告诉客户端该更新哪些内容，然后客户端自己去更新最新的内容！！

- (NSString *) workspace;

- (NSString *) articlesFullPath;

- (NSString *) jokesFullPath;

- (NSString *) novelsFullPath;

- (NSString *) seedsFullPath;

- (NSString *) photosFullPath;

- (NSString *) favoriteSeedsResourcesFullPath;

- (NSString *) favoritePhotosResourcesFullPath;

- (void) favoriteSeed:(NSDictionary *) seedItem;

- (void) cancelFavoriteSeed:(NSDictionary *) seedItem;

- (void) favoritePhoto:(NSDictionary *) photoItem;

- (void) cancelFavoritePhoto:(NSDictionary *) photoItem;

@end
