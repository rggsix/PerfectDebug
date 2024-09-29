//
//  AppDelegate.m
//  QTConfig
//
//  Created by JSK on 2020/11/2.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "PerfectDebug.h"
#import "DebugPerformance.h"
#import "DebugCrashMonitor.h"
#if __has_include(<Bugly/Bugly.h>)
#import <Bugly/Bugly.h>
#else
#import "Bugly.h"
#endif

@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PerfectDebug config];
    //  开启crash监听，如果启用了Bugly，无法监听，需要自行实现Bugly代理并调用 [DebugCrashMonitor logExceptionFromThirdPlatform:...]
    [DebugCrashMonitor config];

    //  自定义log abstract string，这个string是显示在log列表中，若无需要可不处理
    [PerfectDebug.shared registerAbstractProviderForTag:@"Tracking" provider:^NSString * _Nullable(NSString * _Nullable tag, NSDictionary * _Nonnull content) {
        NSString *event_id = content[@"event_id"];
        NSString *page_id = content[@"page_id"];

        NSMutableString *absstr = [NSMutableString stringWithFormat:@"[%@]", content[@"logType"]];
        if (event_id != nil && event_id.length > 0) {
            [absstr appendFormat:@" <%@>", event_id];
        }
        [absstr appendFormat:@" %@", page_id];
        return absstr;
    }];

    //  记录一条log
    [PerfectDebug logWithTag:@"Tracking" content:@{
        @"logType":@"PageViewEntry",
        @"event_id":@"testEvent1",
        @"page_id":@"testPage1",
        @"TestKey1":@"TestValue1",
    }];

    //  记录一条log
    [PerfectDebug logWithTag:@"Tracking" content:@{
        @"logType":@"ActionEvent",
        @"page_id":@"testPage2",
        @"TestKey1":@"TestValue1",
    }];
    
    
//    BuglyConfig *config = [BuglyConfig new];
//    config.debugMode = YES;
//    config.blockMonitorEnable = YES;
//    config.unexpectedTerminatingDetectionEnable = YES;
//    config.consolelogEnable = YES;
//    config.delegate = self;
//    [Bugly startWithAppId:@"c92c46b861" config:config];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    [DebugCrashMonitor logExceptionFromThirdPlatform:exception];
    return @"";
}

@end
