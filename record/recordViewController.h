//
//  recordViewController.h
//  record
//
//  Created by 振江 张 on 11-9-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
@interface recordViewController : UIViewController
{
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    
    NSMutableData  * httpDataBuf;
    int recordEncoding;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
    UILabel *lblStatus;
    UIImageView *imageView;
}
@property (nonatomic, retain) IBOutlet UILabel *lblStatus;

-(IBAction) startRecording;
-(IBAction) stopRecording;
-(IBAction) playRecording;
-(IBAction) stopPlaying;

-(IBAction) onUploadDone:(id)sender;
-(IBAction) onUploadError:(id)sender;
-(IBAction) onProgressSelector:(id)sender;

- (IBAction)btnPlayLocal:(id)sender;
- (IBAction)btnHttpUpload:(id)sender;
- (IBAction)btnPlayHttp:(id)sender;
- (IBAction)btnAsyncHttp:(id)sender;

- (IBAction)btnRecordDown:(id)sender;
- (IBAction)btnRecordUp:(id)sender;
- (IBAction)btnRecordExit:(id)sender;
- (IBAction)showSavedPhoto:(id)sender;
- (IBAction)btnShowHttpImage:(id)sender;

@end
