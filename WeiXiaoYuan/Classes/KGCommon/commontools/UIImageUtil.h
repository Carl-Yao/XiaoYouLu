//
//  UIImageUtil.h
//  YZX
//
//  Created by weisun84 on 13-5-27.
//
//

#import <Foundation/Foundation.h>

@interface UIImageUtil : NSObject
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
+ (UIImage *)createWeixinThumbImage:(UIImage *)image inSize:(CGSize)size;
+ (UIImage *) createImageWithColor: (UIColor *) color;
+(UIImage*)createGrayImage:(UIImage*)sourceImage;
+(UIImage*)imageWithColor:(UIColor*)color andSize:(CGSize)size;
+(UIImage*) createBlackImageWith:(UIImage*) sourceImg;
//+ (UIImage *)roundPortraitWith
@end
