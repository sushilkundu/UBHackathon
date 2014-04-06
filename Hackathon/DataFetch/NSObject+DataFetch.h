//
//  NSObject+DataFetch.h
//  CommonFramework
//
//  Created by Ravi Sahu on 13/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLCache.h"
#import "URLObject.h"

@interface NSObject (DataFetch)

- (void)requestDataFromURL:(NSString*)aURLString urlKey:(NSString*)urlKey doDerialization:(BOOL)aDeserializeFlag sucessSelector:(SEL)aSucessSelector failureSelector:(SEL)aFailureSelector;

// Block Version
- (void)requestDataFromURL:(NSString*)aURLString urlKey:(NSString*)urlKey doDerialization:(BOOL)aDeserializeFlag cacheTimeInterval:(NSTimeInterval)cacheTimeInterval success:(void (^)(id aObject))success failure:(void (^)(id aObject, NSError* error))failure;

// Custom Request URL specific for NSObject+JSONDeserializer function
- (void)requestDataFromURL:(NSString*)aURLString urlKey:(NSString*)urlKey deserializationPath:(NSString*)aPath deserializationClassMappingDictionary:(NSDictionary*)aMapingDictionary sucessSelector:(SEL)aSucessSelector failureSelector:(SEL)aFailureSelector;

// Block Version
- (void)requestDataFromURL:(NSString*)aURLString urlKey:(NSString*)urlKey deserializationPath:(NSString*)aPath deserializationClassMappingDictionary:(NSDictionary*)aMapingDictionary cacheTimeInterval:(NSTimeInterval)cacheTimeInterval success:(void (^)(id aObject))success failure:(void (^)(id aObject, NSError* error))failure;

// Framework Version.
- (void)requestDataFromURLString:(NSString*)aURLString completionBlock:(void (^)(id aObject, NSError* error))completionBlock;

- (void)requestDataFromURLObject:(URLObject*)aURLObject completionBlock:(void (^)(id aObject, NSError* error))completionBlock;

@end
