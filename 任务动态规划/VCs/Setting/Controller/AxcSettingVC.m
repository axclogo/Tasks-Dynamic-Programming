//
//  AxcSettingVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcSettingVC.h"

#import "AxcModelManagementVC.h"


#define SettingCellTitle @"SettingCellTitle"
#define SettingCellSectionTitle @"SettingCellSectionTitle"
#define SettingSectionList @"SettingSectionList"


@interface AxcSettingVC ()<
UITableViewDelegate
,UITableViewDataSource
>


@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic, strong) UITableView *tableView;


@end

@implementation AxcSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AxcSettingVC_createUI];
}





#pragma mark - Delegate代理回调区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    NSArray *Arr = [dic objectForKey:SettingSectionList];
    return Arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"axc"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"axc"];
        [self AxcBase_settingTableViewCellAppearance:cell];
    }
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *Arr = [dic objectForKey:SettingSectionList];
    NSDictionary *dic2 = Arr[indexPath.row];
    
    cell.textLabel.text = [dic2 objectForKey:SettingCellTitle];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        // 行动条件组
        case 0:{
            switch (indexPath.row) {
                case 2: // 常用事件列表
                    
                    break;
                    
                default:{ // 0、1
                    AxcModelManagementVC *modelManagementVC = [[AxcModelManagementVC alloc] init];
                    modelManagementVC.modelListStyle = indexPath.row;
                    [self.navigationController pushViewController:modelManagementVC animated:YES];
                } break;
            }
        } break;
            
        default:  break;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    return [dic objectForKey:SettingCellSectionTitle];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self AxcBase_settingTableViewGroupHeaderViewAppearance:view];
}

#pragma mark - 复用函数




#pragma mark - UI设置区
- (void)AxcSettingVC_createUI{
    [self.view addSubview:self.tableView];

}




#pragma mark - SET区

#pragma mark - 懒加载区
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        // 组1
        NSMutableArray *Group1 = [NSMutableArray array];
        [Group1 addObject:@{SettingCellTitle:@"管理所有行动者优先级"}];
        [Group1 addObject:@{SettingCellTitle:@"管理所有行动地点优先级"}];
        [Group1 addObject:@{SettingCellTitle:@"管理常用任务事项"}];

        NSDictionary *GroupDic1 = @{SettingCellSectionTitle:@"行动条件优先级管理",SettingSectionList:Group1};
        
        
        // 组2
        NSMutableArray *Group2 = [NSMutableArray array];
        [Group2 addObject:@{SettingCellTitle:@"预设任务列表"}];
        [Group2 addObject:@{SettingCellTitle:@"查看数据库"}];

        NSDictionary *GroupDic2 = @{SettingCellSectionTitle:@"其他",SettingSectionList:Group2};

        // 组3
        NSMutableArray *Group3 = [NSMutableArray array];
        [Group3 addObject:@{SettingCellTitle:@"词性颜色设置"}];
        NSDictionary *GroupDic3 = @{SettingCellSectionTitle:@"其他",SettingSectionList:Group3};

        [_dataArray addObject:GroupDic1];
        [_dataArray addObject:GroupDic2];
        [_dataArray addObject:GroupDic3];
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
