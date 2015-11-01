//
//  PersonInfoViewController.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/10/31.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UIColor+Addition.h"
#import "BackButton.h"
#import "InTimeViewController.h"
#import "DBImageView.h"
#import "SJAvatarBrowser.h"
#import "UIView+ViewFrameGeometry.h"
#import "XYLUserInfoBLL.h"
#import "KGProgressView.h"
#import "EditProperyViewController.h"
#import "XYLCommonTableViewCell.h"

@interface PersonInfoViewController ()
{
    UITableView *table;
    NSDictionary* dataDic;
    NSMutableArray* propretys;
}
@end

@implementation PersonInfoViewController
- (id)init {
    self = [super init];
    if (self)
        self.isOwn = false;
    return self;
}

- (void)btnClicked:(id)sender event:(id)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //top
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, self.view.frame.size.width+4, 34+2+rect.size.height)];
    view.backgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    [self.view insertSubview:view atIndex:0];
    
    //title
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height+1, self.view.frame.size.width , 34)];
    laber.text = @"个人信息";
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
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [_webServiceController SendHttpRequestWithMethod:@"/absapi/absuserinfo/viewUserInfo" argsDic:@{@"id":(self.isOwn?[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid:self.userId), @"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
        dataDic = dic[@"data"][@"absUserinfo"];
        if (dataDic) {
            propretys = [[NSMutableArray alloc]init];
            NSMutableDictionary* item = [[NSMutableDictionary alloc]init];
            [item setObject:@"姓名" forKey:@"title"];
            [item setObject:dataDic[@"username"]?:@"null" forKey:@"content"];
            [item setObject:@"username" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"性别" forKey:@"title"];
            [item setObject:dataDic[@"sex"]?:@"null" forKey:@"content"];
            [item setObject:@"sex" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"城市" forKey:@"title"];
            [item setObject:dataDic[@"addr"]?:@"null" forKey:@"content"];
            [item setObject:@"addr" forKey:@"propery"];
            [propretys addObject:item];
        
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"生日" forKey:@"title"];
            [item setObject:dataDic[@"birthday"]?:@"null" forKey:@"content"];
            [item setObject:@"birthday" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"地址" forKey:@"title"];
            [item setObject:dataDic[@"dtAddr"]?:@"null" forKey:@"content"];
            [item setObject:@"dtAddr" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"电话号码" forKey:@"title"];
            [item setObject:dataDic[@"dn"]?:@"null" forKey:@"content"];
            [item setObject:@"dn" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"等级" forKey:@"title"];
            [item setObject:dataDic[@"level"]?:@"null" forKey:@"content"];
            [item setObject:@"level" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"邮箱" forKey:@"title"];
            [item setObject:dataDic[@"mail"]?:@"null" forKey:@"content"];
            [item setObject:@"mail" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"qq" forKey:@"title"];
            [item setObject:dataDic[@"qq"]?:@"null" forKey:@"content"];
            [item setObject:@"qq" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"微信" forKey:@"title"];
            [item setObject:dataDic[@"wechat"]?:@"null" forKey:@"content"];
            [item setObject:@"wechat" forKey:@"propery"];
            [propretys addObject:item];
            
            item = [[NSMutableDictionary alloc]init];
            [item setObject:@"密码" forKey:@"title"];
            [item setObject:@"***" forKey:@"content"];
            [item setObject:@"password" forKey:@"propery"];
            [propretys addObject:item];
            
            [table reloadData];
        }
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;//[[dataDic allKeys] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    XYLCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[XYLCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[propretys objectAtIndex:indexPath.row][@"title"],nil];
    cell.rightContent.text = [propretys objectAtIndex:indexPath.row][@"content"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isOwn) {
        return;
    }
    EditProperyViewController* vc = [[EditProperyViewController alloc] init];
    vc.titleStr = propretys[indexPath.row][@"title"];
    vc.propery = propretys[indexPath.row][@"propery"];
    [self presentViewController:vc animated:YES completion:nil];
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
