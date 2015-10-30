
//  EasyJSWebViewDelegate.m
//  EasyJS
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import "EasyJSWebViewProxyDelegate.h"
#import "EasyJSDataFunction.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import "BackButton.h"
/*
 This is the content of easyjs-inject.js
 Putting it inline in order to prevent loading from files
*/
NSString* INJECT_JS = @"window.EasyJS = {\
__callbacks: {},\
\
invokeCallback: function (cbID, removeAfterExecute){\
var args = Array.prototype.slice.call(arguments);\
args.shift();\
args.shift();\
\
for (var i = 0, l = args.length; i < l; i++){\
args[i] = decodeURIComponent(args[i]);\
}\
\
var cb = EasyJS.__callbacks[cbID];\
if (removeAfterExecute){\
EasyJS.__callbacks[cbID] = undefined;\
}\
return cb.apply(null, args);\
},\
\
call: function (obj, functionName, args){\
var formattedArgs = [];\
for (var i = 0, l = args.length; i < l; i++){\
if (typeof args[i] == \"function\"){\
formattedArgs.push(\"f\");\
var cbID = \"__cb\" + (+new Date);\
EasyJS.__callbacks[cbID] = args[i];\
formattedArgs.push(cbID);\
}else{\
formattedArgs.push(\"s\");\
formattedArgs.push(encodeURIComponent(args[i]));\
}\
}\
\
var argStr = (formattedArgs.length > 0 ? \":\" + encodeURIComponent(formattedArgs.join(\":\")) : \"\");\
\
var iframe = document.createElement(\"IFRAME\");\
iframe.setAttribute(\"src\", \"easy-js:\" + obj + \":\" + encodeURIComponent(functionName) + argStr);\
document.documentElement.appendChild(iframe);\
iframe.parentNode.removeChild(iframe);\
iframe = null;\
\
var ret = EasyJS.retValue;\
EasyJS.retValue = undefined;\
\
if (ret){\
return decodeURIComponent(ret);\
}\
},\
\
inject: function (obj, methods){\
window[obj] = {};\
var jsObj = window[obj];\
\
for (var i = 0, l = methods.length; i < l; i++){\
(function (){\
var method = methods[i];\
var jsMethod = method.replace(new RegExp(\":\", \"g\"), \"\");\
jsObj[jsMethod] = function (){\
return EasyJS.call(obj, method, Array.prototype.slice.call(arguments));\
};\
})();\
}\
}\
};";

@implementation EasyJSWebViewProxyDelegate

