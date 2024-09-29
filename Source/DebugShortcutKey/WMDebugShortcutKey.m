//
//  WMDebugShortcutKey.m
//  WMDebugShortcutKey
//
//  Created by SonG on 2022/12/13.
//

#import "WMDebugShortcutKey.h"
#import <Aspects/Aspects.h>
#import <PerfectDebug/PerfectDebug-Swift.h>

#if TARGET_IPHONE_SIMULATOR

@implementation UIViewController (WMDSK)

+ (void)load {
    [UIViewController aspect_hookSelector:@selector(pressesBegan:withEvent:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info, NSSet<UIPress *> *presses, UIPressesEvent *event) {
    } error:nil];
}

- (void)aspects__pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    if (WMDSKManager.shared.canResponse == NO
        || wmdsk_handlePress(presses, self) == NO) {
        [self.nextResponder pressesBegan:presses withEvent:event];
    }
}

@end

@implementation UIView (WMDSK)

+ (void)load {
    [UIView aspect_hookSelector:@selector(pressesBegan:withEvent:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info, NSSet<UIPress *> *presses, UIPressesEvent *event) {
    } error:nil];
}

- (void)aspects__pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    if (WMDSKManager.shared.canResponse == NO
        || wmdsk_handlePress(presses, self) == NO) {
        [self.nextResponder pressesBegan:presses withEvent:event];
    }
}

@end

#endif
