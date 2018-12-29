//
//  PALoginViewController.m
//  PAFinance
//
//  Created by 李响 on 2018/12/27.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "PALoginViewController.h"
#import "PAForgetPasswordViewController.h"
#import "WSLoginTextField.h"
#import <PPNetworkHelper.h>

@interface PALoginViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet WSLoginTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet WSLoginTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordBtn;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;


@end

@implementation PALoginViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 设置UI
- (void)setupUI {
    
    self.bgImageView.image = [UIImage imageWithColor:WSHexColor(@"0x225bc7")];
    
    if (self.isRootVC) {
        self.backButton.hidden = YES;
    } else {
        self.backButton.hidden = NO;
    }
    
    self.titleLabel.text = NSLocalizedString(@"Supply Chain Finance", "供应链金融");
    [self.forgotPasswordBtn setTitle:NSLocalizedString(@"Forget password", "忘记密码") forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"Login", "登录") forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 3;
    self.loginButton.clipsToBounds = YES;
    
    self.phoneTextField.placeholder = NSLocalizedString(@"phone number", "手机号码");
    self.phoneTextField.textFieldStateChanged = ^(BOOL isSelected) {
        if (isSelected) {
            self.line1.backgroundColor = UIColor.whiteColor;
        } else {
            self.line1.backgroundColor = WSColor(221, 221, 221);
        }
    };
    
    self.passwordTextField.placeholder = NSLocalizedString(@"password", "密码");
    self.passwordTextField.delegate = self;
    self.passwordTextField.textFieldStateChanged = ^(BOOL isSelected) {
        if (isSelected) {
            self.line1.backgroundColor = UIColor.whiteColor;
        } else {
            self.line1.backgroundColor = WSColor(221, 221, 221);
        }
    };
    
    [self.showPasswordBtn setImage:[UIImage imageNamed:@"password_hide"] forState:UIControlStateNormal];
    [self.showPasswordBtn setImage:[UIImage imageNamed:@"password_show"] forState:UIControlStateSelected];
}



#pragma mark - 按钮的点击事件
/**
 登录
 */
- (IBAction)login {
    
    // 判断用户名和密码
    NSString *username = self.phoneTextField.text;
    NSString *password = self.passwordTextField.text;
    if (username.length <= 0 || password.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的用户名或密码"];
        return;
    }
    
    NSDictionary *parameters = @{
                           @"userName" : self.phoneTextField.text,
                           @"password" : self.passwordTextField.text
                           };
    [SVProgressHUD show];
    [PPNetworkHelper POST:@"login" parameters:parameters success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
#warning TODO
        // 做一些事情
        PAUserModel *userModel = [PAUserModel sharedUserModel];
        
        [self dismiss];

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}


- (IBAction)dismiss {
    if (self.isRootVC) {
        UITabBarController *tabVC = PAStoryboardInitialVC(@"Main");
        [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


/**
 是否显示密码
 */
- (IBAction)showOrHiddenPassword:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.passwordTextField.secureTextEntry = NO;
    } else {
        self.passwordTextField.secureTextEntry = YES;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 得到输入框的内容
    NSString *textfieldContent = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    NSLog(@"textfieldContent:%@",textfieldContent);
    if ( textField.isSecureTextEntry) {
        textField.text = textfieldContent;
        return NO;
    }
    return YES;
}

@end
