//
//  ZQRecordHelper.h
//  ZQChatTableView
//
//  Created by zzq on 2018/7/16.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef BOOL(^ZQPrepareRecorderCompletion)(void);
typedef void(^ZQStartRecorderCompletion)(void);
typedef void(^ZQStopRecorderCompletion)(void);
typedef void(^ZQPauseRecorderCompletion)(void);
typedef void(^ZQResumeRecorderCompletion)(void);
typedef void(^ZQCancellRecorderDeleteFileCompletion)();
typedef void(^ZQRecordProgress)(float progress);
typedef void(^ZQPeakPowerForChannel)(float peakPowerForChannel);

@interface ZQRecordHelper : NSObject

@property (nonatomic, copy) ZQStopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) ZQRecordProgress recordProgress;
@property (nonatomic, copy) ZQPeakPowerForChannel peakPowerForChannel;
@property (nonatomic, copy, readonly) NSString *recordPath;
@property (nonatomic, copy) NSString *recordDuration;
@property (nonatomic) float maxRecordTime; // 默认 60秒为最大
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(ZQPrepareRecorderCompletion)prepareRecorderCompletion;
- (void)startRecordingWithStartRecorderCompletion:(ZQStartRecorderCompletion)startRecorderCompletion;
- (void)pauseRecordingWithPauseRecorderCompletion:(ZQPauseRecorderCompletion)pauseRecorderCompletion;
- (void)resumeRecordingWithResumeRecorderCompletion:(ZQResumeRecorderCompletion)resumeRecorderCompletion;
- (void)stopRecordingWithStopRecorderCompletion:(ZQStopRecorderCompletion)stopRecorderCompletion;
- (void)cancelledDeleteWithCompletion:(ZQCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

@end
