//
//  FaceStreamDetectorViewController.m
//  IFlyFaceDemo
//
//  Created by 付正 on 16/3/1.
//  Copyright (c) 2016年 fuzheng. All rights reserved.
//

#import "FaceStreamDetectorViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "PermissionDetector.h"
#import "UIImage+Extensions.h"
#import "UIImage+compress.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import "DemoPreDefine.h"
#import "CaptureManager.h"
#import "CanvasView.h"
#import "CalculatorTools.h"
#import "UIImage+Extensions.h"
#import "IFlyFaceImage.h"
#import "IFlyFaceResultKeys.h"
#import "PANextStepView.h"
#import <PPNetworkHelper.h>
#import <SVProgressHUD.h>
#import "PAPrepareVideoViewController.h"

@interface FaceStreamDetectorViewController ()<CaptureManagerDelegate,CaptureNowImageDelegate>
{
    UILabel *alignLabel;
    int number;//
    int takePhotoNumber;
    NSTimer *timer;
    NSInteger timeCount;
    UIImageView *imgView;//动画图片展示
    
    BOOL isCrossBorder;//判断是否越界
    BOOL isJudgeMouth;//判断张嘴操作完成
    BOOL isShakeHead;//判断摇头操作完成
    
    //嘴角坐标
    int leftX;
    int rightX;
    int lowerY;
    int upperY;
    
    //嘴型的宽高（初始的和后来变化的）
    int mouthWidthF;
    int mouthHeightF;
    int mouthWidth;
    int mouthHeight;
    
    //记录摇头嘴中(最终)点的数据
    int bigNumber;
    int smallNumber;
    int firstNumber;
}
@property (nonatomic, retain ) UIView         *previewView;
@property (nonatomic, strong ) UILabel        *textLabel;
/// 刷脸验证label
@property (nonatomic, strong ) UILabel        *titleLabel;
/// 刷脸验证下面一行字label
@property (nonatomic, strong ) UILabel        *tipLabel;
/// 开始拍摄
@property (nonatomic, strong ) UIButton       *startShot;
/// 动画线
@property (nonatomic, strong ) UIView         *lineView;

// 拍照操作
/// 照片背景
@property (nonatomic, strong ) UIView         *backView;
///照片展示
@property (nonatomic, strong ) UIImageView    *imageView;


@property (nonatomic, retain ) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain ) CaptureManager             *captureManager;

@property (nonatomic, retain ) IFlyFaceDetector           *faceDetector;
/// 矩形框，放人脸的狂，四个角
@property (nonatomic, strong ) CanvasView                 *viewCanvas;
@property (nonatomic, strong ) UITapGestureRecognizer     *tapGesture;

/// 顶部的123view
@property (weak, nonatomic) PANextStepView *nextsetpView;
@property (assign, nonatomic) BOOL isStarting;

@end

@implementation FaceStreamDetectorViewController
@synthesize captureManager;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //创建界面
    [self makeUI];
    //创建摄像页面
    [self makeCamera];
    //创建数据
    [self makeNumber];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止摄像
    [self.previewLayer.session stopRunning];
    [self.captureManager removeObserver];
}

-(void)makeNumber
{
    //张嘴数据
    number = 0;
    takePhotoNumber = 0;
    
    mouthWidthF = 0;
    mouthHeightF = 0;
    mouthWidth = 0;
    mouthHeight = 0;
    
    //摇头数据
    bigNumber = 0;
    smallNumber = 0;
    firstNumber = 0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _nextsetpView.frame = CGRectMake(0, 10, WSScreenW, 40);
    self.startShot.ws_y = self.view.ws_height - self.startShot.ws_height - 10;

}

