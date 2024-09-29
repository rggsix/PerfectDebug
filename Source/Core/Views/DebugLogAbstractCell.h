//
//  DebugLogAbstractCell.h
//  PerfectDebug
//
//  Created by perfectword on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "DebugLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugLogAbstractCell : UITableViewCell

@property (strong,nonatomic) DebugLogModel *logModel;

@end

NS_ASSUME_NONNULL_END
