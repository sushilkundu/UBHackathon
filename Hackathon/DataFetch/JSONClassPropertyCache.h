//
//  ClassPropertyCache.h
//  DataFetchFramework
//
//  Created by Ravi Sahu on 13/06/13.
//  Copyright 2013 Ravi Sahu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONClassPropertyCache : NSObject

+ (JSONClassPropertyCache*) sharedInstance;

- (void)addClassPropertyToCache:(NSDictionary*)propertyDictionary forClass:(Class)aClass;
- (NSDictionary*)getClassPropertyFromCache:(Class)aClass;

@end
