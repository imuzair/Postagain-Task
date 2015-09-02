//
//  UDAudio.h
//  DoctorsBag
//
//  Created by Uzair Danish on 17/12/2013.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@protocol UDAudioDelegate <NSObject>

@required
@optional
- (void)udAudioRecorderDidFinishRecording:(NSMutableDictionary *)audioDict;
- (void)udAudioPlayerDidFinishPlaying;
@end

@interface UDAudio : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>{

    AVAudioRecorder *recorder;
    NSString *recorderFilePath;
    
    NSMutableDictionary *recordSetting;
    int audioDuration;
    NSString *duration;
    
    NSString *caldate;
    
    AVAudioPlayer *audioPlayer;
    
    BOOL isWorking;
    
}

@property (nonatomic, assign) id <UDAudioDelegate> delegate;

+ (UDAudio *)audioSingleton;
- (void)startRecording;
- (void)stopRecording;
- (void)playAudioStream:(NSString *)urlString;
- (BOOL)isworking;

@end
