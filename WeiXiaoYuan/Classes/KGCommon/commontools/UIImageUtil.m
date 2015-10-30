//
//  UIImageUtil.m
//  YZX
//
//  Created by weisun84 on 13-5-27.
//
//

#import "UIImageUtil.h"

@implementation UIImageUtil
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width/2, reSize.height/2), YES, 0.0);
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

+ (UIImage *)createWeixinThumbImage:(UIImage *)image inSize:(CGSize)size{
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.width;
    if ( image.size.width > image.size.height ) {
        imageHeight = image.size.height/image.size.width * imageWidth;
    }else{
        imageWidth = image.size.width/image.size.height * imageHeight;
    }
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake((size.width-imageWidth)/2.0f, (size.height-imageHeight)/2.0f, imageWidth, imageHeight)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * thumbData = UIImageJPEGRepresentation(reSizeImage, 0.5);
    return [UIImage imageWithData:thumbData];
}

+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+(UIImage*)createGrayImage:(UIImage*)sourceImage{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}
+(UIImage*) createBlackImageWith:(UIImage*) sourceImg{
    if (sourceImg==nil) {
        return nil;
    }
    UIImage*blackBgImg = [UIImageUtil imageWithColor:[UIColor blackColor] andSize:sourceImg.size];
    UIGraphicsBeginImageContextWithOptions(sourceImg.size, NO, [UIScreen mainScreen].scale);
    [sourceImg drawInRect:CGRectMake(0, 0, sourceImg.size.width, sourceImg.size.height)];
    [blackBgImg drawInRect:CGRectMake(0, 0, sourceImg.size.width, sourceImg.size.height)
                blendMode:kCGBlendModeDarken
                    alpha:0.4];
    
    UIImage* highlighted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return highlighted;
}
+(UIImage*)imageWithColor:(UIColor*)color andSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, size.width, size.height);
    [color set];
    CGContextFillRect(ctx, area);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
