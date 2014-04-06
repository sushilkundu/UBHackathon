//
//  NSObject+JSONDeserializer.m
//  JSONDeserialize
//
//  Created by Ravi Sahu on 22/12/11.
//  Copyright 2011 Times Internet Limited. All rights reserved.
//

#import "ClassPropertyUtility.h"
#import "NSObject+JSONDeserializer.h"

//#import "ObjectMapper.h"
#import "ObjectMapperContainer.h"
//#import "NSString+Camelize.h"


@interface NSObject (JSONDeserializer_Private)

- (id) deserializeJSON:(id)aJSONObject classMappingDictionary:(NSDictionary*)aClassMappingDictionary;
- (id) deserializeJSON:(id)aJSONObject forClassName:(NSString*)aClassName classMappingDictionary:(NSDictionary*)aClassMappingDictionary;

- (id) deserializeJSON:(id)aJSONObject objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer;
- (id) deserializeJSON:(id)aJSONObject forClassName:(NSString*)aClassName objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer;

@end

@implementation NSObject (JSONDeserializer)

#pragma mark - Public Functions
- (id)deserializeJSONObject:(id)aJSONObject {
    return [self deserializeJSONObject:aJSONObject classMappingDictionary:nil];
}

- (id)deserializeJSONObject:(id)aJSONObject classMappingDictionary:(NSDictionary*)aClassMappingDictionary {
    return [self deserializeJSON:aJSONObject classMappingDictionary:aClassMappingDictionary];
}

- (id)deserializeJSONObject:(id)aJSONObject forPath:(NSString*)aPath {
    return [self deserializeJSONObject:aJSONObject forPath:aPath classMappingDictionary:nil];
}

- (id)deserializeJSONObject:(id)aJSONObject forPath:(NSString*)aPath classMappingDictionary:(NSDictionary*)aClassMappingDictionary {
    id _jsonObject = aJSONObject;
    id _returnData = nil;
    NSArray *_pathArray = [aPath componentsSeparatedByString:@"->"];
    // Come to that path
    for (int _index = 0; _index < [_pathArray count]; _index++) {
        _jsonObject = [_jsonObject objectForKey:[_pathArray objectAtIndex:_index]];
    }
    if (_jsonObject) {
        _returnData = [self deserializeJSON:_jsonObject forClassName:[_pathArray lastObject] classMappingDictionary:aClassMappingDictionary];
    }
    
    return _returnData;
}

// Blocks Functions
- (void)deserializeJSONObject:(id)aJSONObject success:(void (^)(id aObject))success failure:(void (^)(NSString* aErrorString))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id _data = [self deserializeJSONObject:aJSONObject classMappingDictionary:nil];
        if (_data) {
			dispatch_async(dispatch_get_main_queue(), ^{
                success(_data);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // TODO
                failure(nil);
            });
        }
    });
}

- (void)deserializeJSONObject:(id)aJSONObject forPath:(NSString*)aPath classMappingDictionary:(NSDictionary*)aClassMappingDictionary success:(void (^)(id aObject))success failure:(void (^)(NSString* aErrorString))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (aPath) {
            id _data = [self deserializeJSONObject:aJSONObject forPath:aPath classMappingDictionary:aClassMappingDictionary];
            if (_data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(_data);
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // TODO
                    failure(nil);
                });
            }
        }
        else if (aClassMappingDictionary) {
            id _data = [self deserializeJSONObject:aJSONObject classMappingDictionary:aClassMappingDictionary];
            if (_data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(_data);
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // TODO
                    failure(nil);
                });
            }
        }
    });
}

- (void)deserializeJSONObject:(id)aJSONObject objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer success:(void (^)(id aObject))success failure:(void (^)(NSError* error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id _data = [self deserializeJSON:aJSONObject objectMapperContainer:objectMapperContainer];
        if ([_data isKindOfClass:[NSError class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(_data);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(_data);
            });
        }
    });
}

