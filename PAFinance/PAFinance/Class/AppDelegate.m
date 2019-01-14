//
//  AppDelegate.m
//  PAFinance
//
//  Created by StevenWu on 2018/12/27.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "AppDelegate.h"
#import <PPNetworkHelper.h>
#import <SVProgressHUD.h>
#import "PALoginViewController.h"
//#import "iflyMSC/IFlyFaceSDK.h"
#import <iflyMSC/IFlyFaceSDK.h>

#define IFLY_APPID @"5c331496"

//#define kUserID @"kUserID"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    PALoginViewController *vc = PAStoryboardInitialVC(@"Login");
//    vc.rootVC = YES;
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    //配置文件
    [self makeConfiguration];
    
//    [self automaticLogon];
    return YES;
}

-(void)makeConfiguration {
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",IFLY_APPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/// 屏幕支持的方向
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

#define PAToken @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjoie1wiY3VycmVudFBhZ2VcIjpudWxsLFwicGFnZVNpemVcIjpudWxsLFwidG90YWxQYWdlc1wiOjAsXCJjb3VudFwiOjAsXCJ0b3RhbE51bVwiOjAsXCJkYXRhXCI6bnVsbCxcInRva2VuSWRcIjpudWxsLFwiY2xpZW50SXBcIjpudWxsLFwicmVxdWVzdElkXCI6bnVsbCxcInNlc3Npb25JZFwiOm51bGwsXCJvcHJhdGlvbk9ialwiOm51bGwsXCJidXNpbmVzc1R5cGVcIjpudWxsLFwia2V5XCI6bnVsbCxcInNpZ25LZXlcIjpudWxsLFwiY3VzdG9tZXJJZFwiOm51bGwsXCJjdXN0b21lck5vXCI6bnVsbCxcImN1c3RvbWVyVHlwZVwiOm51bGwsXCJjdXN0b21lck5hbWVcIjpudWxsLFwiY3VzdG9tZXJOYW1lRW5cIjpudWxsLFwiY3VzdG9tZXJPcmdhblR5cGVcIjpudWxsLFwicmVnaXN0ZXJlZENhcGl0YWxDdXJyZW5jeVwiOm51bGwsXCJyZWdpc3RlcmVkQ2FwaXRhbEFtb3VudFwiOm51bGwsXCJlbnRlcnByaXNlVHlwZVwiOm51bGwsXCJyZXNpZGVuY2VcIjpudWxsLFwibGVnYWxSZXByZXNlbnRhdGl2ZU5hbWVcIjpudWxsLFwibGVnYWxSZXByZXNlbnRhdGl2ZUlkVHlwZVwiOm51bGwsXCJsZWdhbFJlcHJlc2VudGF0aXZlSWRcIjpudWxsLFwic2V0dXBEYXRlXCI6bnVsbCxcIm9wZW5CYW5rXCI6bnVsbCxcIm9wZW5CYW5rQWNjb3VudE5vXCI6bnVsbCxcImNvbnRhY3RBZGRyZXNzXCI6bnVsbCxcImNvbnRhY3ROYW1lXCI6bnVsbCxcImNvbnRhY3RQaG9uZVwiOm51bGwsXCJjb250YWN0RW1haWxcIjpudWxsLFwiY29udGFjdE90aGVyXCI6bnVsbCxcInJlbWFya1wiOm51bGwsXCJpbmR1c3RyeVR5cGVcIjpudWxsLFwib3JnYW5pemF0aW9uVHlwZVwiOm51bGwsXCJjZXJ0aWZpY2F0ZUltYWdlSWRcIjpudWxsLFwicmVnaXN0ZXJGbGFnXCI6bnVsbCxcInF1ZXJ5Q3VzdG9tZXJUeXBlXCI6bnVsbCxcInN0YXR1c1wiOm51bGwsXCJ1c2VyTm9cIjpcIkMwMDAwMDkyNjFcIn0ifQ.AK0uzaEO2geC-AK_NGQ86FmOeCUTd1O1U03DJPl45ZU"
/// 自动登录
- (void)automaticLogon {
    
    // 取出用户名
//    NSString *userName = [PAUserDefaults objectForKey:kUserName];
    NSString *userName = @"18956331648";
    // 请求成功
    NSDictionary *parameters = @{
                                 @"userName" : userName,
                                 @"token" : PAToken
                                 };
    // 自动登录
//    NSString *PAURL(url) = [NSString stringWithFormat:@"https://103.28.215.253:10489/dockToApp/api/ccs/customer/%@",url];
    [PPNetworkHelper POST:PAURL(@"faceRecognitionDataReturn") parameters:parameters success:^(id responseObject) {// 自动登录成功
        // 做一些事情(比如配置一些...)
        
        
    } failure:^(NSError *error) {
        // 自动登录失败
//        [SVProgressHUD showErrorWithStatus:@"自动登录失败"];
//        [PANotificationCenter postNotificationName:PAAutoLoginFailureNotification object:nil];
    }];
}




@end
