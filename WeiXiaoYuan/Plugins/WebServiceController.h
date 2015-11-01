//
//  WebServiceController+WebServiceController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/11/2.
//
//
#include "XYLUserInfoBLL.h"

typedef enum{
    GETSERVERADDR,
    LOGIN,
    Other
}METHOD_TYPE;
typedef void (^successDictionaryBlock) (NSDictionary *responseDic);
typedef void (^failBlock) (NSError *error);
@interface WebServiceController:NSObject
{
@private
    NSXMLParser *xmlParser;
    BOOL isReturnFlag;
    NSMutableString *tempString;
    UIView *currentView;
    NSString *appServiceUrl;
    successDictionaryBlock successDicBlock;
    failBlock failErrorBlock;
    NSString *name;
    NSString *password;
}
- (void)SendHttpRequestWithMethod:(NSString*)methodName argsDic:(NSDictionary*)argsDic success:(successDictionaryBlock)successBlock;
+ (WebServiceController*)shareController:(UIView*)view;

@end
