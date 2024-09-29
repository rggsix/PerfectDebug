//
//  DebugTagListSelectController.h
//  PerfectDebug
//
//  Created by perfectword on 2020/11/30.
//

#import <UIKit/UIKit.h>
#import "DebugOnceStart.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugTagListSelectController : UIViewController

- (instancetype)initWithTags:(NSArray<NSString *> *)tags callback:(void(^)(NSString *tag))callback;

@end

NS_ASSUME_NONNULL_END
