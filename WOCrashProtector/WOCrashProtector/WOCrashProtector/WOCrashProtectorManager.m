//
//  WOCrashProtectorManager.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/14.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "WOCrashProtectorManager.h"
#import "NSObject+SelectorCrash.h"
#import "NSObject+KVOCrash.h"
#import "NSObject+NSNotificationCrash.h"
#import "NSTimer+Crash.h"
#import "NSArray+WOCrash.h"
#import "NSMutableArray+WOCrash.h"
#import "NSDictionary+WOCrash.h"
#import "NSMutableDictionary+WOCrash.h"
#import "NSString+WOCrash.h"
#import "NSMutableString+WOCrash.h"
#import "NSAttributedString+WOCrash.h"
#import "NSMutableAttributedString+WOCrash.h"

@implementation WOCrashProtectorManager

+ (void)makeAllEffective {
    [self _startAllComponents];
}

+ (void)configCrashProtectorService:(WOCrashProtectorStyle)protectorType {
   
    switch (protectorType) {
        case WOCrashProtectorNone:
            
            break;
        case WOCrashProtectorAll:
        {
            [self _startAllComponents];
        }
            break;
        case WOCrashProtectorUnrecognizedSelector:
            [NSObject wo_enableSelectorProtector];
            break;
        case WOCrashProtectorKVO:
            [NSObject wo_enableKVOProtector];
            break;
        case WOCrashProtectorNotification:
            [NSObject wo_enableNotificationProtector];
            break;
        case WOCrashProtectorTimer:
            [NSTimer wo_enableTimerProtector];
            break;
        case WOCrashProtectorContainer: {
            [NSArray wo_enableArrayProtector];
            [NSMutableArray wo_enableMutableArrayProtector];
            
            [NSDictionary wo_enableDictionaryProtector];
            [NSMutableDictionary wo_enableMutableDictionaryProtector];
        }
            break;
        case WOCrashProtectorString: {
            [NSString wo_enableStringProtector];
            [NSMutableString wo_enableMutableStringProtector];
            
            [NSAttributedString wo_enableAttributedStringProtector];
            [NSMutableAttributedString wo_enableMutableAttributedStringProtector];
        }
            break;
            
        default:
            break;
    }
}

//+ (void)configCrashProtectorServices:(NSArray *)protectorTypes {
//    
//    for (NSNumber *numb in protectorTypes) {
//        
//        [self configCrashProtectorService:[numb integerValue]];
//    }
//}

+ (void)_startAllComponents {
    [NSObject wo_enableSelectorProtector];
    [NSObject wo_enableKVOProtector];
    [NSObject wo_enableNotificationProtector]; // 可能会有性能问题，dealloc里面加了判断，系统的每个对象dealloc时都会调用
    
    [NSTimer wo_enableTimerProtector];
    [NSArray wo_enableArrayProtector];
    [NSMutableArray wo_enableMutableArrayProtector];
    
    [NSDictionary wo_enableDictionaryProtector];
    [NSMutableDictionary wo_enableMutableDictionaryProtector];
    
    [NSString wo_enableStringProtector];
    [NSMutableString wo_enableMutableStringProtector];
    
    [NSAttributedString wo_enableAttributedStringProtector];
    [NSMutableAttributedString wo_enableMutableAttributedStringProtector];
}

@end
