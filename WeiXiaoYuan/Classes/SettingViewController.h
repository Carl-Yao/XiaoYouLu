//
//  SettingViewController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-10.
//
//

#import <UIKit/UIKit.h>
//#import <Cordova/CDVViewController.h>
//#import <Cordova/CDVCommandDelegateImpl.h>
//#import <Cordova/CDVCommandQueue.h>
#import "MALTabBarChinldVIewControllerDelegate.h"


@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UITableView *tableView;
}
@property (nonatomic, strong) UIImageView *portraitImageView;

@property (strong, nonatomic)NSArray *tasks;
@property (nonatomic, assign) id<MALTabBarChinldVIewControllerDelegate>delegate;


@end
