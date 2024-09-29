//
//  WMDSKDefines.h
//  WMDebugShortcutKey
//
//  Created by SonG on 2022/12/13.
//

#import <Foundation/Foundation.h>

///  Copy from `UIKeyboardHIDUsage`
typedef NS_ENUM(NSUInteger, WMDSKKeyType) {
    WMDSKKeyA    = 0x04,    /* a or A */
    WMDSKKeyB    = 0x05,    /* b or B */
    WMDSKKeyC    = 0x06,    /* c or C */
    WMDSKKeyD    = 0x07,    /* d or D */
    WMDSKKeyE    = 0x08,    /* e or E */
    WMDSKKeyF    = 0x09,    /* f or F */
    WMDSKKeyG    = 0x0A,    /* g or G */
    WMDSKKeyH    = 0x0B,    /* h or H */
    WMDSKKeyI    = 0x0C,    /* i or I */
    WMDSKKeyJ    = 0x0D,    /* j or J */
    WMDSKKeyK    = 0x0E,    /* k or K */
    WMDSKKeyL    = 0x0F,    /* l or L */
    WMDSKKeyM    = 0x10,    /* m or M */
    WMDSKKeyN    = 0x11,    /* n or N */
    WMDSKKeyO    = 0x12,    /* o or O */
    WMDSKKeyP    = 0x13,    /* p or P */
    WMDSKKeyQ    = 0x14,    /* q or Q */
    WMDSKKeyR    = 0x15,    /* r or R */
    WMDSKKeyS    = 0x16,    /* s or S */
    WMDSKKeyT    = 0x17,    /* t or T */
    WMDSKKeyU    = 0x18,    /* u or U */
    WMDSKKeyV    = 0x19,    /* v or V */
    WMDSKKeyW    = 0x1A,    /* w or W */
    WMDSKKeyX    = 0x1B,    /* x or X */
    WMDSKKeyY    = 0x1C,    /* y or Y */
    WMDSKKeyZ    = 0x1D,    /* z or Z */
    WMDSKKey1    = 0x1E,    /* 1 or ! */
    WMDSKKey2    = 0x1F,    /* 2 or @ */
    WMDSKKey3    = 0x20,    /* 3 or # */
    WMDSKKey4    = 0x21,    /* 4 or $ */
    WMDSKKey5    = 0x22,    /* 5 or % */
    WMDSKKey6    = 0x23,    /* 6 or ^ */
    WMDSKKey7    = 0x24,    /* 7 or & */
    WMDSKKey8    = 0x25,    /* 8 or * */
    WMDSKKey9    = 0x26,    /* 9 or ( */
    WMDSKKey0    = 0x27,    /* 0 or ) */
    
    WMDSKKeyReturnOrEnter       = 0x28,    /* Return (Enter) */
    WMDSKKeyEscape              = 0x29,    /* Escape */
    WMDSKKeyDeleteOrBackspace   = 0x2A,    /* Delete (Backspace) */
    WMDSKKeyTab                 = 0x2B,    /* Tab */
    WMDSKKeySpacebar            = 0x2C,    /* Spacebar */
    WMDSKKeyHyphen              = 0x2D,    /* - or _ */
    WMDSKKeyEqualSign           = 0x2E,    /* = or + */
    WMDSKKeyOpenBracket         = 0x2F,    /* [ or { */
    WMDSKKeyCloseBracket        = 0x30,    /* ] or } */
    WMDSKKeyBackslash           = 0x31,    /* \ or | */
    WMDSKKeyNonUSPound          = 0x32,    /* Non-US # or _ */
                                                             /* Typical language mappings: US: \| Belg: μ`£ FrCa: <}> Dan:’* Dutch: <> Fren:*μ
                                                                                           Ger: #’ Ital: ù§ LatAm: }`] Nor:,* Span: }Ç Swed: ,*
                                                                                           Swiss: $£ UK: #~. */
    WMDSKKeySemicolon           = 0x33,    /* ; or : */
    WMDSKKeyQuote               = 0x34,    /* ' or " */
    WMDSKKeyGraveAccentAndTilde = 0x35,    /* Grave Accent and Tilde */
    WMDSKKeyComma               = 0x36,    /* , or < */
    WMDSKKeyPeriod              = 0x37,    /* . or > */
    WMDSKKeySlash               = 0x38,    /* / or ? */
    WMDSKKeyCapsLock            = 0x39,    /* Caps Lock */
    
    /* Function keys */
    WMDSKKeyF1             = 0x3A,    /* F1 */
    WMDSKKeyF2             = 0x3B,    /* F2 */
    WMDSKKeyF3             = 0x3C,    /* F3 */
    WMDSKKeyF4             = 0x3D,    /* F4 */
    WMDSKKeyF5             = 0x3E,    /* F5 */
    WMDSKKeyF6             = 0x3F,    /* F6 */
    WMDSKKeyF7             = 0x40,    /* F7 */
    WMDSKKeyF8             = 0x41,    /* F8 */
    WMDSKKeyF9             = 0x42,    /* F9 */
    WMDSKKeyF10            = 0x43,    /* F10 */
    WMDSKKeyF11            = 0x44,    /* F11 */
    WMDSKKeyF12            = 0x45,    /* F12 */
    WMDSKKeyPrintScreen    = 0x46,    /* Print Screen */
    WMDSKKeyScrollLock     = 0x47,    /* Scroll Lock */
    WMDSKKeyPause          = 0x48,    /* Pause */
    WMDSKKeyInsert         = 0x49,    /* Insert */
    WMDSKKeyHome           = 0x4A,    /* Home */
    WMDSKKeyPageUp         = 0x4B,    /* Page Up */
    WMDSKKeyDeleteForward  = 0x4C,    /* Delete Forward */
    WMDSKKeyEnd            = 0x4D,    /* End */
    WMDSKKeyPageDown       = 0x4E,    /* Page Down */
    WMDSKKeyRightArrow     = 0x4F,    /* Right Arrow */
    WMDSKKeyLeftArrow      = 0x50,    /* Left Arrow */
    WMDSKKeyDownArrow      = 0x51,    /* Down Arrow */
    WMDSKKeyUpArrow        = 0x52,    /* Up Arrow */
};

