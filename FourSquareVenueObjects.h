//
//  FourSquareVenueObjects.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FourSquareContactObject.h"
#import "FourSquareLocation.h"
#import "FourSquareCategories.h"
@interface FourSquareVenueObjects : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FourSquareContactObject *contact;
@property (nonatomic, strong) FourSquareLocation *location;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *categories;


@end
