//
//  AxcPlanningVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcPlanningVC.h"

#import "AxcPlanningFooterView.h"

#import "MissionPlanningListVC.h"

#import "AxcEventModel.h"

#import "AxcBottomBannerView.h"

#import "AxcEventChangeVC.h"

#define BottomBannerViewHeight ((kScreenWidth /2) + self.axcTabBarHeight )

#define PlanningFooterTitleString self.tableView.editing?@"删除":@"开始规划"
#define PlanningFooterTitleColor self.tableView.editing?SysRedColor:Axc_ThemeColor

#define BtnBaseTag   100
#define LabelBaseTag 200


@interface AxcPlanningVC ()<
AxcPickSelectorViewDelegate
,UITableViewDelegate
,UITableViewDataSource
,AxcBottomBannerViewDelegate
,AxcEventChangeVCDelegate


>


// 当前设置的任务组数组
@property(nonatomic,strong)NSMutableArray *eventDataArray;
// 开始规划尾View
@property(nonatomic, strong)AxcPlanningFooterView *planningFooterView;
// 添加的事件
@property(nonatomic, strong)AxcEventModel *addEventModel;

// 展示已添加的任务列表
@property(nonatomic, strong)UITableView *tableView;




@property(nonatomic, strong)AxcBottomBannerView *axcBottomBannerView;

// 编辑时候选中的数组，用来存储下标
@property(nonatomic,strong)NSMutableArray *selectedEventDataArray;
// 上标题文字全局指针
@property(nonatomic, strong)NSString *titleForHeaderString;
// 上下列表头脚View指针
@property(nonatomic, strong)UITableViewHeaderFooterView *tableViewHeaderFooterView;

@end

@implementation AxcPlanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AxcPlanningVC_createUI];
}

#pragma mark - 复用函数
//MARK: 头脚文字状态
- (void)reloadTitleForHeaderString{
    self.tableViewHeaderFooterView.textLabel.text = self.titleForHeaderString;
}

//MARK: 左按钮文字状态
- (void)settingLeftButtonText{
    NSString *LeftBarButtonItemTitle = nil;
    if (self.tableView.editing) {
        if (self.eventDataArray.count == self.selectedEventDataArray.count) {
            LeftBarButtonItemTitle = @"取消";
        }else{
            LeftBarButtonItemTitle = @"全选";
        }
    }else{
        if (self.axcBottomBannerView.hidden) {
            LeftBarButtonItemTitle = @"添加";
        }else{
            LeftBarButtonItemTitle = @"收起";
        }
    }
    self.navLeftBarButtonItem.title = LeftBarButtonItemTitle;
//    self.navLeftBarButtonItem.title = self.tableView.editing?self.eventDataArray.count == self.selectedEventDataArray.count?@"取消全选":@"全选":self.axcBottomBannerView.hidden?@"展开":@"收起";
}
//MARK: 点击左按钮
-(void)AxcBase_clickCustomLeftItem{
    if (self.tableView.editing) {
        BOOL eventDataArrayCountEqual = self.eventDataArray.count == self.selectedEventDataArray.count;
        eventDataArrayCountEqual?[self cancelSelectedAllCell]: [self selectedAllCell];
    }else{
        [self isFullScreen:!self.axcBottomBannerView.hidden];
    }
    [self settingLeftButtonText]; // 更新文字
}
//MARK: 复用
- (void)isFullScreen:(BOOL )isScreen{
    [self.view endEditing:YES]; // 取消第一响应者
    [self tableViewListFullScreen:isScreen completion:^(BOOL finished) {
        [self settingLeftButtonText]; // 设置文字状态
    }];
}
//MARK: 全选
- (void)selectedAllCell{
    [self.selectedEventDataArray removeAllObjects]; // 先移除
    [self.eventDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.selectedEventDataArray addObject:indexPath];
    }];
}
//MARK: 取消全选
- (void)cancelSelectedAllCell{
    [self.eventDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    [self.selectedEventDataArray removeAllObjects];
}

//MARK: 展开和收起动画效果
- (void)tableViewListFullScreen:(BOOL )isScreen completion:(void (^ __nullable)(BOOL finished))completion{
    WeakSelf;
    CGFloat duration = 0.5;
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionCurveEaseIn;
    if (isScreen) {
        [UIView animateWithDuration:duration
                              delay:0
                            options:animationOptions
                         animations:^{
                             weakSelf.axcBottomBannerView.axcUI_Y = kScreenHeight;
                             weakSelf.tableView.axcUI_Height = kScreenHeight;
                         } completion:^(BOOL finished) {
                             weakSelf.axcBottomBannerView.hidden = isScreen;
                             completion(finished);
                         }];
    }else{
        self.axcBottomBannerView.hidden = isScreen;
        [UIView animateWithDuration:duration
                              delay:0
                            options:animationOptions
                         animations:^{
                             weakSelf.axcBottomBannerView.axcUI_Y = kScreenHeight - BottomBannerViewHeight;
                             weakSelf.tableView.axcUI_Height = kScreenHeight - BottomBannerViewHeight;
                         } completion:^(BOOL finished) {
                             completion(finished);
                         }];
    }
}
//MARK: 右按钮文字状态
- (void)settingRightButtonText{
    self.navRightBarButtonItem.title = NavRightBarEditTitle(self.tableView.editing);
}
//MARK: 点击右按钮编辑
- (void)AxcBase_clickCustomRightItem{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self settingRightButtonText]; // 设置文字状态
    [self isFullScreen:self.tableView.editing]; // 进入全屏
    [self setPlanningFooterViewState]; // 设置下方按钮的状态
    [self reloadTitleForHeaderString]; // 刷新文字
    self.tableView.editing?:[self.selectedEventDataArray removeAllObjects]; // 如果不是编辑则移除所有
}

