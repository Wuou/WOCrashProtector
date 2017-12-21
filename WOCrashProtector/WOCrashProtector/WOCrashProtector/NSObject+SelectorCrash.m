//
//  NSObject+SelectorCrash.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/14.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "NSObject+SelectorCrash.h"
#import "NSObject+WOSwizzle.h"

@interface WOUnrecognizedSelectorSolveObject ()
@end

@implementation WOUnrecognizedSelectorSolveObject

/**
 在类方法下使用对象实例方法
 
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-protocol-method-implementation"
- (void)method {
 ...
 }
#pragma clang diagnostic pop
*/

// 此方法可被重写也可不重写,不重写可用swizzle， ** 未重写该函数会导致无限循环！ **
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([NSStringFromClass([self.objc class]) hasPrefix:@"_"] || [self.objc isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass([self.objc class]) hasPrefix:@"UIKeyboard"] || [methodName isEqualToString:@"dealloc"]) {
//
//        return nil;
//    }
//
//    CrashProxy *crashProxy = [CrashProxy new];
//    crashProxy.crashMsg = [NSString stringWithFormat:@"[%@ %p %@]: unrecognized selector sent to instance",NSStringFromClass([self.objc class]),self.objc,NSStringFromSelector(aSelector)];
//    class_addMethod([CrashProxy class], aSelector, [crashProxy methodForSelector:@selector(getCrashMsg)], "v@:");
//
//    return crashProxy;
//}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, (IMP)addMethod, "v@:@");
    return YES;
}

id addMethod(id self, SEL _cmd) {
    NSLog(@"WOCrashProtector: unrecognized selector: %@", NSStringFromSelector(_cmd));
    return 0;
}

@end

@implementation NSObject (SelectorCrash)

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored"-Wobjc-protocol-method-implementation"
//
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([NSStringFromClass([self class]) hasPrefix:@"_"] || [self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass([self class]) hasPrefix:@"UIKeyboard"] || [methodName isEqualToString:@"dealloc"]) {
//
//        return nil;
//    }
//
//    CrashProxy * crashProxy = [CrashProxy new];
//    crashProxy.crashMsg =[NSString stringWithFormat:@"CrashProtector: [%@ %p %@]: unrecognized selector sent to instance",NSStringFromClass([self class]),self,NSStringFromSelector(aSelector)];
//    class_addMethod([CrashProxy class], aSelector, [crashProxy methodForSelector:@selector(getCrashMsg)], "v@:");
//
//    return crashProxy;
//}
//
//#pragma clang diagnostic pop

+ (void)wo_enableSelectorProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSObject *object = [[NSObject alloc] init];
        [object wo_instanceSwizzleMethod:@selector(forwardingTargetForSelector:) replaceMethod:@selector(wo_forwardingTargetForSelector:)];
    });
}

- (id)wo_forwardingTargetForSelector:(SEL)aSelector {
    if (class_respondsToSelector([self class], @selector(forwardInvocation:))) {
        IMP impOfNSObject = class_getMethodImplementation([NSObject class], @selector(forwardInvocation:));
        IMP imp = class_getMethodImplementation([self class], @selector(forwardInvocation:));
        if (imp != impOfNSObject) {
            //NSLog(@"class has implemented invocation");
            return nil;
        }
    }
    
    WOUnrecognizedSelectorSolveObject *solveObject = [WOUnrecognizedSelectorSolveObject new];
    solveObject.objc = self;
    return solveObject;
}

@end
