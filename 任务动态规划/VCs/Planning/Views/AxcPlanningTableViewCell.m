//
//  AxcPlanningTableViewCell.m
//  任务动态规划
//
//  Created by Axc on 2017/10/11.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcPlanningTableViewCell.h"

#import "AMUC_Obj.h"

@implementation AxcPlanningTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    __weak typeof(self) WeakSelf = self;

    [self.eventAddDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(WeakSelf.eventDescribeLabel.mas_bottom).offset(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AxcEventModel *)model{
    _model = model;
    
    self.eventNameLabel.text = _model.name;
    self.eventDescribeLabel.attributedText = [AMUC_Obj simulateEventDescriptionWithModel:_model
                                                                          PredicateColor:[UIColor AxcUI_BelizeHoleColor]];
    self.eventAddDateLabel.text = _model.addDate;
    self.eventAddDateLabel.text = [AMUC_Obj getTimeInvervalFromDateString:_model.addDate andFormateString:BaseDateFormat];
    self.eventAddDateLabel.axcUI_Width = [self.eventAddDateLabel.text AxcUI_widthWithStringFont:self.eventAddDateLabel.font];
    
    CGFloat priority = _model.priority;
    self.leftColorView.hidden = !priority; // 优先级没有则不显示
    if (priority <= MaxPriority/2) { // 优先级为最大值的一半
        self.leftColorView.backgroundColor = [UIColor AxcUI_EmeraldColor];
    }else{ // 大于一半
        self.leftColorView.backgroundColor = SysRedColor;
    }
    
    
    
}


@end
