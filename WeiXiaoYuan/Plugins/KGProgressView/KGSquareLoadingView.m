//
//  KGSquareLoadingView.m
//  kugou
//
//  Created by ellzu on 13-12-14.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import "KGSquareLoadingView.h"

@interface KGSquareLoadingView ()

@end

@implementation KGSquareLoadingView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.squreLoadingMode = KGSqureLoadingModeNomalAnimate;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.squreLoadingMode = KGSqureLoadingModeNomalAnimate;
    }
    return self;
}

- (void)setSqureLoadingMode:(KGSqureLoadingMode )squreLoadingMode
{
    if (squreLoadingMode == KGSqureLoadingModeNomalAnimate)
    {
        _roateImg = [UIImage imageNamed:@"img_scanning"];
    }
    _squreLoadingMode = squreLoadingMode;
}

- (void)frameModeAnimateImgList:(NSArray *)imglist
{
    if (_squreLoadingMode == KGSqureLoadingModeFrameAnimate)
    {
        _roateImg = nil;
        self.animationImages = imglist;
        self.animationDuration = 0.75;
    }
}

- (void)startAnimating
{
    [super startAnimating];

    if (_squreLoadingMode == KGSqureLoadingModeNomalAnimate)
    {
        UIImage * img = _roateImg;
        [self setImage:img];
        //self.autoSkin = YES;
        CABasicAnimation *fullRotation;
        fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
        fullRotation.duration =0.8f;
        fullRotation.repeatCount = HUGE_VALF;
        fullRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [fullRotation setValue:@"360" forKey:@"MyAnimationType"];
        fullRotation.removedOnCompletion = NO;
        [self.layer addAnimation:fullRotation forKey:@"360"];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    }
}

- (void)stopAnimating
{
    [super stopAnimating];

    if (_squreLoadingMode == KGSqureLoadingModeNomalAnimate)
    {
        //self.autoSkin = NO;
        [self.layer removeAnimationForKey:@"360"];
        [self setImage:nil];
    }
}

- (void)dealloc
{
   
}

@end
