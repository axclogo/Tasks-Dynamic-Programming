//
//  AxcBaseVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseVC.h"


@interface AxcBaseVC ()




@end

@implementation AxcBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

#pragma mark - 适配
- (void)viewDidLayoutSubviews{
    // 适配UI
    WeakSelf;
    UIDevice* curDev = [UIDevice currentDevice];
    switch (curDev.orientation){
        case UIDeviceOrientationPortrait:           [weakSelf AxcBase_LayoutFitUIWithCross:NO];  break;
        case UIDeviceOrientationLandscapeLeft:      [weakSelf AxcBase_LayoutFitUIWithCross:YES]; break;
        case UIDeviceOrientationLandscapeRight:     [weakSelf AxcBase_LayoutFitUIWithCross:YES]; break;
        default:break;
    }
}
- (void)AxcBase_LayoutFitUIWithCross:(BOOL )cross{}

#pragma mark - 预设函数
// 设置键盘监听
- (void)AxcBase_registeredKeyboardObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AxcBase_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AxcBase_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


// 获取行动者、地点的字符结构集合
- (NSArray <NSString *>*)getActionNPListWithType:(AxcActionDataType )type
                                          Format:(NSString *(^)(NSString *name,NSString *priority))formatBlock {
    NSArray <NSDictionary *>*triggerObjectArray = [self.axcDatabaseManagement getObjectModelTitleListWithType:type];
    // 转成字符格式
    NSMutableArray *titleArray = [NSMutableArray array];
    [triggerObjectArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (formatBlock)  [titleArray addObject:formatBlock([obj valueForKey:ModelName],
                                                            [obj valueForKey:ModelPriority])];
    }];
    return titleArray;
}

// 弹出滚轮选择器
- (void)AxcBase_popDataPickView:(NSArray <NSArray *>*)pickDataArray{
    self.axcPickSelectorView.subTitleLabel.text = @"触发者 - 触发地点 - 执行者 - 执行地点";
    self.axcPickSelectorView.pickDataArray = pickDataArray;
    [self AxcUI_presentSemiView:self.axcPickSelectorView withOptions:
     @{AxcUISemiModalOptionKeys.axcUI_transitionStyle:@(AxcSemiModalTransitionStyleSlideUp),
       AxcUISemiModalOptionKeys.axcUI_disableCancel:  @(1),
       AxcUISemiModalOptionKeys.axcUI_pushParentBack: @(0) }];
    [self.axcPickSelectorView.pickerView reloadAllComponents];
}

// 滚轮选择器的触发
- (void)AxcBase_click_pickDetermineBtn{
    [self AxcUI_dismissSemiModalViewWithCompletion:^{
        [self AxcUI_dismissPickViewCompletion];
    }];
}
// 滚轮消失后触发
- (void)AxcUI_dismissPickViewCompletion{}

// 设置Cell的风格（AxcUIKit的风格）
- (void)AxcBase_settingTableViewCellAppearance:(UITableViewCell *)cell{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"1296db"];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"b0a4e3"];
}
// 设置TableViewGroupHeaderView的风格（AxcUIKit的风格）
- (UITableViewHeaderFooterView *)AxcBase_settingTableViewGroupHeaderViewAppearance:(UIView *)view{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.textLabel.textColor = [UIColor AxcUI_ConcreteColor];
    header.textLabel.font = [UIFont systemFontOfSize:14];
    return header;
}
// 添加一组右按钮
- (void)AxcBase_addRightBarButtonItems:(NSArray *)items{
    NSMutableArray *arr_M = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:obj
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(AxcBase_clickRightItems:)];
        btn.tag = idx + 5324;
        [arr_M addObject:btn];
    }];
    self.navigationItem.rightBarButtonItems = arr_M;
}

// 添加一个右按钮
- (void)AxcBase_addRightBarButtonItemSystemItem:(UIBarButtonSystemItem)systemItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:systemItem
                                              target:self
                                              action:@selector(AxcBase_clickRightBtn:)];
}

#pragma mark - Alent
// MARK:Alent函数
// 弹出一个Alent
- (UIAlertController *)AxcBase_PopAlertViewWithTitle:(NSString *)title
                                             Message:(NSString *)message
                                             Actions:(NSArray <NSString *>*)actions
                                             handler:(void (^ __nullable)(UIAlertAction *action))handler
                                    TextFieldHandler:(void (^ __nullable)(UITextField *textField))configurationHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    if (configurationHandler) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            configurationHandler(textField);
        }];
    }
    [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           handler(action);
                                                       }];
        [alertController addAction:action];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
    return alertController;
}
// 弹出一个警告框
- (UIAlertController *)AxcBase_PopAlertWarningMessage:(NSString *)message{
    return [self AxcBase_PopAlertViewWithTitle:@"警告"
                                       Message:message
                                       Actions:@[@"确定"]
                                       handler:nil
                              TextFieldHandler:nil];
}
// 弹出一个提示框
- (UIAlertController *)AxcBase_PopAlertPromptMessage:(NSString *)message
                                           OKHandler:(void (^ __nullable)(UIAlertAction *action))OKHandler
                                       cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler{
    return [self AxcBase_PopAlertViewWithTitle:@"提示"
                                       Message:message
                                       Actions:@[@"确定",@"取消"]
                                       handler:^(UIAlertAction * _Nonnull action) {
                                           if ([action.title isEqualToString:@"确定"]) {
                                               OKHandler(action);
                                           }else cancelHandler(action);
                                       }
                              TextFieldHandler:nil];
}


