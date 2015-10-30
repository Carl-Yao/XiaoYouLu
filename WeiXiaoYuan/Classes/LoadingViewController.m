//
//  LoadingViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-12.
//
//

#import "LoadingViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

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
    //[NSThread sleepForTimeInterval:0.5];
    
    UIImage *image = [UIImage imageNamed:@"welcome4.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = image;
    [self.view insertSubview:imageView atIndex:0];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self do];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [NSThread detachNewThreadSelector:@selector(checkLogin:) toTarget:self withObject:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkLogin:(id)sender
{
    [NSThread sleepForTimeInterval:1];
    //[NSThread sleepForTimeInterval:0.5];
    [self performSegueWithIdentifier:@"Login" sender:self];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    // Override point for customization after application launch.
    return YES;
}
-(BOOL)prefersStatusBarHiddenChange{
    
    //if(self.bHiddenBar)
        
        return YES;
    
    //else return NO;
    
}

-(void)do{
    
    //self.bHiddenBar = YES;
    
    [self prefersStatusBarHidden];
    
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
}
@end
