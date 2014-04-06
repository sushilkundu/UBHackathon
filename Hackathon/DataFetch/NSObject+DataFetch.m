
//
//  NSObject+DataFetch.m
//  CommonFramework
//
//  Created by Ravi Sahu on 13/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+DataFetch.h"
#import "NSObject+JSONDeserializer.h"
#import "AFNetworking.h"
#import "DataFetchConstants.h"

@interface NSObject (DataFetch_Private)

- (void)sendSuccessData:(id)aData urlKey:aURLKey forSelector:(SEL)aSucessSelector urlString:(NSString*)aURLString;
- (void)sendFaliureData:(id)aData urlKey:aURLKey withError:(NSError *)error forSelector:(SEL)aFailureSelector urlString:(NSString*)aURLString;

@end

@implementation NSObject (DataFetch)

- (void)requestDataFromURL:(NSString*)aURLString urlKey:(NSString*)urlKey doDerialization:(BOOL)aDeserializeFlag sucessSelector:(SEL)aSucessSelector failureSelector:(SEL)aFailureSelector {
	@autoreleasepool {
        if (!aURLString) return;
        NSURL *url = [NSURL URLWithString:aURLString];
		// Check for cached data
        id _data = [[URLCache sharedInstance] getDataFromCacheForURL:url needTimCheck:YES];
		if (_data) {
            int64_t delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self sendSuccessData:_data urlKey:urlKey forSelector:aSucessSelector urlString:aURLString];
            });
		}
		else {
			NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30];
			AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
				if (aDeserializeFlag) {
					// Call the deserailize block
					[self deserializeJSONObject:JSON success:^(id aData) {
                        // Create a cache data
                        CacheData *_cacheData = [[CacheData alloc] init];
                        // Write the values
                        [_cacheData setCachedData:aData];
                        [_cacheData setCacheCreatedDateTime:[NSDate date]];
                        
						// Save data to cache
                        [[URLCache sharedInstance] addDataToCache:_cacheData forURL:url];
                        [self sendSuccessData:_cacheData urlKey:urlKey forSelector:aSucessSelector urlString:aURLString];
					} failure:^(NSString* errorString) {
                        NSLog(@"Deserialation Error : %@", errorString);
						id _data = [[URLCache sharedInstance] getDataForURL:url needTimCheck:NO];
                        if (_data) [[URLCache sharedInstance] addDataToCache:_data forURL:url];
                        [self sendFaliureData:_data?_data:nil urlKey:urlKey withError:[self createErrorForString:SOMETHING_WENT_WRONG errorCode:100] forSelector:aFailureSelector urlString:aURLString];
					}];
				}
				else {
                    // Create a cache data
                    CacheData *_cacheData = [[CacheData alloc] init];
                    // Write the values
                    [_cacheData setCachedData:JSON];
                    [_cacheData setCacheCreatedDateTime:[NSDate date]];
                    
					// Save data to cache
					[[URLCache sharedInstance] addDataToCache:_cacheData forURL:url];
					// No Deserilization is required,return JSON Object
                    [self sendSuccessData:_cacheData urlKey:urlKey forSelector:aSucessSelector urlString:aURLString];
				}
			} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseData) {
                NSLog(@"URL : %@ \nUser Info : %@; Desc : %@", aURLString, error.userInfo, error.localizedDescription);
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                id _data = [[URLCache sharedInstance] getDataForURL:url needTimCheck:NO];
                if (_data) [[URLCache sharedInstance] addDataToCache:_data forURL:url];
                [self sendFaliureData:_data?_data:nil urlKey:urlKey withError:[self createErrorForString:_data?NO_NETWORK_CHACHE_STRING:NO_NETWORK_STRING errorCode:100] forSelector:aFailureSelector urlString:aURLString];
			}];
            [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
			[operation start];
		}
	}
}

