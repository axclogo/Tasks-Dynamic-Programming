//
//  AxcEventChangeHeaderView.h
//  任务动态规划
//
//  Created by Axc on 2017/10/13.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AxcEventChangeHeaderViewDelegate <NSObject >

// 标题改变时候
- (void)titleDidChange:(NSString *)newTitle;

@end

@interface AxcEventChangeHeaderView : UIView <UITextFieldDelegate>

@property(nonatomic, strong)AxcBaseTextFiled *titleTextField;

@property(nonatomic, strong)NSString *title;

@property(nonatomic, weak)id <AxcEventChangeHeaderViewDelegate> delegate;

@end
