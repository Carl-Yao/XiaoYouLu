//
//  KTVInsetsTextField.m
//  kugou
//
//  Created by xiaogaochao on 14-7-1.
//  Copyright (c) 2014年 kugou. All rights reserved.
//

#import "KTVInsetsTextField.h"

@implementation KTVInsetsTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - 10, bounds.size.height), 5, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - 10, bounds.size.height), 5, 0);
}

@end
