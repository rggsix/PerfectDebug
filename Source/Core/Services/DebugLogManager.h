//
//  DebugArchiveManager.h
//  PerfectDebug
//
//  Created by perfectword on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DebugLogModel;
@class DebugLogDay;
@class DebugOnceStart;

static NSString * const kDebugLogFilePrefix = @"debug_log_";

@interface DebugLogManager : NSObject

@property (nonatomic, strong, readonly) NSDateFormatter *fileDateAndTimeFormatter;
@property (nonatomic, strong, readonly) NSDateFormatter *fileDateFormatter;

+ (instancetype)shared;

/**
 加载所有log文件、表信息
 */
- (void)loadLogDayList:(void(^)(NSArray<DebugLogDay *> *logDays))callback;

/**
 存储log
 */
- (void)recordLogWithTag:(NSString *)tag
                 content:(NSDictionary *)content
                complete:(os_block_t _Nullable)complete;

- (void)syncRecordLogWithTag:(NSString *)tag
                     content:(NSDictionary *)content;

/**
 删除某个表
 @content table 要删的table
 */
- (void)deleteStart:(DebugOnceStart *)start complete:(os_block_t)complete;
- (void)deleteAllStarts:(os_block_t)complete;

@end

NS_ASSUME_NONNULL_END
