//
//  UDAudio.m
//  DoctorsBag
//
//  Created by Uzair Danish on 17/12/2013.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#import "UDAudio.h"

#define AUDIO_DIRECTORY_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

static UDAudio *audioSingleton = nil;

@implementation UDAudio
@synthesize delegate;

+ (UDAudio *)audioSingleton{
   	@synchronized(self) {
		if (audioSingleton == nil)
			audioSingleton = [[self alloc] init];
        
	}
	return audioSingleton;
}

- (BOOL)isworking{
    
    return isWorking;
}

- (void)startRecording{
    
    if (!isWorking) {
        
        isWorking = YES;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
        if(err){
            NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
            return;
        }
        [audioSession setActive:YES error:&err];
        err = nil;
        if(err)
        {
            NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            return;
        }
        
        recordSetting = [[NSMutableDictionary alloc] init];
        recordSetting = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithFloat:16000.0],AVSampleRateKey,
                         [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                         [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                         [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                         [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                         [NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                         [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                         [NSData data], AVChannelLayoutKey, nil];
        
        // Create a new dated file
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
        caldate = [now description];
        if (![[NSFileManager defaultManager] fileExistsAtPath:AUDIO_DIRECTORY_PATH]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:AUDIO_DIRECTORY_PATH
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        recorderFilePath = [NSString stringWithFormat:@"%@/%@.wav", AUDIO_DIRECTORY_PATH, caldate];
        
        NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
        err = nil;
        recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        if(!recorder){
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: [err localizedDescription]
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        //prepare to record
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        
        BOOL audioHWAvailable = audioSession.inputAvailable;
        
        if (! audioHWAvailable) {
            UIAlertView *cantRecordAlert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: @"Audio input hardware not available"
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [cantRecordAlert show];
            return;
        }
        
        // start recording
    //    [recorder recordForDuration:15.0];
        [recorder record];
    }
    
}

- (void)stopRecording{

    if ([recorder isRecording]){
        [recorder stop];
        isWorking = NO;
    }
}

- (NSData *)stopRec{
    
    NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
    if(!audioData){
        
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        
    }
    [self deleteFileFromDirectory:[NSString stringWithFormat:@"%@/%@.wav", AUDIO_DIRECTORY_PATH, caldate]];
    return audioData;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    
    duration = [NSString stringWithFormat:@"%d", audioDuration];
    audioDuration = 0;
    NSLog(@"audio duration:%@", duration);
    if ([duration intValue] > 15)
        duration = @"15";
    
    NSData *audioData = [self stopRec];
    
    NSMutableDictionary *datdDict = [[NSMutableDictionary alloc] init];
    [datdDict setValue:[NSString stringWithFormat:@"00:%@",duration] forKey:@"Seconds"];
    [datdDict setValue:[NSString stringWithFormat:@"%@/%@.wav", AUDIO_DIRECTORY_PATH, caldate] forKey:@"FilePath"];
    [datdDict setObject:audioData forKey:@"NSAudioData"];
    
    [delegate udAudioRecorderDidFinishRecording:datdDict];
    
}

-(void)deleteFileFromDirectory:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success =[fileManager removeItemAtPath:filePath error:&error];
    
    if (success)
        NSLog(@"File deleted Successfully");
    else
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
}

# pragma mark - Play Audio

- (void)playAudioStream:(NSString *)urlString{
    
    if (![audioPlayer isPlaying]) {
        
        if (!isWorking) {
        
            NSError *error = nil;
            NSError *error2 = nil;
            
            NSData *songFile = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMappedIfSafe error:&error ];
            audioPlayer = [[AVAudioPlayer alloc] initWithData:songFile error:&error2];
            
            if (audioPlayer) {
                
                [audioPlayer setDelegate:self];
                [audioPlayer setVolume:1.0];
                [audioPlayer prepareToPlay];
                [audioPlayer play];
                isWorking = YES;
            }
            else{
                
                NSLog(@"error: %@", error);
                NSLog(@"error2: %@", error2);
                [Alert show:@"Alert" andMessage:[NSString stringWithFormat:@"Unable To play the audio due to the reason %@",error2.description]];
            }
        }
    }
    else{
        [audioPlayer stop];
        isWorking = NO;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [delegate udAudioPlayerDidFinishPlaying];
    NSLog(@"audioPlayerDidFinishPlaying:%d", flag);
    audioPlayer = nil;
    isWorking = NO;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *) player error:(NSError *) error
{
    NSLog(@"audioPlayerDecodeErrorDidOccur:%@", [error localizedDescription]);
    audioPlayer = nil;
    isWorking = NO;
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *) player
{
    NSLog(@"audioPlayerBeginInterruption");
    audioPlayer = nil;
    isWorking = NO;
}


@end
