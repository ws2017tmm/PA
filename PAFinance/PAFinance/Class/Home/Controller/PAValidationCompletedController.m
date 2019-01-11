//
//  PAValidationCompletedController.m
//  PAFinance
//
//  Created by 李响 on 2019/1/11.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import "PAValidationCompletedController.h"

@interface PAValidationCompletedController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation PAValidationCompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Authentication completed", "认证完成");
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:nil target:self action:@selector(back)];
    
    self.tipLabel.text = NSLocalizedString(@"Please wait patiently for the review of Fukuda financial personnel. The results of the audit will be notified to you by SMS.", "请耐心等待福田金融业务人员的审核，审核的结果将以短信通知您。");
    
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
