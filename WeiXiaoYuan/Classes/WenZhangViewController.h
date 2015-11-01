//
//  WenZhangViewController.h
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/11/1.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceController.h"
#import "DKScrollingTabController.h"
#import "MALTabBarViewController.h"

@interface WenZhangViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DKScrollingTabControllerDelegate>
{
    WebServiceController *_webServiceController;
}
@property (nonatomic, assign) id<MALTabBarChinldVIewControllerDelegate>delegate;
@end