typedef NSString * WMDSKKeyString NS_STRING_ENUM;

extern WMDSKKeyString const WMDSKKeyStringA; /* a or A */
extern WMDSKKeyString const WMDSKKeyStringB; /* b or B */
extern WMDSKKeyString const WMDSKKeyStringC; /* c or C */
extern WMDSKKeyString const WMDSKKeyStringD; /* d or D */
extern WMDSKKeyString const WMDSKKeyStringE; /* e or E */
extern WMDSKKeyString const WMDSKKeyStringF; /* f or F */
extern WMDSKKeyString const WMDSKKeyStringG; /* g or G */
extern WMDSKKeyString const WMDSKKeyStringH; /* h or H */
extern WMDSKKeyString const WMDSKKeyStringI; /* i or I */
extern WMDSKKeyString const WMDSKKeyStringJ; /* j or J */
extern WMDSKKeyString const WMDSKKeyStringK; /* k or K */
extern WMDSKKeyString const WMDSKKeyStringL; /* l or L */
extern WMDSKKeyString const WMDSKKeyStringM; /* m or M */
extern WMDSKKeyString const WMDSKKeyStringN; /* n or N */
extern WMDSKKeyString const WMDSKKeyStringO; /* o or O */
extern WMDSKKeyString const WMDSKKeyStringP; /* p or P */
extern WMDSKKeyString const WMDSKKeyStringQ; /* q or Q */
extern WMDSKKeyString const WMDSKKeyStringR; /* r or R */
extern WMDSKKeyString const WMDSKKeyStringS; /* s or S */
extern WMDSKKeyString const WMDSKKeyStringT; /* t or T */
extern WMDSKKeyString const WMDSKKeyStringU; /* u or U */
extern WMDSKKeyString const WMDSKKeyStringV; /* v or V */
extern WMDSKKeyString const WMDSKKeyStringW; /* w or W */
extern WMDSKKeyString const WMDSKKeyStringX; /* x or X */
extern WMDSKKeyString const WMDSKKeyStringY; /* y or Y */
extern WMDSKKeyString const WMDSKKeyStringZ; /* z or Z */
extern WMDSKKeyString const WMDSKKeyString1; /* 1 or ! */
extern WMDSKKeyString const WMDSKKeyString2; /* 2 or @ */
extern WMDSKKeyString const WMDSKKeyString3; /* 3 or # */
extern WMDSKKeyString const WMDSKKeyString4; /* 4 or $ */
extern WMDSKKeyString const WMDSKKeyString5; /* 5 or % */
extern WMDSKKeyString const WMDSKKeyString6; /* 6 or ^ */
extern WMDSKKeyString const WMDSKKeyString7; /* 7 or & */
extern WMDSKKeyString const WMDSKKeyString8; /* 8 or * */
extern WMDSKKeyString const WMDSKKeyString9; /* 9 or ( */
extern WMDSKKeyString const WMDSKKeyString0; /* 0 or ) */

