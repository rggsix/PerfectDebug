//
//  DebugLogSearchListController.h
//  PerfectDebug
//
//  Created by perfectword on 2021/1/8.
//

#import <UIKit/UIKit.h>

#import "DebugLogDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugLogSearchListController : UIViewController

- (instancetype)initWithDataSource:(DebugLogDataSource *)dataSource;

@end

NS_ASSUME_NONNULL_END
