//
//  KGProgressView.h
//  kugou
//
//  Created by ellzu on 13-12-26.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGSquareLoadingView.h"

//@class KGSkinLabel;

typedef NS_OPTIONS(NSUInteger,KGProgressViewType) {
    
    //back Ground
    KGProgressViewMaskTypeNone =  1 << 0, // allow user interactions while HUD is displayed
    KGProgressViewMaskTypeClear = 1 << 1, // don't allow
    KGProgressViewMaskTypeBlack = 1 << 2, // don't allow and dim the UI in the back of the HUD
//    KGProgressViewMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
    
    
    
    
    /////
    KGProgressViewTypeWhiteTextColor = 1UL << 8, //白色文字，中心黑色半透明
    KGProgressViewTypeBlackTextColor =  1UL << 9, //黑色文字，中心透明
};

@interface KGProgressView : UIView
{
    UIView *_backView;
//    KGSkinLabel *_label;
}

@property(nonatomic,assign) CGPoint fitPoint;

@property(nonatomic,strong,readonly) UIView *centerView;
@property(nonatomic,strong,readonly) UILabel *label;
@property(nonatomic,assign) KGProgressViewType maskType;
@property(nonatomic,strong)KGSquareLoadingView *iconView;

@property(nonatomic,weak) UIView *parentView;
@property(nonatomic)CGFloat yAlign;

+(KGProgressView*)windowProgressView;

-(void)showLatestSuccessWithStatus:(NSString *)string durarion:(NSTimeInterval)duration;

/**
 *  显示loading状态
 *
 *  @param status   <#status description#>
 *  @param maskType <#maskType description#>
 */
-(void)showWithStatus:(NSString*)status maskType:(KGProgressViewType)maskType;

/**
 *  显示操作状态，限时消失
 *
 *  @param string   <#string description#>
 *  @param duration <#duration description#>
 */
-(void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
-(void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
-(void)showWithStatus:(NSString*)string icon:(UIImage*)image duration:(NSTimeInterval)duration;
-(void)showWithStatus:(NSString*)string icon:(UIImage*)image iconSize:(CGSize)size duration:(NSTimeInterval)duration;

/**
 *  自定义动画图片序列
 *
 *  @param string        描述
 *  @param iconList      旋转动画组的一个公共名
 */
-(void)showWithStatus:(NSString*)string iconList:(NSArray *)imgList iconSize:(CGSize)size duration:(NSTimeInterval)duration;

/**
 *  显示完成状态，限时消失， 必须先调用显示loading状态
 *
 *  @param successString <#successString description#>
 *  @param seconds       <#seconds description#>
 */
-(void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds;
-(void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;
-(void)dismissWithStatus:(NSString*)string icon:(UIImage*)image afterDelay:(NSTimeInterval)seconds;
-(void)dismissWithStatus:(NSString*)string icon:(UIImage*)image iconSize:(CGSize)size afterDelay:(NSTimeInterval)seconds;


@end
