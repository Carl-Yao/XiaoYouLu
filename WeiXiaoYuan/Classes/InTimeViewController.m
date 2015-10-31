//
//  InTimeViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14-10-10.
//
//

#import "InTimeViewController.h"
#import "User.h"
#import "SBJson.h"
#import "DBImageView.h"
#import "MBProgressHUD.h"
#import "SGFocusImageItem.h"
#import "SGFocusImageFrame.h"
#import "UIColor+Addition.h"
#import "UIView+ViewFrameGeometry.h"
#import "DKScrollingTabController.h"
#import "RecommendInfo.h"

@interface InTimeViewController ()<SGFocusImageFrameDelegate>
{
    UITableView *table;
    
    NSInteger selectIndex;
}

@end

@implementation InTimeViewController
@synthesize messages;
@synthesize detailViewController;
@synthesize delegate;
@synthesize webServiceController;

- (void)viewDidLoad
{
    //top
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, self.view.frame.size.width+4, 34+2+rect.size.height)];
    view.backgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    [self.view insertSubview:view atIndex:0];
    
    //title
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height+1, self.view.frame.size.width , 34)];
    laber.text = @"众筹";
    laber.textColor = [UIColor blackColor];
    laber.font = [UIFont boldSystemFontOfSize:20];
    laber.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:laber atIndex:1];

    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];

    UIButton *search = [[UIButton alloc] initWithFrame:CGRectMake(1, view.bottom+2, self.view.frame.size.width-2, 24)];
    search.layer.borderWidth = 0.5;
    search.layer.cornerRadius = 12;
    search.layer.masksToBounds = YES;
    [self.view addSubview:search];
    UIImageView* searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 12, 12)];
    [searchImg setImage:[UIImage imageNamed:@"ktv_ksong_searchbtn"]];
    [search addSubview:searchImg];
    UILabel* searchTitle = [[UILabel alloc] initWithFrame:CGRectMake(22+2, 4, search.width - 22-2, 16)];
    searchTitle.backgroundColor = [UIColor clearColor];
    searchTitle.font = [UIFont systemFontOfSize: 12];
    searchTitle.textColor = [UIColor grayColor];
    searchTitle.text = @"搜索活动";
    [search addSubview:searchTitle];
    