@synthesize realDelegate;
@synthesize javascriptInterfaces;
@synthesize startedURL;
@synthesize startedHeight;
@synthesize startedTitle;
- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name{
	if (! self.javascriptInterfaces){
		self.javascriptInterfaces = [[NSMutableDictionary alloc] init];
	}
	
	[self.javascriptInterfaces setValue:interface forKey:name];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError");
    [MBProgressHUD hideHUDForView:[webView superview] animated:YES];
    
    webView.backgroundColor=[UIColor clearColor];
    for (UIView *aView in [webView subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
            for (UIView *shadowView in aView.subviews)
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                }
            }
        }
        //[super hideGradientBackground:aView];
    }

	[self.realDelegate webView:webView didFailLoadWithError:error];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");

    [MBProgressHUD hideHUDForView:[webView superview] animated:YES];
    
    webView.backgroundColor=[UIColor clearColor];
    for (UIView *aView in [webView subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
            for (UIView *shadowView in aView.subviews)
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                }
            }
        }
        //[super hideGradientBackground:aView];
    }

	[self.realDelegate webViewDidFinishLoad:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	NSLog(@"shouldStartLoadWithRequest");
	NSString *requestString = [[request URL] absoluteString];
    if ([requestString hasPrefix:@"easy-js:"]) {
		/*
		 A sample URL structure:
		 easy-js:MyJSTest:test
		 easy-js:MyJSTest:testWithParam%3A:haha
		 */
		NSArray *components = [requestString componentsSeparatedByString:@":"];
		//NSLog(@"req: %@", requestString);
		
		NSString* obj = (NSString*)[components objectAtIndex:1];
		NSString* method = [(NSString*)[components objectAtIndex:2]
							stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
        if ([obj isEqualToString:@"MyEasyJS"] && [method isEqualToString:@"AddEasyJS"])
        {
            
            NSMutableString* injection = [[NSMutableString alloc] init];
            
            //inject the javascript interface
            for(id key in self.javascriptInterfaces) {
                NSObject* interface = [self.javascriptInterfaces objectForKey:key];
                
                [injection appendString:@"EasyJS.inject(\""];
                [injection appendString:key];
                [injection appendString:@"\", ["];
                
                unsigned int mc = 0;
                Class cls = object_getClass(interface);
                Method * mlist = class_copyMethodList(cls, &mc);
                for (int i = 0; i < mc; i++){
                    [injection appendString:@"\""];
                    [injection appendString:[NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))]];
                    [injection appendString:@"\""];
                    
                    if (i != mc - 1){
                        [injection appendString:@", "];
                    }
                }
                
                free(mlist);
                
                [injection appendString:@"]);"];
            }
            
            
            NSString* js = INJECT_JS;
            
            //inject the basic functions first
            [webView stringByEvaluatingJavaScriptFromString:js];
            
            //inject the function interface
            [webView stringByEvaluatingJavaScriptFromString:injection];
            
            [injection release];
            return NO;
        }
        
		NSObject* interface = [javascriptInterfaces objectForKey:obj];
		
		// execute the interfacing method
		SEL selector = NSSelectorFromString(method);
		NSMethodSignature* sig = [[interface class] instanceMethodSignatureForSelector:selector];
		NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:sig];
		invoker.selector = selector;
		invoker.target = interface;
		
		NSMutableArray* args = [[NSMutableArray alloc] init];
		
		if ([components count] > 3){
			NSString *argsAsString = [(NSString*)[components objectAtIndex:3]
									  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			NSArray* formattedArgs = [argsAsString componentsSeparatedByString:@":"];
			for (int i = 0, j = 0, l = [formattedArgs count]; i < l; i+=2, j++){
				NSString* type = ((NSString*) [formattedArgs objectAtIndex:i]);
				NSString* argStr = ((NSString*) [formattedArgs objectAtIndex:i + 1]);
				
				if ([@"f" isEqualToString:type]){
					EasyJSDataFunction* func = [[EasyJSDataFunction alloc] initWithWebView:(EasyJSWebView *)webView];
					func.funcID = argStr;
					[args addObject:func];
					[invoker setArgument:&func atIndex:(j + 2)];
				}else if ([@"s" isEqualToString:type]){
					NSString* arg = [argStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
					[args addObject:arg];
					[invoker setArgument:&arg atIndex:(j + 2)];
				}
			}
		}
        if ([method isEqualToString:@"showDatePickerDialog::"]) {
            //
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"HtmlDateNotification" object:args];

            [webView stringByEvaluatingJavaScriptFromString:@"EasyJS.retValue=null;"];
        }else if ([method isEqualToString:@"closePage"])
        {
            //
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"HtmlCloseNotification" object:args];
            
            [webView stringByEvaluatingJavaScriptFromString:@"EasyJS.retValue=null;"];
        }else if([method isEqualToString:@"showProgressDialog::"])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[webView superview] animated:YES];
            hud.labelText = @"正在处理，请稍等...";
            [webView stringByEvaluatingJavaScriptFromString:@"EasyJS.retValue=null;"];
        }else if([method isEqualToString:@"closeProgressDialog"])
        {
            [MBProgressHUD hideHUDForView:[webView superview] animated:YES];
            [webView stringByEvaluatingJavaScriptFromString:@"EasyJS.retValue=null;"];
        }else if([method isEqualToString:@"setImage"])
        {
            //
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"HtmlPhotoNotification" object:args];
            
            [webView stringByEvaluatingJavaScriptFromString:@"EasyJS.retValue=null;"];
        }else if([method isEqualToString:@"viewPhoto:"])
        {
            [(EasyJSWebView*)webView imageHandle:args[0]];
            [webView stringByEvaluatingJavaScriptFromString:@"EasyJS.retValue=null;"];
        }
        else{
		[invoker invoke];
		
		//return the value by using javascript
		if ([sig methodReturnLength] > 0){
			NSString* retValue;
			[invoker getReturnValue:&retValue];
			
			if (retValue == NULL || retValue == nil){
				[webView stringByEvaluatingJavaScriptFromString:@"EasyJS.retValue=null;"];
			}else{
				retValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) retValue, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
				[webView stringByEvaluatingJavaScriptFromString:[@"" stringByAppendingFormat:@"EasyJS.retValue=\"%@\";", retValue]];
			}
		}
        }
		[args release];
        
		return NO;
    }else if ([requestString rangeOfString:@".html"].location !=NSNotFound)
    {
        //用户点击第二个html中的一项时，跳回到第一个html页面，需要判断是啥类型的
        if (nil != self.startedURL && 0 != self.startedURL.length && [requestString hasPrefix:self.startedURL]) {
            if (((EasyJSWebView*)webView).isNoresizeFrameForEasy == NO) {
                webView.frame = CGRectMake(0, 96+20, webView.frame.size.width, self.startedHeight);
            }
            
            //[[webView superview] addSubview:newView];
            for (UIView *aView in [[webView superview]subviews])
            {
                if ([aView isKindOfClass:[BackButton class]]) {
                    [(BackButton*)aView setTitle:self.startedTitle forState:UIControlStateNormal];
                }
            }
        }else{
            //点击第一个html跳到第二个html或点击第二个跳到第三个或点击第三个跳到第二个
            if ([requestString rangeOfString:@".html?"].location !=NSNotFound) {
                //isNoresizeFrameForEasy==NO说明是FunctionBaseViewController而不是SecondFunctionBaseViewController
                if (((EasyJSWebView*)webView).isNoresizeFrameForEasy == NO) {
                    //如果是点击第二个html跳到第三个html呢？
                webView.frame = CGRectMake(0, 68, webView.frame.size.width, self.startedHeight + 48);
                }
                //[[webView superview] addSubview:newView];
                for (UIView *aView in [[webView superview]subviews])
                {
                    if ([aView isKindOfClass:[BackButton class]]) {
                        [(BackButton*)aView setTitle:@"返回" forState:UIControlStateNormal];
                    }
                }
            }
            //直接进入第一个html
            else
            {
                self.startedURL = requestString;
                self.startedHeight = webView.frame.size.height;
                for (UIView *aView in [[webView superview]subviews])
                {
                    if ([aView isKindOfClass:[BackButton class]]) {
                        //[(BackButton*)aView setTitle:@"返回" forState:UIControlStateNormal];
                        self.startedTitle = ((BackButton*)aView).titleLabel.text;
                    }
                }
            }
        }
    }
    else
    {
        //NSLog(@"no");
    }
	
	if (! self.realDelegate){
		return YES;
	}
	
	return [self.realDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[webView superview] animated:YES];
    hud.labelText = @"正在加载，请等待...";
	[self.realDelegate webViewDidStartLoad:webView];
	if (! self.javascriptInterfaces){
		self.javascriptInterfaces = [[NSMutableDictionary alloc] init];
	}
	
	NSMutableString* injection = [[NSMutableString alloc] init];
	
	//inject the javascript interface
	for(id key in self.javascriptInterfaces) {
		NSObject* interface = [self.javascriptInterfaces objectForKey:key];
		
		[injection appendString:@"EasyJS.inject(\""];
		[injection appendString:key];
		[injection appendString:@"\", ["];
		
		unsigned int mc = 0;
		Class cls = object_getClass(interface);
		Method * mlist = class_copyMethodList(cls, &mc);
		for (int i = 0; i < mc; i++){
			[injection appendString:@"\""];
			[injection appendString:[NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))]];
			[injection appendString:@"\""];
			
			if (i != mc - 1){
				[injection appendString:@", "];
			}
		}
		
		free(mlist);
		
		[injection appendString:@"]);"];
	}
	
	
	NSString* js = INJECT_JS;
    
	//inject the basic functions first
	[webView stringByEvaluatingJavaScriptFromString:js];
    
	//inject the function interface
	[webView stringByEvaluatingJavaScriptFromString:injection];
	
	[injection release];
}

- (void)dealloc{
	if (self.javascriptInterfaces){
		[self.javascriptInterfaces release];
		self.javascriptInterfaces = nil;
	}

	if (self.realDelegate){
		[self.realDelegate release];
		self.realDelegate = nil;
	}
	
    if (self.startedTitle){
        [self.startedTitle release];
        self.startedTitle = nil;
    }
    
    if (self.startedURL){
        [self.startedURL release];
        self.startedURL = nil;
    }
    
    if (dateText)
    {
        [dateText release];
        dateText = nil;
    }
	[super dealloc];
}

@end