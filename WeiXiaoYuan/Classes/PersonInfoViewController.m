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
#import "ZHPickView.h"

@interface PersonInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,ZHPickViewDelegate>
{
    UITableView *table;
    NSDictionary* dataDic;
    NSMutableArray* userPropretys;
    NSMutableArray* schoolPropretys;
    NSMutableArray* workPropretys;
    NSMutableArray* pickList;
    NSMutableArray* pickDicList;
    NSIndexPath* myIndexPath;
    ZHPickView* pickview;
    NSString* selectProp;
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
    if (pickview){
        [pickview remove];
    }
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
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, view.bottom, self.view.frame.size.width, self.view.frame.size.height - view.bottom) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    
    _webServiceController = [WebServiceController shareController:self.view];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}
- (void)refresh{
    NSString* url;
    NSDictionary* dicArg;
    if (self.isOwn) {
        url = @"/absapi/absuserinfo/viewUserInfo";
        dicArg = @{@"id":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
    }else{
        url = @"/absapi/absuserinfo/viewFriendInfo";
        dicArg = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, @"friendId":self.userId,@"token":[XYLUserInfoBLL shareUserInfoBLL].token};
    }
    [_webServiceController SendHttpRequestWithMethod:url argsDic:dicArg success:^(NSDictionary* dic){
        dataDic = dic[@"data"];
        if (dataDic) {
            if (dataDic[@"absUserinfo"]) {
                NSDictionary* dic = dataDic[@"absUserinfo"];
                userPropretys = [[NSMutableArray alloc]init];
                NSMutableDictionary* item = [[NSMutableDictionary alloc]init];
                [item setObject:@"用户名" forKey:@"title"];
                [item setObject:dic[@"username"]?:@"" forKey:@"content"];
                [item setObject:@"username" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"姓名" forKey:@"title"];
                [item setObject:dic[@"name"]?:@"" forKey:@"content"];
                [item setObject:@"name" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"性别" forKey:@"title"];
                [item setObject:dic[@"sex"]?:@"" forKey:@"content"];
                [item setObject:@"sex" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"手机号" forKey:@"title"];
                [item setObject:dic[@"dn"]?:@"" forKey:@"content"];
                [item setObject:@"dn" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"邮箱" forKey:@"title"];
                [item setObject:dic[@"mail"]?:@"" forKey:@"content"];
                [item setObject:@"mail" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"QQ" forKey:@"title"];
                [item setObject:dic[@"qq"]?:@"" forKey:@"content"];
                [item setObject:@"qq" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"微信" forKey:@"title"];
                [item setObject:dic[@"wechat"]?:@"" forKey:@"content"];
                [item setObject:@"wechat" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"省份" forKey:@"title"];
                [item setObject:dic[@"provName"]?:@"" forKey:@"content"];
                [item setObject:@"provName" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"城市" forKey:@"title"];
                [item setObject:dic[@"cityName"]?:@"" forKey:@"content"];
                [item setObject:@"cityName" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"区" forKey:@"title"];
                [item setObject:dic[@"areaName"]?:@"" forKey:@"content"];
                [item setObject:@"areaName" forKey:@"propery"];
                [userPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"是否公开" forKey:@"title"];
                [item setObject:(dic[@"isvalid"]&&[dic[@"isvalid"] isEqualToString:@"1"])?@"是":@"否" forKey:@"content"];
                [item setObject:@"isvalid" forKey:@"propery"];
                [userPropretys addObject:item];
            }
            if (dataDic[@"absUserSchool"]) {
                NSDictionary* dic = dataDic[@"absUserSchool"];
                schoolPropretys = [[NSMutableArray alloc]init];
                NSMutableDictionary* item = [[NSMutableDictionary alloc]init];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"学校" forKey:@"title"];
                [item setObject:dic[@"schoolDesc"]?:@"" forKey:@"content"];
                [item setObject:@"schoolDesc" forKey:@"propery"];
                [schoolPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"入学年份" forKey:@"title"];
                [item setObject:(NSString*)(dic[@"inSchoolYear"]?:@"") forKey:@"content"];
                [item setObject:@"inSchoolYear" forKey:@"propery"];
                [schoolPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"学院" forKey:@"title"];
                [item setObject:dic[@"academyDesc"]?:@"" forKey:@"content"];
                [item setObject:@"academyDesc" forKey:@"propery"];
                [schoolPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"专业" forKey:@"title"];
                [item setObject:dic[@"profDesc"]?:@"" forKey:@"content"];
                [item setObject:@"profDesc" forKey:@"propery"];
                [schoolPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"班级" forKey:@"title"];
                [item setObject:dic[@"className"]?:@"" forKey:@"content"];
                [item setObject:@"className" forKey:@"propery"];
                [schoolPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"是否公开" forKey:@"title"];
                [item setObject:(dic[@"isvalid"]&&[dic[@"isvalid"] isEqualToString:@"1"])?@"是":@"否" forKey:@"content"];
                [item setObject:@"isvalid" forKey:@"propery"];
                [schoolPropretys addObject:item];
            }
            
            if (dataDic[@"absUserWork"]) {
                NSDictionary* dic = dataDic[@"absUserWork"];
                workPropretys = [[NSMutableArray alloc]init];
                NSMutableDictionary* item = [[NSMutableDictionary alloc]init];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"所在行业" forKey:@"title"];
                [item setObject:dic[@"trade"]?:@"" forKey:@"content"];
                [item setObject:@"trade" forKey:@"propery"];
                [workPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"公司名称" forKey:@"title"];
                [item setObject:dic[@"companyName"]?:@"" forKey:@"content"];
                [item setObject:@"companyName" forKey:@"propery"];
                [workPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"公司职位" forKey:@"title"];
                [item setObject:dic[@"position"]?:@"" forKey:@"content"];
                [item setObject:@"position" forKey:@"propery"];
                [workPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"省份" forKey:@"title"];
                [item setObject:dic[@"provName"]?:@"" forKey:@"content"];
                [item setObject:@"provName" forKey:@"propery"];
                [workPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"城市" forKey:@"title"];
                [item setObject:dic[@"cityName"]?:@"" forKey:@"content"];
                [item setObject:@"cityName" forKey:@"propery"];
                [workPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"区" forKey:@"title"];
                [item setObject:dic[@"areaName"]?:@"" forKey:@"content"];
                [item setObject:@"areaName" forKey:@"propery"];
                [workPropretys addObject:item];
                
                item = [[NSMutableDictionary alloc]init];
                [item setObject:@"是否公开" forKey:@"title"];
                [item setObject:(dic[@"isvalid"]&&[dic[@"isvalid"] isEqualToString:@"1"])?@"是":@"否" forKey:@"content"];
                [item setObject:@"isvalid" forKey:@"propery"];
                [workPropretys addObject:item];
            }
            
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[dataDic allKeys] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            if (!self.isOwn && ![dataDic[@"absUserinfo"][@"isvalid"] isEqualToString:@"1"]) {
                return @"";
            }else{
                return @"基本信息";
            }
            break;
        case 1:
            if (!self.isOwn && ![dataDic[@"absUserSchool"][@"isvalid"] isEqualToString:@"1"]) {
                return @"";
            }else{
                return @"学校信息";
            }
            break;
        case 2:
            if (!self.isOwn && ![dataDic[@"absUserWork"][@"isvalid"] isEqualToString:@"1"]) {
                return @"";
            }else{
                return @"工作信息";
            }
            break;
        default:
            break;
    }
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (!self.isOwn && ![dataDic[@"absUserinfo"][@"isvalid"] isEqualToString:@"1"]) {
                return 0;
            }else{
                return [userPropretys count];
            }
            break;
        case 1:
            if (!self.isOwn && ![dataDic[@"absUserSchool"][@"isvalid"] isEqualToString:@"1"]) {
                return 0;
            }else{
                return [schoolPropretys count];
            }
            break;
        case 2:
            if (!self.isOwn && ![dataDic[@"absUserWork"][@"isvalid"] isEqualToString:@"1"]) {
                return 0;
            }else{
                return [workPropretys count];
            }
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    XYLCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[XYLCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        if (self.isOwn) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[userPropretys objectAtIndex:indexPath.row][@"title"],nil];
            cell.rightContent.text = [userPropretys objectAtIndex:indexPath.row][@"content"];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[schoolPropretys objectAtIndex:indexPath.row][@"title"],nil];
            cell.rightContent.text = [schoolPropretys objectAtIndex:indexPath.row][@"content"];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[workPropretys objectAtIndex:indexPath.row][@"title"],nil];
            cell.rightContent.text = [workPropretys objectAtIndex:indexPath.row][@"content"];
            break;
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isOwn) {
        return;
    }
    
    if (pickview){
        [pickview remove];
    }
    
    NSString *proName;
    NSString *titleName;
    switch (indexPath.section) {
        case 0:
            proName = userPropretys[indexPath.row][@"propery"];
            titleName = userPropretys[indexPath.row][@"title"];
            break;
        case 1:
            proName = schoolPropretys[indexPath.row][@"propery"];
            titleName = schoolPropretys[indexPath.row][@"title"];
            break;
        case 2:
            proName = workPropretys[indexPath.row][@"propery"];
            titleName = workPropretys[indexPath.row][@"title"];
            break;
        default:
            break;
    }
    
    if ([proName isEqualToString:@"sex"] || [proName isEqualToString:@"isvalid"]
        || [proName isEqualToString:@"provName"]
        || [proName isEqualToString:@"cityName"]
        || [proName isEqualToString:@"areaName"]
        || [proName isEqualToString:@"className"]
        || [proName isEqualToString:@"academyDesc"]
        || [proName isEqualToString:@"profDesc"]
        || [proName isEqualToString:@"schoolDesc"]
        || [proName isEqualToString:@"inSchoolYear"]) {
        if ([proName isEqualToString:@"sex"]) {
            pickList = [[NSMutableArray alloc]initWithObjects:@"男",@"女",nil];
            pickview=[[ZHPickView alloc] initPickviewWithArray:pickList isHaveNavControler:NO];
            selectProp = @"sex";
            pickview.delegate=self;
            myIndexPath = indexPath;
            [pickview show];
        }else if([proName isEqualToString:@"isvalid"]){
            pickList = [[NSMutableArray alloc]initWithObjects:@"是",@"否",nil];
            pickview=[[ZHPickView alloc] initPickviewWithArray:pickList isHaveNavControler:NO];
            selectProp = @"isvalid";
            pickview.delegate=self;
            myIndexPath = indexPath;
            [pickview show];
        }
        else if([proName isEqualToString:@"className"]){
            pickList = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
            pickview=[[ZHPickView alloc] initPickviewWithArray:pickList isHaveNavControler:NO];
            selectProp = @"className";
            pickview.delegate=self;
            myIndexPath = indexPath;
            [pickview show];
        }else if([proName isEqualToString:@"provName"]){
            NSString *str = @"/absapi/absarea/queryByParentId";
            [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"parentId":@"0",@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
                pickDicList = dic[@"data"];
                myIndexPath = indexPath;
                selectProp = @"provCode";
                [self showPick];
            }];
            
        }else if([proName isEqualToString:@"cityName"]){
            NSString* provCode;
            if (indexPath.section == 0) {
                provCode = dataDic[@"absUserinfo"][@"provCode"];
            }else if (indexPath.section == 2){
                provCode = dataDic[@"absUserWork"][@"provCode"];
            }
            if (provCode) {
                NSString *str = @"/absapi/absarea/queryByParentId";
                [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"parentId":provCode,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
                    pickDicList = dic[@"data"];
                    myIndexPath = indexPath;
                    selectProp = @"cityCode";
                    [self showPick];
                }];
            }
        }else if([proName isEqualToString:@"areaName"]){
            NSString* cityCode;
            if (indexPath.section == 0) {
                cityCode = dataDic[@"absUserinfo"][@"cityCode"];
            }else if (indexPath.section == 2){
                cityCode = dataDic[@"absUserWork"][@"cityCode"];
            }
            if (cityCode) {
                NSString *str = @"/absapi/absarea/queryByParentId";
                [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"parentId":cityCode,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
                    pickDicList = dic[@"data"];
                    myIndexPath = indexPath;
                    selectProp = @"areaCode";
                    [self showPick];
                }];
            }
        }
        else if([proName isEqualToString:@"schoolDesc"]){
            NSString *str = @"/absapi/abscollege/queryByParentId";
            [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"parentId":@"0",@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
                pickDicList = dic[@"data"];
                myIndexPath = indexPath;
                selectProp = @"schoolId";
                [self showPick];
            }];
            
        }
        else if([proName isEqualToString:@"academyDesc"]){
            NSString* schoolId = dataDic[@"absUserSchool"][@"schoolId"];
            
            if (schoolId) {
                NSString *str = @"/absapi/abscollege/queryByParentId";
                [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"parentId":schoolId,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
                    pickDicList = dic[@"data"];
                    myIndexPath = indexPath;
                    selectProp = @"academy";
                    [self showPick];
                }];
            }
        }
        else if([proName isEqualToString:@"profDesc"]){
            NSString* academy = dataDic[@"absUserSchool"][@"academy"];
            if (academy)
            {
                NSString *str = @"/absapi/abscollege/queryByParentId";
                [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"parentId":academy,@"token":[XYLUserInfoBLL shareUserInfoBLL].token} success:^(NSDictionary* dic){
                    pickDicList = dic[@"data"];
                    myIndexPath = indexPath;
                    selectProp = @"prof";
                    [self showPick];
                }];
            }
        }else if([proName isEqualToString:@"inSchoolYear"]){
            pickList = [[NSMutableArray alloc] init];
            for (int i = 1945; i<2025; i++) {
                [pickList addObject:[NSString stringWithFormat:@"%d",i]];
            }
            pickview=[[ZHPickView alloc] initPickviewWithArray:pickList isHaveNavControler:NO];
            selectProp = @"inSchoolYear";
            pickview.delegate=self;
            myIndexPath = indexPath;
            [pickview show];
        }
    }else if ([proName isEqualToString:@"username"]){
        //不可以编辑
    }else{
        EditProperyViewController* vc = [[EditProperyViewController alloc] init];
        if (indexPath.section == 0) {
            vc.propery = userPropretys[indexPath.row][@"propery"];
        }else if (indexPath.section == 1){
            vc.propery = schoolPropretys[indexPath.row][@"propery"];
        }else{
            vc.propery = workPropretys[indexPath.row][@"propery"];
        }
        vc.titleStr = @"信息";//userPropretys[indexPath.row][@"title"];
        vc.type = indexPath.section;
        //vc.propery = selectProp;//userPropretys[indexPath.row][@"propery"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)showPick
{
    if (pickDicList) {
        pickList = [[NSMutableArray alloc] init];
        for (NSDictionary* item in pickDicList) {
            if (item[@"name"] && [item[@"name"] isKindOfClass:[NSString class]]) {
                [pickList addObject:item[@"name"]];
            }
        }
        if (pickview){
            [pickview remove];
        }
        pickview = [[ZHPickView alloc] initPickviewWithArray:pickList isHaveNavControler:NO];
        
        pickview.delegate=self;
        [pickview show];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    XYLCommonTableViewCell*cell = [table cellForRowAtIndexPath:myIndexPath];
    cell.rightContent.text = resultString;
    NSDictionary* dic;
    if ([selectProp isEqualToString: @"sex"]) {
        dic = @{@"id":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, @"sex":resultString, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
    }else if([selectProp isEqualToString: @"isvalid"]) {
        if ([resultString isEqualToString:@"是"]) {
            dic = @{(myIndexPath.section==0?@"id":@"userId"):[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, @"isvalid":@"1", @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
        }else{
            dic = @{(myIndexPath.section==0?@"id":@"userId"):[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, @"isvalid":@"0", @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
        }
    }else if ([selectProp isEqualToString: @"className"]) {
        dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, @"className":resultString, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
    }
    else if([selectProp isEqualToString: @"inSchoolYear"]){
        dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, @"inSchoolYear":resultString, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
        
    }else{
        NSString* code;
        for (NSDictionary* item in pickDicList) {
            if ([item[@"name"] isEqualToString:resultString]) {
                code = item[@"id"];
                break;
            }
        }
        if (myIndexPath.section == 0){
            dic = @{@"id":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, selectProp:code, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
        }else{
            dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, selectProp:code, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
        }
//        if ([selectProp isEqualToString:@"areaCode"] || [selectProp isEqualToString:@"className"]) {
//            if (myIndexPath.section == 0){
//                dic = @{@"id":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid,@"userName":[XYLUserInfoBLL shareUserInfoBLL].userInfo.username, selectProp:code, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
//            }else{
//                dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, selectProp:code, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
//            }
//        }else{//还要设置下级pick
//            if ([selectProp isEqualToString:@"cityCode"]) {
//                dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, selectProp:code,@"areaCode":@"01", @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
//            }else if ([selectProp isEqualToString:@"provCode"]) {
//                dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, selectProp:code,@"cityCode":@"01",@"areaCode":@"01", @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
//            }else if ([selectProp isEqualToString:@"prof"]) {
//                dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, selectProp:code, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
//            }else if ([selectProp isEqualToString:@"academy"]) {
//                dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, selectProp:code,@"prof":@"01", @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
//            }else if ([selectProp isEqualToString:@"school"]) {
//                dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, selectProp:code,@"academy":@"01",@"prof":@"01", @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
//            }else {
//                dic = @{@"userId":[XYLUserInfoBLL shareUserInfoBLL].userInfo.userid, selectProp:code, @"token":[XYLUserInfoBLL shareUserInfoBLL].token};
//            }
//        }

        
        
    }
    
    NSString* str;
    if (myIndexPath.section == 0) {
        str = @"/absapi/absuserinfo/update";
    }else if (myIndexPath.section == 1){
        str = @"/absapi/absuserschool/save";
    }else{
        str = @"/absapi/absuserwork/updateByUserId";
    }
    
    [_webServiceController SendHttpRequestWithMethod:str argsDic:dic success:^(NSDictionary* dic){
        //[self dismissViewControllerAnimated:YES completion:nil];
        [[KGProgressView windowProgressView] showErrorWithStatus:@"保存成功" duration:0.5];
        [self refresh];
    }];
}
@end
