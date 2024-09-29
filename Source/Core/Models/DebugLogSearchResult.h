//
//  DebugLogSearchResult.h
//  PerfectDebug
//
//  Created by pwrd on 2022/8/5.
//

#import <Foundation/Foundation.h>
#import "DebugLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugLogSearchResult : DebugLogModel

@property (nonatomic, strong) NSAttributedString *searchAttrStr;

- (instancetype)initWithModel:(DebugLogModel *)model searchAttrStr:(NSAttributedString *)searchAttrStr;

@end

NS_ASSUME_NONNULL_END
