//
//  DebugArchiveManager.m
//  PerfectDebug
//
//  Created by perfectword on 2020/11/26.
//

#import "DebugLogManager.h"
#import "PerfectDebug.h"
#import "PerfectDebug.h"
#import "DebugUtil.h"
#import "DebugLogDay.h"
#import "DebugOnceStart.h"
#import "DebugLogModel.h"
#import "DebugCoreCategorys.h"

static NSInteger const kDebugDaySeconds = 86400;
static NSInteger const kDebugMaxSaveDays = 10;
static NSString * const kDebugLogFilesFoldName = @"debug_log_files";
static NSString * const kDebugLogFileSuffix = @"dg";

@interface DebugLogManager ()

@property (nonatomic, strong, readwrite) NSDateFormatter *fileDateAndTimeFormatter;
@property (nonatomic, strong, readwrite) NSDateFormatter *fileDateFormatter;
@property (nonatomic, copy) NSString *launchKey;
@property (nonatomic, strong) DebugOnceStart *currentStart;
@property (nonatomic, strong) NSMutableArray<DebugLogDay *> *logFiles;
@property (nonatomic, assign) BOOL dbError;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation DebugLogManager

+ (instancetype)shared {
    static DebugLogManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DebugLogManager new];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.name = @"DebugLogManager";
        self.queue.maxConcurrentOperationCount = 1;
        dispatch_queue_t dispatch_queue = dispatch_queue_create(self.queue.name.UTF8String, DISPATCH_QUEUE_SERIAL);
        self.queue.underlyingQueue = dispatch_queue;
    }
    return self;
}

#pragma mark - interface
- (void)loadLogDayList:(void (^)(NSArray<DebugLogDay *> * _Nonnull))callback {
    [self safeInArchiveQueue:^{
        [self loadLocalLogFilesIfNeed];
        [DebugUtil executeMain:^{
            if(callback) {
                callback(DebugLogManager.shared.logFiles);
            }
        }];
    }];
}

- (void)recordLogWithTag:(NSString *)tag content:(NSDictionary *)content complete:(os_block_t)complete {
    if (PerfectDebug.validTags.count && ![PerfectDebug.validTags containsObject:tag]) return;
    
    [self safeInArchiveQueue:^{
        [self _recordLogWithTag:tag content:content];
        [DebugUtil executeMain:^{
            if (complete) {
                complete();
            }
        }];
    }];
}

- (void)syncRecordLogWithTag:(NSString *)tag content:(NSDictionary *)content {
    dispatch_sync(self.queue.underlyingQueue, ^{
        [self _recordLogWithTag:tag content:content];
    });
}

- (void)_recordLogWithTag:(NSString *)tag content:(NSDictionary *)content{
    //  如果之前数据库出现错误，则不再进行储存，防止出现死循环
    if (self.dbError) {
        return;
    }
    //  尝试初始化log存储文件夹和数据库
    [self prepareThisStartIfNeed];
    
    //  生成log model
    DebugLogModel *log = [[DebugLogModel alloc] initWithTag:tag
                                                 contentDic:DGNotNullDict(content)
                                                  timeStamp:[NSDate date].timeIntervalSince1970];
    [self.currentStart archiveLogModel:log];
}

- (void)deleteStart:(DebugOnceStart *)start complete:(os_block_t)complete{
    [self safeInArchiveQueue:^{
        //  没有dbq没法回调
        if (!start.day.dbq) {
            return;
        }

        [start.day deleteStart:start];
        //  如果清空的是当次的，当前onceStart也要清空
        if (start.isCurrentStartup) {
            [self clearCurrentStart];
        }
        [DebugUtil executeMain:^{
            if (complete) {
                complete();
            }
        }];
    }];
}

- (void)deleteAllStarts:(os_block_t)complete {
    [self safeInArchiveQueue:^{
        //  把本地所有数据库文件清空
        [self.logFiles enumerateObjectsUsingBlock:^(DebugLogDay * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj closeDatabase];
            if (![DebugUtil deleteFileOfPath:obj.filePath]) {
                [PerfectDebug logConsole:@"[DebugLogManager] 删除Log文件时出错：%@", obj.filePath];
            }
        }];
        
        [self.logFiles removeAllObjects];
        
        //  清空当次的
        [self clearCurrentStart];
        
        [DebugUtil executeMain:^{
            if (complete) {
                complete();
            }
        }];
    }];
}

#pragma mark - private func
/**
 子线程串行执行数据存取操作
 注意 ：这个队列是用来操作DebugLogManager的属性的，数据库的存储和写入使用的是log文件对应的DatabaseQueue
 */
- (void)safeInArchiveQueue:(os_block_t)block {
    if ([[NSOperationQueue currentQueue] isEqual:self.queue]) {
        if (block) {
            block();
        }
    } else {
        [self.queue addOperationWithBlock:block];
    }
}

