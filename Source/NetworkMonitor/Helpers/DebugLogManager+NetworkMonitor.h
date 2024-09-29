//
//  DebugLogManager+NetworkMonitor.h
//  PerfectDebug
//
//  Created by perfectword on 2020/12/21.
//

#import "DebugLogManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugLogManager (NetworkMonitor)

/**
 记录一次网络请求

 @content request -> 网络请求的 NSURLRequest
 @content content -> 网络请求的参数
 @content response -> 网络请求的response
 @content response -> 网络请求的error
 */
- (void)recordNetRequestWithRequest:(NSURLRequest *)request content:(id)content response:(id)response error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