extern WMDSKKeyString const WMDSKKeyStringReturnOrEnter;      /* Return (Enter) */
extern WMDSKKeyString const WMDSKKeyStringEscape;             /* Escape */
extern WMDSKKeyString const WMDSKKeyStringDeleteOrBackspace;  /* Delete (Backspace) */
extern WMDSKKeyString const WMDSKKeyStringTab;                /* Tab */
extern WMDSKKeyString const WMDSKKeyStringSpacebar;           /* Spacebar */
extern WMDSKKeyString const WMDSKKeyStringHyphen;             /* - or _ */
extern WMDSKKeyString const WMDSKKeyStringEqualSign;          /* = or + */
extern WMDSKKeyString const WMDSKKeyStringOpenBracket;        /* [ or { */
extern WMDSKKeyString const WMDSKKeyStringCloseBracket;       /* ] or } */
extern WMDSKKeyString const WMDSKKeyStringBackslash;          /* \ or | */
extern WMDSKKeyString const WMDSKKeyStringNonUSPound;         /* Non-US # or _ */

extern WMDSKKeyString const WMDSKKeyStringSemicolon;              /* ; or : */
extern WMDSKKeyString const WMDSKKeyStringQuote;                  /* ' or " */
extern WMDSKKeyString const WMDSKKeyStringGraveAccentAndTilde;    /* Grave Accent and Tilde */
extern WMDSKKeyString const WMDSKKeyStringComma;                  /* , or < */
extern WMDSKKeyString const WMDSKKeyStringPeriod;                 /* . or > */
extern WMDSKKeyString const WMDSKKeyStringSlash;                  /* / or ? */
extern WMDSKKeyString const WMDSKKeyStringCapsLock;               /* Caps Lock */

/* Function keys */
extern WMDSKKeyString const WMDSKKeyStringF1;              /* F1 */
extern WMDSKKeyString const WMDSKKeyStringF2;              /* F2 */
extern WMDSKKeyString const WMDSKKeyStringF3;              /* F3 */
extern WMDSKKeyString const WMDSKKeyStringF4;              /* F4 */
extern WMDSKKeyString const WMDSKKeyStringF5;              /* F5 */
extern WMDSKKeyString const WMDSKKeyStringF6;              /* F6 */
extern WMDSKKeyString const WMDSKKeyStringF7;              /* F7 */
extern WMDSKKeyString const WMDSKKeyStringF8;              /* F8 */
extern WMDSKKeyString const WMDSKKeyStringF9;              /* F9 */
extern WMDSKKeyString const WMDSKKeyStringF10;             /* F10 */
extern WMDSKKeyString const WMDSKKeyStringF11;             /* F11 */
extern WMDSKKeyString const WMDSKKeyStringF12;             /* F12 */
extern WMDSKKeyString const WMDSKKeyStringPrintScreen;     /* Print Screen */
extern WMDSKKeyString const WMDSKKeyStringScrollLock;      /* Scroll Lock */
extern WMDSKKeyString const WMDSKKeyStringPause;           /* Pause */
extern WMDSKKeyString const WMDSKKeyStringInsert;          /* Insert */
extern WMDSKKeyString const WMDSKKeyStringHome;            /* Home */
extern WMDSKKeyString const WMDSKKeyStringPageUp;          /* Page Up */
extern WMDSKKeyString const WMDSKKeyStringDeleteForward;   /* Delete Forward */
extern WMDSKKeyString const WMDSKKeyStringEnd;             /* End */
extern WMDSKKeyString const WMDSKKeyStringPageDown;        /* Page Down */
extern WMDSKKeyString const WMDSKKeyStringRightArrow;      /* Right Arrow */
extern WMDSKKeyString const WMDSKKeyStringLeftArrow;       /* Left Arrow */
extern WMDSKKeyString const WMDSKKeyStringDownArrow;       /* Down Arrow */
extern WMDSKKeyString const WMDSKKeyStringUpArrow;         /* Up Arrow */


NS_ASSUME_NONNULL_BEGIN

@interface WMDSKDefines : NSObject

@end

NS_ASSUME_NONNULL_END
