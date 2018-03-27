# WOCrashProtector
Crash protection based on Swizzle Method. Can effectively prevent the code potential crash, automatically capture the broken loop factor that causes the app to crash when the app runs, so as to prevent the app from collapsing, so it can continue to function normally

# 前言
  一个无侵入的 iOS crash 防护框架，基于 Swizzle Method 的 Crash 防护。能有效的防止代码潜在的crash，自动在app运行时实时捕获导致app崩溃的破环因子，使app避免崩溃，照样可以继续正常运行。
  主要参考了[《大白健康系统--iOS APP运行时Crash自动修复系统》](https://neyoufan.github.io/2017/01/13/ios/BayMax_HTSafetyGuard/)此文，以及[AvoidCrash](https://github.com/chenfanfang/AvoidCrash)、[QYCrashProtector](https://github.com/qiyer/QYCrashProtector)、[NeverCrash](https://github.com/jseanj/NeverCrash)这三个框架编写而成。更多内容请看项目吧。

# 功能
- unrecognized selector crash
- KVO、KVC crash
- NSNotification crash
- NSTimer crash
- Container crash（数组越界，插nil，字典objc、key为nil等）
- NSString crash（字符串截取越界等） 
- NSAttributedString

  
# 使用方法

导入#import "WOCrashProtectorManager.h"

```
/**
 启动所有组件
 */
+ (void)makeAllEffective;
     
/**
 单独启动组件

 @param protectorType 启动的组件类型
 */
+ (void)configCrashProtectorService:(WOCrashProtectorStyle)protectorType;

```
![]
(https://github.com/Wuou/WOCrashProtector/blob/master/crash.png)

# 版本适配   
系统支持 iOS 8.0 ~ iOS 11.2


# 注意事项

 ** 建议实际开发的时候关闭该组件，以便及时发现crash bug，需要上架或者演示的时候开启crash防护组件。 **
 *  该组件中使用了@try@catch捕捉crash会占用极少量内存，不过正常情况下不影响性能。
 *  目前尚未测试其他第三方框架共同使用时是否存在冲突的情况，如bugly、友盟等。
 *  如果您发现了问题希望能issue，大家一起来解决问题 ^_^
 *  最后，如果你觉得这个框架对你有帮助就给个star吧 ^_^


