//
//  CMLoopView.m
//  CMLoopView
//
//  Created by pro on 2017/6/12.
//  Copyright © 2017年 Chaim Chen. All rights reserved.
//


#import "CMLoopView.h"
#import "UIImageView+WebCache.h"

#define kPageH 20

@interface CMLoopView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *currentImages;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *imagePathsGroup;

@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图
@end

@implementation CMLoopView

+(instancetype)loopViewWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames{
    CMLoopView *loopView = [[self alloc]initWithFrame:frame];
    loopView.localizationImageNames = imageNames;
    return loopView;
}


+(instancetype)loopViewWithFrame:(CGRect)frame delegate:(id<CMLoopViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage{
    CMLoopView *loopView = [[self alloc]initWithFrame:frame];
    loopView.placeholderImage = placeholderImage;
    loopView.delegate = delegate;
    return loopView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor whiteColor];
        _autoScroll = YES;
        _autoScrollTimeInterval = 2.0f;
        ;
        [self addScrollView];
    }
    return self;
}


#pragma mark - public properties

-(void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup{
    _imageURLStringsGroup = imageURLStringsGroup;
    
    self.imagePathsGroup = [imageURLStringsGroup copy];
}


-(void)setLocalizationImageNames:(NSArray *)localizationImageNames{
    _localizationImageNames = localizationImageNames;
    
    self.imagePathsGroup = [localizationImageNames copy];
}

-(void)setImagePathsGroup:(NSArray *)imagePathsGroup{
    _imagePathsGroup = imagePathsGroup;
    
//    if (self.backgroundImageView) {
//        [self.backgroundImageView removeFromSuperview];
//    }
    
    if (imagePathsGroup.count >= 1) {
        self.scrollView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
        [self refreshImages];
    } else {
        self.scrollView.scrollEnabled = NO;
    }
    
    [self addPageControl];
    
}


-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self stopAutoLoop];
    
    if (_autoScroll) {
        [self autoLoop];
    }
}

-(void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:_autoScroll];
}

#pragma mark - Public Methods

-(void)stopAutoLoop{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
}

-(void)autoLoop{
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:_autoScrollTimeInterval];
}

-(void) autoPlayToNextPage {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0)animated:YES];
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:_autoScrollTimeInterval];
    
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage{
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        bgImageView.backgroundColor = [UIColor greenColor];
        //bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:self.scrollView];
        self.backgroundImageView = bgImageView;
    }
    self.backgroundImageView.image = placeholderImage;
}

-(void)addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:scrollView.bounds];
        imageView.frame = CGRectMake(i*width, 0, width, height);
        [scrollView addSubview:imageView];
    }
    scrollView.scrollsToTop = NO;
    scrollView.contentSize = CGSizeMake(3*width, height);
    scrollView.contentOffset = CGPointMake(width, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [scrollView addGestureRecognizer:tap];
    
    
    [self addSubview:scrollView];
    
    _scrollView = scrollView;
}

-(void)addPageControl{
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, height-kPageH, width, kPageH)];
    bgView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, width, kPageH)];
    pageControl.numberOfPages = self.imagePathsGroup.count;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    _pageControl = pageControl;
    [bgView addSubview:self.pageControl];
    [self addSubview:bgView];
}


#pragma mark - delegate
- (void)singleTapped:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(loopView:didSelectItemAtIndex:)]) {
        [self.delegate loopView:self didSelectItemAtIndex:_currentPage];
    }
}

-(NSMutableArray *)currentImages{
    if (_currentImages == nil) {
        _currentImages = [NSMutableArray array];
    }
    
    [_currentImages removeAllObjects];
    NSInteger count = self.imagePathsGroup.count;
    if (!count) {
        return nil;
    }
    int i = (int)(_currentPage + count - 1)%count;
    [_currentImages addObject:self.imagePathsGroup[i]];
    
    [_currentImages addObject:self.imagePathsGroup[_currentPage]];
    
    i = (int)(_currentPage + 1)%count;
    [_currentImages addObject:self.imagePathsGroup[i]];
    return _currentImages;
    
}

-(void)refreshImages{
    CGFloat width = self.frame.size.width;
    
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIImageView *imageView = (UIImageView *)self.scrollView.subviews[i];
        imageView.image = [UIImage imageNamed:self.currentImages[i]];
        if ([self.currentImages[i]hasPrefix:@"http"]||[self.currentImages[i]hasPrefix:@"https"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.currentImages[i]] placeholderImage:self.placeholderImage];
        }
    }
    [self.scrollView setContentOffset:CGPointMake(width, 0)];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = self.frame.size.width;
    if (x >= 2*width) {
        _currentPage = (++_currentPage) % self.imagePathsGroup.count;
        
        _pageControl.currentPage = _currentPage;
        
        [self refreshImages];
    }
    
    if (x <= 0) {
        _currentPage = (int)(_currentPage + self.imagePathsGroup.count - 1)%self.imagePathsGroup.count;
        
        _pageControl.currentPage = _currentPage;
        
        [self refreshImages];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}

@end
