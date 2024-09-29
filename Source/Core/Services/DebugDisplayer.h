//
//  DebugDisplayer.h
//  PerfectDebug
//
//  Created by perfectword on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "DebugOnceStart.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugDisplayer : NSObject

- (void)start;
- (void)stop;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
