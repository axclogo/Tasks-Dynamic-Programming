//
//  AxcBaseLabel.m
//  任务动态规划
//
//  Created by Axc on 2017/10/10.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseLabel.h"

@implementation AxcBaseLabel

- (instancetype)init{
    if (self == [super init]) {
        for (NSString *keyStr in self.KVO_KeyArray) {
            [self addObserver:self forKeyPath:keyStr
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary *)change
                       context:(nullable void *)context{
    if ([keyPath isEqualToString:@"text"]) { // 当被赋值时
        // 进行大小改写
        self.axcUI_Size = [self.text AxcUI_rectWithStringFont:self.font.pointSize].size;
    }
}
- (void)dealloc{
    for (NSString *keyStr in self.KVO_KeyArray) {
        NSLog(@"已销毁标题为['%@']的Label，成功移除观察者：%@的键值",self.text,keyStr);
        [self removeObserver:self forKeyPath:keyStr];
    }
}


- (NSArray *)KVO_KeyArray{
    if (!_KVO_KeyArray) {
        _KVO_KeyArray = @[@"text"];
    }
    return _KVO_KeyArray;
}

@end
