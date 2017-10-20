//
//  AxcBaseMenuController.h
//  任务动态规划
//
//  Created by Axc on 2017/10/20.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AxcBaseMenuController : UIMenuController


@property(nonatomic, strong)id obj;

+ (AxcBaseMenuController *)sharedMenuController;



@end
