//
//  AxcPickSelectorView.m
//  任务动态规划
//
//  Created by Axc on 2017/9/21.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcPickSelectorView.h"

//#import "AxcEventModel.h"


@implementation AxcPickSelectorView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI{
    
    self.backgroundColor =  [UIColor AxcUI_colorWithHexColor:@"f6f6f6"];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -5);
    self.layer.shadowOpacity = 0.4;
    
    __weak typeof(self)weakSelf = self;
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    // 副标题
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    // 滚轮
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    // 确定按钮
    [self.determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AxcPickSelectorView:didSelectRow:inComponent:)]) {
        [self.delegate AxcPickSelectorView:pickerView didSelectRow:row inComponent:component];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *rowArr = self.pickDataArray[component];
    return rowArr[row];
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowArr = self.pickDataArray[component];
    return rowArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}
//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - 懒加载
- (UIButton *)determineBtn{
    if (!_determineBtn) {
        _determineBtn = [[UIButton alloc] init];
        [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        _determineBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_determineBtn];
    }
    return _determineBtn;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        // 选择框
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor clearColor];
        // 显示选中框
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        [self addSubview:_pickerView];
    }
    return _pickerView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = Axc_ThemeColorTwoCollocation;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"请选择";
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.textColor = Axc_ThemeColorTwoCollocation;
        _subTitleLabel.alpha = 0.7;
        [self addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

@end
