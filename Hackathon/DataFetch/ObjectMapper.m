//
//  ObjectMapper.m
//  ET
//
//  Created by Ravi Sahu on 17/05/13.
//  Copyright (c) 2013 Times Internet Limited. All rights reserved.
//

#import "ObjectMapper.h"

@implementation ObjectMapper

@synthesize jsonAttributeName;
@synthesize classAttributeName;
@synthesize internalClassName;
@synthesize jsonClassName;

+ (id)objectMapperForJsonAttribute:(NSString*)jsonAttribute
                  toClassAttribute:(NSString*)toClassAttribute
                         jsonClass:(NSString*)jsonClass {
    ObjectMapper *_objectMapper = [ObjectMapper new];
    if (_objectMapper) {
        _objectMapper.jsonAttributeName = jsonAttribute;
        _objectMapper.classAttributeName = toClassAttribute;
        _objectMapper.jsonClassName = jsonClass;
    }
    return _objectMapper;
}

+ (id)objectMapperForJsonClass:(NSString*)jsonClassName
               toInternalClass:(NSString*)toInternalClass {
    ObjectMapper *_objectMapper = [ObjectMapper new];
    if (_objectMapper) {
        _objectMapper.jsonClassName = jsonClassName;
        _objectMapper.internalClassName = toInternalClass;
    }
    return _objectMapper;
}

@end
