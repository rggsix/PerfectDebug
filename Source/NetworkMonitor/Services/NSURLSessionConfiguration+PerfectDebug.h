//
//  NSURLSessionManager+PerfectDebug.h
//  PerfectDebug
//
//  Created by JSK on 2020/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionConfiguration (PerfectDebug)

+ (void)dg_hookDefaultSessionConfiguration;

@end

NS_ASSUME_NONNULL_END