#pragma mark - Private Functions
- (id) deserializeJSON:(id)aJSONObject classMappingDictionary:(NSDictionary*)aClassMappingDictionary {
    id _returnData = nil;
    // Initialize the _object to nil. It will be filled according to need
    if ([aJSONObject isKindOfClass:[NSDictionary class]]) {
        NSArray *_allKeys = [aJSONObject allKeys];
        for (NSString *_key in _allKeys) {
            Class _targetClass = nil;
            NSString *_reflexStringDueToClassMapping = nil;
            if (aClassMappingDictionary && [aClassMappingDictionary valueForKey:_key]) {
                _targetClass = NSClassFromString([aClassMappingDictionary valueForKey:_key]);
                _reflexStringDueToClassMapping = [aClassMappingDictionary valueForKey:_key];
            }
            else {
                _targetClass = NSClassFromString(_key);
            }
            
            if (_reflexStringDueToClassMapping) {
                if (_targetClass) {
                    // Get the data for the specific key
                    _returnData = [self deserializeJSON:[aJSONObject valueForKey:_key] forClassName:_reflexStringDueToClassMapping classMappingDictionary:aClassMappingDictionary];
                }
            }
            else {
                if (_targetClass) {
                    // Get the data for the specific key
                    _returnData = [self deserializeJSON:[aJSONObject valueForKey:_key] forClassName:_key classMappingDictionary:aClassMappingDictionary];
                }
            }
        }
    }
    else if ([aJSONObject isKindOfClass:[NSArray class]]) {
        _returnData = [[NSMutableArray alloc] init];
        for (id _childJSONObject in aJSONObject) {
            [_returnData addObject:[self deserializeJSON:_childJSONObject classMappingDictionary:aClassMappingDictionary]];
        }
    }
    else {
        _returnData = aJSONObject;
    }
    return _returnData;
}

- (id) deserializeJSON:(id)aJSONObject forClassName:(NSString*)aClassName classMappingDictionary:(NSDictionary*)aClassMappingDictionary {
    id _returnData = nil;
    Class _targetClass = nil;
    if (aClassMappingDictionary && [aClassMappingDictionary valueForKey:aClassName]) {
        _targetClass = NSClassFromString([aClassMappingDictionary valueForKey:aClassName]);
    }
    else {
        _targetClass = NSClassFromString(aClassName);
    }
    if (_targetClass) {
        if ([aJSONObject isKindOfClass:[NSArray class]]) {
            // This means array of aClassName objects
            _returnData = [[NSMutableArray alloc] init];
            for (id _childJSONObject in aJSONObject) {
                [_returnData addObject:[self deserializeJSON:_childJSONObject forClassName:aClassName classMappingDictionary:aClassMappingDictionary]];
            }
        }
        else if ([aJSONObject isKindOfClass:[NSDictionary class]]) {
            id _classObject = [[_targetClass alloc] init];
            // Get the list of Instance Varialble in the Class and its corresponding type.
            NSDictionary *_propertyTypeDictionary = [ClassPropertyUtility propertyDictionary:_targetClass];
            // Get all the keys
            NSArray *_propertyArray = [_propertyTypeDictionary allKeys];
            for (NSString *_property in _propertyArray) {
                // Check this property is present in the classMappingDictionary
                NSArray *_keyArray = [aClassMappingDictionary allKeysForObject:_property];
                NSString *_reflexStringDueToClassMapping = nil;
                if (_keyArray && [_keyArray count]) {
                    _reflexStringDueToClassMapping = [[NSString alloc] initWithString:[_keyArray objectAtIndex:0]];
                }
                if (_reflexStringDueToClassMapping) {
                    if ([[aJSONObject valueForKey:_reflexStringDueToClassMapping] isKindOfClass:[NSArray class]]) {
                        if ([aJSONObject valueForKey:_reflexStringDueToClassMapping]) {
                            id _data = [self deserializeJSON:[aJSONObject valueForKey:_reflexStringDueToClassMapping] forClassName:_property classMappingDictionary:aClassMappingDictionary];
                            if (_data) {
                                [_classObject setValue:_data forKey:_property];
                            }
                        }
                    }
                }
                else if ([[aJSONObject valueForKey:_property] isKindOfClass:[NSArray class]]) {
                    if ([aJSONObject valueForKey:_property]) {
                        id _data = [self deserializeJSON:[aJSONObject valueForKey:_property] forClassName:_property classMappingDictionary:aClassMappingDictionary];
                        if (_data) {
                            [_classObject setValue:_data forKey:_property];
                        }
                    }
                }
                else if ([[aJSONObject valueForKey:_property] isKindOfClass:[NSDictionary class]]) {
                    if ([aJSONObject valueForKey:_property]) {
                        id _data = [self deserializeJSON:[aJSONObject valueForKey:_property] forClassName:[_propertyTypeDictionary valueForKey:_property] classMappingDictionary:aClassMappingDictionary];
                        if (_data) {
                            [_classObject setValue:_data forKey:_property];
                        }
                    }
                }
                else {
                    if ([aJSONObject valueForKey:_property]) {
                        id _data = [self deserializeJSON:[aJSONObject valueForKey:_property] classMappingDictionary:aClassMappingDictionary];
                        if (_data) {
                            [_classObject setValue:_data forKey:_property];
                        }
                    }
                }
            }
            _returnData = _classObject;
        }
        else {
            _returnData = aJSONObject;
        }
    }
    return _returnData;
}

