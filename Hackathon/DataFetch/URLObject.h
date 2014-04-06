//
//  URLObject.h
//  ET
//
//  Created by Ravi Sahu on 08/05/13.
//  Copyright (c) 2013 Times Internet Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectMapperContainer;

typedef enum {
    kRequestTypeGet,
    kRequestTypePost
} RequestType;


@interface URLObject : NSObject

@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, strong) NSDictionary *headerParams;

@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, strong) NSString *postPath;
@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, assign) NSStringEncoding encoding;

@property (nonatomic, assign) BOOL forcedFecth;
@property (nonatomic, assign) BOOL needsPersistance;
@property (nonatomic, assign) NSTimeInterval cacheIntervalTime;

@property (nonatomic, assign) BOOL mappingRequired;
@property (nonatomic, strong) NSString *toInternalClass;
@property (nonatomic, strong) ObjectMapperContainer *objectMapperContainer;

@property (nonatomic, strong) NSDictionary *infoDictionary;

// Convience Constructors

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
                objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer;

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath;

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                     internalClass:(NSString*)internalClass;

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
             objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer;

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                     internalClass:(NSString*)internalClass
             objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer;

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                       forcedFecth:(BOOL)aForceFetch;

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                       forcedFecth:(BOOL)aForceFetch
                     internalClass:(NSString*)internalClass;

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                       forcedFecth:(BOOL)aForceFetch
             objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer;

+ (URLObject*)defaultGETForURLPath:(NSString*)aURLPath
                       forcedFecth:(BOOL)aForceFetch
                     internalClass:(NSString*)internalClass
             objectMapperContainer:(ObjectMapperContainer*)objectMapperContainer;

@end
