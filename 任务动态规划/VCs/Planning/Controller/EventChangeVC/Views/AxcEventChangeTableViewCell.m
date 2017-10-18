

//
//  AxcEventChangeTableViewCell.m
//  任务动态规划
//
//  Created by Axc on 2017/10/13.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcEventChangeTableViewCell.h"

#import "AMUC_Obj.h"

#define WeakSelf __weak typeof(self) weakSelf = self;


@implementation AxcEventChangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    
}

- (void)emptyControl{
    if (self.textLabel.text.length) {
        self.textLabel.text = nil;
    }
    if (_noteTextView) {
        [_noteTextView removeFromSuperview];
        _noteTextView = nil;
    }
    if (_subtitleLabel) {
        [_subtitleLabel removeFromSuperview];
        _subtitleLabel = nil;
    }
    if (_priorityStartRatingView) {
        [_priorityStartRatingView removeFromSuperview];
        _priorityStartRatingView = nil;
    }
    if (_simulationDescribeLabel) {
        [_simulationDescribeLabel removeFromSuperview];
        _simulationDescribeLabel = nil;
    }
}

- (void)setModelMsgDic:(NSDictionary *)modelMsgDic{
    _modelMsgDic = modelMsgDic;

    [self emptyControl];
    
    WeakSelf;
    switch (weakSelf.type) {
        case AxcEventTypeFourElements:// 事件四要素
            weakSelf.titleString = [modelMsgDic objectForKey:kElementsTitle];
            weakSelf.subtitleString = [modelMsgDic objectForKey:kElementsContent];
            weakSelf.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 带箭头

            break;
        case AxcEventTypeSimulationDescribe: // 事件模拟描述
            weakSelf.simulationDescribeLabel.attributedText = [modelMsgDic objectForKey:kElementsContent];
            break;
        case AxcEventTypePriority:// 事件优先级
        {
            CGFloat priority = [[modelMsgDic objectForKey:kElementsContent] floatValue];
            weakSelf.priorityStartRatingView.axcUI_value = priority;
        }break;
        case AxcEventTypeNoteString:// 事件备注
        {
            weakSelf.noteTextView.text = [modelMsgDic objectForKey:kElementsContent];
        }break;
        case AxcEventTypeCreateDate:// 事件创建时间
        {
            weakSelf.titleString = [modelMsgDic objectForKey:kElementsContent];
            weakSelf.subtitleString = [AMUC_Obj getTimeInvervalFromDateString:[modelMsgDic objectForKey:kElementsContent]
                                                             andFormateString:BaseDateFormat];
            weakSelf.subtitleLabel.textColor = [UIColor lightGrayColor];
        }break;
            
        default:  break;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.textLabel.text = _titleString;
    
    self.textLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSubtitleString:(NSString *)subtitleString{
    _subtitleString = subtitleString;
    self.subtitleLabel.text = _subtitleString;
    self.subtitleLabel.axcUI_Width = [self.subtitleString AxcUI_widthWithStringFont:_subtitleLabel.font];
}


#pragma mark - 回调
- (void)starRatingViewDidChangeValue:(AxcUI_StarRatingView *)sender { // 数值
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePriority:)]) {
        [self.delegate changePriority:sender.axcUI_value]; // 回调数值
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    // 判断代理是否正确
    if ([self.tableView.delegate conformsToProtocol:@protocol(AxcEventChangeTableViewCellDelegate)]) {
        
        id<AxcEventChangeTableViewCellDelegate> delegate = (id<AxcEventChangeTableViewCellDelegate>)self.tableView.delegate;
        
        CGFloat newHeight = [self computedTextHeightWithTextView:self.noteTextView];
        CGFloat oldHeight = [delegate tableView:self.tableView heightForRowAtIndexPath:self.cellIndexPath];
        if (fabs(newHeight - oldHeight) > 0.01) {
            if (newHeight > oldHeight) { // 大于之前的默认值才更新
                // 回调更新主控制器的数据
                if ([delegate respondsToSelector:@selector(changeTextViewCellHeight:IndexPath:)]) {
                    [delegate changeTextViewCellHeight:newHeight IndexPath:self.cellIndexPath];
                }
            }
            // 刷新高度但是不关闭键盘
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeNoteString:)]) {
            [self.delegate changeNoteString:textView.text]; // 回调备注
        }
    }
}

- (CGFloat)computedTextHeightWithTextView:(UITextView *)textView{
    return [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)].height + TextViewMarginValue;
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}


#pragma mark - 懒加载
- (NSIndexPath *)cellIndexPath{
    return [self.tableView indexPathForCell:self];
}

- (UITextView *)noteTextView{
    if (!_noteTextView) {
        _noteTextView = [[UITextView alloc] init];
        _noteTextView.delegate = self;
        _noteTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        _noteTextView.layer.masksToBounds = YES;
        _noteTextView.layer.cornerRadius = 5;
        _noteTextView.layer.borderWidth = 1;
        _noteTextView.layer.borderColor = [[UIColor AxcUI_CloudColor] CGColor];
        _noteTextView.scrollEnabled = NO;
        
        [self addSubview:_noteTextView];
        [_noteTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(TextViewFrameMargin);
            make.left.mas_equalTo(TextViewFrameMargin);
            make.right.mas_equalTo(-TextViewFrameMargin);
            make.bottom.mas_equalTo(-TextViewFrameMargin);
        }];
    }
    return _noteTextView;
}

- (AxcUI_StarRatingView *)priorityStartRatingView{
    if (!_priorityStartRatingView) {
        _priorityStartRatingView = [[AxcUI_StarRatingView alloc] init];
        
        _priorityStartRatingView.axcUI_maximumValue = MaxPriority;
        _priorityStartRatingView.axcUI_minimumValue = 0;
        _priorityStartRatingView.tintColor = Axc_ThemeColor;
        [_priorityStartRatingView addTarget:self action:@selector(starRatingViewDidChangeValue:) forControlEvents:UIControlEventValueChanged];

        [self addSubview:_priorityStartRatingView];
        [_priorityStartRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _priorityStartRatingView;
}

- (UILabel *)simulationDescribeLabel{
    if (!_simulationDescribeLabel) {
        _simulationDescribeLabel = [[UILabel alloc] init];
        _simulationDescribeLabel.textAlignment = NSTextAlignmentCenter;
        _simulationDescribeLabel.numberOfLines = 0;
        [self addSubview:_simulationDescribeLabel];
        [_simulationDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            AxcWholeFrameLayout;
        }];
    }
    return _simulationDescribeLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor AxcUI_PeterRiverColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
            make.centerY.mas_equalTo(0);
//            make.width.mas_equalTo();
        }];
    }
    return _subtitleLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

