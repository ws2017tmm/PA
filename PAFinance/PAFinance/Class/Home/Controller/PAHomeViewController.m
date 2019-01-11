//
//  PAHomeViewController.m
//  PAFinance
//
//  Created by StevenWu on 2018/12/28.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "PAHomeViewController.h"
#import "PALoginViewController.h"
#import <PPNetworkHelper.h>
#import "PAInfoValidationViewController.h"

@interface PAHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *mineButton;

@property (weak, nonatomic) IBOutlet UILabel *CACertificateLabel;

@property (weak, nonatomic) IBOutlet UILabel *desCerLabel;



@end

@implementation PAHomeViewController {
    // 监听器
    id _autoLoginFailureObserver;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 监听通知
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    // 设置UI
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}


#pragma mark - 设置UI界面
- (void)setupUI {
    self.topBgImageView.image = [UIImage imageWithColor:WSHexColor(@"0x225bc7")];
    self.titleLabel.text = NSLocalizedString(@"One-Account Finance", "金融壹账通");
    self.subTitleLabel.text = NSLocalizedString(@"Serving SMEs and Core Enterprises", "服务于中小企业、核心企业");
    self.CACertificateLabel.text = NSLocalizedString(@"CA Certificate", "CA证书");
    self.desCerLabel.text = NSLocalizedString(@"Digital Certificate Encryption", "数字证书加密");
    
    PAUserModel *userModel = [PAUserModel sharedUserModel];
    if (userModel.ID.length > 0) {
        self.mineButton.userInteractionEnabled = NO;
        [self.mineButton setTitle:NSLocalizedString(@"mine", "我的") forState:UIControlStateNormal];
    } else {
        [self.mineButton setTitle:NSLocalizedString(@"Login", "登录") forState:UIControlStateNormal];
        self.mineButton.userInteractionEnabled = YES;
    }
    
}

/// 监听通知
- (void)addNotification {
    _autoLoginFailureObserver = [PANotificationCenter addObserverForName:PAAutoLoginFailureNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        // 弹出登录框,让用户去登录
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Expiration notice", "过期通知") message:NSLocalizedString(@"Because you have not logged in for a long time, you need to log in again.", "由于你长期未登录账号,需要重新登录。") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", "好的") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self login];
        }];
        [alertVC addAction:confirmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
}


#pragma mark - 按钮的点击事件
/// CA验证
- (IBAction)CAVerifyAction {
    
    PAUserModel *userModel = [PAUserModel sharedUserModel];
    if (userModel.ID.length < 0) {
        [self login];
    } else {
        if (userModel.isCAVerified) { // 验证过-> 去CA认证(调三方SDK)
            
            
        } else { // 未验证过 -> 去人脸识别,视频录制
            PAInfoValidationViewController *infoVC = [[PAInfoValidationViewController alloc] init];
            [self.navigationController pushViewController:infoVC animated:YES];
            
            
        }
        
    }
    
    
}

- (IBAction)login {
    PALoginViewController *vc = PAStoryboardInitialVC(@"Login");
//    vc.rootVC = NO;
    [self presentViewController:vc animated:YES completion:nil];
}



#pragma mark - 销毁
- (void)dealloc {
    //移除观察者 _observe
    [[NSNotificationCenter defaultCenter] removeObserver:_autoLoginFailureObserver];
}

@end
