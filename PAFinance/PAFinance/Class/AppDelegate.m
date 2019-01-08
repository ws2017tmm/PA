//
//  AppDelegate.m
//  PAFinance
//
//  Created by 李响 on 2018/12/27.
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
#define kUserName @"kUserName"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 进入首页
    // 判断用户是否登录过
    NSString *userName = [PAUserDefaults objectForKey:kUserName];
    if (userName.length >= 0) { // 自动登录
        [self automaticLogon];
        
    } else { // 直接到登录界面
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        PALoginViewController *vc = PAStoryboardInitialVC(@"Login");
        vc.rootVC = YES;
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
    }
    
    //配置文件
    [self makeConfiguration];
    
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


/// 自动登录
- (void)automaticLogon {
    
    // 取出用户名
    NSString *userName = [PAUserDefaults objectForKey:kUserName];
    userName = @"18956331648";
    // 请求成功
    NSDictionary *parameters = @{
                                 @"userName" : userName
                                 };
    // 自动登录
    [PPNetworkHelper POST:@"login" parameters:parameters success:^(id responseObject) {// 自动登录成功
        // 做一些事情(比如配置一些...)
        
        
    } failure:^(NSError *error) {
        // 自动登录失败
//        [SVProgressHUD showErrorWithStatus:@"自动登录失败"];
        [PANotificationCenter postNotificationName:PAAutoLoginFailureNotification object:nil];
    }];
}




@end
