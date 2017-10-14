//
//  AxcMainTabBarVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcMainTabBarVC.h"

#import "AxcBaseVC.h"

#define VCClassName @"className"
#define VCImg @"Img"
#define VCTitle @"title"

@interface AxcMainTabBarVC ()


@property(nonatomic,strong)NSArray <NSDictionary *>*dataArray;


@end



@implementation AxcMainTabBarVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AxcMainTabBarVC_createUI];

}

#pragma mark - UI设置区
- (void)AxcMainTabBarVC_createUI{

    [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *VC_Name = [obj objectForKey:VCClassName];
        NSString *title = [obj objectForKey:VCTitle];
        NSString *img = [obj objectForKey:VCImg];
        
        Class class = NSClassFromString(VC_Name);
        AxcBaseVC *viewController = [[class alloc]init];
        
        [self createVC:viewController Title:title imageName:img];
        
    }];
    
}



#pragma mark - Delegate代理回调区


#pragma mark - 复用函数









#pragma mark - SET区

#pragma mark - 懒加载区
- (NSArray <NSDictionary *>*)dataArray{
    if (!_dataArray) {
        _dataArray = @[@{VCClassName:@"AxcPlanningVC",
                         VCImg:@"planning",
                         VCTitle:@"待规划"},
                       @{VCClassName:@"AxcRecordVC",
                         VCImg:@"record",
                         VCTitle:@"记录"},
                       @{VCClassName:@"AxcSettingVC",
                         VCImg:@"setting",
                         VCTitle:@"设置"}];
    }
    return _dataArray;
}


@end
