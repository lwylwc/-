//
//  ViewController.m
//  仿斗音动画的实现
//
//  Created by Apple on 22/2/19.
//  Copyright © 2019年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "wy_dylikeAnnimationView.h"
@interface ViewController ()
@property (nonatomic, strong) wy_dylikeAnnimationView *likeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat cx = 5; //倍数
    CGFloat width = 50 * cx;
    CGFloat height = 45 * cx;
 self.likeView = [[wy_dylikeAnnimationView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    self.likeView.backgroundColor = [UIColor blueColor];
    
    self.likeView.likeDuration = 3;
    self.likeView.zanFillColor = [UIColor redColor];
    [self.view addSubview:self.likeView];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
