//
//  ChangePasswordViewController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/12/28.
//  Copyright (c) 2014年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceController.h"

@interface ChangePasswordViewController : UIViewController{
    WebServiceController* _webServiceController;
}
- (IBAction)okButtonPressed: (id)sender;
- (IBAction)cancelButtonPressed: (id)sender;
- (IBAction)getCode:(id)sender;

//@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *refreshPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;

@property (weak, nonatomic) IBOutlet UITextField *telNum;
@property (weak, nonatomic) IBOutlet UITextField *code;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
