//
//  AxcEventChangeHeaderView.m
//  任务动态规划
//
//  Created by Axc on 2017/10/13.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcEventChangeHeaderView.h"


#define WeakSelf __weak typeof(self) weakSelf = self;


@implementation AxcEventChangeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {

    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleTextField.text = _title;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) { // 取消
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (AxcBaseTextFiled *)titleTextField{
    if (!_titleTextField) {
        WeakSelf;
        _titleTextField = [[AxcBaseTextFiled alloc] init];
        _titleTextField.font = [UIFont fontWithName:@"Arial-BoldItalicMT"size:20];
        _titleTextField.delegate = self;
        _titleTextField.backgroundColor = [UIColor clearColor];
        _titleTextField.layer.masksToBounds = NO;
        _titleTextField.layer.cornerRadius = 0;
        _titleTextField.textColor = nil;
        _titleTextField.leftAlignment = 10;
        // 设置回调
        _titleTextField.AxcBase_textFiledShouldChange = ^(NSString *text) {
            // 这里回调使用的点语法不会造成递归
            [weakSelf.delegate titleDidChange:weakSelf.titleTextField.text];
        };

        [self addSubview:_titleTextField];
        [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            AxcWholeFrameLayout;
        }];
    }
    return _titleTextField;
}


@end
