//
//  WebServiceController+WebServiceController.m
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/11/2.
//
//

#import "WebServiceController.h"
//#import <ASIHTTPRequest/ASIHTTPRequestHeader.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "UserManager.h"
#import "StringTool.h"
#import "KGProgressView.h"
#import "KTVDateFormatter.h"

static WebServiceController* _instance = nil;
static METHOD_TYPE _methodType;
@implementation WebServiceController
-(WebServiceController*)init:(UIView*)view
{
    static WebServiceController* obj = nil;
    static dispatch_once_t onceToToken;
    dispatch_once(&onceToToken, ^{
        if ((obj=[super init]) != nil) {
            //初始化
            self->currentView = view;
            self->appServiceUrl = @"http://123.57.11.237";
        }
    });
    self = obj;
    return self;
}
+ (WebServiceController*)shareController:(UIView*)view
{
    @synchronized(self)
    {
        if (!_instance) {
            _instance = [[self alloc] init:view];
        }
    }
    return _instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self){
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _instance;
}

- (void)SendHttpRequestWithMethod:(NSString*)methodName argsDic:(NSDictionary*)argsDic success:(successDictionaryBlock)successBlock fail:(failBlock)failBlock
{
    failErrorBlock = failBlock;
    [self SendHttpRequestWithMethod:methodName argsDic:argsDic success:successBlock];
}

- (void)SendHttpRequestWithMethod:(NSString*)methodName argsDic:(NSDictionary*)argsDic success:(successDictionaryBlock)successBlock
{
    NSMutableString *strUrl = [[NSMutableString alloc] init];
    NSArray *arr = [argsDic allKeys];
    for (int i=0; i<arr.count; i++) {
        NSString *key = [arr objectAtIndex:i];
        NSObject *obj = [argsDic objectForKey:key];
        if (i>0) {
            [strUrl appendString:@"&"];
        }
        //        NSString  *c = NSStringFromClass([obj class]);
        if ([[ obj class] isSubclassOfClass:[NSNumber class]] ) {
            NSNumber *number = (NSNumber*)obj;
            [strUrl appendFormat:@"%@=%d",key,[number intValue]];
        }else {
            NSString *strVal = (NSString*)obj;
            [strUrl appendFormat:@"%@=%@",key,[strVal URLEncodedString]];
        }
    }
    successDicBlock = successBlock;
    NSString *url = [NSString stringWithFormat:@"%@%@?%@",appServiceUrl,methodName,strUrl,nil];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self->currentView animated:YES];
    hud.labelText = @"正在登录，请等待...";
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self->currentView animated:YES];
    if (request.responseStatusCode == 400) {
        //textView.text = ;
        [[KGProgressView windowProgressView] showErrorWithStatus:@"请求失败:Invalid code" duration:0.5];
        //[self->delegate HttpFailCallBack:@"Invalid code"];
    } else if (request.responseStatusCode == 403) {
        //textView.text = ;
        //[self->delegate HttpFailCallBack:@"Code already used"];
        [[KGProgressView windowProgressView] showErrorWithStatus:@"请求失败:Code already used" duration:0.5];
    } else if (request.responseStatusCode == 200) {
        //NSString *responseString = [request responseString];
        NSMutableData *data = request.rawResponseData;
        NSDictionary *retDic = nil;
        if (data) {
            retDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        
        if (retDic && [retDic isKindOfClass:[NSDictionary class] ]) {
            if ([retDic[@"message"] isEqualToString:@"success"] || [retDic[@"resultcode"] isEqualToString:@"0"]){
                successDicBlock(retDic);
            }else{
                //[[KGProgressView windowProgressView] showErrorWithStatus:@"请求失败" duration:0.5];
            }
        }else{
            [[KGProgressView windowProgressView] showErrorWithStatus:@"请求失败:无返回数据" duration:0.5];
        }
    } else {
        [[KGProgressView windowProgressView] showErrorWithStatus:@"请求失败:未知错误" duration:0.5];
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self->currentView animated:YES];
    NSError *error = [request error];
    //[self->delegate HttpFailCallBack:error.userInfo ];
    NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
    //[self->delegate HttpFailCallBack:errorMessage];
    [[KGProgressView windowProgressView] showWithStatus:errorMessage icon:nil duration:0.5];
}

//日期格式转换
- (NSString*)dateStringConverter:(NSString*)oldDateString
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *oldDateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [oldDateFormatter setDateFormat:@"yyyy-M-d"];
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [newDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [oldDateFormatter dateFromString:oldDateString];
    //用[NSDate date]可以获取系统当前时间
    NSString *newDateStr = [newDateFormatter stringFromDate:date];
    return newDateStr;
}
@end
