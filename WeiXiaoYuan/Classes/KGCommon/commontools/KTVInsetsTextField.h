//
//  KTVInsetsTextField.h
//  kugou
//
//  Created by xiaogaochao on 14-7-1.
//  Copyright (c) 2014年 kugou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTVInsetsTextField : UITextField

- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;

@end
