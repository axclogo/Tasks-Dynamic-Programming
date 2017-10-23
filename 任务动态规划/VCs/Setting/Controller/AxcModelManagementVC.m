//
//  AxcModelManagementVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/20.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcModelManagementVC.h"

#define PlanningFooterTitleString self.tableView.editing?@"删除":@"添加"
#define PlanningFooterTitleColor self.tableView.editing?SysRedColor:Axc_ThemeColor

@interface AxcModelManagementVC ()<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic, strong)UITableView *tableView;
// 数据组
@property(nonatomic,strong)NSMutableArray *dataArray;
// 删除记录组
@property(nonatomic, strong)NSMutableArray *deleteArray;

// 删除专用脚
@property(nonatomic, strong)AxcPlanningFooterView *planningFooterView;

@end

@implementation AxcModelManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AxcModelManagementVC_createUI];

}


#pragma mark - 数据处理



#pragma mark - Delegate代理回调区
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"axc"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"axc"];
        [self AxcBase_settingTableViewCellAppearance:cell];
    }
    AxcConditionsBaseModel *conditionsModel = self.dataArray[indexPath.row];
    cell.textLabel.text = conditionsModel.name;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.planningFooterView;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AxcPlanningFooterViewHeight;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.editing? [self didEditSelectRowAtIndexPath:indexPath]: [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    AxcConditionsBaseModel *model = self.dataArray[sourceIndexPath.row];
    [self.dataArray removeObjectAtIndex:sourceIndexPath.row]; // 删除原有的
    [self.dataArray insertObject:model atIndex:destinationIndexPath.row]; // 重新插入一个
    // 优先级重置
    [self resetPriorityWithDataArray];
    // 保存
    [self.axcDatabaseManagement saveObjectModelList:self.dataArray SaveWithType:(NSInteger )self.modelListStyle];
}

//   设置删除操作时候的标题
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self AxcBase_settingTableViewGroupHeaderViewAppearance:view];
}



#pragma mark - 复用函数
//  MARK: 设置右按钮文字
- (void)settingNavRightButtonTitle{
    self.navRightBarButtonItem.title = NavRightBarEditTitle(self.tableView.editing);
}
//  MARK: 右按钮触发
- (void)AxcBase_clickCustomRightItem{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self settingNavRightButtonTitle]; // 设置右按钮
    [self setPlanningFooterViewState]; // 设置底部的View
}
// MARK: 编辑状态下点击（多选选中）
- (void)didEditSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.deleteArray addObject:indexPath];
}
// MARK: 多选取消
- (void)cancelSelectedDelectedAtIndexPath:(NSIndexPath *)indexPath{
    [self.deleteArray removeObject:indexPath];
}
// MARK: 设置删除按钮的状态
- (void)setPlanningFooterViewState{
    _planningFooterView.titleLabel.text = PlanningFooterTitleString;
    _planningFooterView.titleLabel.backgroundColor = PlanningFooterTitleColor;
}

// 点击了底部
- (void)click_startPlanningBtn{ // 编辑则删除，否则添加
    self.tableView.editing?[self deleteTrigger]:[self addTrigger];
}
// MARK: 删除按钮
- (void)deleteTrigger{
    // 升序后倒叙输出
    [self AxcBase_ascendingEnumerationReverse:self.deleteArray
                                   usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                       [self removingSingleDelected:obj];
                                   }];
    // 之后移除所有
    [self.deleteArray removeAllObjects];
}

// MARK: 添加按钮
- (void)addTrigger{
    NSArray *alentTitleArray = @[@"确定",@"取消"];
    NSString *modelListStyleStr = self.modelListStyle?@"地点":@"行动者";
    NSString *alentNameStr = [NSString stringWithFormat:@"新增%@",modelListStyleStr];
    NSString *alentMessageStr = [NSString stringWithFormat:@"请输入想要新增的%@名称",modelListStyleStr];
    WeakSelf;
    __block UITextField *alentTextField ;
    [self AxcBase_PopAlertViewWithTitle:alentNameStr
                                Message:alentMessageStr
                                Actions:alentTitleArray
                                handler:^(UIAlertAction * _Nonnull action) {
                                    if (alentTextField.text.length) {
                                        [weakSelf addNewElementWithName:alentTextField.text];
                                    }
                                } TextFieldHandler:^(UITextField * _Nonnull textField) {
                                    alentTextField = textField;
                                }];
}
// MARK: 新增一个行动者
- (void)addNewElementWithName:(NSString *)name{
    AxcConditionsBaseModel *model = [[AxcConditionsBaseModel alloc] init];
    model.name = name;
    model.addDate = [AMUC_Obj getNowTime];
    [self.dataArray insertObject:model atIndex:0]; // 插入最前
    [self.axcDatabaseManagement saveObjectModelList:self.dataArray SaveWithType:(NSInteger )self.modelListStyle];  // 保存
    [self.tableView reloadData];
}

// MARK: 删除某个元素
- (void)removingSingleDelected:(NSIndexPath *)indexPath{
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self resetPriorityWithDataArray]; // 重设优先级
    [self.axcDatabaseManagement saveObjectModelList:self.dataArray SaveWithType:(NSInteger )self.modelListStyle]; // 存储更新
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    if (!self.dataArray && self.tableView.editing) { // 数据无并且在编辑状态
        [self AxcBase_clickCustomRightItem]; // 自动点击右按钮
    }
}
// MARK: 重设优先级
- (void)resetPriorityWithDataArray{
    NSMutableArray *M_Arr = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AxcConditionsBaseModel *conditionsModel = obj;
        conditionsModel.priority = idx +1;
        [M_Arr addObject:conditionsModel];
    }];
    self.dataArray = M_Arr;
}
#pragma mark - SET




#pragma mark - UI设置区
- (void)AxcModelManagementVC_createUI{
    // 编辑按钮
    [self settingNavRightButtonTitle];
    [self.view addSubview:self.tableView];
    
}





#pragma mark - SET区


#pragma mark - 懒加载区

- (AxcPlanningFooterView *)planningFooterView{
    if (!_planningFooterView) {
        _planningFooterView = [[AxcPlanningFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        [self setPlanningFooterViewState]; // 设置状态
        // 触发事件
        [_planningFooterView addTarget:self action:@selector(click_startPlanningBtn)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    return _planningFooterView;
}

- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray.count) { // 无数据
        NSArray *arrayModeList = [self.axcDatabaseManagement getObjectModelListWithType:(NSInteger )self.modelListStyle];

        _dataArray = [NSMutableArray arrayWithArray:arrayModeList];
        [self.tableView reloadData];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end
