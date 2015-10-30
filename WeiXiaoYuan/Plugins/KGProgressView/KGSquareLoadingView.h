//
//  KGSquareLoadingView.h
//  kugou
//
//  Created by ellzu on 13-12-14.
//  Copyright (c) 2013年 kugou. All rights reserved.
//  update by ganvin

#import <UIKit/UIKit.h>
//#import "KGSkinImageView.h"

typedef enum KGSqureLoadingMode
{
    KGSqureLoadingModeNomalAnimate = 0,//普通旋转动画
    KGSqureLoadingModeFrameAnimate,//图片数组贞动画
}
KGSqureLoadingMode;

@interface KGSquareLoadingView : UIImageView

@property (nonatomic,retain) UIImage                * roateImg;
@property (nonatomic,assign) KGSqureLoadingMode      squreLoadingMode;

//贞模式下设置图片数组
- (void)frameModeAnimateImgList:(NSArray *)imglist;

@end
