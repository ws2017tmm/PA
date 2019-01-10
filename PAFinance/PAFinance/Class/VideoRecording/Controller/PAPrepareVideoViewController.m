//
//  PAPrepareVideoViewController.m
//  PAFinance
//
//  Created by StevenWu on 2019/1/8.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import "PAPrepareVideoViewController.h"
#import "PANextStepView.h"
#import "PAVideoRecordController.h"

@interface PAPrepareVideoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *prepareLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel3;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel4;

@property (weak, nonatomic) IBOutlet UIButton *startVideoButton;

/// 顶部的123view
@property (weak, nonatomic) PANextStepView *nextsetpView;

@end

@implementation PAPrepareVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _nextsetpView.frame = CGRectMake(0, 10, WSScreenW, 40);
    
}

- (void)setupUI {
    
    // 不延伸
    self.edgesForExtendedLayout = NO;
    
    // topNextStepView
    PANextStepView *nextsetpView = [PANextStepView viewFromXib];
    nextsetpView.index = 2;
    [self.view addSubview:nextsetpView];
    _nextsetpView = nextsetpView;
    
    
    self.title = NSLocalizedString(@"Video dual recording", "视频双录");
    self.totalTipLabel.text = NSLocalizedString(@"Please record a video to confirm your identity.", "请您录制一段视频来确认您的身份");
    self.prepareLabel.text = NSLocalizedString(@"Please get ready before video recording", "视频录制前请做好一下准备");
    
    self.tipLabel1.text = NSLocalizedString(@"Get enough light", "光线充足");
    self.tipLabel2.text = NSLocalizedString(@"Quiet around", "周围安静");
    self.tipLabel3.text = NSLocalizedString(@"Do not hide your face", "勿遮挡面部";);
    self.tipLabel4.text = NSLocalizedString(@"Clear voice", "声音清晰");
    
    [self.startVideoButton setTitle:NSLocalizedString(@"start recording", "开始录制") forState:UIControlStateNormal];
    self.startVideoButton.layer.cornerRadius = 5;
    self.startVideoButton.layer.masksToBounds = YES;
    
}

- (IBAction)startRecording {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"视频录制会产生较大流量，请尽量使用WIFI" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        PAVideoRecordController *videoC = [[PAVideoRecordController alloc] init];
        //    [self presentViewController:videoC animated:YES completion:nil];
        [self.navigationController pushViewController:videoC animated:YES];
    }];
    [alertVC addAction:comfirmAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
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
