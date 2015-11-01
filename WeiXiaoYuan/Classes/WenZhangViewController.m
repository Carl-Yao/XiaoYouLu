//
//  WenZhangViewController.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/11/1.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "WenZhangViewController.h"
#import "UIColor+Addition.h"
#import "UIView+ViewFrameGeometry.h"
#import "DKScrollingTabController.h"
#import "RecommendInfo.h"
#import "KGProgressView.h"
#import "PersonInfoViewController.h"
#import "DetailForMessageViewController.h"
#import "XYLCommonTableViewCell.h"
#import "KTVDateFormatter.h"

@interface WenZhangViewController ()<DKScrollingTabControllerDelegate>{
    UITableView *table;
    NSMutableArray* dataArr;
    NSInteger selectIndex;
    DKScrollingTabController *leftTabController;
}

@end

@implementation WenZhangViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myZY) name:@"WODEZIYUAN" object:nil];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)myZY{
    [leftTabController selectButtonWithIndex:1];
    [_webServiceController SendHttpRequestWithMethod:@"/absapi/abssource/search" argsDic:@{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
        dataArr = dic[@"data"];
        if (dataArr) {
            [table reloadData];
        }
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)viewDidLoad {
    //top
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, self.view.frame.size.width+4, 34+2+rect.size.height)];
    view.backgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    [self.view insertSubview:view atIndex:0];
    
    //title
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height+1, self.view.frame.size.width , 34)];
    laber.text = @"文章";
    laber.textColor = [UIColor blackColor];
    laber.font = [UIFont boldSystemFontOfSize:20];
    laber.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:laber atIndex:1];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    leftTabController = [[DKScrollingTabController alloc] init];
    leftTabController.delegate = self;
    [self addChildViewController:leftTabController];
    [leftTabController didMoveToParentViewController:self];
    [self.view addSubview:leftTabController.view];
    leftTabController.view.frame = CGRectMake(0, view.bottom+2, self.view.frame.size.width, 30);
    leftTabController.view.backgroundColor = [UIColor clearColor];
    leftTabController.buttonPadding = 0;
    leftTabController.underlineIndicator = YES;
    leftTabController.underlineIndicatorColor = [UIColor colorWithHexString:@"#49c996"];
    leftTabController.buttonsScrollView.showsHorizontalScrollIndicator = NO;
    leftTabController.selectedBackgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    leftTabController.selectedTextColor = [UIColor blackColor];
    leftTabController.unselectedTextColor = [UIColor blackColor];
    leftTabController.unselectedBackgroundColor = [UIColor clearColor];
    leftTabController.buttonInset = 12;
    leftTabController.selectionFont = [UIFont systemFontOfSize:14];
    leftTabController.selection = [[NSArray alloc]initWithObjects:@"PLACEPPPPLACEPPPPP",@"PLACEPPPPLACEPPPPP",nil];
    int i = 0;
    NSArray* titles = @[@"文章",@"资源"];
    for (id object in titles) {
        [leftTabController setButtonName:object atIndex:i++];
    }
    [leftTabController.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }];
    
    //列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, leftTabController.view.bottom+4, self.view.frame.size.width, self.view.frame.size.height - leftTabController.view.bottom -50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    selectIndex = 0;
    _webServiceController = [WebServiceController shareController:self.view];
    [_webServiceController SendHttpRequestWithMethod:@"/absapi/absarticle/search" argsDic:@{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
        dataArr = dic[@"data"];
        if (dataArr) {
            [table reloadData];
        }
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.delegate setBadgeNumber:0 index:0];
    //加未读标示
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    //});
}

#pragma mark - TabControllerDelegate

- (void)DKScrollingTabController:(DKScrollingTabController *)controller selection:(NSUInteger)selection {
    NSLog(@"Selection controller action button with index=%d",selection);
    selectIndex = selection;
    NSString* str;
    if (selection == 1) {
        str = @"/absapi/abssource/search";
        [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
            dataArr = dic[@"data"];
            if (dataArr) {
                [table reloadData];
            }
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        str = @"/absapi/absarticle/search";
        [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
            dataArr = dic[@"data"];
            if (dataArr) {
                [table reloadData];
            }
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    XYLCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[XYLCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [dataArr objectAtIndex: indexPath.row][@"title"];
    NSString* aaa = [dataArr objectAtIndex: indexPath.row][@"createTime"];
    NSString * date = [KTVDateFormatter formatSecondToDataString:[aaa longLongValue]];
    //cell.rightContent.text = date;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str;
    if (selectIndex == 1) {
        str = @"/absapi/abssource/viewSourceDetail";
    }else{
        str = @"/absapi/absarticle/viewArticleDetail";
    }
    [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"id":dataArr[indexPath.row][@"id"],@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
        NSDictionary* dataDic = dic[@"data"];
        
        DetailForMessageViewController* controller = [[DetailForMessageViewController alloc] init];
        RecommendInfo* info = [[RecommendInfo alloc] init];
        info.title = dataDic[@"title"];
        info.content = dataDic[@"context"];
        //info.date = @"date";
        info.relatePersonNum = 0;//dataDic[@""];
        //info.imgUrl
        controller.recommendInfo = info;
        [self presentViewController:controller animated:YES completion:nil];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
