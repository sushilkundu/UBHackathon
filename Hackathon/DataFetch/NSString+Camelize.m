//
//  NSString+Camelize.m
//  DataFetchFramework
//
//  Created by Ravi Sahu on 23/05/13.
//  Copyright (c) 2013 Ravi Sahu. All rights reserved.
//

#import "NSString+Camelize.h"

@implementation NSString (Camelize)

- (NSCharacterSet *)camelcaseDelimiters {
	return [NSCharacterSet characterSetWithCharactersInString:@"-_:"];
}

- (NSString *)camelizeAttribute {
	return [self camelizeAttribute:[self camelcaseDelimiters]];
}

- (NSString *)camelizeAttribute:(NSCharacterSet*)camelcaseDelimiters {
    unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer ];
	NSMutableString *underscored = [NSMutableString string];
	
	BOOL capitalizeNext = NO;
	NSCharacterSet *delimiters = camelcaseDelimiters;
	for (int i = 0; i < [self length]; i++) {
		NSString *currChar = [NSString stringWithCharacters:buffer+i length:1];
		if([delimiters characterIsMember:buffer[i]]) {
			capitalizeNext = YES;
		}
        else {
			if(capitalizeNext) {
				[underscored appendString:[currChar uppercaseString]];
				capitalizeNext = NO;
			}
            else {
				[underscored appendString:currChar];
			}
		}
	}
	
	free(buffer);
	return underscored;
}

- (NSString *)camelizeClassName {
	NSString *result = [self camelizeAttribute];
	return [result stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                           withString:[[result substringWithRange:NSMakeRange(0,1)] uppercaseString]];
}

@end
