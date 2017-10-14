//
//  AxcBannerView.m
//  任务动态规划
//
//  Created by Axc on 2017/9/28.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBottomBannerView.h"
#import "AxcBottomBannerCollectionViewCell.h"

#import "AxcBottomBannerFirstView.h"


#define AXCFOOTER_WIDTH 64


@interface AxcBottomBannerView ()
<UICollectionViewDelegate
,UICollectionViewDataSource
,UICollectionViewDelegateFlowLayout
,AxcBottomBannerFirstViewDelegate

>

// 最下方的BannerView
@property (nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong)AxcBannerFooter *footer;

// 导航条
@property(nonatomic, strong)UIView *NavBarView;
@property(nonatomic, strong)AxcUI_Label *NavBarLabel;
// 导航条Title
@property(nonatomic, strong)NSArray *NavBarTitleArray;

@property(nonatomic, strong)NSArray <UIView *>*cellViewsArray;
// 第一个View
@property(nonatomic, strong)AxcBottomBannerFirstView *firstView;

@end

static NSString *banner_footer = @"banner_footer";

@implementation AxcBottomBannerView


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self scrollViewDidEndDecelerating:self.collectionView];
}


#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AxcBottomBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axc" forIndexPath:indexPath];
    
    if (indexPath.row < self.cellViewsArray.count) {
        UIView *contentView = self.cellViewsArray[indexPath.row];
        [cell.axcContentView addSubview: contentView];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }else{
        [cell.axcContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath{
    UICollectionReusableView *footer = nil;
    if(kind == UICollectionElementKindSectionFooter){
        footer = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                       withReuseIdentifier:banner_footer
                                                              forIndexPath:theIndexPath];
        self.footer = (AxcBannerFooter *)footer;
        // 配置footer的提示语
        self.footer.idleTitle = @"拖动进入下一页";
        self.footer.triggerTitle = @"释放进入下一页";
    }
    return footer;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(kScreenWidth, kScreenWidth/2);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self endEditing:YES];
    static CGFloat lastOffset;
    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * 2));
    // footer的动画
    if (footerDisplayOffset > 0){
        // 开始出现footer
        if (footerDisplayOffset > AXCFOOTER_WIDTH) {
            if (lastOffset > 0) return;
            self.footer.state = AxcBannerFooterStateTrigger;
        } else {
            if (lastOffset < 0) return;
            self.footer.state = AxcBannerFooterStateIdle;
        }
        lastOffset = footerDisplayOffset - AXCFOOTER_WIDTH;
    }
    
}

// 设置标题
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    static NSInteger lastPage = 100;
    NSInteger page = scrollView.contentOffset.x / kScreenWidth;
    self.NavBarLabel.text = self.NavBarTitleArray[page];
    if (lastPage != page) {
        self.NavBarLabel.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.NavBarLabel.alpha = 1;
        }];
        lastPage = page;
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * 2));
    // 通知footer代理
    if (footerDisplayOffset > AXCFOOTER_WIDTH) {
        if ([self.delegate respondsToSelector:@selector(AxcUI_bottomBannerViewFooterDidTrigger)]) {
            [self.delegate AxcUI_bottomBannerViewFooterDidTrigger];
        }
    }
    
}

// textFiled编辑中
- (void)eventTextFiledTextEding{
    [self clickPickOKBtn];
}

// 事件被创建完成后
- (void)clickPickOKBtn{
    NSString *eventDescription = @"";
    NSString *nameStr = self.firstView.eventTitleTextFiled.text;
    if (!nameStr.length) {
        self.firstView.eventDescriptionLabel.text = eventDescription;
        return;
    }
    self.eventModel.name = nameStr;
    
    self.firstView.eventDescriptionLabel.attributedText = [AMUC_Obj simulateEventDescriptionWithModel:self.eventModel];

}



- (void)Axc_click_eventFourElementsBtn{
    if (self.firstView.eventTitleTextFiled.text.length) {
        [self endEditing:YES];
        [self.delegate AxcUI_click_eventFourElementsBtn:self.firstView.eventTitleTextFiled.text];
    }else{
        [AxcUI_Toast AxcUI_showCenterWithText:@"请先输入事件名称"];
    }
}

- (void)Axc_click_addEventBtn{
    if (self.eventModel.name.length &&
        self.eventModel.triggerObject.name.length &&
        self.eventModel.triggerLocation.name.length &&
        self.eventModel.performObject.name.length &&
        self.eventModel.performLocation.name.length) {
        [self.firstView.eventTitleTextFiled resignFirstResponder];
        [self.delegate AxcUI_click_addEventModel:self.firstView.eventTitleTextFiled.text];
    }else{
        [AxcUI_Toast AxcUI_showCenterWithText:@"请设置事件的各项必填属性！"];
    }
}

#pragma mark - 懒加载

- (NSArray *)NavBarTitleArray{
    if (!_NavBarTitleArray) {
        _NavBarTitleArray = @[@"设置事件主属性",@"设置事件非必填项",@"其他"];
    }
    return _NavBarTitleArray;
}

- (AxcUI_Label *)NavBarLabel{
    if (!_NavBarLabel) {
        _NavBarLabel = [[AxcUI_Label alloc] init];
        _NavBarLabel.backgroundColor = [UIColor clearColor];
        _NavBarLabel.textColor = [UIColor AxcUI_ConcreteColor];
        _NavBarLabel.font = [UIFont systemFontOfSize:15];
        _NavBarLabel.textAlignment =NSTextAlignmentCenter;
        
        [self.NavBarView addSubview:_NavBarLabel];
        
        [_NavBarLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _NavBarLabel;
}

- (UIView *)NavBarView{
    if (!_NavBarView) {
        _NavBarView = [[UIView alloc] init];
        _NavBarView.backgroundColor = [UIColor whiteColor];

        _NavBarView.layer.shadowColor = [UIColor blackColor].CGColor;
        _NavBarView.layer.shadowOffset = CGSizeMake(1,0);
        _NavBarView.layer.shadowOpacity = 0.7;
        _NavBarView.layer.shadowRadius = 2;
        
        [self addSubview:_NavBarView];

        [_NavBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
    }
    return _NavBarView;
}

- (AxcEventModel *)eventModel{
    if (!_eventModel) {
        _eventModel = [[AxcEventModel alloc] init];
    }
    return _eventModel;
}

- (NSArray <UIView *>*)cellViewsArray{
    if (!_cellViewsArray) {
        _cellViewsArray = @[self.firstView];
    }
    return _cellViewsArray;
}

- (AxcBottomBannerFirstView *)firstView{
    if (!_firstView) {
        _firstView = [[AxcBottomBannerFirstView alloc] init];
        _firstView.delegate = self;
        [_firstView.eventFourElementsBtn addTarget:self
                                            action:@selector(Axc_click_eventFourElementsBtn)
                                  forControlEvents:UIControlEventTouchUpInside];
        [_firstView.addEventBtn addTarget:self action:@selector(Axc_click_addEventBtn)
                         forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.footerReferenceSize = CGSizeMake(AXCFOOTER_WIDTH, self.frame.size.height);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        [_collectionView.collectionViewLayout invalidateLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor AxcUI_CloudColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"AxcBottomBannerCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"axc"];
        // 注册 \ 配置footer
        [_collectionView registerClass:[AxcBannerFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:banner_footer];
        
        [self addSubview:self.collectionView];
    }
    return  _collectionView;
}

@end
