# WOCrashProtector
Crash protection based on Swizzle Method. Can effectively prevent the code potential crash, automatically capture the broken loop factor that causes the app to crash when the app runs, so as to prevent the app from collapsing, so it can continue to function normally

# 前言
  一个无侵入的 iOS crash 防护框架.主要参考了《大白健康系统--iOS APP运行时Crash自动修复系统》此文，以及AvoidCrash、QYCrashProtector、NeverCrash这三个框架编写而成。
  

# 功能
 unrecognized selector crash
 KVO crash
 NSNotification crash
 NSTimer crash
 Container crash
 NSString crash

  
# 使用方法
/**
 启动所有组件
 */
+ (void)makeAllEffective;
     
/**
 单独启动组件

 @param protectorType 启动的组件类型
 */
+ (void)configCrashProtectorService:(WOCrashProtectorStyle)protectorType;


# 注意事项

 ** 建议实际开发的时候关闭该组件，以便及时发现crash bug，需要上架或者演示的时候开启crash防护组件。 **
 *  该组件会占用一定内存，不过正常情况下不影响性能
 *  目前尚未测试其他第三方框架共同使用时是否存在冲突的情况，如bugly、友盟等。

