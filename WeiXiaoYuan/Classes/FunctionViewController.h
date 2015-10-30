//
//  FunctionViewController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-10.
//
//

#import <UIKit/UIKit.h>
#import "MALTabBarChinldVIewControllerDelegate.h"


@interface FunctionViewController:UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *m_arData;
    NSMutableArray *m_image;
    NSDictionary* allModelsDic;
    NSDictionary* allFunctionsDic;
}
@property (nonatomic, assign) id<MALTabBarChinldVIewControllerDelegate>delegate;


@end


