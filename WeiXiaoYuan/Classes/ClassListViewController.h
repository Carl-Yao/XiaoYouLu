//
//  ClassListViewController.h
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/11/2.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceController.h"

@interface ClassListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    WebServiceController *_webServiceController;
}
@end
