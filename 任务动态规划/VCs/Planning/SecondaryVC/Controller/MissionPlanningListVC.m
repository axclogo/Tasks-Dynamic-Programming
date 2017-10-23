//
//  MissionPlanningListVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "MissionPlanningListVC.h"



@interface MissionPlanningListVC ()<
UITableViewDelegate
,UITableViewDataSource
>


@property(nonatomic, strong) UITableView *tableView;

@end

@implementation MissionPlanningListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self createUI];
    [self operationData];
    
}

#pragma mark - 业务逻辑
- (void)AxcBase_clickRightItems:(UIBarButtonItem *)sender{
    NSInteger tag = sender.tag - 5324;
    switch (tag) {
        case 0: // 点击保存
            [self popInputFileNameAlent]; break;
            
        default: break;
    }
}


//MARK: 保存已规划列表
- (void)savePlanningEventListArrayWithName:(NSString *)name{
    [self.axcDatabaseManagement addAlreadyPlanningEventListWithArray:self.dataArray WithTitle:name];
}
- (void)popInputFileNameAlent{
    WeakSelf;
    NSArray *alentTitleArray = @[@"确定",@"取消"];
    __block UITextField *alentTextField ;
    [self AxcBase_PopAlertViewWithTitle:@"保存规划记录"
                                Message:@"请输入想要保存的名称"
                                Actions:alentTitleArray
                                handler:^(UIAlertAction * _Nonnull action) {
                                    if (alentTextField.text.length) {
                                        [weakSelf savePlanningEventListArrayWithName:alentTextField.text];
                                    }
                                } TextFieldHandler:^(UITextField * _Nonnull textField) {
                                    alentTextField = textField;
                                }];
}


#pragma mark - Delegate代理回调区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArray = self.dataArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AxcPlanningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellKey];
    cell.backgroundColor = [UIColor clearColor];
    if (self.dataArray.count) {
        NSArray *sectionArray = self.dataArray[indexPath.section];
        AxcEventModel *eventModel = sectionArray[indexPath.row];
        cell.model = eventModel;
        tableView.rowHeight = 70;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *titleNameAray = self.dataArray[section];
    AxcEventModel *sectionModel = [titleNameAray firstObject]; // 以事件的第一个触发地点名称为准
    // 取出事件的名称
    return [self.axcDMP Axc_DMP_SwitchAttributeWithObj:sectionModel.triggerLocation
                                             Parameter:AxcParameterPropertiesName];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self AxcBase_settingTableViewGroupHeaderViewAppearance:view];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell AxcUI_cellAppearAnimateStyle:AxcCellAppearAnimateStyleRightToLeft indexPath:indexPath];
}

- (void)createUI{
    // tableView的适配
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        AxcWholeFrameLayout;
    }];
   
    
}

- (void)operationData{// 选择以触发地点进行升序运算
    if (!self.dataArray.count) { // 如果有数据则不需要运算事件
        [self reloadOperationDataWithOperationProperties:AxcOperationPropertiesTriggerLocation];
        // 右按钮
        [self AxcBase_addRightBarButtonItems:@[@"保存"]];
    }
}



// 刷新运算数据
- (void)reloadOperationDataWithOperationProperties:(AxcOperationProperties )operationProperties{
    NSArray <NSArray *>*parallelArray = [self.axcDMP Axc_DMP_ParallelWithArray:self.eventArray
                                                           OperationProperties:operationProperties];
    // 根据每个小分组中的执行者优先级进行排序，优先级越低（数值高）的放前头，也就是降序
    self.dataArray = [self.axcDMP Axc_DMP_ParallelDimensionalWithArray:parallelArray
                                                   OperationProperties:AxcOperationPropertiesPerformObject
                                                             Ascending:NO];
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNib:[UINib nibWithNibName:@"AxcPlanningTableViewCell" bundle:nil]
         forCellReuseIdentifier:tableCellKey];
    }
    return _tableView;
}

-(void)dealloc{
    NSLog(@"销毁控制器");
}

@end
