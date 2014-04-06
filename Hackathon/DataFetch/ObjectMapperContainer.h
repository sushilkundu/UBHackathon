//
//  ObjectMapperContainer.h
//  DataFetchFramework
//
//  Created by Ravi Sahu on 23/05/13.
//  Copyright (c) 2013 Ravi Sahu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectMapper;

@interface ObjectMapperContainer : NSObject

+ (id)objectMapperContainer;

- (void)addAttributeNameMapping:(ObjectMapper*)attributeNameObjectMapper;
- (void)addAttributesNameMapping:(NSArray*)attributeNameObjectMapperArray;

- (void)addClassNameMapping:(ObjectMapper*)classNameObjectMapper;
- (void)addClassesNameMapping:(NSArray*)classNameObjectMapperArray;

- (NSString*)getNameMappingForJSONAttributeKey:(NSString*)key inJSONClassKey:(NSString*)inJSONClassKey;
- (NSString*)getNameMappingForJSONClassKey:(NSString*)jsonClassKey;

@end
