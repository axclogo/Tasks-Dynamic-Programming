

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

- (void)setModelMsgDic:(NSDictionary *)modelMsgDic{
    _modelMsgDic = modelMsgDic;
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
            self.priorityStartRatingView.axcUI_value = priority;
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

- (void)starRatingViewDidChangeValue:(AxcUI_StarRatingView *)sender { // 数值
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePriority:)]) {
        [self.delegate changePriority:sender.axcUI_value]; // 回调数值
    }
}

#pragma mark - 懒加载
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

