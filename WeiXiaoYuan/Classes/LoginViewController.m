//
//  LoginViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-9.
//
//

#import "LoginViewController.h"
#import "UIKit/UIKit.h"
#import "KeychainItemWrapper.h"
#import "UserManager.h"
#import "SFHFKeychainUtils.h"
#import "BPush.h"
#import "AppDelegate.h"
#import "MALTabBarViewController.h"
#import "SBJson.h"
#import "ChangePasswordViewController.h"
#import "XYLUserInfo.h"
#import "XYLUserInfoBLL.h"

#define SERVICE_NAME @"XiaoYouLu"
#define USERNAMEKEY @"UserNameKey"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize tabberViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"loginbg.png"];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.frame = self.view.frame;
    [self.view insertSubview:view atIndex:0];
    _webServiceController = [WebServiceController shareController:self.view];
    [_webServiceController SetDalegate:self];
    
    //wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"WXYLogin" accessGroup:nil];
    //NSString *userName = [wrapper objectForKey: (__bridge id)kSecAttrAccount];
 
    userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取NSString类型的数据
    NSString *myString = [userDefaultes stringForKey:USERNAMEKEY];
    self.nameField.text = myString;
    
    NSString *passWord =  [SFHFKeychainUtils getPasswordForUsername:myString andServiceName:SERVICE_NAME error:nil];

    self.numberField.text = passWord;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)regist: (id)sender
{
    [self performSegueWithIdentifier:@"MainToChangePassword" sender:self];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self.numberField resignFirstResponder];
    [self.nameField resignFirstResponder];
    NSDictionary* dicArg = @{@"username":[self.nameField.text lowercaseString],
                          @"password":[self.numberField.text lowercaseString]};
    [_webServiceController SendHttpRequestWithMethod:@"/addressBooks/absapi/login" argsDic:dicArg success:^(NSDictionary* dic){
        [self HttpSuccessDictionaryCallBack:dic];
    }];
}
- (IBAction)cancelButtonPressed: (id)sender
{
     exit(0);
}
- (IBAction)textFieldDoneEditing:(id)sender
{
    [self.numberField resignFirstResponder];
    [self.nameField resignFirstResponder];
}
- (IBAction)backgroundTap:(id)sender
{
    [self.numberField resignFirstResponder];
    [self.nameField resignFirstResponder];
}
-(void)HttpSuccessDictionaryCallBack:(NSDictionary *)result
{
    //[BPush bindChannel];

    XYLUserInfo* userInfo = [[XYLUserInfo alloc] initWithDictionary:result[@"data"] error:nil];
    XYLUserInfoBLL* bll = [XYLUserInfoBLL shareUserInfoBLL];
    bll.userInfo = userInfo;
    bll.token = result[@"token"];
    [userDefaultes setObject:self.nameField.text forKey:USERNAMEKEY];
    [SFHFKeychainUtils storeUsername:self.nameField.text andPassword:self.numberField.text forServiceName:SERVICE_NAME updateExisting:1 error:nil];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    NSArray *controllerArray = [NSArray arrayWithObjects:@"InTimeViewController",@"FunctionViewController",@"SettingViewController" ,nil];//类名数组
    NSArray *titleArray = [NSArray arrayWithObjects:@"众筹",@"通讯录",@"我的", nil];//item标题数组
    NSArray *normalImageArray = [NSArray arrayWithObjects:@"icon_square_nor.png",@"icon_meassage_nor.png",@"icon_selfinfo_nor.png", nil];//item 正常状态下的背景图片
    NSArray *selectedImageArray = [NSArray arrayWithObjects:@"icon_square_sel.png",@"icon_meassage_sel.png",@"icon_selfinfo_sel.png",nil];//item被选中时的图片名称
    
    for (int i = 0; i< controllerArray.count; i++) {
        MALTabBarItemModel *itemModel = [[MALTabBarItemModel alloc] init];
        itemModel.controllerName = controllerArray[i];
        itemModel.itemTitle = titleArray[i];
        itemModel.itemImageName = normalImageArray[i];
        itemModel.selectedItemImageName = selectedImageArray[i];
        [itemsArray addObject:itemModel];
    }
    
    tabberViewController = [[MALTabBarViewController alloc] initWithItemModels:itemsArray defaultSelectedIndex:0];
    [self presentViewController:tabberViewController animated:YES completion:nil];
}
-(void)HttpFailCallBack:(NSString *)errorMessage
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}
@end
