//
//  WOCrashProtectorManager.h
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/14.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

/**
 ** 建议实际开发的时候关闭该组件，以便及时发现crash bug，需要上架或者演示的时候开启crash防护组件。 **
 *  该组件会占用一定内存，不过正常情况下不影响性能
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WOCrashProtectorStyle) {
    WOCrashProtectorNone = 0,
    WOCrashProtectorAll ,
    WOCrashProtectorUnrecognizedSelector,
    WOCrashProtectorKVO ,
    WOCrashProtectorNotification ,
    WOCrashProtectorTimer ,
    WOCrashProtectorContainer ,
    WOCrashProtectorString ,
};

@interface WOCrashProtectorManager : NSObject

@property(nonatomic,assign) WOCrashProtectorStyle style;


/**
 启动所有组件
 */
+ (void)makeAllEffective;


/**
 单独启动组件

 @param protectorType 启动的组件类型
 */
+ (void)configCrashProtectorService:(WOCrashProtectorStyle)protectorType;



/**
 启动一组组件

 @param protectorTypes 启动的组件类型数组
 */
//+ (void)configCrashProtectorServices:(NSArray *)protectorTypes;

@end
