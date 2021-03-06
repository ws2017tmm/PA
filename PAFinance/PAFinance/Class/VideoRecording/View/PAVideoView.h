//
//  PAVideoView.h
//  GHMetroSupervision
//
//  Created by StevenWu on 2018/1/9.
//  Copyright © 2018年 StevenWu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PAVideoView;

@protocol PAVideoViewDelegate<NSObject>

@optional
// 返回
- (void)goBack;

/**
 点击完成返回影像资料

 @param imageData 影像资料
 @param isVideo YES 影像 NO 图片
 */
- (void)clickFinishWithImageData:(id)imageData isVideo:(BOOL)isVideo;


/**
 录制完成
 */
- (void)videoView:(PAVideoView *)videoView completeRecording:(NSURL *)videoUrl;


@end

@interface PAVideoView : UIView


@property (nonatomic,weak) id<PAVideoViewDelegate> delegate;

/**
 开始会话
 */
- (void)startSession;

/**
 停止会话
 */
- (void)stopSession;

@property (nonatomic,assign) NSInteger paSeconds; // 录屏时长




@end
