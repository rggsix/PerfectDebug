//
//  DebugNetworkMonitor.h
//  PerfectDebug
//
//  Created by JSK on 2020/12/25.
//

#import <Foundation/Foundation.h>

typedef BOOL(^DGResponseStatusJudgeBlock)(NSURLRequest * _Nullable request, NSDictionary * _Nullable response);

NS_ASSUME_NONNULL_BEGIN

@interface DebugNetworkMonitor : NSObject

@property(nonatomic,strong) NSArray<NSString*> *ignoreUrlList;
///  你需要自行检查Response, 返回是否成功, 失败的网络请求会在 Log list 中标红
@property(nonatomic, strong, nullable) DGResponseStatusJudgeBlock responseJudgeBlock;

+(instancetype)shared;

@end

NS_ASSUME_NONNULL_END
