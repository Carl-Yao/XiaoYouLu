/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.h
//  WeiXiaoYuan
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> 
#import "MALTabBarViewController.h"
static NSString* PUSH_SENDER = @"pushSender";
static NSString* PUSH_TITLE = @"pushTitle";
static NSString* PUSH_CONTENT = @"pushContent";
static NSString* PUSH_DATE = @"pushDate";
static NSString* PUSH_IMAGE = @"pushImage";
static NSString* PUSH_ID = @"pushID";
static NSString* PUSH_TYPE = @"pushType";
static NSString* USER_MINPIC = @"userPic";
static NSString* FEEDBACK_ID = @"feedbackID";
//#import <Cordova/CDVViewController.h>

@interface AppDelegate : NSObject <UIApplicationDelegate>{}

// invoke string is passed to your app on launch, this is only valid if you
// edit WeiXiaoYuan-Info.plist to add a protocol
// a simple tutorial can be found here :
// http://iphonedevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *userId;

@property (nonatomic, strong) IBOutlet UIWindow* window;
//@property (nonatomic, strong) IBOutlet CDVViewController* viewController;
@property(strong,nonatomic,readonly)NSManagedObjectModel* managedObjectModel;

@property(strong,nonatomic,readonly)NSManagedObjectContext* managedObjectContext;

@property(strong,nonatomic,readonly)NSPersistentStoreCoordinator* persistentStoreCoordinator;

@property(strong,nonatomic)NSDictionary* titlesDictionary;
@property(strong,nonatomic)MALTabBarViewController* tabbarViewController;
- (void)addIntoDataSource:(NSDictionary*)dictionary;
- (NSArray*)query;
- (void)del:(NSString*) pushID;

@property(strong,nonatomic) NSString *schoolName;
@property(strong,nonatomic) UIImage *logoImg;
@end
