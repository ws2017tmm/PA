//
//  PAInfoValidationViewController.m
//  PAFinance
//
//  Created by 李响 on 2018/12/29.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "PAInfoValidationViewController.h"
#import "PANextStepView.h"
#import "FaceStreamDetectorViewController.h"

@interface PAInfoValidationViewController ()

/// 企业代表
@property (weak, nonatomic) IBOutlet UILabel *enterprisesLabel;
/// 公司名称
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
/// 法人
@property (weak, nonatomic) IBOutlet UILabel *legalPersonLabel;
/// 法人名字
@property (weak, nonatomic) IBOutlet UILabel *legalNameLabel;
/// 身份证
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
/// 身份证号码
@property (weak, nonatomic) IBOutlet UILabel *idCardNumberLabel;
/// 请注意
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
/// 描述注意事项
@property (weak, nonatomic) IBOutlet UILabel *descAttentionLabel;
/// 下一步
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

/// 顶部的123view
@property (weak, nonatomic) PANextStepView *nextsetpView;

@end

@implementation PAInfoValidationViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置UI
    [self setupUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _nextsetpView.frame = CGRectMake(0, 10, WSScreenW, 40);

}

#pragma mark - 设置UI
- (void)setupUI {
    
    self.title = @"信息确认";
    // 不延伸
    self.edgesForExtendedLayout = NO;
    
    // topNextStepView
    PANextStepView *nextsetpView = [PANextStepView viewFromXib];
    nextsetpView.index = 0;
    [self.view addSubview:nextsetpView];
    _nextsetpView = nextsetpView;
    
    PAUserModel *userModel = [PAUserModel sharedUserModel];
    
    /// 企业代表
    self.enterprisesLabel.text = NSLocalizedString(@"representative of enterprises", "企业代表");
    /// 公司名称
    self.companyNameLabel.text = userModel.companyName;
    /// 法人
    self.legalPersonLabel.text = NSLocalizedString(@"Legal Representative", "法定代表人");
    /// 法人名字
    self.legalNameLabel.text = userModel.legalPersonName;
    /// 身份证
    self.idCardLabel.text = NSLocalizedString(@"IDCard", "身份证");
    /// 身份证号码
    NSString *tempStr = @"12345678908645".securyIdCardNumber;
//    self.idCardNumberLabel.text = userModel.idCardNumber.securyIdCardNumber;
    self.idCardNumberLabel.text = tempStr;
    /// 请注意
    self.attentionLabel.text = NSLocalizedString(@"Please note that", "请注意");
    /// 描述注意事项
    self.descAttentionLabel.text = NSLocalizedString(@"Follow-up operations require legal representatives to authenticate face recognition, video acquisition and so on. If the authenticated user is not the legal representative of the enterprise, the latter authentication will not be passed. Are you sure?", "后续操作需要法定代表人进行人脸识别、 视频采集等认证，如该认证用户并非企业法定代表人，则后缕认证将无法被通过， 是否确认?");
    /// 下一步
    [self.nextStepButton setTitle:NSLocalizedString(@"nextStep", "下一步") forState:UIControlStateNormal];
    self.nextStepButton.layer.cornerRadius = 3;
    self.nextStepButton.clipsToBounds = YES;
}

#pragma mark - 按钮的点击事件
- (IBAction)showOrHiddenIdCard:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.isSelected) {
        NSString *tempStr = @"12345678908645";
//    self.idCardNumberLabel.text = userModel.idCardNumber.securyIdCardNumber;
        self.idCardNumberLabel.text = tempStr;
    } else {
        NSString *tempStr = @"12345678908645".securyIdCardNumber;
//    self.idCardNumberLabel.text = userModel.idCardNumber.securyIdCardNumber;
        self.idCardNumberLabel.text = tempStr;
    }
}

/// 去人脸识别界面
- (IBAction)nextStep {
    FaceStreamDetectorViewController *faceVC = [[FaceStreamDetectorViewController alloc]init];
//    faceVC.faceDelegate = self;
    [self.navigationController pushViewController:faceVC animated:YES];
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
