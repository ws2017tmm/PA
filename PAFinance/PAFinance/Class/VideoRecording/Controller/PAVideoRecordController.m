//
//  PAVideoRecordController.m
//  GHMetroSupervision
//
//  Created by StevenWu on 2018/1/9.
//  Copyright © 2018年 StevenWu. All rights reserved.
//

#import "PAVideoRecordController.h"
#import "PAVideoView.h"
#import "PAVideoCommitViewController.h"


#define WeakSelf __weak typeof(self) weakSelf = self;

@interface PAVideoRecordController ()<PAVideoViewDelegate>
@property (nonatomic,strong) PAVideoView *PAVideoView;

@end

@implementation PAVideoRecordController


#pragma mark - View Controller LifeCyle // 生命周期的方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialData];
    
    if (_photographFlag) {
        _PAVideoView.paSeconds = 0; // 0秒就只能拍照
    } else {
        _PAVideoView.paSeconds = 18;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WSRGBAColor(0, 0, 0, 0.8)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:17]}];

//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.PAVideoView startSession];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WSGrayColor(224)] forBarMetrics:UIBarMetricsDefault];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:17]}];

//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.PAVideoView stopSession];
}

#pragma mark - Override // 重载父类的方法
- (void)loadView {
    self.view = self.PAVideoView;
}

#pragma mark - Initial Methods // 初始化的方法

- (void)initialData
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"white_back"] highImage:nil target:self action:@selector(back)];
    
    self.title = @"视频双录";
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Target Methods // 点击事件

/**
 返回
 */
//- (void)goBack {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)clickFinishWithImageData:(id)imageData isVideo:(BOOL)isVideo {
    if (isVideo) {
        NSLog(@"回传视频");
        WeakSelf
        if (weakSelf.takeBlock) {
            weakSelf.takeBlock(imageData);
        }
    } else {
        NSLog(@"回传图片");
        WeakSelf
        if (weakSelf.takeBlock) {
            weakSelf.takeBlock(imageData);
        }
    }
}

#pragma mark - Delegate // 代理
- (void)videoView:(PAVideoView *)videoView completeRecording:(NSURL *)videoUrl {
    
    PAVideoCommitViewController *vc = [[PAVideoCommitViewController alloc] init];
    vc.videoUrl = videoUrl;
    
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - NetworkRequest // 网络请求


#pragma mark - Setter Getter Methods //  懒加载 setter Or getter
- (PAVideoView *)PAVideoView {
    if (!_PAVideoView) {
        _PAVideoView = [PAVideoView new];
        _PAVideoView.delegate = self;
    }
    return _PAVideoView;
}

#pragma mark - Notification Methods //通知事件


#pragma mark - Privater Methods // 私有方法(尽量抽取在公共类)


//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

@end
