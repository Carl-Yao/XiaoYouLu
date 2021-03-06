//
//  ClassListViewController.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/11/2.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "ClassListViewController.h"
#import "BackButton.h"
#import "InTimeViewController.h"
#import "DBImageView.h"
#import "SJAvatarBrowser.h"
#import "UIColor+Addition.h"
#import "UIView+ViewFrameGeometry.h"
#import "XYLUserInfoBLL.h"
#import "KGProgressView.h"
#import "PersonInfoViewController.h"

@interface ClassListViewController ()
{
    UITableView *table;
    NSMutableArray* newFriends;
    NSMutableArray* dataArr;
}
@end

@implementation ClassListViewController

- (void)btnClicked:(id)sender event:(id)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    laber.text = @"班级通讯录";
    laber.textColor = [UIColor blackColor];
    laber.font = [UIFont systemFontOfSize:20];
    laber.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:laber atIndex:1];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    BackButton *returnButton = [[BackButton alloc] initWithFrame:CGRectMake(-2+10, -2+20 + 6, 150, 48-20)];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    //换返回按钮图标和文字
    UIImage *image1 = [UIImage imageNamed:@"biz_pics_main_back_normal.png"];
    [returnButton setImage:image1 forState:UIControlStateNormal];
    [self.view insertSubview:returnButton atIndex:1];
    [returnButton addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    //列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, view.bottom+10, self.view.frame.size.width, self.view.frame.size.height - view.bottom) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    
    //    newFriends = [[NSMutableArray alloc]init];
    //    for (int i = 1; i < 8; i++) {
    //        NSString* info = [[NSString alloc] init];
    //        info = [NSString stringWithFormat:@"新的朋友%d",i];
    //        [newFriends addObject:info];
    //    }
    
    _webServiceController = [WebServiceController shareController:self.view];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [_webServiceController SendHttpRequestWithMethod:@"/absapi/absuserinfo/listUserByClass" argsDic:@{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
        dataArr = dic[@"data"];
        if (dataArr) {
            newFriends = [[NSMutableArray alloc]init];
            for (NSDictionary* itemDic in dataArr) {
                NSString *info = itemDic[@"name"]?:@"NULL";
                [newFriends addObject:info];
            }
            [table reloadData];
        }
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [newFriends objectAtIndex: indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonInfoViewController* vc = [[PersonInfoViewController alloc] init];
    vc.isOwn = NO;
    vc.userId = dataArr[indexPath.row][@"friendsId"];
    //[self presentViewController:vc animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
