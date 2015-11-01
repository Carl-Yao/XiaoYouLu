//
//  SearchFriendViewController.h
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/10/31.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceController.h"

@interface SearchFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    WebServiceController *_webServiceController;
}

@end
