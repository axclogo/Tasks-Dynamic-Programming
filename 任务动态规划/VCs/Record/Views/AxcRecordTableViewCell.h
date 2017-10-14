//
//  AxcRecordTableViewCell.h
//  任务动态规划
//
//  Created by Axc on 2017/10/14.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AxcRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSubTitleLabel;

@property(nonatomic, strong)NSDictionary *dataDictionary;

@end
