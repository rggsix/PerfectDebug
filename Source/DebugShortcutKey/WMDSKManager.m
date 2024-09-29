//
//  WMDSKManager.m
//  WMDebugShortcutKey
//
//  Created by SonG on 2022/12/13.
//

#import "WMDSKManager.h"

WMDSKey *WMDSKeyDefine(WMDSKKeyType keyType, UIResponder *responder) {
    return [[WMDSKey alloc] initWithKeyType:keyType responder:responder];
}

WMDSKey *WMDSStringKeyDefine(NSString *key, UIResponder *responder) {
    return [[WMDSKey alloc] initWithKeyString:key responder:responder];
}


@interface WMDSKManager ()

@property(nonatomic, assign, readwrite) BOOL isOn;
///  键盘是否在展示, 键盘展示的时候不响应快捷键
@property(nonatomic, assign) BOOL isKeyboardShowing;

///  @{@"a": WMDSKKeyA}
@property(nonatomic, strong, nonnull) NSDictionary<NSString *, NSNumber *> *key_typeMap;
///  @{WMDSKKeyA: @"a"}
@property(nonatomic, strong, nonnull) NSDictionary<NSNumber *, NSString *> *type_keyMap;

@end

@implementation WMDSKManager

#pragma - mark Life cycle
+ (instancetype)shared {
    static WMDSKManager *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [self new];
    });
    return ins;
}

- (instancetype)init {
    if (self = [super init]) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma - mark Interface
+ (void)config {
    WMDSKManager.shared.isOn = YES;
}

#pragma - mark Actions
- (void)keyboardDidShow {
    self.isKeyboardShowing = YES;
}

- (void)keyboardDidHide {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isKeyboardShowing = NO;
    });
}

#pragma - mark getter && setter
- (BOOL)canResponse {
    return self.isOn && (!self.isKeyboardShowing);
}

