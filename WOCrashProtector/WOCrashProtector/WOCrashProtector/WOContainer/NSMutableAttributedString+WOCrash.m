//
//  NSMutableAttributedString+WOCrash.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/21.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "NSMutableAttributedString+WOCrash.h"
#import "NSObject+WOSwizzle.h"

@implementation NSMutableAttributedString (WOCrash)

+ (void)wo_enableMutableAttributedStringProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
        
        //initWithString:
        [self wo_instanceSwizzleMethodWithClass:NSConcreteMutableAttributedString orginalMethod:@selector(initWithString:) replaceMethod:@selector(wo_initWithString:)];

        //initWithString:attributes:
        [self wo_instanceSwizzleMethodWithClass:NSConcreteMutableAttributedString orginalMethod:@selector(initWithString:attributes:) replaceMethod:@selector(wo_initWithString:attributes:)];
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
