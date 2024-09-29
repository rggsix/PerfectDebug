//
//  DebugLogDataSource.h
//  PerfectDebug
//
//  Created by perfectword on 2020/12/30.
//

#import <Foundation/Foundation.h>
#import "DebugLogModel.h"
#import "DebugLogSearchResult.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kDebugNoTagKey = @"_kDebugNoTagKey";

@interface DebugLogDataSource : NSObject

///  被tag过滤过的logs
@property (nonatomic, strong) NSArray<DebugLogModel *> *logs;
///  搜索结果
@property (nonatomic, strong) NSArray<DebugLogSearchResult *> *searchLogs;

- (instancetype)initWithLogs:(NSArray<DebugLogModel *> *)logs;
- (void)filterLogsWithTag:(NSString *)tag;
- (void)searchLogsWithKey:(NSString *)key;
- (NSArray<NSString *> *)tags;

@end

NS_ASSUME_NONNULL_END
