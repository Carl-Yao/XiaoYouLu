//
//  EasyJSWebView.m
//  EasyJS
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import "EasyJSWebView.h"
#import "XHImageViewer.h"
@interface EasyJSWebView()
{
    NSMutableArray *_imageViews;
}
@end

@implementation EasyJSWebView

@synthesize proxyDelegate;
@synthesize isRequestedForEasy;
@synthesize isNoresizeFrameForEasy;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.scrollView.backgroundColor = [UIColor whiteColor];
		[self initEasyJS];
    }
    return self;
}
- (id)init{
	self = [super init];
    if (self) {
		[self initEasyJS];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	
	if (self){
		[self initEasyJS];
	}
	
	return self;
}

- (void) initEasyJS{
	self.proxyDelegate = [[EasyJSWebViewProxyDelegate alloc] init];
	self.delegate = self.proxyDelegate;
}

- (void) setDelegate:(id<UIWebViewDelegate>)delegate{
	if (delegate != self.proxyDelegate){
		self.proxyDelegate.realDelegate = delegate;
	}else{
		[super setDelegate:delegate];
	}
}

- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name{
	[self.proxyDelegate addJavascriptInterfaces:interface WithName:name];
}

- (void) dealloc{
	[super dealloc];
	
	//[self.proxyDelegate release];
	//self.proxyDelegate = nil;
}

- (void)imageHandle:(NSString *)imagePath {
    NSArray* array = [imagePath componentsSeparatedByString:@"?t="];
    NSString* imagePathEx = array[0];
    _imageViews = [NSMutableArray array];
    [_imageViews addObject:[[UIImageView alloc] initWithFrame:CGRectMake(160, 500, 1, 1)]];
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    UIImage* image= [[UIImage alloc] initWithContentsOfFile:imagePathEx];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 200)];
    [imageView setImage:image];
    [(UIImageView*)_imageViews[0] setImage:image];
    [imageViewer showWithImageViews:_imageViews selectedView:imageView];
}

#pragma mark - XHImageViewerDelegate

- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
//    NSInteger index = [_imageViews indexOfObject:selectedView];
//    NSLog(@"index : %d", index);
}

@end
