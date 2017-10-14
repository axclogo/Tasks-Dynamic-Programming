//
//  AxcEventChangeVC.m
//  任务动态规划
//
//  Created by Axc on 2017/10/13.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcEventChangeVC.h"

#import "AxcEventChangeTableViewCell.h"

#import "AxcEventChangeHeaderView.h"
#import "AxcPlanningFooterView.h"



#define kEventSectionTitle @"eventSectionTitle"
#define kEventSectionContent @"eventSectionContent"

#define kEventSectionHeight @"EventSectionHeight"
#define kEventRowHeight     @"EventRowHeight"


#define kEventChangeTableViewCell @"kAxcEventChangeTableViewCell"

#define PlanningFooterTitleString self.modelChangeState?@"确定修改":@"返回"
#define PlanningFooterTitleColor self.modelChangeState?SysRedColor:Axc_ThemeColor

@interface AxcEventChangeVC ()<
UITableViewDelegate
,UITableViewDataSource
,AxcPickSelectorViewDelegate
,AxcEventChangeTableViewCellDelegate

>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, strong)AxcEventChangeHeaderView *tableHeaderView;
@property(nonatomic, strong)AxcPlanningFooterView *planningFooterView;

@property(nonatomic, assign)BOOL modelChangeState;

@end

@implementation AxcEventChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.changeEventModel.name; // 标题名
    
    [self createUI];
    
}

- (void)createUI{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        AxcWholeFrameLayout;
    }];
    self.axcPickSelectorView.delegate = self;
    
}

// 点击了返回
- (BOOL)AxcUI_navigationShouldPopOnBackButton{
    WeakSelf;
    if (self.modelChangeState) { // 被修改了Model
        [self AxcBase_PopAlertPromptMessage:@"确定不保存修改直接返回吗？"
                                  OKHandler:^(UIAlertAction * _Nonnull action) { // 回调代理
                                      [weakSelf.navigationController popViewControllerAnimated:YES];
                                  } cancelHandler:^(UIAlertAction * _Nonnull action) {
                                  }];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 复用函数
//MARK: 点击了下方按钮
- (void)click_sureModifyBtn{
    if (self.modelChangeState)  [self.delegate eventChangeVC:self didChangeEventModel:self.changeEventModel];
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: 滚轮回调
- (void)AxcPickSelectorView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    // 一旦触发滚轮，说明修改
    self.modelChangeState = YES;
    NSArray *elementsArr = self.selectedPickModelArray[component];
    AxcConditionsBaseModel *conditionsBaseModel = elementsArr[row];

    [self.axcDatabaseManagement changeEventModel:self.changeEventModel
                                 ConditionsModel:conditionsBaseModel
                                  WithProperties:component]; // 修改属性
    [self reloadUI];
}
//MARK: 优先级回调
- (void)changePriority:(CGFloat)priority{
    self.modelChangeState = YES; // 一旦触发，说明修改
    self.changeEventModel.priority = priority;
    [self setPlanningFooterViewState]; // 只刷新头脚
}

//MARK: 刷新相关UI
- (void)reloadUI{
    self.dataArray = nil;
    [self.tableView reloadData];
    [self setPlanningFooterViewState];
}

- (void)setPlanningFooterViewState{
    _planningFooterView.titleLabel.text = PlanningFooterTitleString;
    _planningFooterView.titleLabel.backgroundColor = PlanningFooterTitleColor;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AxcEventType cellType = indexPath.section;
    AxcEventChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventChangeTableViewCell];
    NSDictionary *rowMsgDic = self.dataArray[indexPath.section];
    NSArray *rowArray = [rowMsgDic objectForKey:kEventSectionContent];
    NSDictionary *modelMsgDic = rowArray[indexPath.row];
    cell.type = cellType;
    cell.modelMsgDic = modelMsgDic;
    if (cellType == AxcEventTypePriority) cell.delegate = self;
    return cell;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataArray[section];
    NSArray *arr = [dic objectForKey:kEventSectionContent];
    return arr.count;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self AxcBase_settingTableViewGroupHeaderViewAppearance:view];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    return [dic objectForKey:kEventSectionTitle];
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.section];
    CGFloat height = [[dic objectForKey:kEventRowHeight] floatValue];
    return height;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    CGFloat height = [[dic objectForKey:kEventSectionHeight] floatValue];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.section) { // 第一个
        [self AxcBase_popDataPickView:self.selectedPickContentArray];
        [self AxcBase_dataPickSelectedWithModel:self.changeEventModel]; // 选中相应元素
    }
}


#pragma mark - 生成函数
- (NSArray <NSDictionary *>*)createFourElementsArray{
    NSMutableArray *fourElementsArray = [NSMutableArray array];
    NSArray *fourElementsTitleArray = @[@"触发者（事件将由谁发起）",
                                        @"触发地点（事件将会在哪发起）",
                                        @"执行者（事件将由谁执行）",
                                        @"触发地点（事件将会在哪执行）"];
    NSArray *elementsContentNameArray = [self.axcDatabaseManagement AxcBase_elementsContentNameArrayWithModel:self.changeEventModel];
    for (int i = 0; i < fourElementsTitleArray.count; i ++) {
        [fourElementsArray addObject:@{kElementsTitle:fourElementsTitleArray[i],
                                       kElementsContent:elementsContentNameArray[i]}];
    }
    return [NSArray arrayWithArray:fourElementsArray];
}


- (NSArray <NSDictionary *>*)simulationDescribe{
    return @[@{kElementsContent:[AMUC_Obj simulateEventDescriptionWithModel:self.changeEventModel
                                                             PredicateColor:[UIColor AxcUI_BelizeHoleColor]]}];
}


#pragma mark - 懒加载
- (AxcPlanningFooterView *)planningFooterView{
    if (!_planningFooterView) {
        _planningFooterView = [[AxcPlanningFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        [self setPlanningFooterViewState];
        // 触发事件
        [_planningFooterView addTarget:self action:@selector(click_sureModifyBtn)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    return _planningFooterView;
}

- (AxcEventChangeHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[AxcEventChangeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _tableHeaderView.title = self.title;
    }
    return _tableHeaderView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        
        CGFloat sectionHeight = 30;
        _dataArray = @[@{kEventSectionTitle:@"事件四要素",kEventSectionContent:[self createFourElementsArray],
                         kEventSectionHeight:@(sectionHeight),kEventRowHeight:@30 },
                       @{kEventSectionTitle:@"事件模拟描述",kEventSectionContent:[self simulationDescribe],
                         kEventSectionHeight:@(sectionHeight),kEventRowHeight:@60 },
                       @{kEventSectionTitle:@"事件优先级（非必选项）",kEventSectionContent:@[@{kElementsContent:@(self.changeEventModel.priority)}],
                         kEventSectionHeight:@(sectionHeight),kEventRowHeight:@70 },
                       @{kEventSectionTitle:@"事件创建时间",kEventSectionContent:@[@{kElementsContent:self.changeEventModel.addDate}],
                         kEventSectionHeight:@(sectionHeight),kEventRowHeight:@30 }];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.planningFooterView;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerNib:[UINib nibWithNibName:@"AxcEventChangeTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:kEventChangeTableViewCell];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}






@end
