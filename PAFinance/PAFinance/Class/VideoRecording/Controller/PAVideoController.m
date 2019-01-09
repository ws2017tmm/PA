//
//  PAVideoController.m
//  GHMetroSupervision
//
//  Created by StevenWu on 2018/1/9.
//  Copyright © 2018年 StevenWu. All rights reserved.
//

#import "PAVideoController.h"
#import "PAVideoView.h"

#define WeakSelf __weak typeof(self) weakSelf = self;

@interface PAVideoController ()<PAVideoViewDelegate>
@property (nonatomic,strong) PAVideoView *PAVideoView;

@end

@implementation PAVideoController


#pragma mark - View Controller LifeCyle // 生命周期的方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialData];
    
    if (_photographFlag) {
        _PAVideoView.PASeconds = 0; // 0秒就只能拍照
    } else {
        _PAVideoView.PASeconds = 10;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.PAVideoView startSession];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    self.title = @"";
}


#pragma mark - Target Methods // 点击事件

/**
 返回
 */
- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
