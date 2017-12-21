//
//  ViewController.h
//  WOCrashProtector
//
//  Created by 吴欧 on 2017/12/21.
//  Copyright © 2017年 wuou. All rights reserved.
//


#import <Foundation/Foundation.h>

//==================================================
//   本类的作用是用来测试unrecoganized selector的处理情况
//==================================================
@interface Person : NSObject

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age height:(float)height weight:(float)weight;

@end