#pragma mark --- 创建UI界面
-(void)makeUI
{
    // 下一步view（1-2-3）
    PANextStepView *nextsetpView = [PANextStepView viewFromXib];
    nextsetpView.index = 1;
    [self.view addSubview:nextsetpView];
    _nextsetpView = nextsetpView;
    
    CGFloat previewViewWH = ScreenWidth * 0.8;
    CGFloat previewViewX = (ScreenWidth-previewViewWH) * 0.5;
    self.previewView = [[UIView alloc]initWithFrame:CGRectMake(previewViewX, 80, previewViewWH, previewViewWH)];
    self.previewView.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.previewView];
    
    // 动画图片提示
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-ScreenHeight/6+10)/2, CGRectGetMaxY(self.previewView.frame)+15, ScreenHeight/6-10, ScreenHeight/6-10)];
    [self.view addSubview:imgView];
    
    // 提示文字的label(张嘴,摇头)
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+10, ScreenWidth, 30)];
    self.textLabel.backgroundColor = UIColor.redColor;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.layer.cornerRadius = 15;
    self.textLabel.text = NSLocalizedString(@"Please follow the instructions.", "请按提示做动作");
    self.textLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.textLabel];
    self.textLabel.hidden = YES;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.text = NSLocalizedString(@"Brush face verification", "刷脸验证");
    [self.titleLabel sizeToFit];
    self.titleLabel.ws_centerX = self.previewView.ws_centerX;
    self.titleLabel.ws_y = self.previewView.ws_bottomY + 20;
    [self.view addSubview:self.titleLabel];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.text = NSLocalizedString(@"You need to brush your face to verify your identity\nPlease take a picture of your face to confirm your identity.", "您需要刷脸来验证身份\n请拍摄脸部来确认身份");
    [self.tipLabel sizeToFit];
    self.tipLabel.ws_centerX = self.previewView.ws_centerX;
    self.tipLabel.ws_y = self.titleLabel.ws_bottomY + 5;
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = UIColor.lightGrayColor;
    [self.view addSubview:self.tipLabel];
    
    self.startShot = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startShot.ws_width = self.view.ws_width * 0.85;
    self.startShot.ws_height = 50;
    self.startShot.ws_centerX = self.view.ws_centerX;
//    self.startShot.ws_y = self.view.ws_bottomY - self.startShot.ws_height - 10;
    [self.startShot setBackgroundColor:WSHexColor(@"0x5574FF")];
    [self.startShot setTitle:NSLocalizedString(@"Start shooting", "开始拍摄") forState:UIControlStateNormal];
    [self.startShot addTarget:self action:@selector(startShot:) forControlEvents:UIControlEventTouchUpInside];
    self.startShot.layer.cornerRadius = 5;
    self.startShot.layer.masksToBounds = YES;
    [self.view addSubview:self.startShot];
    
    
    
}

- (UIView *)backView {
    if (_backView == nil) {
        //背景View
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-WSNavAndStatusHight)];
        _backView.backgroundColor = [UIColor whiteColor];
        
        //图片放置View
        _imageView = [[UIImageView alloc] init];
        _imageView.ws_width = _backView.ws_width - 20;
        _imageView.ws_height = _backView.ws_height * 0.6;
        _imageView.ws_centerX = _backView.ws_centerX;
        _imageView.ws_y = (_backView.ws_height - 50 - _imageView.ws_height) * 0.5;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_backView addSubview:_imageView];
        
        //button上传图片
        UIButton *uploadBtn = [UIButton buttonWithTitle:NSLocalizedString(@"Confirm upload", "确认上传") font:15 textColor:WSHexColor(@"0x5574FF") backgroundColor:UIColor.whiteColor target:self selector:@selector(didClickUpPhoto)];
        uploadBtn.ws_width = self.view.ws_width * 0.5;
        uploadBtn.ws_height = 50;
        uploadBtn.ws_x = 0;
        uploadBtn.ws_y = _backView.ws_height - uploadBtn.ws_height;
        [_backView addSubview:uploadBtn];
        
        //重拍图片按钮
        UIButton *reShootingBtn = [UIButton buttonWithTitle:NSLocalizedString(@"Re shooting", "重新拍摄") font:15 textColor:UIColor.whiteColor backgroundColor:WSHexColor(@"0x5574FF") target:self selector:@selector(didClickPhotoAgain)];
        reShootingBtn.ws_width = self.view.ws_width * 0.5;
        reShootingBtn.ws_height = 50;
        reShootingBtn.ws_x = uploadBtn.ws_width;
        reShootingBtn.ws_y = _backView.ws_height - reShootingBtn.ws_height;
        [_backView addSubview:reShootingBtn];
    }
    return _backView;
}


