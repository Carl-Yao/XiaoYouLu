//
//  WebViewController.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/11/2.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "WebViewController.h"
#import "BackButton.h"
#import "UIColor+Addition.h"
#import "UIView+ViewFrameGeometry.h"
#import "XYLUserInfoBLL.h"

@interface WebViewController ()<UIWebViewDelegate>{
    UIWebView * webView;
    NSString* urlStr;
}

@end

@implementation WebViewController

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
    laber.text = [NSString stringWithFormat:@"%@",self.titleStr,nil];
    laber.textColor = [UIColor blackColor];
    laber.font = [UIFont systemFontOfSize:20];
    laber.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:laber atIndex:1];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    BackButton *joinButton = [[BackButton alloc] initWithFrame:CGRectMake(self.view.width-32 -8, -2+20 + 6, 32, 48-20)];
    [joinButton setImage:[UIImage imageNamed:@"ic_share"] forState:UIControlStateNormal];
    [self.view insertSubview:joinButton atIndex:1];
    [joinButton addTarget:self action:@selector(shareD) forControlEvents:UIControlEventTouchUpInside];
    
    BackButton *returnButton = [[BackButton alloc] initWithFrame:CGRectMake(-2+10, -2+20 + 6, 90, 48-20)];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    //换返回按钮图标和文字
    UIImage *image1 = [UIImage imageNamed:@"biz_pics_main_back_normal.png"];
    [returnButton setImage:image1 forState:UIControlStateNormal];
    [self.view insertSubview:returnButton atIndex:1];
    [returnButton addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    // Do any additional setup after loading the view.
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, view.bottom, self.view.frame.size.width, self.view.frame.size.height - view.bottom)];
    urlStr = [NSString stringWithFormat:@"http://123.57.11.237/absapi/absarticle/selectById?id=%@&token=%@",self.wzId,[XYLUserInfoBLL shareUserInfoBLL].token,nil];
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    webView.delegate = self;
    //webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
//    NSURL *url = [NSURL URLWithString: @"http://123.57.11.237/absapi/absarticle/selectById"];
//    NSString *body = [NSString stringWithFormat: @"id=%@&token=%@", self.wzId,[XYLUserInfoBLL shareUserInfoBLL].token];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
//    [request setHTTPMethod: @"POST"];
//    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
//    [webView loadRequest: request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    int i = 1;
}
-(void)shareD{
    
    NSString *textToShare = @"文章";
    
    UIImage *imageToShare = [UIImage imageNamed:@"icon-76.png"];
    
    NSURL *urlToShare = [NSURL URLWithString:urlStr];//@"http://www.iosbook3.com"];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                            
                                                                            applicationActivities:nil];
    
    //不出现在活动项目
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                         
                                         UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
    
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
