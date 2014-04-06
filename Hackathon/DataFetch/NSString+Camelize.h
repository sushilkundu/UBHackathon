//
//  NSString+Camelize.h
//  DataFetchFramework
//
//  Created by Ravi Sahu on 23/05/13.
//  Copyright (c) 2013 Ravi Sahu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Camelize)

- (NSString *)camelizeAttribute;
- (NSString *)camelizeAttribute:(NSCharacterSet*)camelcaseDelimiters;

- (NSString *)camelizeClassName;

@end
