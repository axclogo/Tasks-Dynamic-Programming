//
//  AxcNavBaseView.h
//  任务动态规划
//
//  Created by Axc on 2017/9/29.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AxcEventModel.h"

@interface AxcNavBaseView : UIView


@property(nonatomic, strong)AxcUI_Label *titleLabel;


- (AxcUI_Label *)createcontentTitleLabelWithText:(NSString *)text;


@end
