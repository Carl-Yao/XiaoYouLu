//
//  NewFriendListViewController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 15/10/15.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceController.h"

@interface NewFriendListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    WebServiceController *_webServiceController;
}
@end