#pragma mark --- 创建相机
-(void)makeCamera
{
    self.title = NSLocalizedString(@"Face recognition", "人脸识别");
    //adjust the UI for iOS 7
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER ){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
//    self.view.backgroundColor = [UIColor blackColor];
    self.previewView.backgroundColor = [UIColor clearColor];
    
    //设置初始化打开识别
    self.faceDetector = [IFlyFaceDetector sharedInstance];
    [self.faceDetector setParameter:@"1" forKey:@"detect"];
    [self.faceDetector setParameter:@"1" forKey:@"align"];
    
    //初始化 CaptureSessionManager
    self.captureManager = [[CaptureManager alloc] init];
    self.captureManager.capturedelegate = self;
    
    self.previewLayer = self.captureManager.previewLayer;
    
    self.captureManager.previewLayer.frame = self.previewView.frame;
    //    self.captureManager.previewLayer.position = self.previewView.center;
    self.captureManager.previewLayer.position = CGPointMake(self.previewView.frame.size.width*0.5, self.previewView.frame.size.height*0.5);
    self.captureManager.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.captureManager.previewLayer];
    
    self.viewCanvas = [[CanvasView alloc] initWithFrame:self.captureManager.previewLayer.frame];
    [self.previewView addSubview:self.viewCanvas];
    self.viewCanvas.center=self.captureManager.previewLayer.position;
    self.viewCanvas.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, self.viewCanvas.ws_width, 1);
    lineView.backgroundColor = UIColor.blueColor;
    [self.viewCanvas addSubview:lineView];
    self.lineView = lineView;
    [self startAnimation];
    
    
    
