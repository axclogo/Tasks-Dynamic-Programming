//
//  AxcRecordTableViewCell.m
//  任务动态规划
//
//  Created by Axc on 2017/10/14.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcRecordTableViewCell.h"

#import "AxcDatabaseManagement.h"

@implementation AxcRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    WEAK_SELF;
    CGFloat margin = 10;
    CGFloat bottomMargin = 5;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(bottomMargin + 3);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.bottom.mas_equalTo(-bottomMargin);
        make.right.mas_equalTo(weakSelf.mas_centerX).offset(0);
    }];
    
    [self.rightSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-margin);
        make.bottom.mas_equalTo(-bottomMargin);
        make.left.mas_equalTo(weakSelf.mas_centerX).offset(0);
    }];
  

}

- (void)setDataDictionary:(NSDictionary *)dataDictionary{
    _dataDictionary = dataDictionary;
    
    self.titleLabel.textColor = Axc_ThemeColor;
    self.titleLabel.text = [_dataDictionary objectForKey:kAlreadyPlanningEventListTitle];
    
    NSString *dateString = [_dataDictionary objectForKey:kAlreadyPlanningEventListDate];
    self.subTitleLabel.text = dateString;
    
    self.rightSubTitleLabel.text = [AMUC_Obj getTimeInvervalFromDateString:dateString andFormateString:BaseDateFormat];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