- (NSDictionary<NSString *,NSNumber *> *)key_typeMap {
    if (!_key_typeMap) {
        _key_typeMap = @{
            WMDSKKeyStringA: @(WMDSKKeyA),
            WMDSKKeyStringB: @(WMDSKKeyB),
            WMDSKKeyStringC: @(WMDSKKeyC),
            WMDSKKeyStringD: @(WMDSKKeyD),
            WMDSKKeyStringE: @(WMDSKKeyE),
            WMDSKKeyStringF: @(WMDSKKeyF),
            WMDSKKeyStringG: @(WMDSKKeyG),
            WMDSKKeyStringH: @(WMDSKKeyH),
            WMDSKKeyStringI: @(WMDSKKeyI),
            WMDSKKeyStringJ: @(WMDSKKeyJ),
            WMDSKKeyStringK: @(WMDSKKeyK),
            WMDSKKeyStringL: @(WMDSKKeyL),
            WMDSKKeyStringM: @(WMDSKKeyM),
            WMDSKKeyStringN: @(WMDSKKeyN),
            WMDSKKeyStringO: @(WMDSKKeyO),
            WMDSKKeyStringP: @(WMDSKKeyP),
            WMDSKKeyStringQ: @(WMDSKKeyQ),
            WMDSKKeyStringR: @(WMDSKKeyR),
            WMDSKKeyStringS: @(WMDSKKeyS),
            WMDSKKeyStringT: @(WMDSKKeyT),
            WMDSKKeyStringU: @(WMDSKKeyU),
            WMDSKKeyStringV: @(WMDSKKeyV),
            WMDSKKeyStringW: @(WMDSKKeyW),
            WMDSKKeyStringX: @(WMDSKKeyX),
            WMDSKKeyStringY: @(WMDSKKeyY),
            WMDSKKeyStringZ: @(WMDSKKeyZ),
            WMDSKKeyString1: @(WMDSKKey1),
            WMDSKKeyString2: @(WMDSKKey2),
            WMDSKKeyString3: @(WMDSKKey3),
            WMDSKKeyString4: @(WMDSKKey4),
            WMDSKKeyString5: @(WMDSKKey5),
            WMDSKKeyString6: @(WMDSKKey6),
            WMDSKKeyString7: @(WMDSKKey7),
            WMDSKKeyString8: @(WMDSKKey8),
            WMDSKKeyString9: @(WMDSKKey9),
            WMDSKKeyString0: @(WMDSKKey0),
            WMDSKKeyStringReturnOrEnter: @(WMDSKKeyReturnOrEnter),
            WMDSKKeyStringEscape: @(WMDSKKeyEscape),
            WMDSKKeyStringDeleteOrBackspace: @(WMDSKKeyDeleteOrBackspace),
            WMDSKKeyStringTab: @(WMDSKKeyTab),
            WMDSKKeyStringSpacebar: @(WMDSKKeySpacebar),
            WMDSKKeyStringHyphen: @(WMDSKKeyHyphen),
            WMDSKKeyStringEqualSign: @(WMDSKKeyEqualSign),
            WMDSKKeyStringOpenBracket: @(WMDSKKeyOpenBracket),
            WMDSKKeyStringCloseBracket: @(WMDSKKeyCloseBracket),
            WMDSKKeyStringBackslash: @(WMDSKKeyBackslash),
            WMDSKKeyStringNonUSPound: @(WMDSKKeyNonUSPound),
            WMDSKKeyStringSemicolon: @(WMDSKKeySemicolon),
            WMDSKKeyStringQuote: @(WMDSKKeyQuote),
            WMDSKKeyStringGraveAccentAndTilde: @(WMDSKKeyGraveAccentAndTilde),
            WMDSKKeyStringComma: @(WMDSKKeyComma),
            WMDSKKeyStringPeriod: @(WMDSKKeyPeriod),
            WMDSKKeyStringSlash: @(WMDSKKeySlash),
            WMDSKKeyStringCapsLock: @(WMDSKKeyCapsLock),
            WMDSKKeyStringF1: @(WMDSKKeyF1),
            WMDSKKeyStringF2: @(WMDSKKeyF2),
            WMDSKKeyStringF3: @(WMDSKKeyF3),
            WMDSKKeyStringF4: @(WMDSKKeyF4),
            WMDSKKeyStringF5: @(WMDSKKeyF5),
            WMDSKKeyStringF6: @(WMDSKKeyF6),
            WMDSKKeyStringF7: @(WMDSKKeyF7),
            WMDSKKeyStringF8: @(WMDSKKeyF8),
            WMDSKKeyStringF9: @(WMDSKKeyF9),
            WMDSKKeyStringF10: @(WMDSKKeyF10),
            WMDSKKeyStringF11: @(WMDSKKeyF11),
            WMDSKKeyStringF12: @(WMDSKKeyF12),
            WMDSKKeyStringPrintScreen: @(WMDSKKeyPrintScreen),
            WMDSKKeyStringScrollLock: @(WMDSKKeyScrollLock),
            WMDSKKeyStringPause: @(WMDSKKeyPause),
            WMDSKKeyStringInsert: @(WMDSKKeyInsert),
            WMDSKKeyStringHome: @(WMDSKKeyHome),
            WMDSKKeyStringPageUp: @(WMDSKKeyPageUp),
            WMDSKKeyStringDeleteForward: @(WMDSKKeyDeleteForward),
            WMDSKKeyStringEnd: @(WMDSKKeyEnd),
            WMDSKKeyStringPageDown: @(WMDSKKeyPageDown),
            WMDSKKeyStringRightArrow: @(WMDSKKeyRightArrow),
            WMDSKKeyStringLeftArrow: @(WMDSKKeyLeftArrow),
            WMDSKKeyStringDownArrow: @(WMDSKKeyDownArrow),
            WMDSKKeyStringUpArrow: @(WMDSKKeyUpArrow),
        };
    }
    return _key_typeMap;
}

- (NSDictionary<NSNumber *, NSString *> *)type_keyMap {
    if (!_type_keyMap) {
        NSMutableDictionary<NSNumber *, NSString *> *tmp = [NSMutableDictionary dictionaryWithCapacity:self.key_typeMap.count];
        [self.key_typeMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            tmp[obj] = key;
        }];
        _type_keyMap = [tmp mutableCopy];
    }
    return _type_keyMap;
}

@end

@interface WMDSKey ()

@property(nonatomic, assign, readwrite) WMDSKKeyType keyType;
@property(nonatomic, weak, nullable, readwrite) UIResponder *responder;

@property(nonatomic, copy, nullable) void(^_userDefineAction)(UIResponder *target);


@end

@implementation WMDSKey

- (instancetype)initWithKeyType:(WMDSKKeyType)keyType responder:(UIResponder *)responder {
    if (self = [super init]) {
        self.keyType = keyType;
        self.responder = responder;
    }
    return self;
}

- (instancetype)initWithKeyString:(NSString *)key responder:(UIResponder *)responder {
    NSNumber *keyTypeVal = WMDSKManager.shared.key_typeMap[key];
    ///  👉🏻 ``WMDSKKeyString``
    NSAssert(keyTypeVal, @"没找到这个键位, 请参考 `WMDSKKeyString`");
    return [self initWithKeyType:keyTypeVal.intValue responder:responder];
}

- (WMDSKey * _Nonnull (^)(void (^ _Nonnull)(__kindof UIResponder * _Nonnull)))customAction {
    __weak typeof(self) wself = self;
    return ^id(void(^action)(UIResponder *target)){
        NSParameterAssert(action);
        wself._userDefineAction = [action copy];
        return wself;
    };
}

@end

