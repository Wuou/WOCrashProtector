//
//  NSMutableAttributedString+WOCrash.h
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/21.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

/**
 *  Can avoid crash method
 *
 *  1.- (instancetype)initWithString:(NSString *)str
 *  2.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 */
#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (WOCrash)

+ (void)wo_enableMutableAttributedStringProtector;

@end
