//
//  AxcBottomBannerThirdView.m
//  任务动态规划
//
//  Created by Axc on 2017/10/19.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBottomBannerThirdView.h"

#define TagViewMargin 5

@implementation AxcBottomBannerThirdView


- (instancetype)init{
    if (self == [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self.tagTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-5);
    }];
    
}




#pragma mark - SET
- (void)setCommonlyUsedEventArray:(NSArray<AxcEventModel *> *)commonlyUsedEventArray{
    _commonlyUsedEventArray = commonlyUsedEventArray;
    // 移除所有
    [self.tagTextView AxcUI_removeAllTags];
    WEAK_SELF; // 开始添加
    [_commonlyUsedEventArray enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AxcTagTextConfig *config = [AxcTagTextConfig new];
        config.axcUI_tagTextColor = [UIColor whiteColor];   // 原本字体颜色
        config.axcUI_tagSelectedTextColor = [UIColor whiteColor]; // 选中字体颜色
        
        config.axcUI_tagBackgroundColor = Axc_ThemeColorTwoCollocation; // 原本背景色
        config.axcUI_tagSelectedBackgroundColor = Axc_ThemeColor; // 选中背景色
        
        config.axcUI_tagTextFont = [UIFont systemFontOfSize:12]; // 字体大小
        if (obj.priority) { // 如果有优先级存在则添加阴影
            // 阴影设置
            config.axcUI_tagShadowColor = [UIColor blackColor];
            config.axcUI_tagShadowOffset = CGSizeMake(2, 2);
            config.axcUI_tagShadowRadius = 2;
            config.axcUI_tagShadowOpacity = 0.3f;
            // 优先级的背景
            config.axcUI_tagBackgroundColor = [AMUC_Obj getPriorityColorWithPriority:obj.priority]; // 原本背景色
            config.axcUI_tagSelectedBackgroundColor = Axc_ThemeColor; // 选中背景色
        }
        [weakSelf.tagTextView AxcUI_addTag:obj.name withConfig:config];
    }];
    // 刷新数据
    [self.tagTextView AxcUI_reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray<NSString *> *)eventTagsTextArray{
    if (!_eventTagsTextArray) {
        _eventTagsTextArray = [NSMutableArray array];
    }
    return _eventTagsTextArray;
}

- (AxcUI_TagTextView *)tagTextView{
    if (!_tagTextView) {
        _tagTextView = [[AxcUI_TagTextView alloc] init];
        _tagTextView.axcUI_Y = 100;
        
        _tagTextView.axcUI_tagTextViewDelegate = self;
        _tagTextView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_tagTextView];
    }
    return _tagTextView;
}


@end
