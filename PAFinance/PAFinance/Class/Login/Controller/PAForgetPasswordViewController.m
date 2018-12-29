//
//  PAForgetPasswordViewController.m
//  PAFinance
//
//  Created by 李响 on 2018/12/28.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "PAForgetPasswordViewController.h"

@interface PAForgetPasswordViewController ()


@end

@implementation PAForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Forget password", "忘记密码");
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
