//
//  FourSquareCategories.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FourSquareIconObject.h"

@interface FourSquareCategories : NSObject


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pluralName;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) FourSquareIconObject *icon;

@end
