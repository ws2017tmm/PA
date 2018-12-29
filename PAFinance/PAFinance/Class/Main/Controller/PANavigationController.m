//
//  PANavigationController.m
//  PAFinance
//
//  Created by 李响 on 2018/12/28.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "PANavigationController.h"
#import "UIBarButtonItem+Item.h"

@interface PANavigationController ()

@end

@implementation PANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.toolbar.tintColor = WSColor(123, 158, 252);
    
}

/** 重写push方法 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) { // 不是根控制器
        // 隐藏toolbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:nil target:self action:@selector(back)];
    }
    //一定要调父类
    [super pushViewController:viewController animated:animated];
}
      
                                                           
- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
