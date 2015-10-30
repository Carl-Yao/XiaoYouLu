//
//  DetailForMessageViewController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 15/1/5.
//  Copyright (c) 2015年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendInfo.h"
@interface DetailForMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) RecommendInfo* recommendInfo;
@end
