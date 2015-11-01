//
//  DetailForMessageViewController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 15/1/5.
//  Copyright (c) 2015年 Dukeland. All rights reserved.
//

#import "DetailForMessageViewController.h"
#import "BackButton.h"
#import "InTimeViewController.h"
#import "DBImageView.h"
#import "SJAvatarBrowser.h"
#import "UIColor+Addition.h"
#import "UIView+ViewFrameGeometry.h"

@interface DetailForMessageViewController ()
{
    UIImageView* imageViewNormal;
    //DBImageView *imageViewNormal;
    DBImageView * downloadImageView;
    NSString* imagePath;
    UITableView *table;
    NSMutableArray* joinPeoples;
}
@end

@implementation DetailForMessageViewController
@synthesize recommendInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            }
    return self;
}

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
    laber.text = recommendInfo.title;
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
    
    BackButton *joinButton = [[BackButton alloc] initWithFrame:CGRectMake(self.view.width-64 -8, -2+20 + 6, 64, 48-20)];
    [joinButton setTitle:@"参与" forState:UIControlStateNormal];
    [self.view insertSubview:joinButton atIndex:1];
    [joinButton addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    //布局显示内容
    CGFloat heightLayout = 64;
    
//    UIImageView *showImg = [[UIImageView alloc] init];
//    showImg.backgroundColor = [UIColor grayColor];
//    showImg.frame = CGRectMake(0, view.bottom, self.view.frame.size.width, 200);
//    [self.view addSubview:showImg];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, view.bottom+10, self.view.frame.size.width-20, 30)];
    label.text = [NSString stringWithFormat:@"  %@", recommendInfo.content];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15];
    //label.textColor = [UIColor greenColor];
    [self.view insertSubview:label atIndex:2];
    //heightLayout = heightLayout + 10 + 30;
    
    //换行
    CGSize labelSize;
    labelSize = [label.text sizeWithFont:label.font
                       constrainedToSize:CGSizeMake(label.frame.size.width, 5000)
                           lineBreakMode:UILineBreakModeWordWrap];
    //14 为UILabel的字体大小
    //200为UILabel的宽度，5000是预设的一个高度，表示在这个范围内
    label.numberOfLines = 0;//表示label可以多行显示
    label.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelSize.height);//保持原来Label的位置和宽度，只是改变高度。
    heightLayout += labelSize.height + 10;
    //}
    
    //if (recommendInfo.date) {
        UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 200, label.bottom+10, 190, 24)];
        dateLabel.text = recommendInfo.date;
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.font = [UIFont boldSystemFontOfSize:14];
        dateLabel.textColor = [UIColor grayColor];
        [self.view insertSubview:dateLabel atIndex:2];
    //}
    
    
    //列表
//    table = [[UITableView alloc] initWithFrame:CGRectMake(0, dateLabel.bottom+10, self.view.frame.size.width, self.view.frame.size.height - dateLabel.bottom) style:UITableViewStylePlain];
//    table.delegate = self;
//    table.dataSource = self;
//    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    table.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:table];
//    
//    joinPeoples = [[NSMutableArray alloc]init];
//    for (int i = 1; i < 8; i++) {
//        NSString* info = [[NSString alloc] init];
//        info = [NSString stringWithFormat:@"参与人%d",i];
//        [joinPeoples addObject:info];
//    }

    
    //            if (userMessages.pushImage)
    //            {
//    downloadImageView =[[DBImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
//    [downloadImageView setImageWithPath:@"http://pic19.nipic.com/20120309/6871263_122441051300_2.jpg"];
//    
//    //UIImage *pushImage = [UIImage imageNamed:userMessages.pushImage];
//    CGFloat height = self.view.frame.size.height - heightLayout -20 >self.view.frame.size.width-20?self.view.frame.size.height - heightLayout -20:self.view.frame.size.width-20;
//    
//    imageViewNormal = [[UIImageView alloc] initWithFrame:CGRectMake(10, heightLayout + 10, self.view.frame.size.width-20, height)];
//    
//    [imageViewNormal setImage:downloadImageView.MyImage];
//    [self.view insertSubview:imageViewNormal atIndex:2];
//    heightLayout = heightLayout + 10 + 160;
//    //            }
//    if (imageViewNormal) {
//        imagePath = @"http://pic19.nipic.com/20120309/6871263_122441051300_2.jpg";
//        imageViewNormal.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageHandle)];
//        [imageViewNormal addGestureRecognizer:singleTap];
//    }

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//点击图片，放大
- (void)imageHandle {
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(160, 300, 1, 1)];
    view.image = downloadImageView.MyImage;
    [SJAvatarBrowser showImage:view];
//    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
//    imageViewer.delegate = self;
//    NSMutableArray* imageViews = [NSMutableArray array];
//    [imageViews addObject:imageViewNormal];
//    //UIImage* image= [UIImage imageNamed:imagePath];
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 200)];
//    [imageView setImage:imageViewNormal.MyImage];
//    [(DBImageView*)imageViewNormal setImageWithPath:imagePath];
//    [imageViewer showWithImageViews:imageViews selectedView:imageView];
}
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;//[joinPeoples count];
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
    cell.textLabel.text = [joinPeoples objectAtIndex: indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
@end