// ==== 关于滚轮 =====
//MARK: 推出滚轮和相关设置
- (void)popDataPick{
    [self AxcBase_popDataPickView:self.selectedPickContentArray];
}
//MARK: 滚轮回调
- (void)AxcPickSelectorView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self AxcPickViewDidSelectRow:row inComponent:component];
}
//MARK: 滚轮选中某一个的时候
- (void)AxcPickViewDidSelectRow:(NSInteger )row inComponent:(NSInteger)component{
    NSArray *elementsArr = self.selectedPickModelArray[component];
    AxcConditionsBaseModel *conditionsBaseModel = elementsArr[row];
    [self.axcDatabaseManagement changeEventModel:self.axcBottomBannerView.eventModel
                                 ConditionsModel:conditionsBaseModel
                                  WithProperties:component]; // 修改属性
}
//MARK: 滚轮点击确定后
- (void)AxcBase_click_pickDetermineBtn{
    [super AxcBase_click_pickDetermineBtn];
    [self.axcBottomBannerView clickPickOKBtn]; // OK了
}

//MARK: 点击添加事件
- (void)AxcUI_click_addEventModel:(NSString *)eventTitle{
    self.addEventModel = self.axcBottomBannerView.eventModel;
    AxcEventModel *model = [self.addEventModel Axc_copy];
    model.addDate = [AMUC_Obj getNowTime]; // 标签时间戳
    [self.eventDataArray insertObject:model atIndex:0]; // 将插入到最前
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationMiddle];

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self reloadTitleForHeaderString]; // 更新标题文字
    // 存储更新
    [self.axcDatabaseManagement saveWaitingPlanningEventListWithArray:self.eventDataArray];
}
//MARK: 下方横幅回调
- (void)AxcUI_bottomBannerViewFooterDidTrigger{
    [self.navigationController pushViewController:[AxcBaseVC new] animated:YES];
}

