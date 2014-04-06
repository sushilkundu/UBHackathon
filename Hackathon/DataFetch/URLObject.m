//
//  URLObject.m
//  ET
//
//  Created by Ravi Sahu on 08/05/13.
//  Copyright (c) 2013 Times Internet Limited. All rights reserved.
//

#import "URLObject.h"
#import "DataFetchConstants.h"

#import "ObjectMapper.h"
#import "ObjectMapperContainer.h"

@implementation URLObject

@synthesize requestType;
@synthesize headerParams;

@synthesize urlPath;
@synthesize postPath;
@synthesize params;

@synthesize encoding;

@synthesize forcedFecth;
@synthesize needsPersistance;
@synthesize cacheIntervalTime;

@synthesize mappingRequired;
@synthesize toInternalClass;
@synthesize objectMapperContainer;

@synthesize infoDictionary;

+ (URLObject*)urlObjectForRequestType:(RequestType)aRequestType
                         headerParams:(NSDictionary*)aHeaderParams
                              urlPath:(NSString*)aURLPath
                               params:(NSDictionary*)aParams
                          forcedFecth:(BOOL)aForceFetch
                     needsPersistance:(BOOL)aNeedPersisctance
                    cacheIntervalTime:(NSTimeInterval)aCacheIntervalTime
                       infoDictionary:(NSDictionary*)aInfoDictionary
                      mappingRequired:(BOOL)mappingRequired
                        internalClass:(NSString*)internalClass
                objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer {
    URLObject *_urlObject = [[URLObject alloc] init];
    [_urlObject setRequestType:aRequestType];
    [_urlObject setHeaderParams:aHeaderParams];
    [_urlObject setUrlPath:aURLPath];
    [_urlObject setParams:aParams];
    [_urlObject setEncoding:NSUTF8StringEncoding];
    [_urlObject setForcedFecth:aForceFetch];
    [_urlObject setNeedsPersistance:aNeedPersisctance];
    [_urlObject setCacheIntervalTime:aCacheIntervalTime];
    [_urlObject setInfoDictionary:aInfoDictionary];
    [_urlObject setMappingRequired:mappingRequired];
    [_urlObject setToInternalClass:internalClass];
    if (objectMapperContainer) [_urlObject setObjectMapperContainer:objectMapperContainer];
    else [_urlObject setObjectMapperContainer:[ObjectMapperContainer objectMapperContainer]];
    return _urlObject;
}

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath {
    return [URLObject urlObjectForRequestType:kRequestTypeGet headerParams:nil urlPath:aURLPath params:nil forcedFecth:NO needsPersistance:YES cacheIntervalTime:DEFAULT_CACHE_TIME infoDictionary:nil mappingRequired:YES internalClass:nil objectMapperContainer:nil];
}

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                     internalClass:(NSString*)internalClass {
    return [URLObject urlObjectForRequestType:kRequestTypeGet headerParams:nil urlPath:aURLPath params:nil forcedFecth:NO needsPersistance:YES cacheIntervalTime:DEFAULT_CACHE_TIME infoDictionary:nil mappingRequired:YES internalClass:internalClass objectMapperContainer:nil];
}

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
             objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer {
    return [URLObject urlObjectForRequestType:kRequestTypeGet headerParams:nil urlPath:aURLPath params:nil forcedFecth:NO needsPersistance:YES cacheIntervalTime:DEFAULT_CACHE_TIME infoDictionary:nil mappingRequired:YES internalClass:nil objectMapperContainer:objectMapperContainer];
}

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                     internalClass:(NSString*)internalClass
             objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer {
    return [URLObject urlObjectForRequestType:kRequestTypeGet headerParams:nil urlPath:aURLPath params:nil forcedFecth:NO needsPersistance:YES cacheIntervalTime:DEFAULT_CACHE_TIME infoDictionary:nil mappingRequired:YES internalClass:internalClass objectMapperContainer:objectMapperContainer];
}

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                       forcedFecth:(BOOL)aForceFetch {
    return [URLObject urlObjectForRequestType:kRequestTypeGet headerParams:nil urlPath:aURLPath params:nil forcedFecth:aForceFetch needsPersistance:YES cacheIntervalTime:DEFAULT_CACHE_TIME infoDictionary:nil mappingRequired:YES internalClass:nil objectMapperContainer:nil];
}

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                       forcedFecth:(BOOL)aForceFetch
                     internalClass:(NSString*)internalClass {
    return [URLObject urlObjectForRequestType:kRequestTypeGet headerParams:nil urlPath:aURLPath params:nil forcedFecth:aForceFetch needsPersistance:YES cacheIntervalTime:DEFAULT_CACHE_TIME infoDictionary:nil mappingRequired:YES internalClass:internalClass objectMapperContainer:nil];
}

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                       forcedFecth:(BOOL)aForceFetch
             objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer {
    return [URLObject urlObjectForRequestType:kRequestTypeGet headerParams:nil urlPath:aURLPath params:nil forcedFecth:aForceFetch needsPersistance:YES cacheIntervalTime:DEFAULT_CACHE_TIME infoDictionary:nil mappingRequired:YES internalClass:nil objectMapperContainer:objectMapperContainer];
}

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                       forcedFecth:(BOOL)aForceFetch
                     internalClass:(NSString*)internalClass
             objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer {
    return [URLObject urlObjectForRequestType:kRequestTypeGet headerParams:nil urlPath:aURLPath params:nil forcedFecth:aForceFetch needsPersistance:YES cacheIntervalTime:DEFAULT_CACHE_TIME infoDictionary:nil mappingRequired:YES internalClass:internalClass objectMapperContainer:objectMapperContainer];
}

@end
