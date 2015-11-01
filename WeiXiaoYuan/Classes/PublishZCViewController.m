//
//  PublishZCViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 15/10/15.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "PublishZCViewController.h"
#import "BackButton.h"
#import "InTimeViewController.h"
#import "DBImageView.h"
#import "SJAvatarBrowser.h"
#import "UIColor+Addition.h"
#import "UIView+ViewFrameGeometry.h"
#import "KGProgressView.h"
#import "SliderSwitch.h"

@interface PublishZCViewController ()<SliderSwitchDelegate>
{
    UITextView* contentView;
    UITextField* titleLabel;
    WebServiceController *_webServiceController;
    SliderSwitch* slideSwitchH;
    NSString* classId;
}
@end

@implementation PublishZCViewController

- (void)btnClicked:(id)sender event:(id)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)okBtn
{
    [_webServiceController SendHttpRequestWithMethod:@"/absapi/abssource/save" argsDic:@{@"title":titleLabel.text,@"context":contentView.text,@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"classId":classId, @"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[KGProgressView windowProgressView] showSuccessWithStatus:@"发布成功" duration:0.5];
    }];
}
- (void)viewDidLoad {
    //top
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, self.view.frame.size.width+4, 34+2+rect.size.height)];
    view.backgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    [self.view insertSubview:view atIndex:0];
    
    //title
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height+1, self.view.frame.size.width , 34)];
    if (self.isZC) {
        laber.text = @"发布众筹";
    }else{
        laber.text = @"发布资源";
    }
    laber.textColor = [UIColor blackColor];
    laber.font = [UIFont systemFontOfSize:20];
    laber.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:laber atIndex:1];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    BackButton *returnButton = [[BackButton alloc] initWithFrame:CGRectMake(-2+10, -2+20 + 6, 150, 48-20)];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    //换返回按钮图标和文字
    UIImage *image1 = [UIImage imageNamed:@"biz_pics_main_back_normal.png"];
    [returnButton setImage:image1 forState:UIControlStateNormal];
    [self.view insertSubview:returnButton atIndex:1];
    [returnButton addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    BackButton *joinButton = [[BackButton alloc] initWithFrame:CGRectMake(self.view.width-64 -8, -2+20 + 6, 64, 48-20)];
    [joinButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.view insertSubview:joinButton atIndex:1];
    [joinButton addTarget:self action:@selector(okBtn) forControlEvents:UIControlEventTouchUpInside];
    
    titleLabel = [[UITextField alloc] initWithFrame:CGRectMake(5, view.bottom + 8, self.view.width - 10, 30)];
    titleLabel.placeholder = @"标题";
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(5, titleLabel.bottom+8, self.view.width - 10, 200)];
    [self.view addSubview:contentView];
    
    if (self.isZC){
        UIButton* addPic = [[UIButton alloc] initWithFrame:CGRectMake(10, contentView.bottom+8, self.view.width-20, 40)];
        [addPic setTitle:@"添加图片" forState:UIControlStateNormal];
        addPic.backgroundColor = [UIColor colorWithHexString:@"#41C9D7"];
        [self.view addSubview:addPic];
    }else{
        slideSwitchH=[[SliderSwitch alloc]init];
        
        [slideSwitchH setFrameHorizontal:(CGRectMake(80, contentView.bottom+8, 160, 40)) numberOfFields:2 withCornerRadius:4.0];
        //240/3=80
        //width of each option is 80 (It should not be a fractional value)
        slideSwitchH.delegate=self;
        [slideSwitchH setFrameBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.2 alpha:0.3]];
        [slideSwitchH setSwitchFrameColor:[UIColor whiteColor]];
        [slideSwitchH setTextColor:[UIColor grayColor]];
        
        [slideSwitchH setText:@"需求" forTextIndex:1];
        [slideSwitchH setText:@"供给" forTextIndex:2];
        classId = @"1";
        [slideSwitchH setSwitchBorderWidth:6.0];
        [self.view addSubview:slideSwitchH];
    }
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    _webServiceController = [WebServiceController shareController:self.view];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)slideView:(SliderSwitch *)slideswitch switchChangedAtIndex:(NSUInteger)index
{
    NSLog(@"selected option is:::::: %@,%d",slideswitch,index);
    
    if (slideswitch==slideSwitchH) {
        NSLog(@"Horizontal slideview");
        if (index==0) {
            classId = @"1";
        }
        else{
            classId = @"2";
        }
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
