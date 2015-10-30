//
//  EasyJSWebView.h
//  EasyJS
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyJSWebViewProxyDelegate.h"
#import "XHImageViewer.h"
@interface EasyJSWebView : UIWebView<XHImageViewerDelegate>
// All the events will pass through this proxy delegate first
@property (nonatomic, retain) EasyJSWebViewProxyDelegate* proxyDelegate;
@property BOOL isRequestedForEasy;
@property BOOL isNoresizeFrameForEasy;

- (void) initEasyJS;
- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name;
- (void)imageHandle:(NSString *)imagePath;
@end
