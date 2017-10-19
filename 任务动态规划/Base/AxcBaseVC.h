//
//  AxcBaseVC.h
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

// 事件动态算法
#import "AxcDMP_Algorithm.h"
// 数据管理器
#import "AxcDatabaseManagement.h"
// 滚轮选择器
#import "AxcPickSelectorView.h"
// 共用对象
#import "AxcParameterObj.h"
// 专用简易展示事件的Cell和Key
#import "AxcPlanningTableViewCell.h"
#define tableCellKey @"kAxcPlanningTableViewCell"

#define WeakSelf __weak typeof(self) weakSelf = self;

#define NavRightBarEditTitle(a) a?@"完成":@"编辑"

/** 宏指针定义 __nonnull 类型 */
NS_ASSUME_NONNULL_BEGIN

@interface AxcBaseVC : UIViewController

#pragma mark - 关于右按钮
// 添加右按钮组
- (void)AxcBase_addRightBarButtonItems:(NSArray *)items;
// 单个右按钮
- (void)AxcBase_addRightBarButtonItemSystemItem:(UIBarButtonSystemItem)systemItem;

// 右按钮组的触发事件
- (void)AxcBase_clickRightItems:(UIBarButtonItem *)sender;
// 单个右按钮触发
- (void)AxcBase_clickRightBtn:(UIBarButtonItem *)sender;
// 单个自定义按钮触发
- (void)AxcBase_clickCustomRightItem;

// 单个自定义左按钮触发
- (void)AxcBase_clickCustomLeftItem;

#pragma mark - 关于Alent
/** 弹出一个Alent */
- (UIAlertController *)AxcBase_PopAlertViewWithTitle:(NSString *)title
                                             Message:(NSString *)message
                                             Actions:(NSArray <NSString *>*)actions
                                             handler:(void (^ __nullable)(UIAlertAction *action))handler
                                    TextFieldHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

/** 弹出一个警告Alent */
- (UIAlertController *)AxcBase_PopAlertWarningMessage:(NSString *)message;

/** 弹出一个提示Alent */
- (UIAlertController *)AxcBase_PopAlertPromptMessage:(NSString *)message
                                           OKHandler:(void (^ __nullable)(UIAlertAction *action))OKHandler
                                       cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler;

#pragma mark - 关于tablView属性
// 设置TableView默认的Cell外观属性
- (void)AxcBase_settingTableViewCellAppearance:(UITableViewCell *)cell;
// 设置TableView默认的组头外观属性
- (UITableViewHeaderFooterView *)AxcBase_settingTableViewGroupHeaderViewAppearance:(UIView *)view;

#pragma mark - 关于共用组件
// 弹出滚轮选择器
- (void)AxcBase_popDataPickView:(NSArray <NSArray *>*)pickDataArray;
// 滚轮选择确定按钮的触发
- (void)AxcBase_click_pickDetermineBtn;
// 滚轮消失后触发
- (void)AxcUI_dismissPickViewCompletion;
// 获取行动者、地点的字符结构集合，字符结构组合通过Block返回
- (NSArray <NSString *>*)getActionNPListWithType:(AxcActionDataType )type
                                                  Format:(NSString *(^)(NSString *name,NSString *priority))formatBlock;

// 根据Model来使得滚轮自动选中相应元素
- (void)AxcBase_dataPickSelectedWithModel:(AxcEventModel *)model;

#pragma mark - 关于共用通知
// 设置键盘监听
- (void)AxcBase_registeredKeyboardObserver;
//当键盘出现
- (void)AxcBase_keyboardWillShow:(NSNotification *)notification;
//当键退出
- (void)AxcBase_keyboardWillHide:(NSNotification *)notification;


#pragma maek - 关于共用布局函数
// view开始适配布局，是否是横屏状态
- (void)AxcBase_LayoutFitUIWithCross:(BOOL )cross;

// 计算对象
@property(nonatomic, strong)AxcDMP_Algorithm *axcDMP;

// 数据管理对象
@property(nonatomic, strong)AxcDatabaseManagement *axcDatabaseManagement;

// 滚轮选择器
@property(nonatomic, strong)AxcPickSelectorView *axcPickSelectorView;

// 共用对象
@property(nonatomic, strong)AxcParameterObj *axcParameterObj;

// 滚轮使用的字符串二维数组
@property(nonatomic, strong)NSArray *selectedPickContentArray;
// 与之匹配的模型数组
@property(nonatomic, strong)NSArray *selectedPickModelArray;


// tabbar高度
@property(nonatomic, assign)CGFloat axcTabBarHeight;
// navbar高度
@property(nonatomic, assign)CGFloat axcNavBarHeight;
// statusbar高度
@property(nonatomic, assign)CGFloat axcStatusBarHeight;
// 上部Bar所有高度
@property(nonatomic, assign)CGFloat axcTopBarAllHeight;


// 右按钮
@property(nonatomic, strong)UIBarButtonItem *navRightBarButtonItem;
// 左按钮
@property(nonatomic, strong)UIBarButtonItem *navLeftBarButtonItem;


@end


/** 宏指针定义下文 */
NS_ASSUME_NONNULL_END
