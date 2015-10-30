//
//  PersonViewController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/12/29.
//  Copyright (c) 2014年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQActionSheetPickerView.h"
#import "VPImageCropperViewController.h"
#import "BackButton.h"

@interface PersonViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
{
    NSString* divName;
    BackButton *returnButton;
}

@property (nonatomic, strong) UIImageView *portraitImageView;
@end
