//
//  EditProperyViewController.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/10/31.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "EditProperyViewController.h"
#import "UIColor+Addition.h"
#import "BackButton.h"
#import "UIView+ViewFrameGeometry.h"
#import "KTVInsetsTextField.h"
#import "KGProgressView.h"
#import "PersonInfoViewController.h"

@interface EditProperyViewController ()<UITextViewDelegate>

@end

@implementation EditProperyViewController
- (void)btnClicked:(id)sender event:(id)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //top
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, self.view.frame.size.width+4, 34+2+rect.size.height)];
    view.backgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    [self.view insertSubview:view atIndex:0];
    
    //title
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height+1, self.view.frame.size.width , 34)];
    laber.text = [NSString stringWithFormat:@"修改%@",self.titleStr,nil];
    laber.textColor = [UIColor blackColor];
    laber.font = [UIFont systemFontOfSize:20];
    laber.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:laber atIndex:1];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    BackButton *returnButton = [[BackButton alloc] initWithFrame:CGRectMake(-2+10, -2+20 + 6, 90, 48-20)];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    //换返回按钮图标和文字
    UIImage *image1 = [UIImage imageNamed:@"biz_pics_main_back_normal.png"];
    [returnButton setImage:image1 forState:UIControlStateNormal];
    [self.view insertSubview:returnButton atIndex:1];
    [returnButton addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    
    //    newFriends = [[NSMutableArray alloc]init];
    //    for (int i = 1; i < 8; i++) {
    //        NSString* info = [[NSString alloc] init];
    //        info = [NSString stringWithFormat:@"新的朋友%d",i];
    //        [newFriends addObject:info];
    //    }
    
    _webServiceController = [WebServiceController shareController:self.view];

    BackButton *joinButton = [[BackButton alloc] initWithFrame:CGRectMake(self.view.width-64 -8, -2+20 + 6, 64, 48-20)];
    [joinButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view insertSubview:joinButton atIndex:1];
    [joinButton addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIFont * textFont = [UIFont systemFontOfSize:15];
    CGSize textSize = [@"文本" sizeWithFont:textFont];
    CGFloat textWidth = self.view.frame.size.width - 28;
    UIView * editView = [[UIView alloc]initWithFrame:CGRectMake(14,
                                                            view.bottom+14,
                                                            textWidth,
                                                            textSize.height * 4 + 16)];
    editView.layer.masksToBounds = YES;
    editView.layer.borderWidth = 1;
    editView.layer.borderColor = [[UIColor colorWithRed:188.0f/255.0f
                                              green:188.0f/255.0f
                                               blue:188.0f/255.0f
                                              alpha:1] CGColor];
    
    [editView setBackgroundColor:[UIColor whiteColor]];
    CGRect textFieldFrame = UIEdgeInsetsInsetRect(view.bounds,
                                                  UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5));
    
    UITextView * tField = [[UITextView alloc] initWithFrame:textFieldFrame];
    tField.contentSize = tField.frame.size;
    tField.delegate = self;
    tField.autocorrectionType = UITextAutocorrectionTypeNo;
    [tField setBackgroundColor:[UIColor whiteColor]];
    [tField setTextColor:[UIColor blackColor]];
    [tField setFont:textFont];
    [editView addSubview:tField];
    self.textField = tField;
    
//    if ([self.placeholderText length] > 0) {
//        CGSize size = self.textField.contentSize;
//        CGSize labelsize = [self.placeholderText sizeWithFont:textFont
//                                            constrainedToSize:size
//                                                lineBreakMode:UILineBreakModeWordWrap];
//        
//        self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,
//                                                                          8,
//                                                                          textWidth - 10,
//                                                                          labelsize.height)];
//        self.placeholderLabel.text = self.placeholderText;
//        self.placeholderLabel.enabled = NO;// lable必须设置为不可用
//        self.placeholderLabel.backgroundColor = [UIColor clearColor];
//        self.placeholderLabel.textColor = [UIColor colorWithHexString:@"#848484"];
//        self.placeholderLabel.font = textFont;
//        self.placeholderLabel.numberOfLines = 3;
//        self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        
//        [view addSubview:self.placeholderLabel];
//    }
    [self.textField becomeFirstResponder];
    [self.view addSubview:editView];
    // Do any additional setup after loading the view.
}

- (void)btnClicked
{
    if (self.type == 0){
        [_webServiceController SendHttpRequestWithMethod:@"/absapi/absuserinfo/update" argsDic:@{@"id":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, self.propery:self.textField.text, @"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
            [self dismissViewControllerAnimated:YES completion:nil];
            [[KGProgressView windowProgressView] showErrorWithStatus:@"保存成功" duration:0.5];
        }];
    }else if (self.type == 1){
        [_webServiceController SendHttpRequestWithMethod:@"/absapi/absuserschool/save" argsDic:@{@"id":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, self.propery:self.textField.text, @"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
            [self dismissViewControllerAnimated:YES completion:nil];
            [[KGProgressView windowProgressView] showErrorWithStatus:@"保存成功" duration:0.5];
        }];
    }else if (self.type == 2){
        [_webServiceController SendHttpRequestWithMethod:@"/absapi/absuserwork/updateByUserId" argsDic:@{@"id":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, self.propery:self.textField.text, @"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
            [self dismissViewControllerAnimated:YES completion:nil];
            [[KGProgressView windowProgressView] showErrorWithStatus:@"保存成功" duration:0.5];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