- (void)requestDataFromURL:(NSString*)aURLString urlKey:(NSString*)urlKey doDerialization:(BOOL)aDeserializeFlag cacheTimeInterval:(NSTimeInterval)cacheTimeInterval success:(void (^)(id aObject))success failure:(void (^)(id aObject, NSError* error))failure {
    @synchronized(self) {
        NSURL *url = [NSURL URLWithString:aURLString];
		// Check for cached data
        id _data = [[URLCache sharedInstance] getDataFromCacheForURL:url needTimCheck:YES cacheTimeInterval:cacheTimeInterval];
		if (_data) {
            success(_data);
		}
		else {
			NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30];
			AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
				if (aDeserializeFlag) {
					// Call the deserailize block
					[self deserializeJSONObject:JSON success:^(id aData) {
                        // Create a cache data
                        CacheData *_cacheData = [[CacheData alloc] init];
                        // Write the values
                        [_cacheData setCachedData:aData];
                        [_cacheData setCacheCreatedDateTime:[NSDate date]];
                        
						// Save data to cache
                        [[URLCache sharedInstance] addDataToCache:_cacheData forURL:url];
                        success(_cacheData);
					} failure:^(NSString* errorString) {
                        NSLog(@"Deserialation Error : %@", errorString);
						id _data = [[URLCache sharedInstance] getDataForURL:url needTimCheck:NO];
                        if (_data) [[URLCache sharedInstance] addDataToCache:_data forURL:url];
                        failure(_data?_data:nil, [self createErrorForString:SOMETHING_WENT_WRONG errorCode:100]);
					}];
				}
				else {
                    // Create a cache data
                    CacheData *_cacheData = [[CacheData alloc] init];
                    // Write the values
                    [_cacheData setCachedData:JSON];
                    [_cacheData setCacheCreatedDateTime:[NSDate date]];
                    
					// Save data to cache
					[[URLCache sharedInstance] addDataToCache:_cacheData forURL:url];
					// No Deserilization is required,return JSON Object
                    success(_cacheData);
				}
			} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseData) {
                NSLog(@"User Info : %@; Desc : %@", error.userInfo, error.localizedDescription);
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                
				id _data = [[URLCache sharedInstance] getDataForURL:url needTimCheck:NO];
                if (_data) [[URLCache sharedInstance] addDataToCache:_data forURL:url];
                failure(_data?_data:nil, [self createErrorForString:_data?NO_NETWORK_CHACHE_STRING:NO_NETWORK_STRING errorCode:100]);
			}];
            [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
			[operation start];
		}
    }
}

- (void)requestDataFromURL:(NSString*)aURLString urlKey:(NSString*)urlKey deserializationPath:(NSString*)aPath deserializationClassMappingDictionary:(NSDictionary*)aMapingDictionary sucessSelector:(SEL)aSucessSelector failureSelector:(SEL)aFailureSelector {
	@autoreleasepool {
		// Check for cached data
		NSURL *url = [NSURL URLWithString:aURLString];
		// Check for cached data
        id _data = [[URLCache sharedInstance] getDataFromCacheForURL:url needTimCheck:YES];
		if (_data) {
			int64_t delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self sendSuccessData:_data urlKey:urlKey forSelector:aSucessSelector urlString:aURLString];
            });
		}
		else {
			NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30];
			AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
				// Call the deserailize block
				[self deserializeJSONObject:JSON forPath:aPath classMappingDictionary:aMapingDictionary success:^(id aData) {
					// Create a cache data
                    CacheData *_cacheData = [[CacheData alloc] init];
                    // Write the values
                    [_cacheData setCachedData:aData];
                    [_cacheData setCacheCreatedDateTime:[NSDate date]];
                    
                    // Save data to cache
                    [[URLCache sharedInstance] addDataToCache:_cacheData forURL:url];
                    [self sendSuccessData:_cacheData urlKey:urlKey forSelector:aSucessSelector urlString:aURLString];
				} failure:^(NSString* errorString) {
                    NSLog(@"Deserialation Error : %@", errorString);
                    id _data = [[URLCache sharedInstance] getDataForURL:url needTimCheck:NO];
                    if (_data) [[URLCache sharedInstance] addDataToCache:_data forURL:url];
                    [self sendFaliureData:_data?_data:nil urlKey:urlKey withError:[self createErrorForString:SOMETHING_WENT_WRONG errorCode:100] forSelector:aFailureSelector urlString:aURLString];
				}];
			} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseData) {
                NSLog(@"User Info : %@; Desc : %@", error.userInfo, error.localizedDescription);
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
				id _data = [[URLCache sharedInstance] getDataForURL:url needTimCheck:NO];
                if (_data) [[URLCache sharedInstance] addDataToCache:_data forURL:url];
                [self sendFaliureData:_data?_data:nil urlKey:urlKey withError:[self createErrorForString:_data?NO_NETWORK_CHACHE_STRING:NO_NETWORK_STRING errorCode:100] forSelector:aFailureSelector urlString:aURLString];
			}];
            [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
			[operation start];
		}
	}
}

