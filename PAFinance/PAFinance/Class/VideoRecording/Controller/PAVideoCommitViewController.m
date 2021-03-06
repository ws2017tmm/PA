//
//  PAVideoCommitViewController.m
//  PAFinance
//
//  Created by 李响 on 2019/1/10.
//  Copyright © 2019 StevenWu. All rights reserved.
//

#import "PAVideoCommitViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <PPNetworkHelper.h>
#import "PAValidationCompletedController.h"

#define PAToken @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjoie1wiY3VycmVudFBhZ2VcIjpudWxsLFwicGFnZVNpemVcIjpudWxsLFwidG90YWxQYWdlc1wiOjAsXCJjb3VudFwiOjAsXCJ0b3RhbE51bVwiOjAsXCJkYXRhXCI6bnVsbCxcInRva2VuSWRcIjpudWxsLFwiY2xpZW50SXBcIjpudWxsLFwicmVxdWVzdElkXCI6bnVsbCxcInNlc3Npb25JZFwiOm51bGwsXCJvcHJhdGlvbk9ialwiOm51bGwsXCJidXNpbmVzc1R5cGVcIjpudWxsLFwia2V5XCI6bnVsbCxcInNpZ25LZXlcIjpudWxsLFwiY3VzdG9tZXJJZFwiOm51bGwsXCJjdXN0b21lck5vXCI6bnVsbCxcImN1c3RvbWVyVHlwZVwiOm51bGwsXCJjdXN0b21lck5hbWVcIjpudWxsLFwiY3VzdG9tZXJOYW1lRW5cIjpudWxsLFwiY3VzdG9tZXJPcmdhblR5cGVcIjpudWxsLFwicmVnaXN0ZXJlZENhcGl0YWxDdXJyZW5jeVwiOm51bGwsXCJyZWdpc3RlcmVkQ2FwaXRhbEFtb3VudFwiOm51bGwsXCJlbnRlcnByaXNlVHlwZVwiOm51bGwsXCJyZXNpZGVuY2VcIjpudWxsLFwibGVnYWxSZXByZXNlbnRhdGl2ZU5hbWVcIjpudWxsLFwibGVnYWxSZXByZXNlbnRhdGl2ZUlkVHlwZVwiOm51bGwsXCJsZWdhbFJlcHJlc2VudGF0aXZlSWRcIjpudWxsLFwic2V0dXBEYXRlXCI6bnVsbCxcIm9wZW5CYW5rXCI6bnVsbCxcIm9wZW5CYW5rQWNjb3VudE5vXCI6bnVsbCxcImNvbnRhY3RBZGRyZXNzXCI6bnVsbCxcImNvbnRhY3ROYW1lXCI6bnVsbCxcImNvbnRhY3RQaG9uZVwiOm51bGwsXCJjb250YWN0RW1haWxcIjpudWxsLFwiY29udGFjdE90aGVyXCI6bnVsbCxcInJlbWFya1wiOm51bGwsXCJpbmR1c3RyeVR5cGVcIjpudWxsLFwib3JnYW5pemF0aW9uVHlwZVwiOm51bGwsXCJjZXJ0aWZpY2F0ZUltYWdlSWRcIjpudWxsLFwicmVnaXN0ZXJGbGFnXCI6bnVsbCxcInF1ZXJ5Q3VzdG9tZXJUeXBlXCI6bnVsbCxcInN0YXR1c1wiOm51bGwsXCJ1c2VyTm9cIjpcIkMwMDAwMDkyNjFcIn0ifQ.AK0uzaEO2geC-AK_NGQ86FmOeCUTd1O1U03DJPl45ZU"

@interface PAVideoCommitViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *rephotographBtn;

@property (weak, nonatomic) IBOutlet UIButton *startPlayBtn;


@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic,weak) AVPlayerLayer *playerLayer;
@property (nonatomic,assign) BOOL isPlaying;

@end

@implementation PAVideoCommitViewController

#pragma mark -生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
    [self setupPlayerLayer];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _playerLayer.frame = self.videoImageView.layer.frame;
}

