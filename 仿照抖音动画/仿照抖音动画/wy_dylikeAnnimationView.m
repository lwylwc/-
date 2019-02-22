//
//  wy_dylikeAnnimationView.m
//  仿斗音动画的实现
//
//  Created by Apple on 22/2/19.
//  Copyright © 2019年 Apple. All rights reserved.
//

#import "wy_dylikeAnnimationView.h"
#define WYFavoriteViewLikeBeforeTag 1 //点赞
#define WYFavoriteViewLikeAfterTag  2 //取消点赞
@interface wy_dylikeAnnimationView ()<UIGestureRecognizerDelegate>

@end
@implementation wy_dylikeAnnimationView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //点赞前图片的图片
        _likeBefore = [[UIImageView alloc]init];
        //设置图片模式
        _likeBefore.contentMode = UIViewContentModeCenter;
        //设施图片
        _likeBefore.image = [UIImage imageNamed:@"icon_home_like_before"];
        //开启图片的用户交互
        _likeBefore.userInteractionEnabled = YES;
        //绑定是否点赞
        _likeBefore.tag = WYFavoriteViewLikeBeforeTag;
        NSLog(@"测试");
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(handleGesture:)];
        tap.delegate = self;
        
        [_likeBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeBefore];
        
        
        //创建点赞后的图片
        _likeAfter = [[UIImageView alloc]init];
        _likeAfter.contentMode = UIViewContentModeCenter;
        _likeAfter.image = [UIImage imageNamed:@"icon_home_like_after"];
        _likeAfter.userInteractionEnabled = YES;
        _likeAfter.tag = WYFavoriteViewLikeAfterTag;
        [_likeAfter setHidden:YES];
        
        [_likeAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeAfter];
        
        
    }
    return self;
}
#pragma mark 布局子控件位置
-(void)layoutSubviews{
    _likeBefore.frame = self.bounds;
    _likeAfter.frame = self.bounds;
    
    
}
#pragma mark 添加手势
- (void)handleGesture:(UITapGestureRecognizer *)sender{
    //看下触摸的点在哪个view上
    //  CGPoint point = [sender locationInView:self];
    switch (sender.view.tag) {
        case WYFavoriteViewLikeBeforeTag: {
            //开始动画(点赞)
            [self startLikeAnim:YES];
            break;
        }
        case WYFavoriteViewLikeAfterTag: {
            //开始动画(取消点赞)
            [self startLikeAnim:NO];
            break;
        }
    }
    
    
    
}
-(void)startLikeAnim:(BOOL)isLike{
    //在动画执行过程中关闭用户交互
    _likeBefore.userInteractionEnabled = NO;
    _likeAfter.userInteractionEnabled = NO;
    //判断是否是点赞过的
    if (isLike) {
        //设定一个长度
        CGFloat length = 30;
        //设置动画时间
        CGFloat duration = self.likeDuration > 0? self.likeDuration :0.5f;
        //循环添加6个3角型
        for (int i =0; i< 6; i++) {
            //CAShapeLayer 使用专用图层进行绘制而不是用bitmap进行绘制性能会好很多详细请看drawRect内存恶鬼
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            
            //设置layer position点默认为父视图的的(0,0),position的这个点等于他自身的center所在的位置 imageview的center 定位到视图的的中间
            layer.position = _likeBefore.center;
            //将锚点定位到position
            layer.anchorPoint = layer.position;
            //设置点赞按钮的填充颜色
            layer.fillColor = self.zanFillColor == nil ? [UIColor redColor].CGColor: self.zanFillColor.CGColor;
            //开启一个UIBezierPath
            UIBezierPath *startPath = [UIBezierPath bezierPath];
            //添加起始点(倒三角左边的点,说明下指的是第一个倒三角左边的点,后面会以此基础的倒立的三角旋转出6个三角形出来)
            //此时坐标系以center 为中心
            [startPath moveToPoint:CGPointMake(-2, -length)];
            
            [startPath addLineToPoint:CGPointMake(2, -length)];
            [startPath addLineToPoint:CGPointMake(0, 0)];
            //填充会自动关闭路径不用写也行
            //[startPath closePath]
            layer.path = startPath.CGPath;
            //旋转添加6个三角形
            
            
            layer.transform = CATransform3DMakeRotation(M_PI / 3.0f * i, 0.0, 0.0, 1.0);
            [self.layer addSublayer:layer];
            
            //创建一个组动画同时执行2个baseAnimation动画
            CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
            
            //是否在播放完成后移除。这是一个非常重要的属性，有的时候我们希望动画播放完成，但是保留最终的播放效果是，这个属性一定要改为NO，否则无效。
            group.removedOnCompletion = NO;
            
            //因为我们设置了其动画的时间函数为CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)。时间函数通过修改持续时间的分数来控制动画的速度。
            //这里使用了淡入淡出 (kCAMediaTimingFunctionEaseInEaseOut)它有很多枚举值自己去查可以了
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            // fillMode，kCAFillModeForwards是播放结束后的状态不会要会到播放前的效果
            group.fillMode = kCAFillModeForwards;
            //执行动画的时间
            group.duration = duration;
            
            
            //创建一个基本动画 放大
            CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            
            scaleAnim.fromValue = @(0.0);
            scaleAnim.toValue = @(1.0);
            //            //动画时间
            scaleAnim.duration = duration * 0.2;
            //            scaleAnim.removedOnCompletion = NO;   这2行代码保留动画效果
            //            scaleAnim.fillMode = kCAFillModeForwards;
            // [layer addAnimation:scaleAnim forKey:@"scaleAnimation"];
            
            //创建一个路径动画
            UIBezierPath *endPath = [UIBezierPath bezierPath];
            //相当于把三角形的顶点移动底边一样移成了一条线 由三角型变成了一条线
            [endPath moveToPoint:CGPointMake(-2, -length)];
            [endPath addLineToPoint:CGPointMake(2, -length)];
            [endPath addLineToPoint:CGPointMake(0, -length)];
            //            [endPath moveToPoint:CGPointMake(-2, -length-length)];
            //            [endPath addLineToPoint:CGPointMake(2, -length-length)];
            //            [endPath addLineToPoint:CGPointMake(0, -length-length)];
            
            
            //创建一个路径动画
            CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
            //从原本的三角型位置
            pathAnim.fromValue = (__bridge id)layer.path;
            //一天直线的位置
            pathAnim.toValue = (__bridge id)endPath.CGPath;
            
            pathAnim.beginTime = duration * 0.2f;
            pathAnim.duration = duration * 0.8f;
            //   pathAnim = NO;   这2行代码保留动画效果
            //  pathAnim.fillMode = kCAFillModeForwards;(太麻烦了设置动画组)
            // [layer addAnimation:pathAnim forKey:@"pathAnimation"];
            //将CABasicAnimation添加到动画组中
            [group setAnimations:@[pathAnim]];
            [layer addAnimation:group forKey:@"GroupAnimation"];
            
        }
        
        [_likeAfter setHidden:NO];
        // _likeAfter.alpha = 0.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI/3*2), 0.1f, 0.1f);
        /*
         效果样式太单一
         */
        
        //        [UIView animateWithDuration:0.4f animations:^{
        //            self.likeBefore.alpha = 0.0f;
        //            self.likeAfter.alpha = 1.0f;
        //            self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
        //        } completion:^(BOOL finished) {
        //            self.likeBefore.alpha = 1.0f;
        //            self.likeBefore.userInteractionEnabled = YES;
        //            self.likeAfter.userInteractionEnabled = YES;
        //        }];
        /*
         duration 动画时间
         delay 延时时间
         usingSpringWithDamping dampingRatio阻尼效果
         initialSpringVelocity velocity初速度
         options 动画的效果
         animations 动画完成是的状态
         completion动画完成后做的操作
         */
        /*
         //时间曲线函数，UIViewAnimationOptionCurveEaseInOut由快到慢(快入缓出)多种效果自己去试
         */
        [UIView animateWithDuration:0.4f
                              delay:0.2f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.8f
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.likeBefore.alpha = 0.0f;
                                self.likeAfter.alpha = 1.0f;
                                self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                                self.likeBefore.alpha = 1.0f;
                                self.likeBefore.userInteractionEnabled = YES;
                                self.likeAfter.userInteractionEnabled = YES;
                            }];
        
        
    }else{
        
        //当用户是喜欢的状态下点击 self.likeAfter 隐藏
        _likeAfter.alpha = 1.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
        [UIView animateWithDuration:0.35f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_4), 0.1f, 0.1f);
                         }
                         completion:^(BOOL finished) {
                             [self.likeAfter setHidden:YES];
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
        
    }
    
    
    
}

-(void)drawRect:(CGRect)rect{
    //    CGContextRef t = UIGraphicsGetCurrentContext();
    //    CGFloat length = 20;
    //    self.layer.position = _likeAfter.center;
    // //   self.layer.anchorPoint = self.layer.position;
    //     UIBezierPath *startPath = [UIBezierPath bezierPath];
    //    //[startPath moveToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    //
    //
    //
    //    [startPath moveToPoint:CGPointMake(self.bounds.size.width/2 -2, length)];
    //
    //    [startPath addLineToPoint:CGPointMake(self.bounds.size.width/2 +2, length)];
    //    [startPath addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    //    [startPath closePath];
    //     CGContextSetLineWidth(t, 2);
    //    [[UIColor redColor] set];
    //    CGContextAddPath(t, startPath.CGPath);
    //
    //    CGContextFillPath(t);
    
}
@end