//    NSString *str = [NSString stringWithFormat:@"{{%f, %f}, {220, 240}}",(ScreenWidth-220)/2,(ScreenWidth-240)/2+15];
    NSString *str = [NSString stringWithFormat:@"%@",NSStringFromCGRect(self.previewView.bounds)];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:str forKey:@"RECT_KEY"];
    [dic setObject:@"1" forKey:@"RECT_ORI"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:dic];
    self.viewCanvas.arrFixed = arr;
    self.viewCanvas.hidden = NO;
    
    //开始摄像
    [self.captureManager setup];
    [self.captureManager addObserver];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    [self.captureManager observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - 开始拍摄
- (void)startShot:(UIButton *)button {
    button.hidden = YES;
    self.isStarting = YES;
    self.titleLabel.hidden = YES;
    self.tipLabel.hidden = YES;
    self.textLabel.hidden = NO;
    
    [self.lineView.layer removeAllAnimations];
    [self.lineView removeFromSuperview];
}

/// 上下扫描动画
- (void)startAnimation {
    [UIView animateWithDuration:1 delay:0.1 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{
        self.lineView.ws_y = self.viewCanvas.ws_bottomY;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 开启识别
- (void)showFaceLandmarksAndFaceRectWithPersonsArray:(NSMutableArray *)arrPersons
{
    if (self.viewCanvas.hidden) {
        self.viewCanvas.hidden = NO;
    }
    self.viewCanvas.arrPersons = arrPersons;
    [self.viewCanvas setNeedsDisplay] ;
}

#pragma mark --- 关闭识别
- (void)hideFace
{
    if (!self.viewCanvas.hidden) {
        self.viewCanvas.hidden = YES;
    }
}

#pragma mark --- 脸部框识别
- (NSString*)praseDetect:(NSDictionary* )positionDic OrignImage:(IFlyFaceImage*)faceImg
{
    if(!positionDic){
        return nil;
    }
    
    // 判断摄像头方向
    BOOL isFrontCamera=self.captureManager.videoDeviceInput.device.position==AVCaptureDevicePositionFront;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.previewLayer.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.previewLayer.frame.size.height / faceImg.width;
    
    CGFloat bottom =[[positionDic objectForKey:KCIFlyFaceResultBottom] floatValue];
    CGFloat top=[[positionDic objectForKey:KCIFlyFaceResultTop] floatValue];
    CGFloat left=[[positionDic objectForKey:KCIFlyFaceResultLeft] floatValue];
    CGFloat right=[[positionDic objectForKey:KCIFlyFaceResultRight] floatValue];
    
    float cx = (left+right)/2;
    float cy = (top + bottom)/2;
    float w = right - left;
    float h = bottom - top;
    
    float ncx = cy ;
    float ncy = cx ;
    
    CGRect rectFace = CGRectMake(ncx-w/2 ,ncy-w/2 , w, h);
    
    if(!isFrontCamera){
        rectFace=rSwap(rectFace);
        rectFace=rRotate90(rectFace, faceImg.height, faceImg.width);
    }
    
    //判断位置
    BOOL isNotLocation = [self identifyYourFaceLeft:left right:right top:top bottom:bottom];
    
    if (isNotLocation==YES) {
        return nil;
    }
    
    NSLog(@"left=%f right=%f top=%f bottom=%f",left,right,top,bottom);
    
    isCrossBorder = NO;
    
    rectFace=rScale(rectFace, widthScaleBy, heightScaleBy);
    
    return NSStringFromCGRect(rectFace);
}

#pragma mark --- 脸部部位识别
-(NSMutableArray*)praseAlign:(NSDictionary* )landmarkDic OrignImage:(IFlyFaceImage*)faceImg
{
    if(!landmarkDic){
        return nil;
    }
    
    // 判断摄像头方向
    BOOL isFrontCamera=self.captureManager.videoDeviceInput.device.position==AVCaptureDevicePositionFront;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.previewLayer.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.previewLayer.frame.size.height / faceImg.width;
    
    NSMutableArray *arrStrPoints = [NSMutableArray array];
    NSEnumerator* keys=[landmarkDic keyEnumerator];
    for(id key in keys){
        id attr=[landmarkDic objectForKey:key];
        if(attr && [attr isKindOfClass:[NSDictionary class]]){
            
            id attr=[landmarkDic objectForKey:key];
            CGFloat x=[[attr objectForKey:KCIFlyFaceResultPointX] floatValue];
            CGFloat y=[[attr objectForKey:KCIFlyFaceResultPointY] floatValue];
            
            CGPoint p = CGPointMake(y,x);
            
            if(!isFrontCamera){
                p=pSwap(p);
                p=pRotate90(p, faceImg.height, faceImg.width);
            }
            
            //判断是否越界
            if (isCrossBorder == YES) {
                [self delateNumber];//清数据
                return nil;
            }
            
            //获取嘴的坐标，判断是否张嘴
            [self identifyYourFaceOpenMouth:key p:p];
            
            //获取鼻尖的坐标，判断是否摇头
            [self identifyYourFaceShakeHead:key p:p];
            
            p=pScale(p, widthScaleBy, heightScaleBy);
            
            [arrStrPoints addObject:NSStringFromCGPoint(p)];
            
        }
    }
    
    return arrStrPoints;
}

#pragma mark --- 脸部识别
-(void)praseTrackResult:(NSString*)result OrignImage:(IFlyFaceImage*)faceImg
{
    
    if(!result){
        return;
    }
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* faceDic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        resultData=nil;
        if(!faceDic){
            return;
        }
        
        NSString* faceRet=[faceDic objectForKey:KCIFlyFaceResultRet];
        NSArray* faceArray=[faceDic objectForKey:KCIFlyFaceResultFace];
        faceDic=nil;
        
        int ret=0;
        if(faceRet){
            ret=[faceRet intValue];
        }
        //没有检测到人脸或发生错误
        if (ret || !faceArray || [faceArray count]<1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideFace];
            }) ;
            return;
        }
        
        //检测到人脸
        NSMutableArray *arrPersons = [NSMutableArray array] ;
        
        for(id faceInArr in faceArray){
            
            if(faceInArr && [faceInArr isKindOfClass:[NSDictionary class]]){
                
                NSDictionary* positionDic=[faceInArr objectForKey:KCIFlyFaceResultPosition];
                NSString* rectString=[self praseDetect:positionDic OrignImage: faceImg];
                positionDic=nil;
                
                NSDictionary* landmarkDic=[faceInArr objectForKey:KCIFlyFaceResultLandmark];
                NSMutableArray* strPoints=[self praseAlign:landmarkDic OrignImage:faceImg];
                landmarkDic=nil;
                
                
                NSMutableDictionary *dicPerson = [NSMutableDictionary dictionary] ;
                if(rectString){
                    [dicPerson setObject:rectString forKey:RECT_KEY];
                }
                if(strPoints){
                    [dicPerson setObject:strPoints forKey:POINTS_KEY];
                }
                
                strPoints=nil;
                
                [dicPerson setObject:@"0" forKey:RECT_ORI];
                [arrPersons addObject:dicPerson] ;
                
                dicPerson=nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showFaceLandmarksAndFaceRectWithPersonsArray:arrPersons];
                });
            }
        }
        faceArray=nil;
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
    }
}

