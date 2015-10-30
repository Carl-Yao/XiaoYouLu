//
//  UIImage+RoundRectImage.h
//  FanxingSDK
//
//  Created by xiaogaochao on 13-12-2.
//  Copyright (c) 2013年 YZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
