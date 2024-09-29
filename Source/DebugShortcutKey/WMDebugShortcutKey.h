//
//  WMDebugShortcutKey.h
//  WMDebugShortcutKey
//
//  Created by SonG on 2022/12/13.
//

#import <Foundation/Foundation.h>
#import "WMDSKManager.h"
#import "WMDSKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WMDebugShortcutKeyResponder <NSObject>

@optional
/**
 Debug工具: 模拟器添加键盘快捷键
 
 示例:
 
 1. 导入 `<PerfectDebug/WMDebugShortcutKey.h>` (`import PerfectDebug`)
 
 2. 开启 WMDebugShortcutKey:
    ```objective-c
    #if DEBUG
        [WMDSKManager config];
    #endif
    ```
 
 3. Controller/View 实现 `-wm_debugShortcutKeys` , 返回其支持的快捷键
    ```objective-c
    @implementation MyViewOrVC
    ...
    #if DEBUG
    - (NSArray<WMDSKey *> *)wm_debugShortcutKeys {
        return @[
            WMDSKeyDefine(WMDSKKeyReturnOrEnter, self.nextButton),
            WMDSKeyDefine(WMDSKKey1, self.optionButtons[0])
        ];
    }
    #endif
    @end
    ```
 */
- (NSArray<WMDSKey *> *)wm_debugShortcutKeys;

@end

@interface UIResponder (WMDSK) <WMDebugShortcutKeyResponder>
@end

NS_ASSUME_NONNULL_END
