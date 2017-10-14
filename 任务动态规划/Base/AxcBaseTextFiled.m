//
//  AxcBaseTextFiled.m
//  任务动态规划
//
//  Created by Axc on 2017/10/10.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseTextFiled.h"

@implementation AxcBaseTextFiled

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor AxcUI_CloudColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [[UIColor AxcUI_BelizeHoleColor] CGColor];
        
        self.textColor = [UIColor AxcUI_WetAsphaltColor];
        self.font = [UIFont systemFontOfSize:13];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFiledShouldChange)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setLeftAlignment:(CGFloat )leftAlignment{
    _leftAlignment = leftAlignment;
    //设置左边视图的宽度
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _leftAlignment, 0)];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)textFiledShouldChange{
    if (self.AxcBase_textFiledShouldChange) {
        self.AxcBase_textFiledShouldChange(self.text);
    }
}

@end
