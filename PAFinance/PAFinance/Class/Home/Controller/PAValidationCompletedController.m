//
//  PAValidationCompletedController.m
//  PAFinance
//
//  Created by 李响 on 2019/1/11.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import "PAValidationCompletedController.h"

@interface PAValidationCompletedController ()

@end

@implementation PAValidationCompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"认证完成";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:nil target:self action:@selector(back)];
    
    
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
