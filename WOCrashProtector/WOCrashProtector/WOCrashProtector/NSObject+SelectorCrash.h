//
//  NSObject+SelectorCrash.h
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/14.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOUnrecognizedSelectorSolveObject : NSObject

@property (nonatomic, weak) NSObject *objc;

@end

@interface NSObject (SelectorCrash)

+ (void)wo_enableSelectorProtector;

@end
