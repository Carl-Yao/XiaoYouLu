//
//  SearchFriendViewController.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/10/31.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "UIColor+Addition.h"
#import "BackButton.h"
#import "UIView+ViewFrameGeometry.h"
#import "KTVInsetsTextField.h"
#import "KGProgressView.h"
#import "PersonInfoViewController.h"

@interface SearchFriendViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UITableView *table;
    NSMutableArray* newFriends;
    KTVInsetsTextField* searchtext;
    UIButton* cancelbtn;
    UIButton* searchbtn;
    NSMutableArray* dataArr;
}

@end

@implementation SearchFriendViewController
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
    laber.text = @"查找朋友";
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
    
    
    //    newFriends = [[NSMutableArray alloc]init];
    //    for (int i = 1; i < 8; i++) {
    //        NSString* info = [[NSString alloc] init];
    //        info = [NSString stringWithFormat:@"新的朋友%d",i];
    //        [newFriends addObject:info];
    //    }
    
    _webServiceController = [WebServiceController shareController:self.view];
    
    // Do any additional setup after loading the view.
    UIView *seachbg = [[UIView alloc]initWithFrame:CGRectMake(0, view.bottom, self.view.frame.size.width, 44)];
    seachbg.backgroundColor = [UIColor colorWithHexString:@"#e7e7e7"];
    [self.view addSubview:seachbg];
    
    UIView* seachtextbg = [[UIView alloc]initWithFrame:CGRectMake(9, 7, self.view.frame.size.width - 18, 30)];
    seachtextbg.backgroundColor = [UIColor whiteColor];
    seachtextbg.layer.cornerRadius = 3;
    seachtextbg.layer.borderColor = [UIColor colorWithHexString:@"#cdcdcd"].CGColor;
    seachtextbg.layer.borderWidth = 0.5;
    [seachbg addSubview:seachtextbg];
    
    searchtext = [[KTVInsetsTextField alloc]initWithFrame:CGRectMake(11, 9, self.view.frame.size.width - 34-11-16, 27)];
    searchtext.font = [UIFont systemFontOfSize:13];
    searchtext.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchtext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    searchtext.delegate = self;
    searchtext.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchtext.backgroundColor = [UIColor clearColor];
    searchtext.placeholder = @" 歌曲名/歌手名";
    searchtext.textAlignment = UITextAlignmentLeft;
    [searchtext setRightViewMode:UITextFieldViewModeNever];
    [searchtext setLeftViewMode:UITextFieldViewModeNever];
    searchtext.autocorrectionType = UITextAutocorrectionTypeYes;//启用自动提示更正功能
    searchtext.returnKeyType = UIReturnKeySearch;//设置键盘完成按钮，相应的还有“Return”"Gｏ""Google"等
    [seachbg addSubview:searchtext];
    
    UIView* separateView = [[UIView alloc] initWithFrame:CGRectMake(-5, 5, 0.5, 20)];
    separateView.backgroundColor = [UIColor colorWithHexString:@"#797d80"];
    
    searchbtn = [[UIButton alloc] init];
    
    [searchbtn setTitle: @"搜索" forState:UIControlStateNormal];
    searchbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchbtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    searchbtn.frame = CGRectMake(seachtextbg.frame.size.width - 34, 0, 30, 30);
    [searchbtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    //[searchbtn setImageEdgeInsets:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)];
    [searchbtn addSubview:separateView];
    [seachtextbg addSubview:searchbtn];
    searchbtn.hidden = YES;
    
    UIView* separateView1 = [[UIView alloc] initWithFrame:CGRectMake(-5, 5, 0.5, 20)];
    separateView1.backgroundColor = [UIColor colorWithHexString:@"#797d80"];
    
    cancelbtn = [[UIButton alloc] init];
    [cancelbtn setTitle: @"取消" forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelbtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    cancelbtn.frame = CGRectMake(seachtextbg.frame.size.width - 34, 0, 30, 30);
    [cancelbtn addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelbtn addSubview:separateView1];
    [seachtextbg addSubview:cancelbtn];
    //cancelbtn.hidden = YES;
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
    [tapGesture addTarget:self action:@selector(respondsText)];
    [seachbg addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    //列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, seachbg.bottom+10, self.view.frame.size.width, self.view.frame.size.height - view.bottom) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    
    [searchtext becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)respondsText
{
    [searchtext resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doSearch];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self setTextFieldButtonHiden:textField.text];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string != nil) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 0)
        {
            if ([toBeString length] > 64) {
                float height = (self.view.frame.size.height - 252)/2 - (self.view.frame.size.height - 30)/2;
//                [self setTipsViewYAlign:height>0?0:height];
//                [self showErrorWithStatus:@"超出64个字符！" duration:1];
//                [self setTipsViewYAlign:0];
            }
            [self setTextFieldButtonHiden:toBeString];
        }
        else{
            if ([string isEqualToString:@""] && (range.length <= 1)) {
                [self setTextFieldButtonHiden:nil];
            }
        }
        NSRange strRange = [toBeString rangeOfString:toBeString];
        if (NSEqualRanges(strRange, range)) {
            [self setTextFieldButtonHiden:nil];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    searchbtn.hidden = NO;
    cancelbtn.hidden = YES;
}

-(void)setTextFieldButtonHiden:(NSString*)string
{
    if (string != nil && ![string isEqualToString:@""]) {
        searchbtn.hidden = NO;
        cancelbtn.hidden = YES;
    }else
    {
        searchbtn.hidden = YES;
        cancelbtn.hidden = NO;
    }
}
-(void)doCancel
{
    [searchtext resignFirstResponder];
    cancelbtn.hidden = YES;
    searchbtn.hidden = NO;
}

- (void)doSearch
{
    if (searchtext.text.length == 0) {
        float height = (self.view.frame.size.height - 252)/2 - (self.view.frame.size.height - 30)/2;
//        [self setTipsViewYAlign:height>0?0:height];
//        [self showErrorWithStatus:@"请输入搜索内容！" duration:1];
        [searchtext becomeFirstResponder];
        return;
    }
    
    NSString * searchstr = [searchtext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchstr.length == 0) {
        float height = (self.view.frame.size.height - 252)/2 - (self.view.frame.size.height - 30)/2;
//        [self setTipsViewYAlign:height>0?0:height];
//        [self showErrorWithStatus:@"还没输入内容呢" duration:1];
        [searchtext becomeFirstResponder];
        return;
    }
    
    if ([searchstr length] > 64) {
        float height = (self.view.frame.size.height - 252)/2 - (self.view.frame.size.height - 30)/2;
//        [self setTipsViewYAlign:height>0?0:height];
//        [self showErrorWithStatus:@"超出64个字符！" duration:1];
//        [self setTipsViewYAlign:0];
        [searchtext becomeFirstResponder];
        return ;
    }
    
    [_webServiceController SendHttpRequestWithMethod:@"/absapi/absuserinfo/list" argsDic:@{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"searchArea":@"2", @"token":[XYLUserInfoBLL shareUserInfoBLL].token,@"searchKey":searchstr} success:^(NSDictionary* dic){
        dataArr = dic[@"data"];
        if (dataArr) {
            newFriends = [[NSMutableArray alloc]init];
            for (NSDictionary* itemDic in dataArr) {
                NSString *info = itemDic[@"username"]?:@"NULL";
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
        UIButton* receiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60, 10, 40, 20)];
        [receiveBtn setTitle:@"添加" forState:UIControlStateNormal];
        [receiveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        receiveBtn.backgroundColor = [UIColor colorWithHexString:@"#41C9D7"];
        [cell addSubview:receiveBtn];
    }
    cell.textLabel.text = [newFriends objectAtIndex: indexPath.row];
    return cell;
}

-(void)btnAction:(id)sender{
    UIButton* btn = sender;
    [_webServiceController SendHttpRequestWithMethod:@"/absapi/absfriends/save" argsDic:@{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"friendsId":dataArr[btn.tag][@"id"],@"type":@"0",@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
        [[KGProgressView windowProgressView] showErrorWithStatus:@"请求成功" duration:0.5];
    }];
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
