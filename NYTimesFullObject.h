//
//  NYTimesFullObject.h
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYTimesFullObject : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *copyright;
@property (nonatomic, strong) NSString *numResults;
@property (nonatomic, strong) NSArray *results;

@end
