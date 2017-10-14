//
//  AxcPickSelectorView.h
//  任务动态规划
//
//  Created by Axc on 2017/9/21.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AxcPickSelectorViewDelegate <NSObject>

// 选中时
- (void)AxcPickSelectorView:(UIPickerView *)pickerView
               didSelectRow:(NSInteger)row
                inComponent:(NSInteger)component;


@end

@interface AxcPickSelectorView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

// 上标题Label
@property(nonatomic, strong)UILabel *titleLabel;

// 下标题
@property(nonatomic, strong)UILabel *subTitleLabel;

// 滚轮
@property(nonatomic, strong)UIPickerView *pickerView;

// 确定按钮
@property(nonatomic, strong)UIButton *determineBtn;

// 滚轮数据组
@property(nonatomic, strong)NSArray <NSArray *>*pickDataArray;


// 代理
@property(nonatomic, strong)id <AxcPickSelectorViewDelegate >delegate;



@end
