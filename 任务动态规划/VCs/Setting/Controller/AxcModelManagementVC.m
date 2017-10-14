//
//  AxcModelManagementVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/20.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcModelManagementVC.h"


@interface AxcModelManagementVC ()<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation AxcModelManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AxcModelManagementVC_createUI];

    [self loadModelListData];
}


#pragma mark - 数据处理
- (void)loadModelListData{
    NSArray *arrayModeList = [self.axcDatabaseManagement getObjectModelListWithType:(NSInteger )self.modelListStyle];
    [self reloadDataArray:arrayModeList];
}



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

// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [self.axcDatabaseManagement saveObjectModelList:self.dataArray SaveWithType:(NSInteger )self.modelListStyle];
}
//   设置删除操作时候的标题
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self AxcBase_settingTableViewGroupHeaderViewAppearance:view];
}



#pragma mark - 复用函数


#pragma mark - SET




#pragma mark - UI设置区
- (void)AxcModelManagementVC_createUI{
    // 编辑按钮
    [self AxcBase_addRightBarButtonItemSystemItem:UIBarButtonSystemItemEdit];
    [self.view addSubview:self.tableView];
}

- (void)AxcBase_clickRightBtn:(UIBarButtonItem *)sender{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}



#pragma mark - SET区
- (void)reloadDataArray:(NSArray *)dataArray{
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    [self.tableView reloadData];
}


#pragma mark - 懒加载区


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
