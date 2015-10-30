//
//  ChangePasswordViewController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/12/28.
//  Copyright (c) 2014年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
- (IBAction)okButtonPressed: (id)sender;
- (IBAction)cancelButtonPressed: (id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;

@property (weak, nonatomic) IBOutlet UITextField *refreshPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
