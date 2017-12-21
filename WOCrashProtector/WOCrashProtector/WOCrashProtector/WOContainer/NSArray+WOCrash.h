//
//  NSArray+WOCrash.h
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/19.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

/**
 *  Can avoid crash method
 *
 *  1. NSArray的快速创建方式 NSArray *array = @[@"chenfanfang", @"AvoidCrash"];  //这种创建方式其实调用的是2中的方法
 *  2. +(instancetype)arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
 *  3. - (id)objectAtIndex:(NSUInteger)index
 *  4. - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 */
#import <Foundation/Foundation.h>

@interface NSArray (WOCrash)

+ (void)wo_enableArrayProtector;

@end
