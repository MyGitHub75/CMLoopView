//
//  ViewController.m
//  CMLoopView
//
//  Created by pro on 2017/6/12.
//  Copyright © 2017年 Chaim Chen. All rights reserved.
//

#import "ViewController.h"
#import "CMLoopView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    
//    CMLoopView *loopView = [CMLoopView loopViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/4) imageNames:@[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg"]];
    CMLoopView *loopView = [CMLoopView loopViewWithFrame:CGRectMake(0, 0, 375, 200) delegate:nil placeholderImage:[UIImage imageNamed:@"timg.jpeg"]];
    loopView.imageURLStringsGroup  = @[@"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2gb9f9j20da0gm40t.jpg",
                                       @"https://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2hj86bj20gk0gk414.jpg",
                                       @"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2izm5gj20dt0gltbe.jpg",
                                       @"http://ww4.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2k7k1hj20er0glabv.jpg",
                                       @"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2leqhxj20et0gkdht.jpg",
                                       @"http://ww4.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2mdjq0j20d60ghtaz.jpg",
                                       @"http://ww1.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2o49cwj20d80gj769.jpg",
                                       @"http://ww3.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2qjocsg205706ikjl.gif",
                                       @"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2ymkhxg206i0847wi.gif"];
    [self.view addSubview:loopView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
