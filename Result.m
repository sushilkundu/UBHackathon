//
//  Result.m
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "Result.h"
#import "NSObject+NSCoding.h"

@implementation Result
@synthesize section,subsection,title,abstract,url,
byline,
thumbnailStandard,
itemType,
source,
updatedDate,
createdDate,
publishedDate,
materialTypeFacet,
kicker;

- (void)encodeWithCoder:(NSCoder *)coder {
    [self autoEncodeWithCoder:coder];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        [self autoDecode:coder];
    }
    return self;
}
@end
