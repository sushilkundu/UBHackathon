//
//  Archiver.m
//  OpenStack
//
//  Created by Mike Mayo on 10/4/10.
//  The OpenStack project is provided under the Apache 2.0 license.
//

#import "Archiver.h"

@implementation Archiver

+ (id)readFile:(NSString *)aFileName {
    @try {
        NSString *filePath = [Archiver getFilePath:aFileName];
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException *exception) {
        [Archiver deleteFile:aFileName];
    }
}

+ (NSDate*)createdOn:(NSString *)aFileName {
    NSString *filePath = [Archiver getFilePath:aFileName];
    
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    NSError *_error = nil;
    NSDictionary *_fileAttributes = [_fileManager attributesOfItemAtPath:filePath error:&_error];
    if (_fileAttributes) {
        return [_fileAttributes fileCreationDate];
    }
    return nil;
}

+ (BOOL)fileExists:(NSString *)aFileName {
    NSString *filePath = [Archiver getFilePath:aFileName];
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    return [_fileManager fileExistsAtPath:filePath];
}

+ (BOOL)createFile:(id)object aFileName:(NSString *)aFileName {
    @try {
        @synchronized (object) {
            NSString *filePath = [Archiver getFilePath:aFileName];
            return [NSKeyedArchiver archiveRootObject:object toFile:filePath];
        }
    }
    @catch (NSException *exception) {
        [Archiver deleteFile:aFileName];
    }
}

+ (BOOL)deleteFile:(NSString *)aFileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [Archiver getFilePath:aFileName];
    return [fileManager removeItemAtPath:filePath error:NULL];    
}

+ (BOOL)deleteEverything {
    BOOL result = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    
    for (int i = 0; i < [files count]; i++) {
        NSString *path = [files objectAtIndex:i];
        result = result && [fileManager removeItemAtPath:path error:NULL];
    }
    
    return result;
}

+(NSString*)getFilePath:(NSString *)aFileName {
    if (aFileName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.archive", aFileName]];
    }
    return nil;
}

@end
