//
//  NSMutableDictionary+WOCrash.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/21.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "NSMutableDictionary+WOCrash.h"
#import "NSObject+WOSwizzle.h"

@implementation NSMutableDictionary (WOCrash)

+ (void)wo_enableMutableDictionaryProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
        
        //setObject:forKey:
        [self wo_instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(setObject:forKey:) replaceMethod:@selector(wo_setObject:forKey:)];
        
        // iOS11
        [self wo_instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(setObject:forKeyedSubscript:) replaceMethod:@selector(wo_setObject:forKeyedSubscript:)];

        
        //removeObjectForKey:
        [self wo_instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(removeObjectForKey:) replaceMethod:@selector(wo_removeObjectForKey:)];

    });
}

- (void)wo_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    @try {
        [self wo_setObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)wo_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey {
    
    @try {
        [self wo_setObject:anObject forKeyedSubscript:aKey];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)wo_removeObjectForKey:(id)aKey {
    
    @try {
        [self wo_removeObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

@end
