//
//  XYLCommonTableViewCell.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/11/1.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "XYLCommonTableViewCell.h"
#import "UIView+ViewFrameGeometry.h"
#import "WebServiceController.h"
#import "KGProgressView.h"

@implementation XYLCommonTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightContent = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 40, 0, 0, 0)];
        self.rightContent.textColor = [UIColor blackColor];
        self.rightContent.font = [UIFont systemFontOfSize:13];
        self.rightContent.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.rightContent];
        
        self.rightBtn = [[UIButton alloc] init];
        self.rightBtn.hidden = YES;
        [self.rightBtn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
        self.friendId = @"";
    }
    return self;
}
-(void)btn{
    WebServiceController* _webServiceController = [WebServiceController shareController:self];
    NSString *str = @"/absapi/absuserinfo/updateValidById";
    [_webServiceController SendHttpRequestWithMethod:str argsDic:@{@"id":self.friendId,@"token":[XYLUserInfoBLL shareUserInfoBLL].token,@"isvalid":@"1"} success:^(NSDictionary* dic){
        [[KGProgressView windowProgressView] showSuccessWithStatus:@"申请成功" duration:0.5];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.textLabel.width = 150;
    self.rightContent.frame = CGRectMake(self.textLabel.right+10, self.textLabel.top, self.width - self.textLabel.right - 42, self.textLabel.height);
    self.rightBtn.frame = CGRectMake(self.width - 100, self.height/2 - 13.5, 85, 27);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
