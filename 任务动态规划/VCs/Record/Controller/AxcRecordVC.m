//
//  AxcRecordVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcRecordVC.h"

#import "AxcEmptyDataTableView.h"
#import "AxcEmptyDataTableView+AxcEmptyData.h"

#import "AxcRecordPlaceholderView.h"

#import "MissionPlanningListVC.h"

#import "AxcRecordTableViewCell.h"

#define RecordTableCellKey @"kAxcRecordTableViewCell_K"

@interface AxcRecordVC ()<
UITableViewDelegate
,UITableViewDataSource
>


@property(nonatomic, strong) AxcEmptyDataTableView *tableView;

@property(nonatomic, strong)NSMutableArray <NSDictionary *>*dataArray;
// 删除数组
@property(nonatomic, strong)NSMutableArray *deleteArray;

@property(nonatomic, strong)AxcPlanningFooterView *planningFooterView;
@property(nonatomic, strong)AxcRecordPlaceholderView *tablePlaceholderView;

@end

@implementation AxcRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AxcRecordVC_createUI];
}

#pragma mark - UI设置区
- (void)AxcRecordVC_createUI{
    [self settingRightButtonText];
    self.planningFooterView.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self AxcRecordVC_requestData];
    [self settingRightButtonText];
}

#pragma mark - 业务逻辑
//MARK: 右按钮文字状态
- (void)settingRightButtonText{
    self.navRightBarButtonItem.title = self.dataArray.count?NavRightBarEditTitle(self.tableView.editing):nil;
}
//MARK: 点击右按钮编辑
- (void)AxcBase_clickCustomRightItem{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self settingRightButtonText]; // 设置文字状态
    [self statePlanningFooterView];// 设置底部删除
    [self.deleteArray removeAllObjects]; // 移除全部
}
//MARK: 非编辑状态下点击
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSArray *dataArray = [dic objectForKey:kAlreadyPlanningEventList];
    MissionPlanningListVC *vc = [[MissionPlanningListVC alloc] init];
    vc.title = [dic objectForKey:kAlreadyPlanningEventListTitle];
    vc.dataArray = dataArray;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK: 编辑状态下点击（多选选中）
- (void)didEditSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.deleteArray addObject:indexPath];
}
// MARK:多选取消
- (void)didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.deleteArray removeObject:indexPath];
}

// MARK:左滑删除
- (void)didLeftSlideDeleteAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataArray removeObjectAtIndex:indexPath.row]; // 删除原有的
    [self.axcDatabaseManagement saveAlreadyPlanningEventListWithArray:self.dataArray]; // 存储更新
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    // UI动画控制
    if (!self.dataArray.count) { // 空数据了并且是编辑状态
        [self.tableView reloadData];
        [self settingRightButtonText];
        if (!self.tableView.editing) {
            [self AxcBase_clickCustomRightItem];
        }
    }
}

//MARK:点击了删除
- (void)click_delectedBtn{
    // 升序后倒叙输出
    [self AxcBase_ascendingEnumerationReverse:self.deleteArray
                                   usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                       [self didLeftSlideDeleteAtIndexPath:obj];
                                   }];
    // 之后移除所有
    [self.deleteArray removeAllObjects];
}


// 设置删除按钮的存在
- (void)statePlanningFooterView{
    CGFloat duration = 0.4;
    if (self.tableView.editing) {
        self.planningFooterView.hidden = !self.tableView.editing;
        self.planningFooterView.alpha = 0;
        [UIView animateWithDuration:duration
                         animations:^{
                             self.planningFooterView.alpha = 1;
                         }];
    }else{
        [UIView animateWithDuration:duration
                         animations:^{
                             self.planningFooterView.alpha = 0;
                         }completion:^(BOOL finished) {
                             self.planningFooterView.hidden = !self.tableView.editing;
                         }];
    }
}

#pragma mark - 数据请求区
- (void)AxcRecordVC_requestData{
    NSArray *arrData = [self.axcDatabaseManagement getAlreadyPlanningEventList];
    self.dataArray = [NSMutableArray arrayWithArray:arrData];
    [self.tableView reloadData];
}

#pragma mark - Delegate代理回调区
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AxcRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordTableCellKey];

    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    cell.dataDictionary = dic;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.planningFooterView;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AxcPlanningFooterViewHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.editing?[self didEditSelectRowAtIndexPath:indexPath]:[self didSelectRowAtIndexPath:indexPath];
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
    [self didLeftSlideDeleteAtIndexPath:indexPath];
}
//从选中中取消
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didDeselectRowAtIndexPath:indexPath];
}
// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    NSDictionary *dict = self.dataArray[sourceIndexPath.row];
    [self.dataArray removeObjectAtIndex:sourceIndexPath.row]; // 删除原有的
    [self.dataArray insertObject:dict atIndex:destinationIndexPath.row]; // 重新插入一个
    // 存储更新
    [self.axcDatabaseManagement saveAlreadyPlanningEventListWithArray:self.dataArray];
    [self.tableView reloadData]; // 校准数据
}









#pragma mark - SET区

#pragma mark - 懒加载区

- (AxcPlanningFooterView *)planningFooterView{
    if (!_planningFooterView) {
        _planningFooterView = [[AxcPlanningFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _planningFooterView.titleLabel.text = @"删除";
        _planningFooterView.titleLabel.backgroundColor = SysRedColor;
        // 触发事件
        [_planningFooterView addTarget:self action:@selector(click_delectedBtn)
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

- (AxcEmptyDataTableView *)tableView{
    if (!_tableView) {
        _tableView = [[AxcEmptyDataTableView alloc]initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 50;
        _tableView.axcUI_placeHolderView = self.tablePlaceholderView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"AxcRecordTableViewCell" bundle:nil]
         forCellReuseIdentifier:RecordTableCellKey];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            AxcWholeFrameLayout;
        }];
    }
    return _tableView;
}

-(AxcRecordPlaceholderView *)tablePlaceholderView{
    if (!_tablePlaceholderView) {
        WeakSelf;
        _tablePlaceholderView = [[AxcRecordPlaceholderView alloc] initWithFrame:self.tableView.frame];
        _tablePlaceholderView.clickgoToAddEventBtnBlock = ^{ // 跳转到第一页
            weakSelf.tabBarController.selectedIndex = 0;
        };
        [_tablePlaceholderView AxcUI_autoresizingMaskComprehensive]; // 全方位按比例增减适配
    }
    return _tablePlaceholderView;
}

@end
