//
//  ClassPropertyCache.m
//  DataFetchFramework
//
//  Created by Ravi Sahu on 13/06/13.
//  Copyright 2013 Ravi Sahu. All rights reserved.
//

#import "JSONClassPropertyCache.h"

@interface JSONClassPropertyCache ()

@property (nonatomic, strong) NSCache *propertyCache;

@end

@implementation JSONClassPropertyCache

#pragma mark -
#pragma mark Singleton Methods

+ (JSONClassPropertyCache*)sharedInstance {
    
	static JSONClassPropertyCache *_sharedInstance;
	if(!_sharedInstance) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
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

- (void)addClassPropertyToCache:(NSDictionary*)propertyDictionary forClass:(Class)aClass {
    if (!self.propertyCache) self.propertyCache = [NSCache new];
    [self.propertyCache setObject:propertyDictionary forKey:NSStringFromClass(aClass)];
}

- (NSDictionary*)getClassPropertyFromCache:(Class)aClass {
    if (self.propertyCache && [self.propertyCache objectForKey:NSStringFromClass(aClass)]) return [self.propertyCache objectForKey:NSStringFromClass(aClass)];
    return nil;
}

@end
