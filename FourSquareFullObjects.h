//
//  FourSquareFullObjects.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FourSquareResponseObject.h"
#import "MetaFourSquareObject.h"

@interface FourSquareFullObjects : NSObject
@property (nonatomic, strong) MetaFourSquareObject *meta;
@property (nonatomic, strong) FourSquareResponseObject *response;

@end
