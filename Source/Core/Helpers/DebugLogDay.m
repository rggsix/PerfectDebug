//
//  DebugLogDay.m
//  PerfectDebug
//
//  Created by perfectword on 2020/11/26.
//

#import "DebugLogDay.h"

#import "DebugLogManager.h"
#import "DebugCoreCategorys.h"
#import "DebugUtil.h"
#import <fmdb/FMDatabaseQueue.h>

@interface DebugLogDay()

@end

@implementation DebugLogDay

- (instancetype)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        NSString *fileName = [filePath lastPathComponent];
        if ([fileName hasPrefix:kDebugLogFilePrefix]) {
            NSString *dateStr = [fileName stringByReplacingOccurrencesOfString:kDebugLogFilePrefix withString:@""];
            dateStr = [dateStr stringByDeletingPathExtension];
            NSDate *date = [DebugLogManager.shared.fileDateFormatter dateFromString:dateStr];
            self.filePath = filePath;
            self.logDate = date;
            self.dateString = date.dg_dayString;
            self.starts = [NSMutableArray arrayWithCapacity:16];
            self.dbq = [FMDatabaseQueue databaseQueueWithPath:self.filePath];
            //   从该数据库中列出所有表
            [self queryStarts];
        }
    }
    return self;
}

#pragma mark - interface
- (DebugOnceStart *)createStartWithTableName:(NSString *)tableName {
    //  创建once start
    DebugOnceStart *start = [[DebugOnceStart alloc] initWithWithDay:self tableName:tableName];
    start.isCurrentStartup = YES;
    [self.dbq inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@\
                         ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,\
                         'tag' TEXT, \
                         'content' TEXT,\
                         'timeStamp' TEXT);",
                         tableName];
        [db executeUpdate:sql];
        [self.starts insertObject:start atIndex:0];
    }];
    return start;
}

- (void)deleteStart:(DebugOnceStart *)start{
    [self.dbq inDatabase:^(FMDatabase * _Nonnull db) {
        //  删除数据库中的数据
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@;", start.tableName];
        [db executeUpdate:sql];
        //  删除logFiles数组中缓存的对应once start
        [self.starts removeObject:start];
    }];
}

- (void)closeDatabase {
    [self.dbq close];
}

#pragma mark - private
- (void)queryStarts {
    __weak typeof(self) weakSelf = self;
    [self.dbq inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray *starts = [NSMutableArray arrayWithCapacity:16];
        FMResultSet *result = [db executeQuery:@"SELECT name FROM sqlite_master where type='table' order by name"];
        while (result.next) {
            NSString *name = [result stringForColumn:@"name"];
            if ([name hasPrefix:kDebugLogFilePrefix]) {
                DebugOnceStart *start = [[DebugOnceStart alloc] initWithWithDay:weakSelf tableName:name];
                [starts addObject:start];
            }
        }
        [result close];
        [starts sortUsingComparator:^NSComparisonResult(DebugOnceStart *  _Nonnull obj1, DebugOnceStart *  _Nonnull obj2) {
            return [obj2.logDate compare:obj1.logDate];
        }];
        
        self.starts = starts;
    }];
}

@end
