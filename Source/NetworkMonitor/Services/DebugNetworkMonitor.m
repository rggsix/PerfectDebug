//
//  DebugNetworkMonitor.m
//  PerfectDebug
//
//  Created by JSK on 2020/12/25.
//

#import "DebugNetworkMonitor.h"
#import "NSURLSessionConfiguration+PerfectDebug.h"
#import "DebugHTTPProtocol.h"

@implementation DebugNetworkMonitor

+ (instancetype)shared{
    static DebugNetworkMonitor *ins;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[self alloc] init];
    });
    return ins;
}

- (instancetype)init {
    if (self = [super init]) {
        self.ignoreUrlList = [NSMutableArray new];
    }
    return self;
}

/// PerfectDebug会通过runtime调用此方法，不要修改方法签名
+ (void)config{
    [NSURLSessionConfiguration dg_hookDefaultSessionConfiguration];
    [DebugHTTPProtocol registerSelf];
}

@end