- (void)setupUI {
    self.title = NSLocalizedString(@"Video dual recording", "视频双录");
//    self.videoImageView.image = [self videoHandlePhoto:self.videoUrl];
//    self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.videoImageView.clipsToBounds = YES;
    self.videoImageView.hidden = YES;
    
    PAUserModel *userModel = [PAUserModel sharedUserModel];
    NSString *currentLanguage = NSBundle.mainBundle.preferredLocalizations.firstObject;
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        self.tipLabel.text = [NSString stringWithFormat:@"我理解并确认，%@在富金平台的注册账号使用权属于本单位主体，自注册产生的权利义务由本单位承担。", userModel.companyName];
    } else {
        self.tipLabel.text = [NSString stringWithFormat:@"I understand and confirm,the right to use the registered accounts of %@ in the rich platform belongs to the main body of the unit, and the rights and obligations arising from the self-registration shall be borne by the unit.", userModel.companyName];
    }
    
        
    [self.rephotographBtn setTitle:NSLocalizedString(@"rephotograph", "重拍") forState:UIControlStateNormal];
    [self.commitBtn setTitle:NSLocalizedString(@"commit", "提交") forState:UIControlStateNormal];
    
}

- (void)setupPlayerLayer {
    //创建播放器层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.videoImageView.layer.frame;
    playerLayer.videoGravity =AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:playerLayer atIndex:0];
    _playerLayer = playerLayer;
}

#pragma mark - 创建播放器
- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:[self getAVPlayerItem]];
        [self addAVPlayerNtf:_player.currentItem];
    }
    return _player;
}

- (AVPlayerItem *)getAVPlayerItem {
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:self.videoUrl];
    return playerItem;
}


#pragma mark - 触摸播放图层
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    point = [self.videoImageView.layer convertPoint:point fromLayer:self.view.layer];
    if ([self.videoImageView.layer containsPoint:point]) {
        if (self.isPlaying) {
            [self.player pause];
//            self.videoImageView.hidden = NO;
            self.startPlayBtn.hidden = NO;
        }
    }
}

#pragma mark - 按钮的点事件
- (IBAction)startPlay:(UIButton *)sender {
    [self.player play];
    self.isPlaying = YES;
    self.startPlayBtn.hidden = YES;
}

- (IBAction)recordingAgain {
    [self.navigationController popViewControllerAnimated:YES];
}

// 上传视频
- (IBAction)commitVideo {
    NSDictionary *parameters = @{@"token" : PAToken};
    NSString *filePath = [[self.videoUrl absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    
    [PPNetworkHelper uploadFileWithURL:PAURL(@"uploadVideo") parameters:parameters name:@"file" filePath:filePath progress:^(NSProgress *progress) {
        
        // 进度
        float completed = progress.completedUnitCount / progress.totalUnitCount;
        [SVProgressHUD showProgress:completed status:NSLocalizedString(@"Uploading...", "正在上传...")];
        
    } success:^(id responseObject) {
        
        PAValidationCompletedController *vc = [[PAValidationCompletedController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Upload failed, please re-upload", "上传失败，请重新上传")];
    }];
    
    
}


#pragma mark -播放相关
- (void)addAVPlayerNtf:(AVPlayerItem *)playerItem {
    //监控状态属性
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeAvPlayerNtf {
    AVPlayerItem *playerItem = self.player.currentItem;
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)setVideoUrl:(NSURL *)videoUrl {
//    _videoUrl = videoUrl;
//    [self removeAvPlayerNtf];
//    [self nextPlayer];
//}
//
//- (void)nextPlayer {
//    [self.player seekToTime:CMTimeMakeWithSeconds(0, _player.currentItem.duration.timescale)];
//    [self.player replaceCurrentItemWithPlayerItem:[self getAVPlayerItem]];
//    [self addAVPlayerNtf:self.player.currentItem];
//    if (self.player.rate == 0) {
//        [self.player play];
//    }
//}

- (void)stopPlayer {
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

#pragma mark - 播放完毕
- (void)playbackFinished:(NSNotification *)ntf {
    NSLog(@"视频播放完成");
    [self.player seekToTime:CMTimeMake(0, 1)];
    //    [self.player play];
    
    [self.player pause];
    self.startPlayBtn.hidden = NO;
    
}

- (UIImage *)videoHandlePhoto:(NSURL *)url {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    if (image) {
        NSLog(@"视频截取成功");
    } else {
        NSLog(@"视频截取失败");
    }
    
    return image;
}


- (void)dealloc {
    [self removeAvPlayerNtf];
    [self stopPlayer];
    self.player = nil;
}

@end
