//
//  AxcBottomBannerFirstView.m
//  任务动态规划
//
//  Created by Axc on 2017/9/28.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBottomBannerFirstView.h"

@interface AxcBottomBannerFirstView ()<UITextFieldDelegate>

@end

@implementation AxcBottomBannerFirstView

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor AxcUI_ConcreteColor];
        
        [self createUI];
    }
    return self;
}


- (void)createUI{
    __weak typeof(self)weakSelf = self;
    // 事件名称
    self.eventTitleTextFiled.placeholder = @"* 请输入事件名称";
    self.eventTitleTextFiled.axcUI_PlaceholderLabel.textColor = [UIColor AxcUI_WetAsphaltColor];
    self.eventTitleTextFiled.axcUI_PlaceholderLabel.font = [UIFont systemFontOfSize:14];
    self.eventTitleTextFiled.axcUI_PlaceholderLabel.textAlignment = NSTextAlignmentCenter;
    self.eventTitleTextFiled.textAlignment = NSTextAlignmentCenter;
    [self.eventTitleTextFiled mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    
    // 事件四要素
    [self.eventFourElementsBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.eventTitleTextFiled.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    
    // 事件模拟描述
    [self.eventDescriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.eventFourElementsBtn.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    // 添加事件Btn
    [self.addEventBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.eventDescriptionLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (AxcBaseButton *)addEventBtn{
    if (!_addEventBtn) {
        _addEventBtn = [[AxcBaseButton alloc] init];
        _addEventBtn.backgroundColor = [UIColor AxcUI_WetAsphaltColor];
        _addEventBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_addEventBtn setTitle:@"添加事件" forState:UIControlStateNormal];
        [_addEventBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self addSubview:_addEventBtn];
    }
    return _addEventBtn;
}


- (AxcBaseLabel *)eventDescriptionLabel{
    if (!_eventDescriptionLabel) {
        _eventDescriptionLabel = [[AxcBaseLabel alloc] init];
        _eventDescriptionLabel.textColor = [UIColor AxcUI_CloudColor];
        _eventDescriptionLabel.font = [UIFont systemFontOfSize:13];
        _eventDescriptionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_eventDescriptionLabel];
    }
    return _eventDescriptionLabel;
}

- (AxcBaseButton *)eventFourElementsBtn{
    if (!_eventFourElementsBtn) {
        _eventFourElementsBtn = [[AxcBaseButton alloc] init];
        _eventFourElementsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _eventFourElementsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_eventFourElementsBtn setTitle:@"* 请选择事件要素" forState:UIControlStateNormal];
        [self addSubview:_eventFourElementsBtn];
    }
    return _eventFourElementsBtn;
}

- (AxcBaseLabel *)eventTitleLabel{
    if (!_eventTitleLabel) {
        _eventTitleLabel = [[AxcBaseLabel alloc] init];
        [self addSubview:_eventTitleLabel];
    }
    return _eventTitleLabel;
}
- (AxcBaseTextFiled *)eventTitleTextFiled{
    if (!_eventTitleTextFiled) {
        _eventTitleTextFiled = [[AxcBaseTextFiled alloc] init];
        _eventTitleTextFiled.delegate = self;
//        _eventTitleTextFiled.leftAlignment = 10;
        
        __weak typeof(self)weakSelf = self;
        _eventTitleTextFiled.AxcBase_textFiledShouldChange = ^(NSString *text) {
            [weakSelf.delegate eventTextFiledTextEding];
        };
        [self addSubview:_eventTitleTextFiled];
    }
    return _eventTitleTextFiled;
}


@end
