//
//  AxcRecordPlaceholderView.h
//  任务动态规划
//
//  Created by Axc on 2017/10/14.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClikedBlock)(void);

@interface AxcRecordPlaceholderView : UIView

@property(nonatomic, strong)ClikedBlock clickgoToAddEventBtnBlock;


@end
