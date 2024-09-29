//
//  DebugLogInfoController.h
//  PerfectDebug
//
//  Created by perfectword on 2020/11/25.
//

#import <UIKit/UIKit.h>

@class DebugLogModel;

NS_ASSUME_NONNULL_BEGIN

@interface DebugLogInfoController : UIViewController

- (instancetype)initWithLogModel:(DebugLogModel *)logModel;

@end

NS_ASSUME_NONNULL_END
