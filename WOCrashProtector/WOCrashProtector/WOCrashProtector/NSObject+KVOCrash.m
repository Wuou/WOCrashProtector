//
//  NSObject+KVOCrash.m
//  GridGovernance
//
//  Created by 吴欧 on 2017/12/14.
//  Copyright © 2017年 Bitvalue. All rights reserved.
//

#import "NSObject+KVOCrash.h"
#import "NSObject+WOSwizzle.h"
#import <pthread.h>

#pragma mark - KVOProxy


/**
 此类用来管理混乱的KVO关系
 让被观察对象持有一个KVO的delegate，所有和KVO相关的操作均通过delegate来进行管理，delegate通过建立一张map来维护KVO整个关系
 
 好处：
 不会crash 1.如果出现KVO重复添加观察者或重复移除观察者（KVO注册观察者与移除观察者不匹配）的情况，delegate可以直接阻止这些非正常的操作。
 
 crash 2.被观察对象dealloc之前，可以通过delegate自动将与自己有关的KVO关系都注销掉，避免了KVO的被观察者dealloc时仍然注册着KVO导致的crash。
 
 👇：
 重复添加观察者不会crash，即不会走@catch
 多次添加对同一个属性观察的观察者，系统方法内部会强应用这个观察者，同理即可remove该观察者同样次数。
 
 */
@implementation KVOProxy{
    pthread_mutex_t _mutex;
    NSMapTable<id, NSMutableSet<WOCPKVOInfo *> *> *_objectInfosMap; ///< map来维护KVO整个关系
}

- (instancetype)init
{
    self = [super init];
    if (nil != self) {
        
        _objectInfosMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality capacity:0];
        
        pthread_mutex_init(&_mutex, NULL);
    }
    return self;
}

- (BOOL)wo_addObserver:(id)object KVOinfo:(WOCPKVOInfo *)KVOinfo
{
    [self lock];
    
    // WOCPKVOInfo 存入KVO的信息，object为注册者对象
    NSMutableSet *infos = [_objectInfosMap objectForKey:object];
    __block BOOL isHas = NO;
    [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([[KVOinfo valueForKey:@"_keyPath"] isEqualToString:[obj valueForKey:@"_keyPath"]]){
            *stop = YES;
            isHas = YES;
        }
    }];
    if(isHas) {
        [self unlock];
        
        NSLog(@"crash add observer: %@, keyPath: %@", object, KVOinfo);

        return NO ;
    }
    if(nil == infos){
        infos = [NSMutableSet set];
        [_objectInfosMap setObject:infos forKey:object];
    }
    [infos addObject:KVOinfo];
    [self unlock];
    
    return YES;
}

- (void)wo_removeObserver:(id)object keyPath:(NSString *)keyPath block:(void (^)(void))block
{
//    if (!object || !keyPath) {
//        return;
//    }
    
    [self lock];
    NSMutableSet *infos = [_objectInfosMap objectForKey:object];
    __block WOCPKVOInfo *info;
    [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([keyPath isEqualToString:[obj valueForKey:@"_keyPath"]]){
            info = (WOCPKVOInfo *)obj;
            *stop = YES;
        }
    }];
    
    if (info != nil) {
        [infos removeObject:info];
        block();
        if (0 == infos.count) {
            [_objectInfosMap removeObjectForKey:object];
        }
    }else {
        [WOCrashLog printCrashMsg:[NSString stringWithFormat:@"Cannot remove an observer %@ for the key path '%@' from %@ because it is not registered as an observer.",object,keyPath,self]];
    }
    [self unlock];
}

- (void)wo_removeAllObserver
{
    if (_objectInfosMap) {
        NSMapTable *objectInfoMaps = [_objectInfosMap copy];
        for (id object in objectInfoMaps) {
            
            NSSet *infos = [objectInfoMaps objectForKey:object];
            if(nil==infos || infos.count==0) continue;
            [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                WOCPKVOInfo *info = (WOCPKVOInfo *)obj;
                [object removeObserver:self forKeyPath:[info valueForKey:@"_keyPath"]];
            }];
        }
        [_objectInfosMap removeAllObjects];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    NSLog(@"KVOProxy - observeValueForKeyPath :%@",change);
    __block WOCPKVOInfo *info ;
    {
        [self lock];
        NSSet *infos = [_objectInfosMap objectForKey:object];
        [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            if([keyPath isEqualToString:[obj valueForKey:@"_keyPath"]]){
                info = (WOCPKVOInfo *)obj;
                *stop = YES;
            }
        }];
        [self unlock];
    }
    
    if (nil != info) {
        [object observeValueForKeyPath:keyPath ofObject:object change:change context:(__bridge void * _Nullable)([info valueForKey:@"_context"])];
    }
}

-(void)lock
{
    pthread_mutex_lock(&_mutex);
}

-(void)unlock
{
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
//    [self wo_removeAllObserver];
    pthread_mutex_destroy(&_mutex);
//    NSLog(@"KVOProxy dealloc removeAllObserve");
}

@end

