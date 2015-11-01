//
//  LoginViewController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-9.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceController.h"
#import "KeychainItemWrapper.h"
#import "MALTabBarViewController.h"
@interface LoginViewController : UIViewController
{
    WebServiceController *_webServiceController;
    NSUserDefaults *userDefaultes;
    KeychainItemWrapper *wrapper;
    
}
- (IBAction)loginButtonPressed: (id)sender;
- (IBAction)cancelButtonPressed: (id)sender;
- (IBAction)regist: (id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@property (nonatomic,strong)MALTabBarViewController* tabberViewController;
@end
