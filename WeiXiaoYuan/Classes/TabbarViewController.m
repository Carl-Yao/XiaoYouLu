//
//  TabbarViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-15.
//
//

#import "TabbarViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.tabBar setBackgroundColor:[UIColor blackColor]];
    CGRect frame = CGRectMake(0,0,320,50);
    
    UIView *v = [[UIView alloc]initWithFrame:frame];
    
    [v setBackgroundColor:[[UIColor alloc]initWithRed:70.0/255.0
                           
                                                green:65.0/255.0
                           
                                                 blue:62.0/255.0
                           
                                                alpha:1.0]];
    [self.tabBar insertSubview:v atIndex:0];
    self.selectedIndex = 1;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