//MARK: 点击事件四要素按钮
- (void)AxcUI_click_eventFourElementsBtn:(NSString *)eventTitle{
    [self popDataPick];
}
//MARK: 点击下方按钮
- (void)click_startPlanningBtn{ // 编辑状态下调用删除，否则执行规划
    self.tableView.editing?[self clickTableFooterDelected]:[self clickTableFooterPlanning];
}
//MARK: 编辑状态则调用删除
- (void)clickTableFooterDelected{
    // 排序从小到大
    NSArray *result = [self.selectedEventDataArray sortedArrayUsingComparator:^NSComparisonResult
                                                     (id  _Nonnull obj1,
                                                      id  _Nonnull obj2) { // 支持indexPath
        return [obj1 compare:obj2]; //升序
    }];
    self.selectedEventDataArray = [NSMutableArray arrayWithArray:result]; // 转移
    // 倒叙删除
    [self.selectedEventDataArray enumerateObjectsWithOptions:NSEnumerationReverse // 倒叙
                                                  usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removingSingleDelected:obj];
    }];
    // 之后移除所有
    [self.selectedEventDataArray removeAllObjects];
    [self reloadTitleForHeaderString];
}

//MARK: 编辑状态则调用删除
- (void)removingSingleDelected:(nonnull NSIndexPath *)indexPath{
    [self.eventDataArray removeObjectAtIndex:indexPath.row];
    if (self.eventDataArray.count) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }else{ // 还剩最后一个了
        [self.tableView reloadData];// 刷新tableView校准数据
        [self AxcBase_clickCustomRightItem]; // 自动触发完成按钮
    }
}

//MARK: 开始规划
- (void)clickTableFooterPlanning{
    MissionPlanningListVC *vc = [[MissionPlanningListVC alloc] init];
    vc.title = @"任务规划列表";
    vc.eventArray = self.eventDataArray;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: 编辑状态下选中
- (void)selectedDelectedAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.selectedEventDataArray addObject:indexPath];
    [self reloadTitleForHeaderString];
    [self settingLeftButtonText];
}
//MARK: 从选中中取消
- (void)cancelSelectedDelectedAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.selectedEventDataArray removeObject:indexPath];
    [self reloadTitleForHeaderString];
    [self settingLeftButtonText];
}

//MARK: 正常状态下选中则查看详情/修改
- (void)didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    AxcEventModel *model = self.eventDataArray[indexPath.row];
    AxcEventChangeVC *eventChangeVC = [[AxcEventChangeVC alloc] init];
    eventChangeVC.delegate = self;
    eventChangeVC.indexPath = indexPath;
    eventChangeVC.changeEventModel = [model Axc_copy];
    eventChangeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:eventChangeVC animated:YES];
}
// MARK: 修改完后的回调Model
- (void)eventChangeVC:(AxcEventChangeVC *)eventChangeVC didChangeEventModel:(AxcEventModel *)model{
    [self.eventDataArray replaceObjectAtIndex:eventChangeVC.indexPath.row withObject:model]; // 完成替换
    [self.axcDatabaseManagement saveWaitingPlanningEventListWithArray:self.eventDataArray];    // 存储更新
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self.tableView reloadData];
}


#pragma mark - Delegate代理回调区


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.eventDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AxcPlanningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellKey];
    cell.backgroundColor = [UIColor clearColor];
    if (self.eventDataArray.count) {
        AxcEventModel *eventModel = self.eventDataArray[indexPath.row];
        cell.model = eventModel;
        tableView.rowHeight = 70;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.planningFooterView;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleForHeaderString;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    self.tableViewHeaderFooterView = [self AxcBase_settingTableViewGroupHeaderViewAppearance:view];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return self.tableView.editing?UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert:UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
// 单选删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removingSingleDelected:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self settingLeftButtonText]; // 更新文字
    tableView.editing?[self selectedDelectedAtIndexPath:indexPath]:[self didSelectRowAtIndexPath:indexPath];
}
//从选中中取消
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self cancelSelectedDelectedAtIndexPath:indexPath];
}
// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    AxcEventModel *model = self.eventDataArray[sourceIndexPath.row];
    [self.eventDataArray removeObjectAtIndex:sourceIndexPath.row]; // 删除原有的
    [self.eventDataArray insertObject:model atIndex:destinationIndexPath.row]; // 重新插入一个
    // 存储更新
    [self.axcDatabaseManagement saveWaitingPlanningEventListWithArray:self.eventDataArray];
    [self.tableView reloadData]; // 校准数据
}

