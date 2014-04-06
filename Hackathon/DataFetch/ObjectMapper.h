//
//  ObjectMapper.h
//  ET
//
//  Created by Ravi Sahu on 17/05/13.
//  Copyright (c) 2013 Times Internet Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectMapper : NSObject

@property (nonatomic, strong) NSString *jsonAttributeName;
@property (nonatomic, strong) NSString *classAttributeName;

@property (nonatomic, strong) NSString *internalClassName;

@property (nonatomic, assign) NSString *jsonClassName;

+ (id)objectMapperForJsonAttribute:(NSString*)jsonAttribute
                  toClassAttribute:(NSString*)toClassAttribute
                         jsonClass:(NSString*)jsonClass;

+ (id)objectMapperForJsonClass:(NSString*)jsonClassName
               toInternalClass:(NSString*)toInternalClass;

@end
