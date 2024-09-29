//
//  DebugCrashMonitor.h
//  PerfectDebug
//
//  Created by perfectword on 2020/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebugCrashMonitor : NSObject

/// 因为涉及到第三方crash监控的兼容问题，留给用户决定是否以及何时调+config
+ (void)config;

/// 这个方法可以保证crash log被写入本地，可以不调config使用本方法
+ (void)logExceptionFromThirdPlatform:(NSException *)exception;

@end

NS_ASSUME_NONNULL_END