#pragma mark - CaptureManagerDelegate
-(void)onOutputFaceImage:(IFlyFaceImage*)faceImg
{
    if (self.isStarting == NO) return;
    
    NSString* strResult=[self.faceDetector trackFrame:faceImg.data withWidth:faceImg.width height:faceImg.height direction:(int)faceImg.direction];
    NSLog(@"result:%@",strResult);
    
    //此处清理图片数据，以防止因为不必要的图片数据的反复传递造成的内存卷积占用。
    faceImg.data=nil;
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(praseTrackResult:OrignImage:)];
    if (!sig) return;
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:@selector(praseTrackResult:OrignImage:)];
    [invocation setArgument:&strResult atIndex:2];
    [invocation setArgument:&faceImg atIndex:3];
    [invocation retainArguments];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil  waitUntilDone:NO];
    faceImg=nil;
}

#pragma mark --- 判断位置
-(BOOL)identifyYourFaceLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom
{
    //判断位置
    if (right - left < 230 || bottom - top < 250) {
        self.textLabel.text = NSLocalizedString(@"It's too far away...", "太远了...");
        [self delateNumber];//清数据
        isCrossBorder = YES;
        return YES;
    }else if (right - left > 320 || bottom - top > 320) {
        self.textLabel.text = NSLocalizedString(@"Too close...", "太近了...");;
        [self delateNumber];//清数据
        isCrossBorder = YES;
        return YES;
    }else{
        if (isJudgeMouth != YES) {
            self.textLabel.text = NSLocalizedString(@"Repeat opening your mouth, please.", "请重复张嘴动作...");
            [self tomAnimationWithName:@"openMouth" count:2];
#pragma mark --- 限定脸部位置为中间位置
            if (left < 100 || top < 80 || right > 540 || bottom > 400) {
                isCrossBorder = YES;
                isJudgeMouth = NO;
                self.textLabel.text = NSLocalizedString(@"Adjust the position first", "调整下位置先...");
                [self delateNumber];//清数据
                return YES;
            }
        }else if (isJudgeMouth == YES && isShakeHead != YES) {
            self.textLabel.text = NSLocalizedString(@"Repeat shaking your head", "请重复摇头动作...");
            [self tomAnimationWithName:@"shakeHead" count:4];
            number = 0;
        }else{
            takePhotoNumber += 1;
            if (takePhotoNumber == 2) {
                [self timeBegin];
            }
        }
        isCrossBorder = NO;
    }
    return NO;
}

