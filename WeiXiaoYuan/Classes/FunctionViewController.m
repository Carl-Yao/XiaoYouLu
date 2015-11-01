//
//  FunctionViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-10.
//
//

#import "FunctionViewController.h"
#import "AppButton.h"
#import "UIColor+Addition.h"
#import "UIView+ViewFrameGeometry.h"
#import "BackButton.h"
#import "NewFriendListViewController.h"
#import "MBProgressHUD.h"
#import "XYLUserInfoBLL.h"
#import "SearchFriendViewController.h"
#import "PersonInfoViewController.h"

@interface FunctionViewController()
{
    UITableView * table;
    NSMutableArray * friends;
    NSMutableArray* dataArr;
}
@end
@implementation FunctionViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Stationary Background, so that while the user scroll the background is
    // fixed.
//    UIImage *bj = [UIImage imageNamed:@"bj.jpg"];
//    UIImageView *bjview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64-1, self.view.frame.size.width, self.view.frame.size.height - 64-49+1)];
//    bjview.image = bj;
//    [self.view insertSubview:bjview atIndex:0];
    //top
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, self.view.frame.size.width+4, 34+2+rect.size.height)];
    view.backgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    [self.view insertSubview:view atIndex:0];
    
    //title
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height+1, self.view.frame.size.width , 34)];
    laber.text = @"通讯录";
    laber.textColor = [UIColor blackColor];
    laber.font = [UIFont boldSystemFontOfSize:20];
    laber.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:laber];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    BackButton *joinButton = [[BackButton alloc] initWithFrame:CGRectMake(self.view.width-64 -8, -2+20 + 6, 64, 48-20)];
    [joinButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.view insertSubview:joinButton atIndex:1];
    [joinButton addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *search = [[UIButton alloc] initWithFrame:CGRectMake(1, view.bottom+6, self.view.frame.size.width-2, 24)];
    search.layer.borderWidth = 0.5;
    search.layer.cornerRadius = 12;
    search.layer.masksToBounds = YES;
    [self.view addSubview:search];
    [search addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 12, 12)];
    [searchImg setImage:[UIImage imageNamed:@"ktv_ksong_searchbtn"]];
    [search addSubview:searchImg];
    UILabel* searchTitle = [[UILabel alloc] initWithFrame:CGRectMake(22+2, 4, search.width - 22-2, 16)];
    searchTitle.backgroundColor = [UIColor clearColor];
    searchTitle.font = [UIFont systemFontOfSize: 12];
    searchTitle.textColor = [UIColor grayColor];
    searchTitle.text = @"同城搜索／同行业搜索";
    [search addSubview:searchTitle];
    
    //列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, search.bottom, self.view.frame.size.width, self.view.frame.size.height - search.bottom -50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    friends = [[NSMutableArray alloc]init];
    [friends addObject:@"新的朋友"];
    //[friends addObject:@"群聊"];
    [table reloadData];
    _webServiceController = [WebServiceController shareController:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.delegate setBadgeNumber:0 index:0];
    //加未读标示
    //dispatch_async(dispatch_get_main_queue(), ^{
        
        [_webServiceController SendHttpRequestWithMethod:@"/absapi/absfriends/list" argsDic:@{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"searchArea":@"0", @"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
            dataArr = dic[@"data"];
            if (dataArr) {
                friends = [[NSMutableArray alloc]init];
                [friends addObject:@"新的朋友"];
                //[friends addObject:@"群聊"];
                for (NSDictionary* itemDic in dataArr) {
                    NSString *info = itemDic[@"friendsName"]?:@"NULL";
                    [friends addObject:info];
                }
                [table reloadData];
            }
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    //});
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [friends objectAtIndex: indexPath.row];
    //cell.rightContent = [friends objectAtIndex: indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        NewFriendListViewController* vc = [[NewFriendListViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        PersonInfoViewController* vc = [[PersonInfoViewController alloc] init];
        vc.isOwn = NO;
        vc.userId = dataArr[indexPath.row-1][@"friendsId"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)searchBtn
{
    SearchFriendViewController* vc = [[SearchFriendViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
