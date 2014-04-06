//
//  NSCodingClassPropertyCache.h
//  TOIFramework
//
//  Created by Ravi Sahu on 10/07/13.
//  Copyright 2013 Ravi Sahu. All rights reserved.
//	

#import <Foundation/Foundation.h>

@interface NSCodingClassPropertyCache : NSObject

+ (NSCodingClassPropertyCache*) sharedInstance;

- (void)addClassPropertyToCache:(NSDictionary*)propertyDictionary forClass:(Class)aClass;
- (NSDictionary*)getClassPropertyFromCache:(Class)aClass;

@end
