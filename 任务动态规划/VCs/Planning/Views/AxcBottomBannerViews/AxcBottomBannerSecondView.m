//
//  AxcBottomBannerSecondView.m
//  任务动态规划
//
//  Created by Axc on 2017/10/19.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBottomBannerSecondView.h"

#define DefaultPlaceholderText @"请在这里输入备注"

@implementation AxcBottomBannerSecondView

- (instancetype)init{
    if (self == [super init]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    WEAK_SELF;
    CGFloat leftMargin = 10;
    [self.contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(leftMargin);
    }];
    
    [self.priorityStartRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentTitleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(leftMargin);
        make.right.mas_equalTo(-leftMargin);
        make.height.mas_equalTo(30);
    }];
    
    [self.noteTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.priorityStartRatingView.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-10);
    }];
    
    
}

#pragma mark - 回调
- (void)starRatingViewDidChangeValue:(AxcUI_StarRatingView *)sender { // 数值
    if ([self.delegate respondsToSelector:@selector(starRatingViewDidChangePriority:)]) {
        [self.delegate starRatingViewDidChangePriority:sender.axcUI_value];
    }
}
- (void)textViewDidChange:(UITextView *)textView{ // 备注改变
    if ([self.delegate respondsToSelector:@selector(noteTextViewDidChange:)]) {
        NSString *text = defaultPlaceholderText;
        if (textView.text.length)  text = textView.text;
        [self.delegate noteTextViewDidChange:text];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self setDefaultPlaceholderText:textView];
    if ([textView.text isEqualToString:DefaultPlaceholderText]) { // 如果是占位符才清空
        textView.text = @"";
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self setDefaultPlaceholderText:textView];

    return YES;
}

- (void)setDefaultPlaceholderText:(UITextView *)textView{
    if (textView.text.length) {
        textView.textColor = Axc_ThemeColorTwoCollocation;
    }else{
        textView.text = DefaultPlaceholderText;
        textView.textColor = [UIColor grayColor];
    }
}

#pragma mark - 懒加载
- (AxcUI_Label *)contentTitleLabel{
    if (!_contentTitleLabel) {
        _contentTitleLabel = [self createcontentTitleLabelWithText:@"优先级（设置优先级后将无视算法排序，会将该任务置顶考虑）"];
        [self addSubview:_contentTitleLabel];
    }
    return _contentTitleLabel;
}

- (AxcBaseTextView *)noteTextView{
    if (!_noteTextView) {
        _noteTextView = [[AxcBaseTextView alloc] init];
        _noteTextView.delegate = self;
        [self setDefaultPlaceholderText:_noteTextView];
        [self addSubview:_noteTextView];
       
    }
    return _noteTextView;
}

- (AxcUI_StarRatingView *)priorityStartRatingView{
    if (!_priorityStartRatingView) {
        _priorityStartRatingView = [[AxcUI_StarRatingView alloc] init];
        
        _priorityStartRatingView.backgroundColor = [UIColor clearColor];
        _priorityStartRatingView.axcUI_maximumValue = MaxPriority;
        _priorityStartRatingView.axcUI_minimumValue = 0;
        _priorityStartRatingView.tintColor = Axc_ThemeColorTwoCollocation;
        [_priorityStartRatingView addTarget:self action:@selector(starRatingViewDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_priorityStartRatingView];
     
    }
    return _priorityStartRatingView;
}

@end
