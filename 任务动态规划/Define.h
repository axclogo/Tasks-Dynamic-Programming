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
#define kColorWithRGB(_R,_G,_B,_A)      ((UIColor *)[UIColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:_A])

#define kThemeColor                          kColorWithRGB(97, 166, 0, 1)   //#61a600

// KeyWindow
#define kKeyWindow [UIApplication sharedApplication].keyWindow

// ScreenSize
#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height

// System Version
#define SYSTEM_VERSION_UP7              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

// Device Model
#define IS_IPHONE           ([[[UIDevice currentDevice ] model] isEqualToString:@"iPhone"])

// Format string
#define kStringWithFormat(_O,_S)        [NSString stringWithFormat:_O,_S]

// Error Domain
#define kErrorDomain @"Nature"

#endif

//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
// 单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//宏定义 获取当前的 状态栏的高度 和导航栏的高度
#define axcNew64 [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height

//// 屏蔽release版本下NSLog
//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif
