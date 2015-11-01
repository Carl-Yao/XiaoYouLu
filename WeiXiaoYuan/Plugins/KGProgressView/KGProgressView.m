//
//  KGProgressView.m
//  kugou
//
//  Created by ellzu on 13-12-26.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import "KGProgressView.h"
//#import "KGUIView.h"
//#import "KGSkinLabel.h"
#import "AppDelegate.h"
//#import "ColorEx.h"
#import "UIColor+Addition.h"

@interface KGProgressView()
{
    NSCondition *_lock1;
}
@end

@implementation KGProgressView

+(KGProgressView*)windowProgressView
{
    static KGProgressView *progressView = nil;
    if (progressView == nil) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        progressView = [[KGProgressView alloc] initWithFrame:app.window.bounds];
        progressView.parentView = app.window;
        
    }
    progressView.maskType = KGProgressViewMaskTypeBlack;
    return progressView;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self privateInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self privateInit];
    }
    return self;
}

-(void)dealloc
{
}

-(void)privateInit
{
       
    _lock1 = [[NSCondition alloc] init];
    
    _yAlign = 0.0;
    _fitPoint = CGPointMake(CGFLOAT_MIN,CGFLOAT_MIN);
    [self setBackgroundColor:[UIColor clearColor]];
    _backView = [[UIView alloc] initWithFrame:self.bounds];
    _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_backView];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_centerView setFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 100, 100)];
    _centerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    _centerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _centerView.layer.cornerRadius = 10;
    [self addSubview:_centerView];
    
    _iconView = [[KGSquareLoadingView alloc] initWithFrame:CGRectZero];
    [_iconView setFrame:CGRectMake(50, 25, 55, 55)];
    [_centerView addSubview:_iconView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 90, 45)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [_centerView addSubview:_label];
}

-(void)setMaskType:(KGProgressViewType)maskType
{
    _maskType = maskType;
    [self changeMaskType];
}
-(void)changeMaskType
{
    if(_maskType&KGProgressViewMaskTypeClear){
        
        self.userInteractionEnabled = YES;
        _backView.userInteractionEnabled = NO;
        _backView.backgroundColor = [UIColor clearColor];
        
    }else if(_maskType&KGProgressViewMaskTypeBlack){
        
        self.userInteractionEnabled = YES;
        _backView.userInteractionEnabled = NO;
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
    }else{
        
        self.userInteractionEnabled = NO;
        _backView.userInteractionEnabled = NO;
        _backView.backgroundColor = [UIColor clearColor];
        
    }
    
    if (_maskType&KGProgressViewTypeBlackTextColor) {
        _centerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _label.textColor = [UIColor colorWithHexString:@"#5A5A5A"];
    }
    else{
        _centerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _label.textColor = [UIColor whiteColor];
    }
}

-(void)setLabelText:(NSString*)string
{
    CGFloat hudWidth = 100;
    CGFloat hudHeight = 30;

//    CGRect labelRect = CGRectZero;
    _label.text = string;

	CGSize labelSize = [_label sizeThatFits:CGSizeMake(200, 300)];
    if (labelSize.width > hudWidth) {
        hudWidth = ceil(labelSize.width/2)*2+20;
    }
    NSLog(@"_iconView.bounds.size.height:%f",_iconView.bounds.size.height);
    CGFloat iconHeight = (_iconView.bounds.size.height==0?0:20)+_iconView.bounds.size.height;
    hudHeight = (iconHeight==0?5:iconHeight)+labelSize.height+5;

	_centerView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    CGPoint point = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    point.x = _fitPoint.x!=CGFLOAT_MIN?_fitPoint.x:point.x;
    point.y = _fitPoint.y!=CGFLOAT_MIN?_fitPoint.y:point.y + _yAlign;
    _centerView.center = point;
//    _iconView.frame = CGRectMake(0, 0, _iconView.image.size.width, _iconView.image.size.height);
//    if(string.length>0){
//        _iconView.center = CGPointMake(hudWidth/2, 40);
//	}else{
//       	_iconView.center = CGPointMake(CGRectGetWidth(_centerView.bounds)/2, CGRectGetHeight(_centerView.bounds)/2);
//    }
    //yzx at 2015/10/31
    [_iconView setFrame:CGRectMake(_centerView.bounds.size.width/2-_iconView.bounds.size.width/2, 10, _iconView.bounds.size.width, _iconView.bounds.size.height)];
    [_label setFrame:CGRectMake(_centerView.frame.size.width/2-labelSize.width/2, iconHeight==0?5:iconHeight, labelSize.width, labelSize.height)];
    
}
//

-(void)showWithStatus:(NSString*)status maskType:(KGProgressViewType)maskType
{   
    self.maskType = maskType;
    if (self.superview != self.parentView) {
        [self removeFromSuperview];
        self.frame = self.parentView.bounds;
        [self.parentView addSubview:self];
    }
    [_iconView setFrame:CGRectMake(50, 25, 55, 55)];
    [self setLabelText:status];
    
    [_iconView startAnimating];
    [self showAnimation:nil];
}

-(void)showLatestSuccessWithStatus:(NSString *)string durarion:(NSTimeInterval)duration
{
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [self showSuccessWithStatus:string duration:duration];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOutRemove) object:nil];
    [self performSelector:@selector(timeOutRemove) withObject:nil afterDelay:duration];
    self.maskType = KGProgressViewMaskTypeNone;
}