#pragma mark --- 判断是否张嘴
-(void)identifyYourFaceOpenMouth:(NSString *)key p:(CGPoint )p
{
    if ([key isEqualToString:@"mouth_upper_lip_top"]) {
        upperY = p.y;
    }
    if ([key isEqualToString:@"mouth_lower_lip_bottom"]) {
        lowerY = p.y;
    }
    if ([key isEqualToString:@"mouth_left_corner"]) {
        leftX = p.x;
    }
    if ([key isEqualToString:@"mouth_right_corner"]) {
        rightX = p.x;
    }
    if (rightX && leftX && upperY && lowerY && isJudgeMouth != YES) {
        
        number ++;
        if (number == 1 || number == 300 || number == 600 || number ==900) {
            //延时操作
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            mouthWidthF = rightX - leftX < 0 ? abs(rightX - leftX) : rightX - leftX;
            mouthHeightF = lowerY - upperY < 0 ? abs(lowerY - upperY) : lowerY - upperY;
            NSLog(@"%d,%d",mouthWidthF,mouthHeightF);
            //            });
        }else if (number > 1200) {
            [self delateNumber];//时间过长时重新清除数据
            [self tomAnimationWithName:@"openMouth" count:2];
        }
        
        mouthWidth = rightX - leftX < 0 ? abs(rightX - leftX) : rightX - leftX;
        mouthHeight = lowerY - upperY < 0 ? abs(lowerY - upperY) : lowerY - upperY;
        NSLog(@"%d,%d",mouthWidth,mouthHeight);
        NSLog(@"张嘴前：width=%d，height=%d",mouthWidthF - mouthWidth,mouthHeight - mouthHeightF);
        if (mouthWidth && mouthWidthF) {
            //张嘴验证完毕
            if (mouthHeight - mouthHeightF >= 20 && mouthWidthF - mouthWidth >= 15) {
                isJudgeMouth = YES;
                imgView.animationImages = nil;
            }
        }
    }
}

#pragma mark --- 判断是否摇头
-(void)identifyYourFaceShakeHead:(NSString *)key p:(CGPoint )p
{
    if ([key isEqualToString:@"mouth_middle"] && isJudgeMouth == YES) {
        
        if (bigNumber == 0 ) {
            firstNumber = p.x;
            bigNumber = p.x;
            smallNumber = p.x;
        }else if (p.x > bigNumber) {
            bigNumber = p.x;
        }else if (p.x < smallNumber) {
            smallNumber = p.x;
        }
        //摇头验证完毕
        if (bigNumber - smallNumber > 60) {
            isShakeHead = YES;
            [self delateNumber];//清数据
        }
    }
}


#pragma mark --- 重拍按钮点击事件
-(void)didClickPhotoAgain
{
    //清数据
    [self delateNumber];
    
    _backView.hidden = YES;
    [_backView removeFromSuperview];
    _backView = nil;
    
    isJudgeMouth = NO;
    isShakeHead = NO;
    
    self.captureManager.nowImageDelegate=nil;
    
    //开始摄像
    [self.previewLayer.session startRunning];
    self.textLabel.text = NSLocalizedString(@"Please adjust the position.", "请调整位置...");
}

#pragma mark --- 上传图片按钮点击事件
-(void)didClickUpPhoto
{
    NSDictionary *parameters = @{};
    [PPNetworkHelper uploadImagesWithURL:@"uploadImage" parameters:parameters name:@"files" images:@[_imageView.image] fileNames:nil imageScale:1.0 imageType:nil progress:^(NSProgress *progress) {
        // 进度
        float completed = progress.completedUnitCount / progress.totalUnitCount;
        [SVProgressHUD showProgress:completed status:NSLocalizedString(@"Uploading...", "正在上传...")];
    } success:^(id responseObject) {
        // 上传成功
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Upload success", "上传成功")];
        // 去视频录制界面
        [self.navigationController pushViewController:[PAPrepareVideoViewController new] animated:YES];
    } failure:^(NSError *error) {
        // 上传失败
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Upload failed, please re-upload", "上传失败，请重新上传")];
        [self.navigationController pushViewController:[PAPrepareVideoViewController new] animated:YES];
    }];
    
}