// 根据Model来使得滚轮自动选中相应元素
- (void)AxcBase_dataPickSelectedWithModel:(AxcEventModel *)model{
    NSArray *ContentNameArray = [self.axcDatabaseManagement AxcBase_elementsContentNameArrayWithModel:model];
    NSMutableArray *fourElementsArray = [NSMutableArray arrayWithArray:ContentNameArray];
    [fourElementsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull i_obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr = self.selectedPickContentArray[idx];
        [arr enumerateObjectsUsingBlock:^(NSString *  _Nonnull j_obj, NSUInteger jdx, BOOL * _Nonnull j_stop) {
            NSArray *strArr = [j_obj componentsSeparatedByString:@"("];
            NSString *j_Str = [strArr firstObject];
            if ([i_obj isEqualToString:j_Str]) {
                [self.axcPickSelectorView.pickerView selectRow:jdx inComponent:idx animated:YES];
            }
        }];
    }];
}


// 子类重写触发
- (void)AxcBase_clickRightBtn:(UIBarButtonItem *)sender{} // 点击右按钮
- (void)AxcBase_clickCustomRightItem{}  // 点击右按钮
- (void)AxcBase_clickRightItems:(UIBarButtonItem *)sender{} // 点击右按钮组
- (void)AxcBase_clickCustomLeftItem{}   // 点击左按钮
- (void)AxcBase_keyboardWillShow:(NSNotification *)notification{}//当键盘出现
- (void)AxcBase_keyboardWillHide:(NSNotification *)notification{}//当键退出

#pragma mark - GET/SET
- (CGFloat)axcTabBarHeight{
    return [self.tabBarController.tabBar frame].size.height;
}
- (CGFloat )axcNavBarHeight{
    return [self.navigationController.navigationBar frame].size.height;
}
- (CGFloat )axcStatusBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}
- (CGFloat )axcTopBarAllHeight{
    return self.axcStatusBarHeight + self.axcNavBarHeight;
}

// 销毁控制器
- (void)dealloc{
    // 移除键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 懒加载

// 行动元素数组
- (NSArray *)selectedPickModelArray{
    if (!_selectedPickModelArray) {
        NSArray *ObjectModelArray = [self.axcDatabaseManagement getObjectModelListWithType:AxcActionDataTypeObjectModelList];
        NSArray *LocationModelArray = [self.axcDatabaseManagement getObjectModelListWithType:AxcActionDataTypeLocationModelList];
        _selectedPickModelArray = @[ObjectModelArray.copy,
                                    LocationModelArray.copy,
                                    ObjectModelArray.copy,
                                    LocationModelArray.copy];
    }
    return _selectedPickModelArray;
}

// 滚轮数组
- (NSArray *)selectedPickContentArray{
    if (!_selectedPickContentArray) {
#define BlockFormat [NSString stringWithFormat:@"%@(%@)",name,priority]
        // 在Block中设置Format
        NSArray *ObjectModelArray = [self getActionNPListWithType:AxcActionDataTypeObjectModelList
                                                           Format:^NSString *(NSString *name, NSString *priority) {
                                                               return BlockFormat;
                                                           }];
        
        NSArray *LocationModelArray = [self getActionNPListWithType:AxcActionDataTypeLocationModelList
                                                             Format:^NSString *(NSString *name, NSString *priority) {
                                                                 return BlockFormat;
                                                             }];
        _selectedPickContentArray = @[ObjectModelArray.copy,
                                      LocationModelArray.copy,
                                      ObjectModelArray.copy,
                                      LocationModelArray.copy];
    }
    return _selectedPickContentArray;
}

// 共用对象
- (AxcParameterObj *)axcParameterObj{
    if (!_axcParameterObj) {
        _axcParameterObj = [[AxcParameterObj alloc] init];
    }
    return _axcParameterObj;
}
// 滚轮选择器
- (AxcPickSelectorView *)axcPickSelectorView{
    if (!_axcPickSelectorView) {
        _axcPickSelectorView = [[AxcPickSelectorView alloc]  initWithFrame:CGRectMake(0, 0, self.view.axcUI_Width, 200)];
        [_axcPickSelectorView.determineBtn addTarget:self action:@selector(AxcBase_click_pickDetermineBtn)
                                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _axcPickSelectorView;
}
// 数据管理
- (AxcDatabaseManagement *)axcDatabaseManagement{
    if (!_axcDatabaseManagement) {
        _axcDatabaseManagement = [AxcDatabaseManagement sharedDatabaseManagement] ;
    }
    return _axcDatabaseManagement;
}
// 动态任务规划对象
- (AxcDMP_Algorithm *)axcDMP{
    if (!_axcDMP) {
        _axcDMP = [[AxcDMP_Algorithm alloc] init];
    }
    return _axcDMP;
}
// 右按钮
- (UIBarButtonItem *)navRightBarButtonItem{
    if (!_navRightBarButtonItem) {
        _navRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(AxcBase_clickCustomRightItem)];
        self.navigationItem.rightBarButtonItem = _navRightBarButtonItem;
    }
    return _navRightBarButtonItem;
}

- (UIBarButtonItem *)navLeftBarButtonItem{
    if (!_navLeftBarButtonItem) {
        _navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(AxcBase_clickCustomLeftItem)];
        self.navigationItem.leftBarButtonItem = _navLeftBarButtonItem;
    }
    return _navLeftBarButtonItem;
}

@end