-(void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration
{
    UIImage *image = [UIImage imageNamed:@"KGProgress_success.png"];
    [self showWithStatus:string icon:image duration:duration];
    
}
-(void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration
{         
    UIImage *image = [UIImage imageNamed:@"KGProgress_error.png"];
  
    [self showWithStatus:string icon:image duration:duration];
}
-(void)showWithStatus:(NSString*)string icon:(UIImage*)image duration:(NSTimeInterval)duration
{
    
    if (image==nil) {
        
        
        [self showWithStatus:string icon:image iconSize:CGSizeMake(0, 0) duration:duration];
    }
    else
    {
        [self showWithStatus:string icon:image iconSize:CGSizeMake(20, 20) duration:duration];
    }
//    [self showWithStatus:string icon:image iconSize:CGSizeMake(20, 20) duration:duration];
}


-(void)showWithStatus:(NSString*)string icon:(UIImage*)image iconSize:(CGSize)size duration:(NSTimeInterval)duration
{
    [_lock1 lock];
    self.maskType = KGProgressViewMaskTypeNone;
    
    
   
    if (self.superview != self.parentView) {
        
       
        [self removeFromSuperview];
        self.frame = self.parentView.bounds;
        [self.parentView addSubview:self];
    }
    
    [self updateForCurrentOrientation];
    [_iconView stopAnimating];
    _iconView.image = image;
    _iconView.frame = CGRectMake(0, 0, size.width, size.height);
    [self setLabelText:string];
    
    [self showAnimation:nil];
    if (duration>0.01) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOutRemove) object:nil];
        [self performSelector:@selector(timeOutRemove) withObject:Nil afterDelay:duration];
    }else{
        [self unShowAnimation:^(BOOL isFinish){
            
    [self removeFromSuperview];
        }];
    }
    [_lock1 unlock];
}

-(void)showWithStatus:(NSString*)string iconList:(NSArray *)imgList iconSize:(CGSize)size duration:(NSTimeInterval)duration;
{
    [_lock1 lock];
    self.maskType = KGProgressViewMaskTypeNone;
    if (self.superview != self.parentView) {
        [self removeFromSuperview];
        self.frame = self.parentView.bounds;
        [self.parentView addSubview:self];
    }
    _iconView.squreLoadingMode = KGSqureLoadingModeFrameAnimate;
    [_iconView frameModeAnimateImgList:imgList];
    [_iconView startAnimating];
    _iconView.frame = CGRectMake(0, 0, size.width, size.height);
    [self setLabelText:string];
    
    [self showAnimation:nil];
    if (duration>0.01) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOutRemove) object:nil];
        [self performSelector:@selector(timeOutRemove) withObject:Nil afterDelay:duration];
    }else{
        [self unShowAnimation:^(BOOL isFinish){
            [self removeFromSuperview];
        }];
    }
    [_lock1 unlock];
}

-(void)timeOutRemove
{
//    NSLog(@"end");
    [_lock1 lock];
    [self unShowAnimation:^(BOOL isfinish){
        if (isfinish==YES) {
            _yAlign = 0;
            [self removeFromSuperview];
        }
        
    }];
    [_lock1 unlock];
}
-(void)showAnimation:(void (^)(BOOL finish))finishBlock
{
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^(){
        self.alpha = 1;
    } completion:^(BOOL isFinish){
        if (finishBlock) {
            finishBlock(isFinish);
        }
    }];
}


-(void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds
{
    UIImage *image = [UIImage imageNamed:@"KGProgress_success.png"];
    [self dismissWithStatus:successString icon:image afterDelay:seconds];
}
-(void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds
{
    UIImage *image = [UIImage imageNamed:@"KGProgress_error.png"];
    [self dismissWithStatus:errorString icon:image afterDelay:seconds];
}
-(void)dismissWithStatus:(NSString*)string icon:(UIImage*)image afterDelay:(NSTimeInterval)seconds
{
    [self dismissWithStatus:string icon:image iconSize:CGSizeMake(20, 20) afterDelay:seconds];
}
-(void)dismissWithStatus:(NSString*)string icon:(UIImage*)image iconSize:(CGSize)size afterDelay:(NSTimeInterval)seconds
{
    [_lock1 lock];
    [_iconView stopAnimating];
    if (seconds<=0) {
        
//        [self unShowAnimation:^(BOOL isFinish){
            [self removeFromSuperview];
        NSLog(@"dismissWithStatus: %d",self.superview==nil);
//        }];
    }
    else
    {
        _iconView.image = image;
        _iconView.frame = CGRectMake(0, 0, size.width, size.height);
        [self setLabelText:string];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOutRemove) object:nil];
        [self performSelector:@selector(timeOutRemove) withObject:Nil afterDelay:seconds];
    }
    
    [_lock1 unlock];
}
-(void)unShowAnimation:(void (^)(BOOL isFinish))finishBlock
{
    [UIView animateWithDuration:0.25 animations:^(){
        self.alpha = 0;
    } completion:^(BOOL isFinish){
        if (finishBlock) {
            finishBlock(isFinish);
        }
    }];
}

- (void)updateForCurrentOrientation {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        CGFloat radians = 0;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            if (orientation == UIInterfaceOrientationLandscapeLeft) {
                radians = -(CGFloat)M_PI_2;
            }
            else {
                radians = (CGFloat)M_PI_2;
            }
            // Window coordinates differ!
            self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
        }
        else {
            if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                radians = (CGFloat)M_PI;
            }
            else {
                radians = 0;
            }
        }
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
        
        [self setTransform:rotationTransform];
    }
}

@end
