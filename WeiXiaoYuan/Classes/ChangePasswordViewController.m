//
//  ChangePasswordViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/12/28.
//  Copyright (c) 2014年 Dukeland. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "WebServiceController.h"
#import "KGProgressView.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"loginbg.png"];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.frame = self.view.frame;
    [self.view insertSubview:view atIndex:0];
    
    _webServiceController = [WebServiceController shareController:self.view];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)okButtonPressed: (id)sender
{
    if (self.refreshPasswordField.text.length < 6 || self.refreshPasswordField.text.length > 10
        ||self.repeatPasswordField.text.length < 6 || self.repeatPasswordField.text.length > 10 ) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"输入密码位数不合格！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if (self.userName.text.length < 1){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入用户名！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if (self.code.text.length < 1){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if (self.telNum.text.length != 11) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"输入号码位数不合格！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if(![self.refreshPasswordField.text isEqualToString:self.repeatPasswordField.text])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"两次输入密码不一致！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
//        WebServiceController *web = [WebServiceController shareController:nil];
//        NSString* result = [web updatePassword:self.oldPasswordField.text:self.refreshPasswordField.text];
//        if ([result isEqualToString:@"true"]) {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            [self dismissModalViewControllerAnimated:YES];
//        }else{
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"修改失败" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
        [_webServiceController SendHttpRequestWithMethod:@"/addressBooks/absapi/register" argsDic:@{@"username":self.userName.text,@"dn":self.telNum.text,@"password":self.refreshPasswordField.text,@"code":self.code.text} success:^(NSDictionary* dic){
            [[KGProgressView windowProgressView] showErrorWithStatus:@"发送成功" duration:0.5];
        }];
    }
}
- (IBAction)cancelButtonPressed: (id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)getCode:(id)sender {
    if (self.telNum.text.length != 11) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"输入号码位数不合格！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [_webServiceController SendHttpRequestWithMethod:@"/addressBooks/manager/abssmscode/absapi/sendsms" argsDic:@{@"dn":self.telNum.text} success:^(NSDictionary* dic){
        [[KGProgressView windowProgressView] showErrorWithStatus:@"发送成功" duration:0.5];
    }];
}
- (IBAction)textFieldDoneEditing:(id)sender
{
    [self.userName resignFirstResponder];
    [self.refreshPasswordField resignFirstResponder];
    [self.repeatPasswordField resignFirstResponder];
    [self.telNum resignFirstResponder];
    [self.code resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [self.userName resignFirstResponder];
    [self.refreshPasswordField resignFirstResponder];
    [self.repeatPasswordField resignFirstResponder];
    [self.telNum resignFirstResponder];
    [self.code resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