- (void)clearCurrentStart {
    //  清空launchKey，重新生成文件
    self.launchKey = nil;
    self.currentStart = nil;
    self.dbError = NO;
}

- (void)loadLocalLogFilesIfNeed {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //  读取所有log文件
        [self loadLocalLogFiles];
    });
}

- (void)prepareThisStartIfNeed {
    [self loadLocalLogFilesIfNeed];
    if (!self.launchKey) {
        //  生成本次运行对应的文件key
        [self generateLaunchKey];
        //  创建log文件夹
        [self createDirectoryIfNeed];
        //  开启数据库
        [self prepareThisStartDatabase];
    }
}

/// 生成与启动时间对应的唯一key，可以理解为本次启动的ID
- (void)generateLaunchKey {
    self.launchKey = [self.fileDateAndTimeFormatter stringFromDate:[NSDate date]];
}

///  列出本地所有数据库文件
- (void)loadLocalLogFiles {
    //   文件夹如果不存在，说明这是App首次启动
    NSString *logDirPath = [self logDirPath];
    if ([DebugUtil folderExistsAtPath:logDirPath]) {
        NSArray<NSString *> *files = [[NSFileManager defaultManager] subpathsAtPath:logDirPath];
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj hasSuffix:kDebugLogFileSuffix]) {
                return;
            }
            NSString *filePath = [logDirPath stringByAppendingPathComponent:obj];
            DebugLogDay *day = [[DebugLogDay alloc] initWithFilePath:filePath];
            //  检查一下日志有没有过期
            if (day && ![self deleteDatabaseFileIfExpire:day]) {
                //  没过期的才能存入logFiles
                [self.logFiles insertObject:day atIndex:0];
            }
        }];
        
        //  倒序排列
        [self.logFiles sortUsingComparator:^NSComparisonResult(DebugLogDay * _Nonnull obj1,
                                                                                 DebugLogDay * _Nonnull obj2) {
            return [obj2.logDate compare:obj1.logDate];
        }];
    }
}

///  如果过期了，会自动删除，并返回true
- (BOOL)deleteDatabaseFileIfExpire:(DebugLogDay *)day {
    //  如果log过期了，删除
    NSTimeInterval expireSec = kDebugMaxSaveDays * kDebugDaySeconds;
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval passSec = curTime - [day.logDate timeIntervalSince1970];
    if (passSec > expireSec) {
        [DebugUtil deleteFileOfPath:day.filePath];
        return true;
    }
    return false;
}

- (void)createDirectoryIfNeed {
    //  尝试去创建logs文件夹
    NSString *dirPath = [self logDirPath];
    [DebugUtil createFolder:dirPath];
    if (![DebugUtil folderExistsAtPath:dirPath]) {
        //  文件夹没创建成功，后续写入操作都没法继续了
        self.dbError = YES;
        [PerfectDebug logConsole:@"[DebugLogManager] createDirectoryIfNeed failed : %@", dirPath];
    }
}

///  准备本次需要使用的database
- (void)prepareThisStartDatabase {
    //  生成database存储路径
    NSDate *date = [NSDate date];
    NSString *dateName = [self.fileDateFormatter stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@", kDebugLogFilePrefix, dateName, kDebugLogFileSuffix];
    NSString *logDirPath = [self logDirPath];
    NSString *filePath = [logDirPath stringByAppendingPathComponent:fileName];
    //  查找日期model，如果没有，创建
    DebugLogDay *day = self.logFiles.firstObject;
    if (![day.dateString isEqual:date.dg_dayString]) {
        day = [[DebugLogDay alloc] initWithFilePath:filePath];
        if (day) {
            [self.logFiles insertObject:day atIndex:0];
        }
    }
    
    //  创建本次start
    NSString *tableName = [NSString stringWithFormat:@"%@%@", kDebugLogFilePrefix, self.launchKey];
    self.currentStart = [day createStartWithTableName:tableName];
}

#pragma mark - util func

///   log files 所在的文件夹路径
- (NSString *)logDirPath {
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    dirPath = [dirPath stringByAppendingPathComponent:kDebugLogFilesFoldName];
    return dirPath;
}

#pragma mark - getter && setter

- (NSDateFormatter *)fileDateFormatter {
    if (!_fileDateFormatter) {
        _fileDateFormatter = [[NSDateFormatter alloc] init];
        _fileDateFormatter.dateFormat = @"YYYYMMdd";
    }
    return _fileDateFormatter;
}

- (NSDateFormatter *)fileDateAndTimeFormatter {
    if (!_fileDateAndTimeFormatter) {
        _fileDateAndTimeFormatter = [[NSDateFormatter alloc] init];
        _fileDateAndTimeFormatter.dateFormat = @"YYYYMMddHHmmss";
    }
    return _fileDateAndTimeFormatter;
}

- (NSMutableArray<DebugLogDay *> *)logFiles {
    if (!_logFiles) {
        _logFiles = [NSMutableArray array];
    }
    return _logFiles;
}

@end