- (void)requestDataFromURL:(NSString*)aURLString urlKey:(NSString*)urlKey deserializationPath:(NSString*)aPath deserializationClassMappingDictionary:(NSDictionary*)aMapingDictionary cacheTimeInterval:(NSTimeInterval)cacheTimeInterval success:(void (^)(id aObject))success failure:(void (^)(id aObject, NSError* error))failure {
    @synchronized(self) {
        // Check for cached data
		NSURL *url = [NSURL URLWithString:aURLString];
		// Check for cached data
        id _data = [[URLCache sharedInstance] getDataFromCacheForURL:url needTimCheck:YES cacheTimeInterval:cacheTimeInterval];
		if (_data) {
			success(_data);
		}
        else {
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                // Call the deserailize block
                [self deserializeJSONObject:JSON forPath:aPath classMappingDictionary:aMapingDictionary success:^(id aData) {
                    // Create a cache data
                    CacheData *_cacheData = [[CacheData alloc] init];
                    // Write the values
                    [_cacheData setCachedData:aData];
                    [_cacheData setCacheCreatedDateTime:[NSDate date]];
                    
                    // Save data to cache
                    [[URLCache sharedInstance] addDataToCache:_cacheData forURL:url];
                    success(_cacheData);
                } failure:^(NSString* errorString) {
                    NSLog(@"Deserialation Error : %@", errorString);
                    id _data = [[URLCache sharedInstance] getDataForURL:url needTimCheck:NO];
                    if (_data) [[URLCache sharedInstance] addDataToCache:_data forURL:url];
                    failure(_data?_data:nil, [self createErrorForString:SOMETHING_WENT_WRONG errorCode:100]);
                }];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseData) {
                NSLog(@"User Info : %@; Desc : %@", error.userInfo, error.localizedDescription);
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                id _data = [[URLCache sharedInstance] getDataForURL:url needTimCheck:NO];
                if (_data) [[URLCache sharedInstance] addDataToCache:_data forURL:url];
                failure(_data?_data:nil, [self createErrorForString:_data?NO_NETWORK_CHACHE_STRING:NO_NETWORK_STRING errorCode:100]);
            }];
            [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
            [operation start];
        }
    }
}

- (void)requestDataFromURLString:(NSString*)aURLString completionBlock:(void (^)(id aObject, NSError* error))completionBlock {
    URLObject *_urlObject = [URLObject defaultGETForURLPath:aURLString];
    [self requestDataFromURLObject:_urlObject completionBlock:^(id aObject, NSError *error) {
        completionBlock(aObject, error);
    }];
}