#pragma mark - UI设置区
- (void)AxcPlanningVC_createUI{
    // 刷新本地待规划事件数据
    self.eventDataArray = (NSMutableArray *)[self.axcDatabaseManagement getWaitingPlanningEventList];
    [self.tableView reloadData];
    // 全部默认第一个
    for (int i = 0; i < self.selectedPickContentArray.count; i ++) {
        [self AxcPickViewDidSelectRow:0 inComponent:i];
    }
    self.axcPickSelectorView.delegate = self;
    // 设置右按钮
    [self settingRightButtonText];
    // 设置左按钮
    [self settingLeftButtonText];
    // 刷新文字
    [self reloadTitleForHeaderString];
    // 添加键盘监听
    [self AxcBase_registeredKeyboardObserver];
}

//当键盘出现
- (void)AxcBase_keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    CGFloat Y_height = height - self.axcTabBarHeight;
    self.view.axcUI_Y = - Y_height;
}

//当键退出
- (void)AxcBase_keyboardWillHide:(NSNotification *)notification{
    self.view.axcUI_Y = 0;
}


- (void)AxcBase_LayoutFitUIWithCross:(BOOL )cross{
    WeakSelf;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (cross)  make.bottom.mas_equalTo(-((kScreenHeight/3) + weakSelf.axcTabBarHeight ));
        else        make.bottom.mas_equalTo(-BottomBannerViewHeight);
    }];
    [self.axcBottomBannerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.tableView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(- weakSelf.axcTabBarHeight);
    }];
    
}

- (void)setPlanningFooterViewState{
    _planningFooterView.titleLabel.text = PlanningFooterTitleString;
    _planningFooterView.titleLabel.backgroundColor = PlanningFooterTitleColor;
}

#pragma mark - SET区
- (NSString *)titleForHeaderString{
    return self.tableView.editing?[NSString stringWithFormat:@"已选中%lu个事件",(unsigned long)self.selectedEventDataArray.count]
    :[NSString stringWithFormat:@"等待规划共%lu个事件",(unsigned long)self.eventDataArray.count];}


#pragma mark - 懒加载区
- (NSMutableArray *)selectedEventDataArray{
    if (!_selectedEventDataArray) {
        _selectedEventDataArray = [NSMutableArray array];
    }
    return _selectedEventDataArray;
}

- (AxcEventModel *)addEventModel{
    if (!_addEventModel) {
        _addEventModel = [[AxcEventModel alloc] init];
        // 全部默认第一个
        for (int i = 0; i < 4; i ++) {
            [self AxcPickViewDidSelectRow:0 inComponent:i];
        }
    }
    return _addEventModel;
}




- (AxcBottomBannerView *)axcBottomBannerView{
    if (!_axcBottomBannerView) {
        _axcBottomBannerView = [[AxcBottomBannerView alloc] init];
        _axcBottomBannerView.delegate = self;
        
        _axcBottomBannerView.layer.shadowColor = [UIColor blackColor].CGColor;
        _axcBottomBannerView.layer.shadowOffset = CGSizeMake(0,0);
        _axcBottomBannerView.layer.shadowOpacity = 1;
        _axcBottomBannerView.layer.shadowRadius = 4;
        [self.view addSubview:_axcBottomBannerView];
    }
    return _axcBottomBannerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"AxcPlanningTableViewCell" bundle:nil]
         forCellReuseIdentifier:tableCellKey];
        _tableView.allowsMultipleSelectionDuringEditing = YES;

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)eventDataArray{
    if (!_eventDataArray) {
        _eventDataArray = [NSMutableArray array];
    }
    return _eventDataArray;
}

- (AxcPlanningFooterView *)planningFooterView{
    if (!_planningFooterView) {
        _planningFooterView = [[AxcPlanningFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        [self setPlanningFooterViewState];
        // 触发事件
        [_planningFooterView addTarget:self action:@selector(click_startPlanningBtn)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    return _planningFooterView;
}






@end

