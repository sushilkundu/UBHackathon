//
//  URLCache.m
//  TOI
//
//  Created by Ravi Sahu on 28/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "URLCache.h"
#import "Archiver.h"
#import <CommonCrypto/CommonDigest.h>

//static NSString *kCacheFileName = @"URLCache.plist";
//static NSString *kTempCacheFileName = @"TempURLCache.plist";

/* cache update interval in seconds */
#define URLCacheInterval		10*60

@interface URLCache ()

@property (strong, atomic) NSCache *dataCache;
@property (strong, atomic) NSCache *imageCache;

@end

@implementation URLCache

@synthesize dynamicSaveEnabled;

@synthesize dataCache;
@synthesize imageCache;

#pragma mark -
#pragma mark Singleton Methods

+ (URLCache*)sharedInstance {
    
	static URLCache *_sharedInstance;
	if(!_sharedInstance) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
			_sharedInstance.dynamicSaveEnabled = YES;
        });
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
	return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
	return self;
}

#if (!__has_feature(objc_arc))

- (id)retain {
    
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {
    
	return self;
}
#endif

#pragma mark -
#pragma mark Custom Methods

- (CacheData*)getDataForURL:(NSURL *)url needTimCheck:(BOOL)timeCheck {
    return [self getDataForURL:url needTimCheck:timeCheck cacheTimeInterval:0];
}

- (CacheData*)getDataForURL:(NSURL *)url needTimCheck:(BOOL)timeCheck cacheTimeInterval:(NSTimeInterval)cacheTimeInterval {
    CacheData *_cachedData = [self getDataFromCacheForURL:url needTimCheck:timeCheck cacheTimeInterval:cacheTimeInterval];
    if (!_cachedData) {
        // No data found in cache, check persistance
        _cachedData = [self getDataFromPersistanceForURL:url needTimCheck:timeCheck cacheTimeInterval:cacheTimeInterval];
    }
    return _cachedData;
}

- (void)addDataToCache:(CacheData*)cacheData forURL:(NSURL*)url {
    @synchronized (self) {
        // Get URL hash key
        NSString *_urlHashKey = [URLCache cacheKeyForURL:url];
        if (!self.dataCache) self.dataCache = [NSCache new];
        [self.dataCache setObject:cacheData forKey:_urlHashKey];
        // Check if persistance is required.
        if ([self isDynamicSaveEnabled]) [self persistCacheData:cacheData forURL:url];
    }
}

- (CacheData*)getDataFromCacheForURL:(NSURL*)url needTimCheck:(BOOL)timeCheck {
    @synchronized (self) {
        return [self getDataFromCacheForURL:url needTimCheck:timeCheck cacheTimeInterval:URLCacheInterval];
    }
}

- (CacheData*)getDataFromCacheForURL:(NSURL*)url needTimCheck:(BOOL)timeCheck cacheTimeInterval:(NSTimeInterval)cacheTimeInterval {
    @synchronized (self) {
        if (self.dataCache) {
            // Get URL hash key
            NSString *_urlHashKey = [URLCache cacheKeyForURL:url];
            if ([self.dataCache objectForKey:_urlHashKey]) {
                CacheData *_cacheData = [self.dataCache objectForKey:_urlHashKey];
                if (!timeCheck) return _cacheData;
                else if (_cacheData && cacheTimeInterval == 0) return _cacheData;
                else if (_cacheData) {
                    /* get the elapsed time since last file update */
                    NSTimeInterval _elapsedTime = fabs([_cacheData.cacheCreatedDateTime timeIntervalSinceNow]);
                    if (_elapsedTime < cacheTimeInterval) {
                        // We have data in the cache.
                        return _cacheData;
                    }
                }
            }
        }
        return nil;
    }
}

- (void)removeDataFromCacheForURL:(NSURL*)url {
    @synchronized (self) {
        if (self.dataCache) {
            // Get URL hash key
            NSString *_urlHashKey = [URLCache cacheKeyForURL:url];
            if ([self.dataCache objectForKey:_urlHashKey]) [self.dataCache removeObjectForKey:_urlHashKey];
        }
    }
}

- (void)removeAllCachedData {
    @synchronized (self) {
        self.dataCache = nil;
    }
}

- (void)persistCacheData:(CacheData*)cacheData forURL:(NSURL*)url {
    @synchronized (self) {
        // Get URL hash key
        NSString *_urlHashKey = [URLCache cacheKeyForURL:url];
        [Archiver createFile:cacheData aFileName:_urlHashKey];
    }
}

- (void)removeDataFromPersistanceForURL:(NSURL*)url {
    // Get URL hash key
    NSString *_urlHashKey = [URLCache cacheKeyForURL:url];
    [Archiver deleteFile:_urlHashKey];
}

- (CacheData*)getDataFromPersistanceForURL:(NSURL*)url needTimCheck:(BOOL)timeCheck {
    @synchronized (self) {
        return [self getDataFromPersistanceForURL:url needTimCheck:timeCheck cacheTimeInterval:0];
    }
}

- (CacheData*)getDataFromPersistanceForURL:(NSURL*)url needTimCheck:(BOOL)timeCheck cacheTimeInterval:(NSTimeInterval)cacheTimeInterval {
    @synchronized (self) {
        // Get URL hash key
        NSString *_urlHashKey = [URLCache cacheKeyForURL:url];
        if ([Archiver fileExists:_urlHashKey]) {
            @try {
                CacheData *_cacheData = [Archiver readFile:_urlHashKey];
                if (!timeCheck) return _cacheData;
                else if (_cacheData && cacheTimeInterval == 0) return _cacheData;
                else if (_cacheData) {
                    /* get the elapsed time since last file update */
                    NSTimeInterval _elapsedTime = fabs([_cacheData.cacheCreatedDateTime timeIntervalSinceNow]);
                    if (_elapsedTime < cacheTimeInterval) {
                        // We have data in the cache.
                        return _cacheData;
                    }
                }
            }
            @catch (NSException *exception) {
                [Archiver deleteFile:@"_urlHashKey"];
                NSLog(@"Name : %@; Reason : %@; Info : %@", exception.name, exception.reason, exception.userInfo);
            }
        }
        return nil;
    }
}

- (void)addImageToCache:(UIImage*)image forURL:(NSURL*)url {
    @synchronized (self) {
        if (!self.imageCache) self.imageCache = [NSCache new];
        // Get URL hash key
        NSString *_urlHashKey = [URLCache cacheKeyForURL:url];
        [self.imageCache setObject:image forKey:_urlHashKey];
        // Check if persistance is required.
        if ([self isDynamicSaveEnabled]) [Archiver createFile:UIImagePNGRepresentation(image) aFileName:_urlHashKey];
    }
}

- (UIImage*)getImageForURL:(NSURL*)url {
    @synchronized (self) {
        if (!self.imageCache) self.imageCache = [NSCache new];
        if (self.imageCache) {
            // Get URL hash key
            NSString *_urlHashKey = [URLCache cacheKeyForURL:url];
            UIImage *_image = [self.imageCache objectForKey:_urlHashKey];
            if (_image) return _image;
            else {
                // Check in Persistance
                NSData *_imageData = [Archiver readFile:_urlHashKey];
                if (_imageData) return [UIImage imageWithData:_imageData];
                return nil;
            }
        }
        return nil;
    }
}

- (void)removeAllImagesFromCache {
    @synchronized (self) {
        self.imageCache = nil;
    }
}

+ (NSString *)cacheKeyForURL:(NSURL *)url {
    const char *str = [url.absoluteString UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    static NSString *cacheFormatVersion = @"2";
    return [NSString stringWithFormat:@"%@_%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            cacheFormatVersion, r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

@end
