//
//  WebServiceController+WebServiceController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/11/2.
//
//
typedef enum{
    GETSERVERADDR,
    LOGIN,
    Other
}METHOD_TYPE;
@protocol HttpCallbackDelegate
-(void)HttpSuccessDictionaryCallBack:(NSString *)result;
@end
typedef void (^successDictionaryBlock) (NSDictionary *responseDic);
@interface WebServiceController:NSObject
{
@private
    NSXMLParser *xmlParser;
    BOOL isReturnFlag;
    NSMutableString *tempString;
    UIView *currentView;
    NSString *appServiceUrl;
    successDictionaryBlock successDicBlock;
    id<HttpCallbackDelegate> delegate;
    NSString *name;
    NSString *password;
}
- (void)SendHttpRequestWithMethod:(NSString*)methodName argsDic:(NSDictionary*)argsDic success:(successDictionaryBlock)successBlock;
+ (WebServiceController*)shareController:(UIView*)view;

@end
