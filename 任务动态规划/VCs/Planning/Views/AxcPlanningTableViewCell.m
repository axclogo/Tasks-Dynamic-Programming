//
//  AxcPlanningTableViewCell.m
//  任务动态规划
//
//  Created by Axc on 2017/10/11.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcPlanningTableViewCell.h"


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


- (void)setMenuItemsTitle:(NSArray<NSString *> *)menuItemsTitle{
    _menuItemsTitle = menuItemsTitle;
    if (_menuItemsTitle.count) {
        //对于cell设置长按点击事件
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPressGestureRecognizer];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        //定义菜单
        AxcBaseMenuController *menu = [AxcBaseMenuController sharedMenuController];
        
        NSMutableArray *items = [NSMutableArray array];
        [self.menuItemsTitle enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIMenuItem *menuItem = [[UIMenuItem alloc] init];
            menuItem.title = obj;
            // 标记到方法名
            NSString *SelectorString = [NSString stringWithFormat:@"AxcCellMenuControllerAction_%ld:",idx];
            SEL faSelector = NSSelectorFromString(SelectorString);
            menuItem.action = faSelector;
            [items addObject:menuItem];
        }];
        // 设置转移对象
        menu.obj = self;
        //设定菜单显示的区域，显示再Rect的最上面居中
        [menu setTargetRect:self.frame inView:self.tableView];
        [menu setMenuItems:items];
        [menu setMenuVisible:YES animated:YES];
    }
}



-(BOOL)canBecomeFirstResponder{
    return YES;
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
    // 根据优先级获取颜色
    self.leftColorView.backgroundColor = [AMUC_Obj getPriorityColorWithPriority:priority];

    
    
    
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}


@end
