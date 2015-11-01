//
//  XYLCommonTableViewCell.m
//  XiaoYouLu
//
//  Created by 姚振兴 on 15/11/1.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import "XYLCommonTableViewCell.h"
#import "UIView+ViewFrameGeometry.h"

@implementation XYLCommonTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightContent = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 40, 0, 0, 0)];
        self.rightContent.textColor = [UIColor blackColor];
        self.rightContent.font = self.textLabel.font;
        self.rightContent.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.rightContent];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.textLabel.width = 150;
    self.rightContent.frame = CGRectMake(self.textLabel.right+10, self.textLabel.top, self.width - self.textLabel.right - 30, self.textLabel.height);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
