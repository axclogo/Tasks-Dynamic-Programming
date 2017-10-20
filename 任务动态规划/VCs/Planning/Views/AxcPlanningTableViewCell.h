//
//  AxcPlanningTableViewCell.h
//  任务动态规划
//
//  Created by Axc on 2017/10/11.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AxcEventModel.h"

@class AxcPlanningTableViewCell;


@interface AxcPlanningTableViewCell : UITableViewCell

@property(nonatomic, strong)AxcEventModel *model;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventAddDateLabel;
@property (weak, nonatomic) IBOutlet UIView *leftColorView;


@property(nonatomic, strong)NSArray <NSString *>*menuItemsTitle;


@end
