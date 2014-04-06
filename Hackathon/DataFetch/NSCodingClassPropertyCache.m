//
//  NSCodingClassPropertyCache.m
//  TOIFramework
//
//  Created by Ravi Sahu on 10/07/13.
//  Copyright 2013 Ravi Sahu. All rights reserved.
//	

#import "NSCodingClassPropertyCache.h"

@interface NSCodingClassPropertyCache ()

@property (nonatomic, strong) NSCache *propertyCache;

@end

@implementation NSCodingClassPropertyCache

#pragma mark -
#pragma mark Singleton Methods

+ (NSCodingClassPropertyCache*)sharedInstance {

	static NSCodingClassPropertyCache *_sharedInstance;
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

- (void)release {
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
