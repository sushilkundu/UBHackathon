//
//  URLCache.h
//  TOI
//
//  Created by Ravi Sahu on 28/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheData.h"

@interface URLCache : NSObject

+ (URLCache*) sharedInstance;

@property (nonatomic, getter = isDynamicSaveEnabled) BOOL dynamicSaveEnabled;

- (CacheData*)getDataForURL:(NSURL *)url needTimCheck:(BOOL)timeCheck;
- (CacheData*)getDataForURL:(NSURL *)url needTimCheck:(BOOL)timeCheck cacheTimeInterval:(NSTimeInterval)cacheTimeInterval;

- (void)addDataToCache:(CacheData*)cacheData forURL:(NSURL*)url;
- (CacheData*)getDataFromCacheForURL:(NSURL*)url needTimCheck:(BOOL)timeCheck;
- (CacheData*)getDataFromCacheForURL:(NSURL*)url needTimCheck:(BOOL)timeCheck cacheTimeInterval:(NSTimeInterval)cacheTimeInterval;
- (void)removeDataFromCacheForURL:(NSURL*)url;
- (void)removeAllCachedData;

- (void)persistCacheData:(CacheData*)cacheData forURL:(NSURL*)url;
- (void)removeDataFromPersistanceForURL:(NSURL*)url;
- (CacheData*)getDataFromPersistanceForURL:(NSURL*)url needTimCheck:(BOOL)timeCheck;
- (CacheData*)getDataFromPersistanceForURL:(NSURL*)url needTimCheck:(BOOL)timeCheck cacheTimeInterval:(NSTimeInterval)cacheTimeInterval;

- (void)addImageToCache:(UIImage*)image forURL:(NSURL*)url;
- (UIImage*)getImageForURL:(NSURL*)url;
- (void)removeAllImagesFromCache;

@end
