//
//  WOCrashLog.h
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/15.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import <Foundation/Foundation.h>

//user can ignore below define
static NSString * _Nullable WOCrashDefaultReturnNil = @"This framework default is to return nil to avoid crash.";
static NSString * _Nullable WOCrashDefaultReturnIgnore  = @"This framework default is to ignore this operation to avoid crash.";

@interface WOCrashLog : NSObject

@property (nonatomic,copy) NSString * _Nullable crashMsg;

- (void)getCrashMsg;

+ (void)printCrashMsg:(NSString *_Nullable)crashMsg;

+ (void)wo_noteErrorWithException:(NSException *_Nonnull)exception attachedTODO:(NSString *_Nullable)todo;

@end
