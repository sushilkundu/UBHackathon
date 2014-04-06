//
//  ObjectMapperContainer.m
//  DataFetchFramework
//
//  Created by Ravi Sahu on 23/05/13.
//  Copyright (c) 2013 Ravi Sahu. All rights reserved.
//

#import "ObjectMapperContainer.h"
#import "ObjectMapper.h"
#import "NSString+Camelize.h"

@interface ObjectMapperContainer ()

@property (nonatomic, strong) NSMutableDictionary *classNameMappingDictionary;
@property (nonatomic, strong) NSMutableDictionary *attributeNameMappingDictionary;

@end

@implementation ObjectMapperContainer

@synthesize classNameMappingDictionary;
@synthesize attributeNameMappingDictionary;

/*
- (id)init {
    self = [super init];
    if (self) {
        // Custom Init
        self.classNameMappingArray = [NSMutableArray new];
        self.attributeNameMappingArray = [NSMutableArray new];
    }
    return self;
}
*/

#pragma mark - Public Methods
+ (id)objectMapperContainer {
    ObjectMapperContainer *_objectMapperContainer = [ObjectMapperContainer new];
    // Custom Init
    _objectMapperContainer.classNameMappingDictionary = [NSMutableDictionary new];
    _objectMapperContainer.attributeNameMappingDictionary = [NSMutableDictionary new];
    
    return _objectMapperContainer;
}

- (void)addAttributeNameMapping:(ObjectMapper*)attributeNameObjectMapper {
    if (attributeNameObjectMapper && [attributeNameObjectMapper isKindOfClass:[ObjectMapper class]]) {
        [self insertAttributeMapping:attributeNameObjectMapper];
    }
    else {
        if (!attributeNameObjectMapper) {
            NSLog(@"Warning : ObjectMapper [Attribute] Object is Empty!!");
        }
        else {
            NSLog(@"Warning : This calss does not belong to ObjectMapper [Attribute] !!");
        }
    }
}

- (void)addAttributesNameMapping:(NSArray*)attributeNameObjectMapperArray {
    if (attributeNameObjectMapperArray && attributeNameObjectMapperArray.count) {
        for (id _objectMapper in attributeNameObjectMapperArray) {
            [self addAttributeNameMapping:_objectMapper];
        }
    }
    else {
        NSLog(@"Warning : Attribute Name ObjectMapper Array is Empty!!");
    }
}

- (void)addClassNameMapping:(ObjectMapper*)classNameObjectMapper {
    if (classNameObjectMapper && classNameObjectMapper.jsonClassName && classNameObjectMapper.internalClassName) {
        [self.classNameMappingDictionary setValue:classNameObjectMapper.internalClassName forKey:classNameObjectMapper.jsonClassName];
    }
    else {
        if (!classNameObjectMapper) {
            NSLog(@"Warning : No Class Name Object Mapper Available");
        }
        else {
            if (!classNameObjectMapper.jsonClassName) {
                NSLog(@"Warning : Class can not be empty");
            }
            if (!classNameObjectMapper.internalClassName) {
                NSLog(@"Warning : To Map Class can not be empty");
            }
        }
    }
}

- (void)addClassesNameMapping:(NSArray*)classNameObjectMapperArray {
    if (classNameObjectMapperArray && classNameObjectMapperArray.count) {
        for (id _objectMapper in classNameObjectMapperArray) {
            [self addClassNameMapping:_objectMapper];
        }
    }
    else {
        NSLog(@"Warning : Class Name ObjectMapper Array is Empty!!");
    }
}

#pragma mark - Private Methods
- (void)insertAttributeMapping:(ObjectMapper*)attributeNameObjectMapper {
    if (attributeNameObjectMapper && attributeNameObjectMapper.jsonAttributeName && attributeNameObjectMapper.classAttributeName && attributeNameObjectMapper.jsonClassName) {
        [self.attributeNameMappingDictionary setValue:[NSDictionary dictionaryWithObject:attributeNameObjectMapper.classAttributeName forKey:attributeNameObjectMapper.jsonAttributeName] forKey:attributeNameObjectMapper.jsonClassName];
    }
    else {
        if (!attributeNameObjectMapper) {
            NSLog(@"Warning : No Attribute Name Object Mapper Available");
        }
        else {
            if (!attributeNameObjectMapper.jsonAttributeName) {
                NSLog(@"Warning : Key can not be empty");
            }
            if (!attributeNameObjectMapper.classAttributeName) {
                NSLog(@"Warning : Attribute can not be empty");
            }
            if (!attributeNameObjectMapper.jsonClassName) {
                NSLog(@"Warning : Class can not be empty");
            }
        }
    }
}

- (NSString*)getNameMappingForJSONAttributeKey:(NSString*)key inJSONClassKey:(NSString*)inJSONClassKey {
    // Check if we have
    if (attributeNameMappingDictionary && [attributeNameMappingDictionary objectForKey:inJSONClassKey] && [[attributeNameMappingDictionary objectForKey:inJSONClassKey] objectForKey:key]) {
        return [[attributeNameMappingDictionary objectForKey:inJSONClassKey] objectForKey:key];
    }
    else if ([key isEqualToString:@"id"]) {
        return [NSString stringWithFormat:@"%@Id", inJSONClassKey];
    }
    return [key camelizeAttribute];
}

- (NSString*)getNameMappingForJSONClassKey:(NSString*)jsonClassKey {
    // First look into the class Dictionary, If we have a mapping return the same.
    // else then try the Camel Case, if we have a camel case return the same, else return what came in.
    NSString *_returnClassName = nil;
    if (classNameMappingDictionary && [classNameMappingDictionary objectForKey:jsonClassKey]) {
        _returnClassName = [classNameMappingDictionary objectForKey:jsonClassKey];
    }
    else {
        _returnClassName = [jsonClassKey camelizeClassName];
    }
    if (!_returnClassName) {
        _returnClassName = jsonClassKey;
    }
    return _returnClassName;
}

@end