- (id) deserializeJSON:(id)aJSONObject objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer {
    id _returnData = nil;
    // Initialize the _object to nil. It will be filled according to need
    if ([aJSONObject isKindOfClass:[NSDictionary class]]) {
        NSArray *_allKeys = [aJSONObject allKeys];
        for (NSString *_key in _allKeys) {
            // Ravi
            Class _targetClass =  NSClassFromString([objectMapperContainer getNameMappingForJSONClassKey:_key]);//NSClassFromString([_key camelizeClassName]);
            if (_targetClass) {
                // Get the data for the specific key
                _returnData = [self deserializeJSON:[aJSONObject valueForKey:_key] forClassName:_key objectMapperContainer:objectMapperContainer];
            }
        }
    }
    else if ([aJSONObject isKindOfClass:[NSArray class]]) {
        _returnData = [[NSMutableArray alloc] init];
        for (id _childJSONObject in aJSONObject) {
            [_returnData addObject:[self deserializeJSON:_childJSONObject objectMapperContainer:objectMapperContainer]];
        }
    }
    else {
        _returnData = aJSONObject;
    }
    return _returnData;
}

- (id) deserializeJSON:(id)aJSONObject forClassName:(NSString*)aClassName objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer {
    id _returnData = nil;
    // Ravi
    Class _targetClass = NSClassFromString([objectMapperContainer getNameMappingForJSONClassKey:aClassName]);//NSClassFromString([aClassName camelizeClassName]);
    if (_targetClass && [aJSONObject isKindOfClass:[NSDictionary class]]) {
        id _classObject = nil;
        // Get the list of Instance Varialble in the Class and its corresponding type.
        NSDictionary *_propertyTypeDictionary = [ClassPropertyUtility propertyDictionary:_targetClass];
        NSSet *_propertyTypeDictionaryAllKeysSet = [NSSet setWithArray:[_propertyTypeDictionary allKeys]];
        // Get all the keys
        NSArray *_propertyArray = [aJSONObject allKeys];
        for (NSString *_property in _propertyArray) {
            // Ravi
            NSString *_propertyCamalized = [objectMapperContainer getNameMappingForJSONAttributeKey:_property inJSONClassKey:aClassName];//[_property camelizeAttribute];
            if ([_propertyTypeDictionaryAllKeysSet containsObject:_propertyCamalized]) {
                id _data = [self deserializeJSON:[aJSONObject valueForKey:_property] forClassName:_propertyCamalized objectMapperContainer:objectMapperContainer];
                if (_data) {
                    if (!_classObject) _classObject = [[_targetClass alloc] init];
                    [_classObject setValue:_data forKey:_propertyCamalized];
                }
            }
        }
        _returnData = _classObject;
    }
    else if ([aJSONObject isKindOfClass:[NSArray class]]) {
        // This means array of aClassName objects
        _returnData = [[NSMutableArray alloc] init];
        for (id _childJSONObject in aJSONObject) {
            [_returnData addObject:[self deserializeJSON:_childJSONObject forClassName:aClassName objectMapperContainer:objectMapperContainer]];
        }
    }
    else {
        _returnData = aJSONObject;
    }
    return _returnData;
}

@end
