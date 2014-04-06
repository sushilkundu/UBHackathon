//
//  NSObject+JSONDeserializer.h
//  JSONDeserialize
//
//  Created by Ravi Sahu on 22/12/11.
//  Copyright 2011 Times Internet Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectMapperContainer;

@interface NSObject (JSONDeserializer)

- (id)deserializeJSONObject:(id)aJSONObject;
- (id)deserializeJSONObject:(id)aJSONObject classMappingDictionary:(NSDictionary*)aClassMappingDictionary;

- (id)deserializeJSONObject:(id)aJSONObject forPath:(NSString*)aPath;
- (id)deserializeJSONObject:(id)aJSONObject forPath:(NSString*)aPath classMappingDictionary:(NSDictionary*)aClassMappingDictionary;

// Using blocks
- (void)deserializeJSONObject:(id)aJSONObject success:(void (^)(id aObject))success failure:(void (^)(NSString* aErrorString))failure;
- (void)deserializeJSONObject:(id)aJSONObject forPath:(NSString*)aPath classMappingDictionary:(NSDictionary*)aClassMappingDictionary success:(void (^)(id aObject))success failure:(void (^)(NSString* aErrorString))failure;

- (void)deserializeJSONObject:(id)aJSONObject objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer success:(void (^)(id aObject))success failure:(void (^)(NSError* error))failure;

@end
