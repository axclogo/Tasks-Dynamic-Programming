//
//  AxcBaseTabBarVC.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseTabBarVC.h"


@interface AxcBaseTabBarVC ()


@property(nonatomic,strong)NSArray *dataArray;


@end

@implementation AxcBaseTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AxcBaseTabBarVC_createUI];
    [self AxcBaseTabBarVC_requestData];
}





#pragma mark - 数据请求区
- (void)AxcBaseTabBarVC_requestData{
    
}

#pragma mark - Delegate代理回调区


#pragma mark - 复用函数
- (void)createVC:(UIViewController *)vc Title:(NSString *)title imageName:(NSString *)imageName{
    vc.title = title;
    self.tabBar.tintColor = [UIColor AxcUI_colorWithHexCode:@"1296db"];
    NSString *imageNormal = [NSString stringWithFormat:@"%@_normal",imageName];
    vc.tabBarItem.image = [[UIImage imageNamed:imageNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSString *imageSelect = [NSString stringWithFormat:@"%@_selected",imageName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:imageSelect] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:vc]];
}



#pragma mark - UI设置区
- (void)AxcBaseTabBarVC_createUI{
    
}




#pragma mark - SET区

#pragma mark - 懒加载区



@end
