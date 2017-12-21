//
//  NSAttributedString+WOCrash.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/21.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "NSAttributedString+WOCrash.h"
#import "NSObject+WOSwizzle.h"

@implementation NSAttributedString (WOCrash)

+ (void)wo_enableAttributedStringProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
        
        //initWithString:
        [self wo_instanceSwizzleMethodWithClass:NSConcreteAttributedString orginalMethod:@selector(initWithString:) replaceMethod:@selector(wo_initWithString:)];
        //initWithAttributedString
        [self wo_instanceSwizzleMethodWithClass:NSConcreteAttributedString orginalMethod:@selector(initWithAttributedString:) replaceMethod:@selector(wo_initWithAttributedString:)];

        //initWithString:attributes:
        [self wo_instanceSwizzleMethodWithClass:NSConcreteAttributedString orginalMethod:@selector(initWithString:attributes:) replaceMethod:@selector(wo_initWithString:attributes:)];
    });
}

- (instancetype)wo_initWithString:(NSString *)str {
    id object = nil;
    
    @try {
        object = [self wo_initWithString:str];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnNil];
    }
    @finally {
        return object;
    }
}

#pragma mark - initWithAttributedString
- (instancetype)wo_initWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    
    @try {
        object = [self wo_initWithAttributedString:attrStr];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnNil];
    }
    @finally {
        return object;
    }
}

#pragma mark - initWithString:attributes:

- (instancetype)wo_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    
    @try {
        object = [self wo_initWithString:str attributes:attrs];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnNil];
    }
    @finally {
        return object;
    }
}

@end
