//
//  DebugPerformance.m
//  PerfectDebug
//
//  Created by perfectword on 2020/12/11.
//

#import "DebugPerformance.h"

#import "PerfectDebug.h"
#import "DebugUtil.h"
#import "DebugCoreCategorys.h"

#import "DebugAppShortInfoLabel.h"
#import "DebugAppHardwareMonitor.h"


@interface DebugPerformance ()

@property (nonatomic, strong) DebugAppShortInfoLabel *infoLabel;

@end

@implementation DebugPerformance

+ (instancetype)shared {
    static DebugPerformance *ins;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [self new];
    });
    return ins;
}

/// PerfectDebug会通过runtime调用此方法，不要修改方法签名
+ (void)config {
    [DebugPerformance.shared config];
}

- (void)config {
    if (PerfectDebug.shared.isOn) {
        [self start];
    } else {
        [self stop];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isOnChanged) name:PerfectDebugIsOnChangedNotificationName object:nil];
}

- (void)isOnChanged {
    if (PerfectDebug.shared.isOn) {
        [self start];
    }
    else {
        [self stop];
    }
}

- (void)keyboardChange:(NSNotification *)note{
    if (self.infoLabel.hidden) {
        return;
    }
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    if (frame.origin.y < screenH) {
        self.infoLabel.dg_maxY = frame.origin.y - 62;
    } else {
        self.infoLabel.dg_maxY = screenH - 62;
    }
}

- (void)start {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.infoLabel) {
            self.infoLabel = [[DebugAppShortInfoLabel alloc] initWithFrame:CGRectMake(6, 0, 0, 0)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [DebugUtil.currentWindow bringSubviewToFront:self.infoLabel];
            });
        }
        self.infoLabel.dg_maxY = [UIScreen mainScreen].bounds.size.height - 62;
        self.infoLabel.hidden = NO;
    });
    [DebugAppHardwareMonitor startMonitorWithCallback:^(uint fps, float cpu, uint mem) {
        [self.infoLabel updateWithFPS:fps cpu:cpu mem:mem];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)stop {
    [DebugAppHardwareMonitor pauseMonitor];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.infoLabel.hidden = YES;
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

@end