#pragma mark - 点击『验证完成』AlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_imageView.image) {
        //上传照片成功
        [self.faceDelegate sendFaceImage:_imageView.image];
        //上传照片失败
        //    [self.faceDelegate sendFaceImageError];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark --- 清掉对应的数
-(void)delateNumber
{
    number = 0;
    takePhotoNumber = 0;
    
    mouthWidthF = 0;
    mouthHeightF = 0;
    mouthWidth = 0;
    mouthHeight = 0;
    
    smallNumber = 0;
    bigNumber = 0;
    firstNumber = 0;
    
    imgView.animationImages = nil;
    imgView.image = [UIImage imageNamed:@"shakeHead0"];
}

#pragma mark --- 计时开始
-(void)timeBegin
{
    timeCount = 3;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    NSString *currentLanguage = NSBundle.mainBundle.preferredLocalizations.firstObject;
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        self.textLabel.text = [NSString stringWithFormat:@"%zd s后拍照...", timeCount];
    } else {
        self.textLabel.text = [NSString stringWithFormat:@"Take a picture after %zd seconds", timeCount];
    }
    
}

#pragma mark --- 时间变为0，拍照
- (void)timerFireMethod:(NSTimer *)theTimer
{
    timeCount --;
    if(timeCount >= 1) {
        NSString *currentLanguage = NSBundle.mainBundle.preferredLocalizations.firstObject;
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            self.textLabel.text = [NSString stringWithFormat:@"%zd s后拍照...", timeCount];
        } else {
            self.textLabel.text = [NSString stringWithFormat:@"Take a picture after %zd seconds", timeCount];
        }    } else {
        [theTimer invalidate];
        theTimer=nil;
        self.captureManager.nowImageDelegate=self;
    }
}

-(void)returnNowShowImage:(UIImage *)image
{
    //停止摄像
    [self.previewLayer.session stopRunning];
    
    //延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        //取得的静态影像
//        self.imageView.backgroundColor = [UIColor lightGrayColor];

        [self.view addSubview:self.backView];

        self.imageView.image = image;

//        self->imageView.frame = CGRectMake(0, 10, ScreenWidth, ScreenWidth*self->imageView.image.size.height/self->imageView.image.size.width);

        [self delateNumber];

        self.captureManager.nowImageDelegate=nil;
    });
    
}

#pragma mark --- 创建button公共方法
/**使用示例:[self buttonWithTitle:@"点 击" frame:CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 40)/3, 150, 40) action:@selector(didClickButton) AddView:self.view];*/
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [view addSubview:button];
    return button;
}

#pragma mark --- UIImageView显示gif动画
- (void)tomAnimationWithName:(NSString *)name count:(NSInteger)count
{
    // 如果正在动画，直接退出
    if ([imgView isAnimating]) return;
    
    // 动画图片的数组
    NSMutableArray *arrayM = [NSMutableArray array];
    
    // 添加动画播放的图片
    for (int i = 0; i < count; i++) {
        // 图像名称
        NSString *imageName = [NSString stringWithFormat:@"%@%d.png", name, i];
        //        UIImage *image = [UIImage imageNamed:imageName];
        // ContentsOfFile需要全路径
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [arrayM addObject:image];
    }
    
    // 设置动画数组
    imgView.animationImages = arrayM;
    // 重复1次
    imgView.animationRepeatCount = 100;
    // 动画时长
    imgView.animationDuration = imgView.animationImages.count * 0.75;
    
    // 开始动画
    [imgView startAnimating];
}

-(void)dealloc
{
    self.captureManager=nil;
    self.viewCanvas=nil;
    [self.previewView removeGestureRecognizer:self.tapGesture];
    self.tapGesture=nil;
}

@end
