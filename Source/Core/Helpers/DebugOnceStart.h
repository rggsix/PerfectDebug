//
//  DebugOnceStart.h
//  PerfectDebug
//
//  Created by perfectword on 2020/11/25.
//

#import <Foundation/Foundation.h>
#import "DebugLogModel.h"
#import "PerfectDebug.h"

@class FMDatabaseQueue;
@class DebugLogDay;
@class DebugOnceStart;

NS_ASSUME_NONNULL_BEGIN

@protocol DebugOnceStartDelegate <NSObject>

- (void)onceStart:(DebugOnceStart *)onceStart logsDidChange:(NSArray<DebugLogModel *> *)chageLogs;

@end

///  一个OnceStart代表一个表，也就是一次启动的所有log
@interface DebugOnceStart : NSObject

//  ---------------- Start 相关信息 -----------------
///  是否为本次启动的log
@property (nonatomic, assign) BOOL isCurrentStartup;
///  表名（存入kTableNameOfStartList表作为一行）
@property (nonatomic, copy) NSString *tableName;
///  startup的时间
@property (nonatomic, strong) NSDate *logDate;
///  startup的时间(XXXX年XX月XX日 XX:XX:XX)
@property (nonatomic, copy) NSString *dateString;
///  本次启动是哪一天
@property (nonatomic, weak) DebugLogDay *day;
/**
 start不应持有dbq:
 因为他的dbq来自day，如果day被释放了，说明这个dbq不应存在了
 */
@property (nonatomic, weak) FMDatabaseQueue *dbq;

//  ---------------- log数据 ----------------
/**
 若为logModels空，会尝试去磁盘读取对应logs，
 并回调 DebugOnceStartDelegate 的 onceStart:logsDidChange:
 */
@property (strong,nonatomic) NSMutableArray<DebugLogModel *> *originLogs;
- (void)queryLogModelsIfNeed;

//  ---------------- log记录方法 ----------------
- (void)archiveLogModel:(DebugLogModel *)model;

//  ---------------- 代理 ----------------
- (void)addDelegate:(id<DebugOnceStartDelegate>)delegate;
- (void)removeDelegate:(id<DebugOnceStartDelegate>)delegate;
- (void)removeAllDelegates;


//  ---------------- 初始化 ----------------
- (instancetype)initWithWithDay:(DebugLogDay *)day
                      tableName:(NSString *)tableName;
///  如果没调上面的init方法，需要调一下prepare()
- (void)prepare;

@end

NS_ASSUME_NONNULL_END
