//
//  EditProperyViewController.h
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/10/31.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceController.h"

@interface EditProperyViewController : UIViewController
{
    WebServiceController *_webServiceController;
}
@property (nonatomic,strong)NSString* titleStr;
@property (nonatomic,strong)NSString* propery;
@property (nonatomic, strong) UITextView * textField;
@property (nonatomic,assign)NSInteger type;//0:基本 1:学校 2:工作
@end
