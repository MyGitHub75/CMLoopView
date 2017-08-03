//
//  CMLoopView.h
//  CMLoopView
//
//  Created by pro on 2017/6/12.
//  Copyright © 2017年 Chaim Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLoopView;

@protocol CMLoopViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)loopView:(CMLoopView *)loopView didSelectItemAtIndex:(NSInteger)index;

@end

@interface CMLoopView : UIView

/** 本地图片轮播初始化方式*/
+ (instancetype)loopViewWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;

/** 网络初始轮播图*/
+ (instancetype)loopViewWithFrame:(CGRect)frame delegate:(id<CMLoopViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

@property (nonatomic, weak) id<CMLoopViewDelegate> delegate;

/** 本地图片数据源 数组 */
@property (nonatomic, strong) NSArray *localizationImageNames;

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end
