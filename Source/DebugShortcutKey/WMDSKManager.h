//
//  WMDSKManager.h
//  WMDebugShortcutKey
//
//  Created by SonG on 2022/12/13.
//

#import <UIKit/UIKit.h>
#import "WMDSKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class WMDSKey;

extern WMDSKey *WMDSKeyDefine(WMDSKKeyType keyType, UIResponder  * _Nullable responder);
extern WMDSKey *WMDSStringKeyDefine(NSString *key, UIResponder * _Nullable responder);

@interface WMDSKManager : NSObject

///  服务是否启动
@property(nonatomic, assign, readonly) BOOL isOn;
///  是否可以响应快捷键, 比如软键盘被呼出的时候, 就不能响应快捷键
@property(nonatomic, assign, readonly) BOOL canResponse;


+ (instancetype)shared;

///  启动服务(仅`DEBUG`+模拟器生效)
+ (void)config;

@end

@interface WMDSKey : NSObject

///  快捷键key
@property(nonatomic, assign, readonly) WMDSKKeyType keyType;

///  快捷键响应者
@property(nonatomic, weak, nullable, readonly) UIResponder *responder;

///  自定义响应事件, 如果用这个, SDK的内置响应逻辑将会失效 (比如 UIButton 将不会模拟点击事件)
@property(nonatomic, copy, nonnull, readonly) WMDSKey *(^customAction)(void(^)(__kindof UIResponder *target));

/**
 通过枚举创建键与响应者的映射关系, 推荐用这个
 
 比如: `[[WMDSKey alloc] initWithKeyType:WMDSKKeyReturnOrEnter responder:self.nextButton];`
 */
- (instancetype)initWithKeyType:(WMDSKKeyType)keyType responder:(UIResponder *)responder NS_DESIGNATED_INITIALIZER;

/**
 通过字符串创建响应者映射关系, 只支持一些常见的键位, 具体见 ``WMDSKKeyString``
 
 比如: `[[WMDSKey alloc] initWithKeyType:@"enter" responder:self.nextButton];`
 */
- (instancetype)initWithKeyString:(NSString *)key responder:(UIResponder *)responder;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