//    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(2, search.bottom+2, 48, 30)];
//    [btn1 setTitle:@"推荐" forState:UIControlStateNormal];
//    [btn1 setBackgroundColor:[UIColor colorWithHexString:@"#49c9d6"]];
//    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:btn1];
//    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn1.right+2, search.bottom+2, 48, 30)];
//    [btn2 setTitle:@"公益" forState:UIControlStateNormal];
//    btn2.titleLabel.textColor = [UIColor blackColor];
//    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:btn2];
//    UIButton* btn3 = [[UIButton alloc] initWithFrame:CGRectMake(btn2.right+2, search.bottom+2, 48, 30)];
//    [btn3 setTitle:@"股权" forState:UIControlStateNormal];
//    btn3.titleLabel.textColor = [UIColor blackColor];
//    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn3.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:btn3];
//    UIButton* btn4 = [[UIButton alloc] initWithFrame:CGRectMake(btn3.right+2, search.bottom+2, 48, 30)];
//    [btn4 setTitle:@"商品" forState:UIControlStateNormal];
//    btn4.titleLabel.textColor = [UIColor blackColor];
//    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn4.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:btn4];
    
    
    DKScrollingTabController *leftTabController = [[DKScrollingTabController alloc] init];
    leftTabController.delegate = self;
    [self addChildViewController:leftTabController];
    [leftTabController didMoveToParentViewController:self];
    [self.view addSubview:leftTabController.view];
    leftTabController.view.frame = CGRectMake(0, search.bottom+2, self.view.frame.size.width, 30);
    leftTabController.view.backgroundColor = [UIColor clearColor];
    leftTabController.buttonPadding = 10;
    leftTabController.underlineIndicator = YES;
    leftTabController.underlineIndicatorColor = [UIColor colorWithHexString:@"#49c996"];
    leftTabController.buttonsScrollView.showsHorizontalScrollIndicator = NO;
    leftTabController.selectedBackgroundColor = [UIColor colorWithHexString:@"#49c9d6"];
    leftTabController.selectedTextColor = [UIColor blackColor];
    leftTabController.unselectedTextColor = [UIColor blackColor];
    leftTabController.unselectedBackgroundColor = [UIColor clearColor];
    leftTabController.buttonInset = 12;
    leftTabController.selectionFont = [UIFont systemFontOfSize:14];
    leftTabController.selection = [[NSArray alloc]initWithObjects:@"PLACE",@"PLACE",@"PLACE",@"PLACE",nil];
    int i = 0;
    NSArray* titles = @[@"推荐",@"公益",@"股权",@"商品"];
    for (id object in titles) {
        [leftTabController setButtonName:object atIndex:i++];
    }
    [leftTabController.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }];
    
    //滚动图
    //添加最后一张图 用于循环
    int length = 4;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"title%d",i],@"title" ,nil];
        [tempArray addObject:dict];
    }
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    if (length > 1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    __weak InTimeViewController*weakSelf = self;
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, leftTabController.view.bottom+2, 320, 140) delegate:weakSelf imageItems:itemArray isAuto:YES];
    [bannerView scrollToIndex:2];
    [self.view addSubview:bannerView];
    
    //列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, bannerView.bottom, self.view.frame.size.width, self.view.frame.size.height - bannerView.bottom -50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.messages = [[NSMutableArray alloc]init];
    for (int i = 1; i < 6; i++) {
        RecommendInfo* info = [[RecommendInfo alloc] init];
        info.relatePersonNum = 100;
        info.title = [NSString stringWithFormat:@"推荐众筹%d",i];
        info.content = @"最新的技术，最新的产品";
        info.date = @"2015-2-3 10:31";
        [self.messages addObject:info];
    }
    
    _webServiceController = [WebServiceController shareController:self.view];
    [super viewDidLoad];
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.delegate setBadgeNumber:0 index:0];
    [_webServiceController SendHttpRequestWithMethod:@"/addressBooks/manager/absarticle/absapi/search" argsDic:@{@"userid":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
        NSArray* dataArr = dic[@"data"];
        if (dataArr) {
            messages = [[NSMutableArray alloc]init];
            for (NSDictionary* itemDic in dataArr) {
                NSString *info = itemDic[@"trandate"];
                [messages addObject:info];
            }
            [table reloadData];
        }
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
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
        UIImageView *separatorLine = (UIImageView *)[cell viewWithTag:4];
        separatorLine.hidden = YES;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellStyleSubtitle;
        }
        else
        {
            cell.selectionStyle = UITableViewCellStyleSubtitle;
        }
        
        DBImageView *imageView = [[DBImageView alloc] initWithFrame:(CGRect){ 5, 5, 70, 55 }];
        [imageView setPlaceHolder:[UIImage imageNamed:@"Placeholder"]];
        [imageView setTag:101];
        [cell.contentView addSubview:imageView];
        
        UILabel* title = [[UILabel alloc] initWithFrame:(CGRect){85,2,cell.frame.size.width-80-40,22-2}];
        [title setTag:102];
        [title setFont:[UIFont boldSystemFontOfSize:15]];
        [cell.contentView addSubview:title];

        UILabel* content = [[UILabel alloc] initWithFrame:(CGRect){85,22,cell.frame.size.width-80-40,20}];
        [content setTag:103];
        content.textColor = [UIColor blueColor];
        [content setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:content];
        
        UILabel* sender = [[UILabel alloc] initWithFrame:(CGRect){85,42,(cell.frame.size.width-80-40)/2,18}];
        [sender setTag:104];
        [sender setFont:[UIFont systemFontOfSize:11]];
        [cell.contentView addSubview:sender];
        
        UILabel* date = [[UILabel alloc] initWithFrame:(CGRect){85+(cell.frame.size.width-80-40)/2,48,(cell.frame.size.width-60-40)/2,12}];
        [date setTag:105];
        date.textAlignment = NSTextAlignmentRight;
        [date setFont:[UIFont systemFontOfSize:11]];
        [cell.contentView addSubview:date];
        
        UILabel* relateNum = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 120, 2, 100, 22-2)];
        [relateNum setTag:106];
        relateNum.textAlignment = NSTextAlignmentRight;
        [relateNum setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:relateNum];
    }
    RecommendInfo* info = [self.messages objectAtIndex:indexPath.row];
    //User *user = [self.messages objectAtIndex:indexPath.row];
    
    NSString *pushTitle = info.title;//user.pushTitle;
    NSString *pushImage = @"tx.png";//[user.pushImage isEqualToString:@""]?@"tx.png":user.pushImage;
    NSString *pushSender = @"";
    NSString *pushDate = info.date;
    NSString *pushContent = info.content;
    
    //cell.textLabel.text = pushTitle;
    [(UILabel *)[cell viewWithTag:102] setText:pushTitle];

    //NSString *detail = [NSString stringWithFormat:@"%@   %@",pushSender, pushDate];
    //cell.detailTextLabel.text = detail;
    [(UILabel *)[cell viewWithTag:103] setText:pushContent];
    [(UILabel *)[cell viewWithTag:104] setText:pushSender];
    [(UILabel *)[cell viewWithTag:105] setText:pushDate];
    [(UILabel *)[cell viewWithTag:106] setText:[NSString stringWithFormat:@"参与人数：%@", @(info.relatePersonNum),nil]];
    //[cell.imageView setImageWithURL:[NSURL URLWithString:artworkUrl60]
                 //  placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];
    //用来占位
    //[cell.imageView setImage:[UIImage imageNamed:@"tx.png"]];
    //下载图片并缓存
    [(DBImageView *)[cell viewWithTag:101] setImageWithPath:pushImage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendInfo *info = [self.messages objectAtIndex:indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        DetailForMessageViewController* controller = [[DetailForMessageViewController alloc] init];
        controller.recommendInfo = info;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        self.detailViewController.recommendInfo = info;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myAppDelegate del:((User*)(self.messages[indexPath.row])).pushID];
    [self.messages removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark - TabControllerDelegate

- (void)DKScrollingTabController:(DKScrollingTabController *)controller selection:(NSUInteger)selection {
    NSLog(@"Selection controller action button with index=%d",selection);
    selectIndex = selection;
    
    
}

@end

