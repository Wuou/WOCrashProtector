//
//  NSArray+WOCrash.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/19.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

/**
 
 iOS 8:下都是__NSArrayI
 iOS11: 之后分 __NSArrayI、  __NSArray0、__NSSingleObjectArrayI
 
 iOS11之前：arr@[]  调用的是[__NSArrayI objectAtIndexed]
 iOS11之后：arr@[]  调用的是[__NSArrayI objectAtIndexedSubscript]
 
 arr为空数组
 *** -[__NSArray0 objectAtIndex:]: index 12 beyond bounds for empty NSArray
 
 arr只有一个元素
 *** -[__NSSingleObjectArrayI objectAtIndex:]: index 12 beyond bounds [0 .. 0]
 
 */

#import "NSArray+WOCrash.h"
#import "NSObject+WOSwizzle.h"

@implementation NSArray (WOCrash)

+ (void)wo_enableArrayProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //====================
        //   instance method
        //====================
        Class __NSArray = objc_getClass("NSArray");
        Class __NSArrayI = objc_getClass("__NSArrayI");
        Class __NSSingleObjectArrayI = objc_getClass("__NSSingleObjectArrayI");
        Class __NSArray0 = objc_getClass("__NSArray0");
        
        [self wo_classSwizzleMethodWithClass:__NSArray orginalMethod:@selector(arrayWithObjects:count:) replaceMethod:@selector(wo_arrayWithObjects:count:)];
        
        // objectAtIndex:
        /* 数组count >= 2 */
        [self wo_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(wo_objectAtIndex:)];//[arr objectAtIndex:];
        
        [self wo_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(objectAtIndexedSubscript:) replaceMethod:@selector(wo_objectAtIndexedSubscript:)];//arr[];
        
        /* 数组为空 */
        [self wo_instanceSwizzleMethodWithClass:__NSArray0 orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(wo_objectAtIndexedNullarray:)];
        
        /* 数组count == 1 */
        [self wo_instanceSwizzleMethodWithClass:__NSSingleObjectArrayI orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(wo_objectAtIndexedArrayCountOnlyOne:)];
        
        // objectsAtIndexes:
        [self wo_instanceSwizzleMethodWithClass:__NSArray orginalMethod:@selector(objectsAtIndexes:) replaceMethod:@selector(wo_objectsAtIndexes:)];
        
        // 以下方法调用频繁，替换可能会影响性能
        // getObjects:range:
        [self wo_instanceSwizzleMethodWithClass:__NSArray orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(wo_getObjectsNSArray:range:)];
        [self wo_instanceSwizzleMethodWithClass:__NSSingleObjectArrayI orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(wo_getObjectsNSSingleObjectArrayI:range:)];
        [self wo_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(wo_getObjectsNSArrayI:range:)];
        
    });
}

#pragma mark - instance array
+ (instancetype)wo_arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        instance = [self wo_arrayWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        
        NSString *defaultToDo = @"This framework default is to remove nil object and instance a array.";
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:defaultToDo];

        //以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self wo_arrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}


- (id)wo_objectAtIndex:(NSUInteger)index {
//    if (index >= self.count) {
//        [WOCrashLog printCrashMsg:[NSString stringWithFormat:@"-%s: index %ld beyond bounds [0 .. %lu]",__func__,index,(unsigned long)self.count]];
//        return nil;
//    }
//    return [self wo_objectAtIndex:index];
    
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
        object = [self wo_objectAtIndexedSubscript:index];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)wo_objectAtIndexedNullarray:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self wo_objectAtIndexedNullarray:index];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)wo_objectAtIndexedArrayCountOnlyOne:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self wo_objectAtIndexedArrayCountOnlyOne:index];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (NSArray *)wo_objectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *returnArray = nil;
    @try {
        returnArray = [self wo_objectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnNil];
        
    } @finally {
        return returnArray;
    }
}

#pragma mark getObjects:range:
- (void)wo_getObjectsNSArray:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self wo_getObjectsNSArray:objects range:range];
    } @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnIgnore];
    } @finally {
    }
}

- (void)wo_getObjectsNSSingleObjectArrayI:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self wo_getObjectsNSSingleObjectArrayI:objects range:range];
    } @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnIgnore];
    } @finally {
    }
}

- (void)wo_getObjectsNSArrayI:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self wo_getObjectsNSArrayI:objects range:range];
    } @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:WOCrashDefaultReturnIgnore];
    } @finally {
    }
}

@end
