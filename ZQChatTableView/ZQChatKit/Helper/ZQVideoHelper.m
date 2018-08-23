//
//  ZQVideoHelper.m
//  ZQChatTableView
//
//  Created by zzq on 2018/8/22.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQVideoHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface ZQVideoHelper()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *fileOutPut;


@property (nonatomic, strong) dispatch_queue_t captureQueue;
@property (nonatomic, strong) dispatch_queue_t audioQueue;


@end

@implementation ZQVideoHelper

- (void)dealloc {
    NSLog(@"videohelper释放成功");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置录像分辨率
        if ( [self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
            self.session.sessionPreset = AVCaptureSessionPreset640x480;
        }
        //开始配置
//        [self.session beginConfiguration];
        [self configVideo];
        [self configAudio];
        [self configFileOutput];
        //提交配置
//        [self.session commitConfiguration];
        
        [self.session startRunning];
    }
    return self;
}


- (void)configVideo {
    //获取视频设备对象
    AVCaptureDevice *videoDevice;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            videoDevice = device;//前置摄像头
            break;
        }
    }
    //初始化视频捕获输入对象
    NSError *error;
    AVCaptureDeviceInput *videoInput =  [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:&error];
    if (error) {
        NSLog(@"摄像头错误");
    }
    //输入对象添加到Session
    if ([self.session canAddInput:videoInput]) {
        [self.session addInput:videoInput];
    }
    self.videoInput = videoInput;
    //输出对象
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    //是否允许卡顿时丢帧
//    videoOutput.alwaysDiscardsLateVideoFrames = NO;
//    // 设置像素格式
//    [videoOutput setVideoSettings:@{
//                                    (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)
//                                    }];
    //将输出对象添加到队列、并设置代理
    dispatch_queue_t captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [videoOutput setSampleBufferDelegate:self queue:captureQueue];
    self.captureQueue = captureQueue;
    self.videoOutput = videoOutput;
    
    //session添加输出对象
    if ([self.session canAddOutput:self.videoOutput]) {
        [self.session addOutput:self.videoOutput];
    }
    
    self.playerView = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    
    
//    //创建连接  AVCaptureConnection输入对像和捕获输出对象之间建立连接。
//    AVCaptureConnection *connection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
//    //视频的方向
//    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
//    //设置稳定性，判断connection连接对象是否支持视频稳定
//    if ([connection isVideoStabilizationSupported]) {
//        //这个稳定模式最适合连接
//        connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
//    }
//    //缩放裁剪系数
//    connection.videoScaleAndCropFactor = connection.videoMaxScaleAndCropFactor;
}

- (void)configAudio {
    //***音频设置
    //获取音频设备对象
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //初始化捕获输入对象
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:&error];
    if (error) {
        NSLog(@"== 录音设备出错");
    }
    // 添加音频输入对象到session
    if ([self.session canAddInput:audioInput]) {
        [self.session addInput:audioInput];
    }
    //初始化输出捕获对象
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    // 创建设置音频输出代理所需要的线程队列
    dispatch_queue_t audioQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    self.audioQueue = audioQueue;
    // 添加音频输出对象到session
    if ([self.session canAddOutput:audioOutput]) {
        [self.session addOutput:audioOutput];
    }
}

- (void)configFileOutput {
    AVCaptureMovieFileOutput *fileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:fileOutput]) {
        [self.session addOutput:fileOutput];
    }

//    AVCaptureConnection *connection = [fileOutput connectionWithMediaType:AVMediaTypeVideo];
//    //设置稳定性，判断connection连接对象是否支持视频稳定
//    if ([connection isVideoStabilizationSupported]) {
//        //这个稳定模式最适合连接
//        connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
//    }
    self.fileOutPut = fileOutput;
}

- (void)startRecordVideo {
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath=[cachePath stringByAppendingPathComponent:@"video.mp4"];
    NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
    
    [self.fileOutPut startRecordingToOutputFileURL:saveUrl recordingDelegate:self];
    self.lastFilePath = savePath;
}

- (void)stopRecordVideo {
    [self.fileOutPut stopRecording];
}

- (void)switchScene {
    AVCaptureDevicePosition positon = self.videoInput.device.position;
    positon = positon == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *videoDevice = nil;
    for(AVCaptureDevice *device in devices) {
        if (device.position == positon) {
            videoDevice = device;//新摄像头
            break;
        }
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:&error];
    
    [self.session beginConfiguration];
    [self.session removeInput:self.videoInput];
    [self.session addInput:videoInput];
    [self.session commitConfiguration];
    self.videoInput = videoInput;
}

#pragma mark - AVCaptureVideoDataAndAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == [self.videoOutput connectionWithMediaType:AVMediaTypeVideo]) {
        // 在此方法进行 AAC 软硬编码
        NSLog(@"视频--数据");
    } else {
        NSLog(@"音频--数据");
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"drop");
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    NSLog(@"开始写入文件");
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"结束写入文件");
}

#pragma mark - setter && getter
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}


@end