- (void)requestDataFromURLObject:(URLObject*)aURLObject completionBlock:(void (^)(id aObject, NSError* error))completionBlock {
    @synchronized(self) {
        // Check if aURLObject is in correct form, if not return error.
        NSError *_error = [self urlObjectSanityCheck:aURLObject];
        if (_error) {
            // aURLObject is not in correct format, send error on main thread.
            completionBlock(nil, _error);
        }
        else {
            __block CacheData *_cachedData = nil;
            __block NSString *_urlString = aURLObject.urlPath;
            NSURL *_url = [NSURL URLWithString:_urlString];
            if (!_url) {
                _urlString = [_urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                _url = [NSURL URLWithString:_urlString];
            }
            if (_url) {
                NSURL *_baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [_url host]]];
                // Create a HTTP Client with base URL
                AFHTTPClient *_httpClient = [[AFHTTPClient alloc] initWithBaseURL:_baseURL];
                // Set the encoding.
                [_httpClient setStringEncoding:aURLObject.encoding];
                // Check if the after being fecthed from the Server needs Internal Class wrapping, If wrapping is required then
                // AFNetwork auto JSON convert will not be used. If wrapping is not required, then auto JSON conversion will be
                // done after network call finishes.
                if (aURLObject.mappingRequired && !aURLObject.toInternalClass) {
                    [_httpClient setDefaultHeader:@"Accept" value:@"application/json"];
                    [_httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
                }
                if (aURLObject.requestType == kRequestTypePost) {
                    [_httpClient postPath:aURLObject.postPath parameters:aURLObject.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        // Check mapping is required or not. If mapping is not required add the data to cache and send it.
                        if (!aURLObject.mappingRequired) {
                            // Check if we have responseObject, if yes send the data to the caller, else create an error and send the error.
                            if (responseObject) {
                                _cachedData = [CacheData new];
                                [_cachedData setCachedData:responseObject];
                                _cachedData.cacheCreatedDateTime = [NSDate date];
                                if (aURLObject.needsPersistance) {
                                    // Save data to cache
                                    [[URLCache sharedInstance] addDataToCache:_cachedData forURL:_url];
                                }
                                
                                // Mark completion of block
                                completionBlock(_cachedData, nil);
                            }
                            else {
                                // TODO - Create error
                                // Error - Get data from cache or persistance without time check.
                                _cachedData = [[URLCache sharedInstance] getDataForURL:[NSURL URLWithString:_urlString] needTimCheck:NO];
                                // Mark completion of block
                                completionBlock(_cachedData, nil);
                            }
                        }
                        else {
                            // Mapping is required.
                            id _jsonData = responseObject;
                            NSError *_error = nil;
                            if (aURLObject.toInternalClass) {
                                NSMutableString *_mtJSONString = [[NSMutableString alloc] initWithFormat:@"{\"%@\":%@}", aURLObject.toInternalClass, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                // Convert to JSON
                                NSDictionary *_jsonDictionary = [NSJSONSerialization JSONObjectWithData:[_mtJSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&_error];
                                if (!_error) {
                                    _jsonData = _jsonDictionary;
                                }
                            }
                            if (_jsonData) {
                                [self deserializeJSONObject:_jsonData objectMapperContainer:aURLObject.objectMapperContainer success:^(id aObject) {
                                    _cachedData = [CacheData new];
                                    [_cachedData setCachedData:aObject];
                                    _cachedData.cacheCreatedDateTime = [NSDate date];
                                    if (aURLObject.needsPersistance) {
                                        // Save data to cache
                                        [[URLCache sharedInstance] addDataToCache:_cachedData forURL:_url];
                                    }
                                    
                                    // Mark completion of block
                                    completionBlock(_cachedData, nil);
                                } failure:^(NSError *error) {
                                    // Error - Get data from cache or persistance without time check.
                                    _cachedData = [[URLCache sharedInstance] getDataForURL:[NSURL URLWithString:_urlString] needTimCheck:NO];
                                    // Mark completion of block
                                    completionBlock(_cachedData, error);
                                }];
                            }
                            else {
                                // Error - Get data from cache or persistance without time check.
                                _cachedData = [[URLCache sharedInstance] getDataForURL:[NSURL URLWithString:_urlString] needTimCheck:NO];
                                // Mark completion of block
                                completionBlock(_cachedData, _error);
                            }
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        // Error - Get data from cache or persistance without time check.
                        _cachedData = [[URLCache sharedInstance] getDataForURL:[NSURL URLWithString:_urlString] needTimCheck:NO];
                        // Mark completion of block
                        completionBlock(_cachedData, error);
                    }];
                }
                else {
                    // Set the _needToFetchData flag to aURLObject.forcedFecth.
                    // If aURLObject.forcedFecth is YES, we dont need to check the cache, we need to make a mandatory network call.
                    // If aURLObject.forcedFecth is NO, we need to check the cache based on aURLObject.cacheIntervalTime
                    BOOL _needToFetchData = aURLObject.forcedFecth;
                    if (!_needToFetchData) {
                        _cachedData = [[URLCache sharedInstance] getDataForURL:_url needTimCheck:YES cacheTimeInterval:aURLObject.cacheIntervalTime];
                        // if _cachedData is nil, then set _needToFetchData = YES. We need to make a network call.
                        // else send the data to the caller.
                        if (!_cachedData)
                            _needToFetchData = YES;
                        else if (!_cachedData.cachedData)
                            _needToFetchData = YES;
                        else
                            completionBlock(_cachedData, nil);
                    }
                    
                    // Check if we have to make a network call or not. If _needToFetchData is YES, make a network call else by pass it.
                    if (_needToFetchData) {
                        [_httpClient getPath:_urlString parameters:aURLObject.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            // Check mapping is required or not. If mapping is not required add the data to cache and send it.
                            if (!aURLObject.mappingRequired) {
                                // Check if we have responseObject, if yes send the data to the caller, else create an error and send the error.
                                if (responseObject) {
                                    _cachedData = [CacheData new];
                                    [_cachedData setCachedData:responseObject];
                                    _cachedData.cacheCreatedDateTime = [NSDate date];
                                    if (aURLObject.needsPersistance) {
                                        // Save data to cache
                                        [[URLCache sharedInstance] addDataToCache:_cachedData forURL:_url];
                                    }
                                    
                                    // Mark completion of block
                                    completionBlock(_cachedData, nil);
                                }
                                else {
                                    // TODO - Create error
                                    // Error - Get data from cache or persistance without time check.
                                    _cachedData = [[URLCache sharedInstance] getDataForURL:[NSURL URLWithString:_urlString] needTimCheck:NO];
                                    // Mark completion of block
                                    completionBlock(_cachedData, nil);
                                }
                            }
                            else {
                                // Mapping is required.
                                id _jsonData = responseObject;
                                NSError *_error = nil;
                                if (aURLObject.toInternalClass) {
                                    NSMutableString *_mtJSONString = [[NSMutableString alloc] initWithFormat:@"{\"%@\":%@}", aURLObject.toInternalClass, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
                                    // Convert to JSON
                                    NSDictionary *_jsonDictionary = [NSJSONSerialization JSONObjectWithData:[_mtJSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&_error];
                                    if (!_error) {
                                        _jsonData = _jsonDictionary;
                                    }
                                }
                                if (_jsonData) {
                                    [self deserializeJSONObject:_jsonData objectMapperContainer:aURLObject.objectMapperContainer success:^(id aObject) {
                                        _cachedData = [CacheData new];
                                        [_cachedData setCachedData:aObject];
                                        _cachedData.cacheCreatedDateTime = [NSDate date];
                                        if (aURLObject.needsPersistance) {
                                            // Save data to cache
                                            [[URLCache sharedInstance] addDataToCache:_cachedData forURL:_url];
                                        }
                                        
                                        // Mark completion of block
                                        completionBlock(_cachedData, nil);
                                    } failure:^(NSError *error) {
                                        // Error - Get data from cache or persistance without time check.
                                        _cachedData = [[URLCache sharedInstance] getDataForURL:[NSURL URLWithString:_urlString] needTimCheck:NO];
                                        // Mark completion of block
                                        completionBlock(_cachedData, error);
                                    }];
                                }
                                else {
                                    // Error - Get data from cache or persistance without time check.
                                    _cachedData = [[URLCache sharedInstance] getDataForURL:[NSURL URLWithString:_urlString] needTimCheck:NO];
                                    // Mark completion of block
                                    completionBlock(_cachedData, _error);
                                }
                            }
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            // Error - Get data from cache or persistance without time check.
                            _cachedData = [[URLCache sharedInstance] getDataForURL:[NSURL URLWithString:_urlString] needTimCheck:NO];
                            // Mark completion of block
                            completionBlock(_cachedData, error);
                        }];
                    }
                }
            }
            else {
                completionBlock(nil, [self createErrorForString:@"Bad URL" errorCode:400]);
            }
        }
    }
}

#pragma mark - Private Methods
- (void)sendSuccessData:(id)aData urlKey:aURLKey forSelector:(SEL)aSucessSelector urlString:(NSString*)aURLString {
    if (aSucessSelector && [self respondsToSelector:aSucessSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:aSucessSelector]];
        invocation.target = self;
        invocation.selector = aSucessSelector;
        
        // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [invocation setArgument:&aData atIndex:2];
        [invocation setArgument:&aURLString atIndex:3];
        [invocation setArgument:&aURLKey atIndex:4];
        [invocation invoke];
    }
}

- (void)sendFaliureData:(id)aData urlKey:aURLKey withError:(NSError *)error forSelector:(SEL)aFailureSelector urlString:(NSString*)aURLString {
    if (aFailureSelector && [self respondsToSelector:aFailureSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:aFailureSelector]];
        invocation.target = self;
        invocation.selector = aFailureSelector;
        
        // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [invocation setArgument:&aData atIndex:2]; // Data
        [invocation setArgument:&error atIndex:3]; // Error String
        [invocation setArgument:&aURLString atIndex:4]; // URL String
        [invocation setArgument:&aURLKey atIndex:5];
        [invocation invoke];
    }
}

- (NSError*)createErrorForString:(NSString*)errorString errorCode:(NSInteger)errorCode {
    // Create erorr and send in faliure.
    NSMutableDictionary *_errorDetailDictionary = [NSMutableDictionary dictionary];
    [_errorDetailDictionary setValue:errorString forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:errorCode userInfo:_errorDetailDictionary];
}

- (NSError*)urlObjectSanityCheck:(URLObject *)aURLObject {
    // Check for base URL
    if (!(aURLObject.requestType == kRequestTypeGet || aURLObject.requestType == kRequestTypePost)) return [self createErrorForString:@"No Request type is available, like GET, POST etc." errorCode:400];
    else if (aURLObject.requestType == kRequestTypeGet && !aURLObject.urlPath) return [self createErrorForString:@"Its a GET request and no Path has been provided." errorCode:400];
    else if (aURLObject.requestType == kRequestTypePost && !aURLObject.params) return [self createErrorForString:@"Its a POST request and no Parameters have been provided." errorCode:400];
    return nil;
}

@end
