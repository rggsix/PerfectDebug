//
//  NSURLSessionManager+PerfectDebug.m
//  PerfectDebug
//
//  Created by JSK on 2020/12/25.
//

#import "NSURLSessionConfiguration+PerfectDebug.h"
#import "DebugHTTPProtocol.h"
#import "DebugUtil.h"

@implementation NSURLSessionConfiguration (PerfectDebug)

+ (void)dg_hookDefaultSessionConfiguration {
    //  AFN需要hook defaultSessionConfiguration, 自行将protocol加入
    [DebugUtil exchangeClassOriginMethod:@selector(defaultSessionConfiguration) newMethod:@selector(dg_defaultSessionConfiguration) mclass:[self class]];
}

+ (NSURLSessionConfiguration *)dg_defaultSessionConfiguration {
    NSURLSessionConfiguration *configuration = [self dg_defaultSessionConfiguration];
    [self dg_setSessionProtocolEnabled:YES forSessionConfiguration:configuration];
    return configuration;
}

+ (void)dg_setSessionProtocolEnabled:(BOOL)enabled forSessionConfiguration:(NSURLSessionConfiguration *)configuration{
    if ([configuration respondsToSelector:@selector(protocolClasses)]
        && [configuration respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray *protocolClasses = [NSMutableArray arrayWithArray:configuration.protocolClasses];
        Class protoCls = [DebugHTTPProtocol class];
        if (enabled && ![protocolClasses containsObject:protoCls]) {
            [protocolClasses insertObject:protoCls atIndex:0];
        } else if (!enabled && [protocolClasses containsObject:protoCls]) {
            [protocolClasses removeObject:protoCls];
        }
        configuration.protocolClasses = protocolClasses;
    }
}

@end
