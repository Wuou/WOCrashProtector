//
//  NSMutableDictionary+WOCrash.h
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/21.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

/**
 * setValue forKey 的值可设置nil，不会crash
 *
 *  Can avoid crash method
 *
 *  1. - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 *  2. - (void)removeObjectForKey:(id)aKey
 *
 */

@interface NSMutableDictionary (WOCrash)

+ (void)wo_enableMutableDictionaryProtector;

@end
