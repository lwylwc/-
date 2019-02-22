//
//  wy_dylikeAnnimationView.h
//  仿斗音动画的实现
//
//  Created by Apple on 22/2/19.
//  Copyright © 2019年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wy_dylikeAnnimationView : UIView
//点赞前图片
@property (nonatomic, strong) UIImageView *likeBefore;
//点赞后图片
@property (nonatomic, strong) UIImageView *likeAfter;
//点赞时长
@property (nonatomic, assign) CGFloat     likeDuration;
//点赞按钮填充颜色
@property (nonatomic, strong) UIColor     *zanFillColor;
@end
