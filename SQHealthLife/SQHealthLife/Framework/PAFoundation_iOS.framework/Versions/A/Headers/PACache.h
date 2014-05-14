/*
 * This file is part of the PACache package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

typedef NS_ENUM(NSInteger, PACacheType) {
    /**
     * Cache wasn't available, downloaded from the web.
     */
    PACacheTypeNone,
    /**
     * The cache was obtained from the disk cache.
     */
    PACacheTypeDisk,
    /**
     * The cache was obtained from the memory cache.
     */
    PACacheTypeMemory
};

typedef void(^PACacheQueryCompletedBlock)(UIImage *image, PACacheType cacheType);

/**
 * PACache maintains a memory cache and an optional disk cache. Disk cache write operations are performed
 * asynchronous so it doesn’t add unnecessary latency to the UI.
 */
@interface PACache : NSObject

/**
 * The maximum "total cost" of the in-memory cache. The cost function is the number of pixels held in memory.
 */
@property (assign, nonatomic) NSUInteger maxMemoryCost;

/**
 * The maximum length of time to keep an object in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;

/**
 * Returns global shared cache instance
 *
 * @return PACache global instance
 */
+ (PACache *)sharedCache;

/**
 * Init a new cache store with a specific namespace
 *
 * @param ns The namespace to use for this cache store
 */
- (id)initWithNamespace:(NSString *)ns;

/**
 * Add a read-only cache path to search for images pre-cached by SDImageCache
 * Useful if you want to bundle pre-loaded images with your app
 *
 * @param path The path to use for this read-only cache path
 */
- (void)addReadOnlyCachePath:(NSString *)path;

/**
 * Store an object into memory and disk cache at the given key.
 *
 * @param image The image to store
 * @param key The unique image cache key, usually it's image absolute URL
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

- (void)storeData:(NSData *)data forKey:(NSString *)key;

- (void)storeString:(NSString *)string forKey:(NSString *)key;

/**
 * Store an object into memory and optionally disk cache at the given key.
 *
 * @param image The image to store
 * @param key The unique image cache key, usually it's image absolute URL
 * @param toDisk Store the image to disk cache if YES
 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (void)storeData:(NSData *)data forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (void)storeString:(NSString *)string forKey:(NSString *)key toDisk:(BOOL)toDisk;

/**
 * Store an image into memory and optionally disk cache at the given key.
 *
 * @param image The image to store
 * @param recalculate BOOL indicates if imageData can be used or a new data should be constructed from the UIImage
 * @param imageData The image data as returned by the server, this representation will be used for disk storage
 *             instead of converting the given image object into a storable/compressed image format in order
 *             to save quality and CPU
 * @param key The unique image cache key, usually it's image absolute URL
 * @param toDisk Store the image to disk cache if YES
 */
- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;

/**
 * Query the disk cache asynchronously.
 *
 * @param key The unique key used to store the wanted image
 */
- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(PACacheQueryCompletedBlock)doneBlock;

/**
 * Query the memory cache synchronously.
 *
 * @param key The unique key used to store the wanted image
 */
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;

- (NSData *)dataFromMemoryCacheForKey:(NSString *)key;

- (NSString *)stringFromMemoryCacheForKey:(NSString *)key;

/**
 * Query the disk cache synchronously after checking the memory cache.
 *
 * @param key The unique key used to store the wanted image
 */
- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;

- (NSData *)dataFromDiskCacheForKey:(NSString *)key;

- (NSString *)stringFromDiskCacheForKey:(NSString *)key;

/**
 * Remove the cache from memory and disk cache synchronously
 *
 * @param key The unique cache key
 */
- (void)removeCacheForKey:(NSString *)key;

/**
 * Remove the cache from memory and optionally disk cache synchronously
 *
 * @param key The unique cache key
 * @param fromDisk Also remove cache entry from disk if YES
 */
- (void)removeCacheForKey:(NSString *)key fromDisk:(BOOL)fromDisk;

/**
 * Clear all memory cached images
 */
- (void)clearMemory;

/**
 * Clear all disk cached object. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */
- (void)clearDiskOnCompletion:(void (^)())completion;

/**
 * Clear all disk cached object
 * @see clearDiskOnCompletion:
 */
- (void)clearDisk;

/**
 * Remove all expired cached object from disk. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */
- (void)cleanDiskWithCompletionBlock:(void (^)())completionBlock;

/**
 * Remove all expired cached object from disk
 * @see cleanDiskWithCompletionBlock:
 */
- (void)cleanDisk;

/**
 * Get the size used by the disk cache
 */
- (NSUInteger)getSize;

/**
 * Get the number of object in the disk cache
 */
- (int)getDiskCount;

/**
 * Asynchronously calculate the disk cache's size.
 */
- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completionBlock;

/**
 * Check if object exists in cache already
 */
- (BOOL)diskCacheExistsWithKey:(NSString *)key;

@end
