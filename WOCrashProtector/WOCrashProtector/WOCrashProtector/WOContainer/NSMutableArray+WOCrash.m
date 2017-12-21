//
//  NSMutableArray+WOCrash.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/19.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "NSMutableArray+WOCrash.h"
#import "NSObject+WOSwizzle.h"

@implementation NSMutableArray (WOCrash)

+ (void)wo_enableMutableArrayProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //====================
        //   instance method
        //====================
        Class __NSArrayM = NSClassFromString(@"__NSArrayM");

        
        // objectAtIndex:
        [self wo_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(wo_objectAtIndex:)]; 
        
        [self wo_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndexedSubscript:) replaceMethod:@selector(wo_objectAtIndexedSubscript:)];

        //insertObject:atIndex:
        [self wo_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(insertObject:atIndex:) replaceMethod:@selector(wo_insertObject:atIndex:)];

        //removeObjectAtIndex:
        [self wo_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(removeObjectAtIndex:) replaceMethod:@selector(wo_removeObjectAtIndex:)];

        //setObject:atIndexedSubscript:
        [self wo_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(setObject:atIndexedSubscript:) replaceMethod:@selector(wo_setObject:atIndexedSubscript:)];

        [self wo_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(wo_getObjects:range:)];

    });
}

- (id)wo_objectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self wo_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)wo_objectAtIndexedSubscript:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self wo_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (void)wo_insertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self wo_insertObject:anObject atIndex:index];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)wo_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self wo_removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)wo_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self wo_setObject:obj atIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

- (void)wo_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self wo_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    } @finally {
    }
}

@end
