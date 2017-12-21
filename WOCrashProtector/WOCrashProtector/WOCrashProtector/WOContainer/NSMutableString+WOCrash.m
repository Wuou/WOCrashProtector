//
//  NSMutableString+WOCrash.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/21.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "NSMutableString+WOCrash.h"
#import "NSObject+WOSwizzle.h"

@implementation NSMutableString (WOCrash)

+ (void)wo_enableMutableStringProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class __NSCFString = NSClassFromString(@"__NSCFString");
        
        //replaceCharactersInRange
        [self wo_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(replaceCharactersInRange:withString:) replaceMethod:@selector(wo_replaceCharactersInRange:withString:)];
        
        //insertString:atIndex:
        [self wo_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(insertString:atIndex:) replaceMethod:@selector(wo_insertString:atIndex:)];

        //deleteCharactersInRange
        [self wo_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(deleteCharactersInRange:) replaceMethod:@selector(wo_deleteCharactersInRange:)];
    });
}

#pragma mark - replaceCharactersInRange
- (void)wo_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self wo_replaceCharactersInRange:range withString:aString];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnIgnore];
    }
    @finally {
    }
}

#pragma mark - insertString:atIndex:
- (void)wo_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    
    @try {
        [self wo_insertString:aString atIndex:loc];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnIgnore];
    }
    @finally {
    }
}

#pragma mark - deleteCharactersInRange

- (void)wo_deleteCharactersInRange:(NSRange)range {
    
    @try {
        [self wo_deleteCharactersInRange:range];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnIgnore];
    }
    @finally {
    }
}

@end
