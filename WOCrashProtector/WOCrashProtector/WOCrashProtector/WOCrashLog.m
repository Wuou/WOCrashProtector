//
//  WOCrashLog.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/15.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "WOCrashLog.h"

static const NSString *WOCrashSeparatorWithFlag = @">>>>>>>>>>>>>>>>>>>>>>>> WOCrashProtector <<<<<<<<<<<<<<<<<<<<<<<<";

@implementation WOCrashLog

- (void)getCrashMsg{
    NSLog(@"CrashProtector:  %@",_crashMsg);
}

+ (void)printCrashMsg:(NSString *)crashMsg {
    NSLog(@"\n*****************\n\nCrashProtector:  %@\n\n*****************\n",crashMsg);
}

+ (void)wo_noteErrorWithException:(NSException *)exception attachedTODO:(NSString *)todo {
    
    // 堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [self _getMainCallStackSymbolMessageWithCallStackSymbolStr:callStackSymbolsArr[2]];
    
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    
    NSString *crashType = [NSString stringWithFormat:@">>>>>>>>>>>> [Crash Type]: %@",exception.name];
    NSString *errorReason = [NSString stringWithFormat:@">>>>>>>>>>>> [Crash Reason]: %@",exception.reason];;
    NSString *errorPlace = [NSString stringWithFormat:@">>>>>>>>>>>> [Error Place]: %@",mainCallStackSymbolMsg];
    NSString *crashProtector = [NSString stringWithFormat:@">>>>>>>>>>>> [Attached TODO]: %@",todo];
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@\n%@\n",WOCrashSeparatorWithFlag, crashType, errorReason, errorPlace, crashProtector, exception.callStackSymbols];
    NSLog(@"%@", logErrorMessage);
}

/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbolStr 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */
+ (NSString *)_getMainCallStackSymbolMessageWithCallStackSymbolStr:(NSString *)callStackSymbolStr {
    
    //正则表达式
    //http://www.jianshu.com/p/b25b05ef170d
    
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";

    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    [regularExp enumerateMatchesInString:callStackSymbolStr options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbolStr.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result) {
            mainCallStackSymbolMsg = [callStackSymbolStr substringWithRange:result.range];
            *stop = YES;
        }
    }];
    
    return mainCallStackSymbolMsg;
}

@end
