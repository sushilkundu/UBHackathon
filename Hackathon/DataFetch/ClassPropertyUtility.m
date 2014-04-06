//
//  ClassPropertyUtility.m
//  JSONDeserialize
//
//  Created by Ravi Sahu on 22/12/11.
//  Copyright 2011 Times Internet Limited. All rights reserved.
//

#import "ClassPropertyUtility.h"
#import "objc/runtime.h"
#import "JSONClassPropertyCache.h"

@implementation ClassPropertyUtility

+ (NSDictionary*)propertyDictionary:(Class)aObjectClass {
    NSDictionary *_cachePropertyDictionary = [[JSONClassPropertyCache sharedInstance] getClassPropertyFromCache:aObjectClass];
    if (_cachePropertyDictionary) {
        return _cachePropertyDictionary;
    }
    else {
        unsigned int outCount, i;
        NSMutableDictionary *_propertyDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_property_t *properties = class_copyPropertyList(aObjectClass, &outCount);
        for(i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *_propertyName = property_getName(property);
            const char *_attributes = property_getAttributes(property);
            
            NSString *_attributesString = [NSString stringWithCString:_attributes encoding:NSUTF8StringEncoding];
            NSArray *_firstStageArray = [_attributesString componentsSeparatedByString:@","];
            if (_firstStageArray && [_firstStageArray count]) {
                NSString *_firstStageString = [_firstStageArray objectAtIndex:0];
                NSArray *_secondStageArray = [_firstStageString componentsSeparatedByString:@"\""];
                if (_secondStageArray && [_secondStageArray count]) {
                    //NSLog(@"%@", [_secondStageArray objectAtIndex:1]);
                    NSString *propertyName = [NSString stringWithCString:_propertyName encoding:NSUTF8StringEncoding];
                    NSString *propertyType = [NSString stringWithString:[_secondStageArray objectAtIndex:1]];
                    [_propertyDictionary setValue:propertyType forKey:propertyName];
                }
            }
        }
        free(properties);
        [[JSONClassPropertyCache sharedInstance] addClassPropertyToCache:_propertyDictionary forClass:aObjectClass];
        return _propertyDictionary;
    }
	return nil;
}

@end
