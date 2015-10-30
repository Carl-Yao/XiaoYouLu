//
//  BackButton.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/11/18.
//
//

#import "BackButton.h"

@implementation BackButton


+ (BackButton*)BtnWithType:(UIButtonType)buttonType
{
    BackButton *btn = [BackButton buttonWithType:buttonType];
    btn.backgroundColor=[UIColor clearColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn.titleLabel.textColor = [UIColor grayColor];

    [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    return btn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    return bounds;
}

- (CGRect)contentRectForBounds:(CGRect)bounds
{
    return bounds;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x+ contentRect.size.height, contentRect.origin.y , contentRect.size.width - contentRect.size.height, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.height);
}



@end
