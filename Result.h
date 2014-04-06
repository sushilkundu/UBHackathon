//
//  Result.h
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *subsection;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *abstract;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *byline;
@property (nonatomic, strong) NSString *thumbnailStandard;
@property (nonatomic, strong) NSString *itemType;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *updatedDate;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *publishedDate;
@property (nonatomic, strong) NSString *materialTypeFacet;
@property (nonatomic, strong) NSString *kicker;

@end