#pragma mark - WOCPKVOInfo
@implementation WOCPKVOInfo {
    @public
    NSString *_keyPath;
    NSKeyValueObservingOptions _options;
    SEL _action;
    void *_context;
    WOCPKVONotificationBlock _block;
}

- (instancetype)initWithKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    return [self initWithKeyPath:keyPath options:options block:NULL action:NULL context:context];
}

- (instancetype)initWithKeyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options
                          block:(nullable WOCPKVONotificationBlock)block
                         action:(nullable SEL)action
                        context:(nullable void *)context {
    self = [super init];
    if (nil != self) {
        _block = [block copy];
        _keyPath = [keyPath copy];
        _options = options;
        _action = action;
        _context = context;
    }
    return self;
}

@end

#pragma mark - NSObject + KVOCrash
/**
 
 ①、警告⚠️：
 1、重复添加相同的keyPath观察者，会重复调用 observeValueForKeyPath：...方法
 
 ②、crash情况：
 1、移除未被以KVO注册的观察者 会crash
 2、重复移除观察者 会crash
 
 */

// fix "unrecognized selector" ,"KVC"
static void *NSObjectKVOProxyKey = &NSObjectKVOProxyKey;

static int const WONSObjectKVOCrashKey;

@implementation NSObject (KVOCrash)

+ (void)wo_enableKVOProtector {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSObject *objc = [[NSObject alloc] init];
        [objc wo_instanceSwizzleMethod:@selector(addObserver:forKeyPath:options:context:) replaceMethod:@selector(wo_addObserver:forKeyPath:options:context:)];
        [objc wo_instanceSwizzleMethod:@selector(removeObserver:forKeyPath:) replaceMethod:@selector(wo_removeObserver:forKeyPath:)];
    });
}

/// 添加观察者，实际添加WOCPKVOInfo -> KVO的管理者，来管理KVO的注册
/**
 keyPath为对象的属性，通过keyPath作为Key创建对应对应的一条观察者关键路径：keyPath --> observer(self)
 
 */
- (void)wo_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    
//    WOCPKVOInfo * kvoInfo = [[WOCPKVOInfo alloc] initWithKeyPath:keyPath options:options context:context];
//    __weak typeof(self) wkself = self;
//
//    if ([self.KVOProxy wo_addObserver:wkself KVOinfo:kvoInfo]) {
//        [self wo_addObserver:self.KVOProxy forKeyPath:keyPath options:options context:context];
//    }else {
//        NSLog(@"KVO is more");
//    }
//    [self wo_addObserver:observer forKeyPath:keyPath options:options context:context];

    @try {
        [self wo_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
    @catch (NSException *exception) {
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
        if (!observer || !keyPath) {
            return;
        }
        NSHashTable *observers = self.keyPathInfos[keyPath];
        if (observers && [observers containsObject:observer]) {
            //        [WOCrashLog printCrashMsg:[NSString stringWithFormat:@"CrashProtector: Repeat adding the same keyPath observer: %@, keyPath: %@", observer, keyPath]];
            return;
        }
        if (!observers) {
            observers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
        }
        [observers addObject:observer];
        [self.keyPathInfos setObject:observers forKey:keyPath];
    }
}

- (void)wo_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
//    NSLog(@"swizzled removeObserver");
//    [self.KVOProxy wo_removeObserver:observer keyPath:keyPath block:^{
//        [self wo_removeObserver:observer forKeyPath:keyPath];
//    }];

    @try {
        [self wo_removeObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        // 打印crash信息
        [WOCrashLog wo_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
        if (!observer || !keyPath) {
            return;
        }
        NSHashTable *observers = self.keyPathInfos[keyPath];
        // keyPath集合中未包含这个观察者，即移除未被以KVO注册的观察者
        if (!observers) {
//            [WOCrashLog printCrashMsg:[NSString stringWithFormat:@"Cannot remove an observer %@ for the key path '%@' from %@ because it is not registered as an observer.",observer,keyPath,self]];
            return;
        }
        // 重复删除观察者
        if (![observers containsObject:observer]) {
//            [WOCrashLog printCrashMsg:[NSString stringWithFormat:@"Cannot remove an observer %@ for the key path '%@' from %@ because it is not registered as an observer.",observer,keyPath,self]];
            return;
        }
        [observers removeObject:observer];
        [self.keyPathInfos setObject:observers forKey:keyPath];
    }
}

#pragma mark setter、getter
- (NSMutableDictionary *)keyPathInfos {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &WONSObjectKVOCrashKey);
    if (!dict) {
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &WONSObjectKVOCrashKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (void)setKeyPathInfos:(NSMutableDictionary *)keyPathInfos {
    objc_setAssociatedObject(self, &WONSObjectKVOCrashKey, keyPathInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KVOProxy *)KVOProxy
{
    id proxy = objc_getAssociatedObject(self, NSObjectKVOProxyKey);
    
    if (nil == proxy) {
        proxy = [[KVOProxy alloc] init];
        self.KVOProxy = proxy;
    }
    
    return proxy;
}

- (void)setKVOProxy:(KVOProxy *)proxy
{
    objc_setAssociatedObject(self, NSObjectKVOProxyKey, proxy, OBJC_ASSOCIATION_ASSIGN);
}

@end
