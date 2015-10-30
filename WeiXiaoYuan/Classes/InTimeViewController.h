//
//  InTimeViewController.h
//  WeiX    Ω≈iaoYuan
//
//  Created by 姚振兴 on 14-10-10.
//
//

#import <UIKit/UIKit.h>
#import "EasyJSWebView.h"
#import "DetailForMessageViewController.h"
#import "AppDelegate.h" 
#import "MALTabBarChinldVIewControllerDelegate.h"
#import "WebServiceController.h"

@interface InTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray* messages;
@property(nonatomic,retain)AppDelegate* myAppDelegate;
@property (strong,nonatomic) DetailForMessageViewController* detailViewController;
@property (nonatomic, assign) id<MALTabBarChinldVIewControllerDelegate>delegate;
@property (strong, nonatomic) WebServiceController* webServiceController;

//-(NSString*)recordlist;
@end
//
//@interface InTimeCommandDelegate : CDVCommandDelegateImpl
//@end
//
//@interface InTimeCommandQueue : CDVCommandQueue
//@end

