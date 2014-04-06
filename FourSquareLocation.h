//
//  FourSquareLocation.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquareLocation : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *cc;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;

@end
