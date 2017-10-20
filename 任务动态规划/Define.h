//
//  Define.h
//

#ifndef Define_h
#define Define_h


// 适配
#define AxcWholeFrameLayout make.top.mas_equalTo(0);\
make.left.mas_equalTo(0);\
make.right.mas_equalTo(0);\
make.bottom.mas_equalTo(0)

// Color
#define SysRedColor RGB(252, 61, 57)

// 主题色
// 紫色
#define Axc_ThemeColor [UIColor AxcUI_AmethystColor]
// 淡黄
#define Axc_ThemeColorOneCollocation RGB(244,243,192)
// 浅蓝
#define Axc_ThemeColorTwoCollocation RGB(91,141,195)


// RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


// KeyWindow
#define kKeyWindow [UIApplication sharedApplication].keyWindow

// ScreenSize
#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height


#endif

//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

// 通知中心
/** 当有常用事件被添加进常用列表时 */
#define Axc_ModelAddCommonlyUsedList @"kAxc_ModelAddCommonlyUsedList_NotificationName"


