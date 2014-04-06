//
//  CacheData.h
//  TOI
//
//  Created by Ravi Sahu on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheData : NSObject <NSCoding>

@property (strong, nonatomic) NSDate *cacheCreatedDateTime;
@property (strong, nonatomic) NSObject *cachedData;

@end
