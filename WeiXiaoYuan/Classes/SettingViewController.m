//
//  SettingViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-10.
//
//

#import "SettingViewController.h"
#import "PersonViewController.h"
#import "DBImageView.h"
#import "AppDelegate.h"
#import "UIColor+Addition.h"
#import "UIView+ViewFrameGeometry.h"
#import "MyJoinZCViewController.h"
#import "PublishZCViewController.h"
#import "WebServiceController.h"
#import "XYLUserInfoBLL.h"
#import "PersonInfoViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Storyboard" bundle: nil];
    if (self) {
    self = [board instantiateViewControllerWithIdentifier: @"Setting"];
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, self.view.frame.size.width+4, 34+2+rect.size.height)];
    view.backgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    [self.view insertSubview:view atIndex:0];
    
    //title
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height+1, self.view.frame.size.width , 34)];
    laber.text = @"我的";
    laber.textColor = [UIColor blackColor];
    laber.font = [UIFont boldSystemFontOfSize:20];
    laber.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:laber atIndex:1];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, view.bottom, self.view.width, 72)];
    myView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    [self.view addSubview:myView];
    
    UIImageView* headImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 60, 60)];
    headImg.layer.cornerRadius = 30;
    headImg.layer.borderWidth = 0.5;
    headImg.layer.masksToBounds = YES;
    [myView addSubview:headImg];
    
    UILabel* myLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImg.right + 4, 6, self.view.width - 69, 60)];
    myLabel.text = [XYLUserInfoBLL shareUserInfoBLL].userInfo.username;
    myLabel.backgroundColor = [UIColor clearColor];
    [myView addSubview:myLabel];
    
    UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myTap)];
    [myView addGestureRecognizer:tap];
    tap.delegate = self;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 380, self.view.frame.size.width-20, 40)];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];//设置button的title
    button.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
    button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    self.tasks = @[@[@"发起众筹",@"我参与的众筹"],@[@"发布资源",@"我的资源"]];
    
    [super viewDidLoad];
	//@ Do any additional setup after loading the view.
}

- (void)btnClicked:(id)sender event:(id)event
{
    //[self performSegueWithIdentifier:@"LoginToMain" sender:self];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"退出登录" message:@"确定要退出登录吗？" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"取消", nil];
    alert.tag = 1001;
    [alert show];
}
- (void)myTap
{
    PersonInfoViewController* vc = [[PersonInfoViewController alloc] init];
    vc.isOwn = YES;
    //vc.userId = dataArr[indexPath.row][@"friendsId"];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (alertView.tag == 1001) {
            //退出登录接口
            __weak SettingViewController * weakSelf = self;
            XYLUserInfoBLL* infoBLL = [XYLUserInfoBLL shareUserInfoBLL];
            NSDictionary* dicArg = @{@"userId":infoBLL.userInfo.userid,
                                     @"token":infoBLL.token};
            WebServiceController* _webServiceController = [WebServiceController shareController:self.view];
            [_webServiceController SendHttpRequestWithMethod:@"/absapi/logout" argsDic:dicArg success:^(NSDictionary* dic){
                [weakSelf dismissModalViewControllerAnimated:YES];
            }];
        }else if(alertView.tag == 1002)
        {
            [self clearCache];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"清除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else if(alertView.tag == 1003)
        {
            [self clearCache];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] del:@"ClearAll"];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"清空成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        alertView.tag = 0;
    }
}

- (void) clearCache
{
    [DBImageView clearCache];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tasks count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
    return [self.tasks[0] count];
    }else{
        return [self.tasks[1] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.tasks[0][indexPath.row];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.tasks[1][indexPath.row];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //该方法响应列表中行的点击事件
    NSString *selected=[self.tasks[indexPath.section] objectAtIndex:indexPath.row];
    if ([selected isEqualToString:@"修改密码"]) {
        [self performSegueWithIdentifier:@"MainToChangePassword" sender:self];
    }else if ([selected isEqualToString:@"清除缓存"]) {
        UIAlertView *myAlertView;
        myAlertView = [[UIAlertView alloc]initWithTitle:@"询问" message:@"是否清除缓存？" delegate:self cancelButtonTitle:@"清除" otherButtonTitles:@"取消",nil];
        myAlertView.tag = 1002;
        [myAlertView show];
    }else if ([selected isEqualToString:@"清空消息记录"]) {
        UIAlertView *myAlertView;
        myAlertView = [[UIAlertView alloc]initWithTitle:@"询问" message:@"是否清空消息记录？" delegate:self cancelButtonTitle:@"清空" otherButtonTitles:@"取消",nil];
        myAlertView.tag = 1003;
        [myAlertView show];
    }else if ([selected isEqualToString:@"个人信息"]) {
        PersonViewController* personView = [[PersonViewController alloc]init];
        [self presentViewController:personView animated:YES completion:nil];
    }else if ([selected isEqualToString:@"发起众筹"]) {
        PublishZCViewController* vc = [[PublishZCViewController alloc]init];
        vc.isZC = YES;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([selected isEqualToString:@"我参与的众筹"]) {
        MyJoinZCViewController* vc = [[MyJoinZCViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([selected isEqualToString:@"发布资源"]){
        PublishZCViewController* vc = [[PublishZCViewController alloc]init];
        vc.isZC = NO;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([selected isEqualToString:@"我的资源"]){
        ((UITabBarController*)self.parentViewController).selectedIndex = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WODEZIYUAN" object: nil];
    }

    //indexPath.row得到选中的行号，提取出在数组中的内容。
//    UIAlertView *myAlertView;
//    myAlertView = [[UIAlertView alloc]initWithTitle:@"dota群英传" message:heroSelected delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [myAlertView show];
    //点击后弹出该对话框。
}

#pragma mark -

- (id)initWithStyle:(UITableViewStyle)style

{
    
    //self = [self->tableView initWithStyle:style];
    
    if (self) {
        
        // Custom initialization
        
    }
    
    return self;
    
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        
        if (tableView == self->tableView) {
            
            CGFloat cornerRadius = 0.f;//圆角
            
            cell.backgroundColor = UIColor.clearColor;
            
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            
            CGMutablePathRef pathRef = CGPathCreateMutable();
            
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);//边距
            
            BOOL addLine = NO;
            
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                
            } else if (indexPath.row == 0) {
                
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                
                addLine = YES;
                
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
                
            } else {
                
                CGPathAddRect(pathRef, nil, bounds);
                
                addLine = YES;
                
            }
            
            layer.path = pathRef;
            
            CFRelease(pathRef);
            
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            
            
            if (addLine == YES) {
                
                CALayer *lineLayer = [[CALayer alloc] init];
                
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                
                [layer addSublayer:lineLayer];
                
            }
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            
            [testView.layer insertSublayer:layer atIndex:0];
            
            testView.backgroundColor = UIColor.clearColor;
            
            cell.backgroundView = testView;
            
        }
        
    }
    
}

#pragma 拍照

@end
