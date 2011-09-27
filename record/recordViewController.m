//
//  recordViewController.m
//  record
//
//  Created by 振江 张 on 11-9-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "recordViewController.h"
#import "HttpUploader.h"
@implementation recordViewController
@synthesize lblStatus;
@synthesize _moviePlayerController;
@synthesize _moviePlayViewController;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    recordEncoding = ENC_AAC;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(IBAction) startRecording
{
    NSLog(@"startRecording");
    [audioRecorder release];
    audioRecorder = nil;
    
    // Init audio with record capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];   
    }
    else
    {
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case (ENC_AAC): 
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
        /*
         [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
         [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
         [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
         [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
         [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
         */
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.aac", [[NSBundle mainBundle] resourcePath]]];
    
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    
    if ([audioRecorder prepareToRecord] == YES){
        [audioRecorder record];
    }else {
        int errorCode = CFSwapInt32HostToBig ([error code]); 
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode); 
        
    }
    [recordSettings release];
    NSLog(@"recording");
}

-(IBAction) stopRecording
{
    NSLog(@"stopRecording");
    [audioRecorder stop];
    NSLog(@"stopped");
}

-(IBAction) playRecording
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.aac", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

-(IBAction) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
}

- (IBAction)btnRecordDown:(id)sender {
    printf("%s","btnDown");
    [self startRecording];
    [lblStatus setText:[NSString stringWithFormat:@"正在录音...."]];
}

- (IBAction)btnRecordUp:(id)sender {
    printf("%s","btnUp");
    [self stopRecording];
    [lblStatus setText:[NSString stringWithFormat:@"录音完成!!!"]];
}

- (IBAction)btnRecordExit:(id)sender {
    printf("%s","btnExit");
    [self stopRecording];
    [lblStatus setText:[NSString stringWithFormat:@"录音完成!!!"]];
}

- (IBAction)btnPlayLocal:(id)sender {
    if (audioPlayer)
    {
        [self stopPlaying];
        [audioPlayer release];
        audioPlayer=nil;
    }
    [self playRecording];
    //[self showSavedPhoto:sender];
}

- (IBAction)btnHttpUpload:(id)sender {
    [lblStatus setText:@"上传中...."];
    //http://221.7.245.196/up/file/recordTest.aac
    [[[HttpUploader alloc] initWithURL:[NSURL URLWithString:@"http://221.7.245.196/up/Upload"]
                              filePath:[NSString stringWithFormat:@"%@/recordTest.aac", [[NSBundle mainBundle] resourcePath]]
                            remoteFile:[NSString stringWithFormat:@"recordTest.aac"]
                              delegate:self 
                          doneSelector:@selector(onUploadDone:)
                         errorSelector:@selector(onUploadError:)
                      progressSelector:@selector(onProgressSelector:)] autorelease]; 
}   


//异步下载
- (IBAction)btnPlayHttp:(id)sender {
    if (audioPlayer)
    {
        [self stopPlaying];
        [audioPlayer release];
        audioPlayer=nil;
    }
    [lblStatus setText:[NSString stringWithFormat:@"开始经收!!!"]];
    if (httpDataBuf)
        [httpDataBuf release];
    httpDataBuf=[[NSMutableData alloc] init];
    
    NSURL *url=[NSURL URLWithString:@"http://221.7.245.196/up/file/recordTest.aac"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [connection autorelease];
    
}
//接受数据的过成
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%s: self:0x%p\n", __func__, self);
    
    [httpDataBuf appendData:data];
    [lblStatus setText:[NSString stringWithFormat:@"已经收[%d]字节",[httpDataBuf length]]];
    /*
     if (audioPlayer.playing == FALSE) {
     //[lblStatus setText:[NSString stringWithFormat:@"共接收[%d]字节 开始播放",[httpDataBuf length]]];
     AVAudioSession *audioSession = [AVAudioSession sharedInstance];
     [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
     NSError *error;
     audioPlayer =[[AVAudioPlayer alloc] initWithData:httpDataBuf error:&error];
     audioPlayer.numberOfLoops=0;
     [audioPlayer play];
     }
     */
}
//数据接受完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (audioPlayer)
    {
        [self stopPlaying];
        [audioPlayer release];
        audioPlayer=nil;
    }
    if (audioPlayer.playing == FALSE) {
        [lblStatus setText:[NSString stringWithFormat:@"共接收[%d]字节 开始播放",[httpDataBuf length]]];
        // AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        // [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSError *error;
        audioPlayer =[[AVAudioPlayer alloc] initWithData:httpDataBuf error:&error];
        audioPlayer.numberOfLoops=0;
        [audioPlayer play];
    }  
    
}

//同步
- (IBAction)btnAsyncHttp:(id)sender {
    
    if (audioPlayer)
    {
        [self stopPlaying];
        [audioPlayer release];
        audioPlayer=nil;
    }
    if (httpDataBuf)
        [httpDataBuf release];
    httpDataBuf=[[NSMutableData alloc] init];
    
    
    NSString *urlAsString = @"http://221.7.245.196/up/file/recordTest.aac";
    NSURL    *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                       error:&error];
    /* 下载的数据 */
    if (data != nil){
        [httpDataBuf appendData:data];
        //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSError *error;
        audioPlayer =[[AVAudioPlayer alloc] initWithData:httpDataBuf error:&error];
        audioPlayer.numberOfLoops=0;
        [audioPlayer play];
    } else {
        NSLog(@"%@", error);
    } 
}


-(IBAction) onUploadDone:(id)sender
{
    NSLog(@"%s: self:0x%p\n", __func__, self); 
    
}
-(IBAction) onUploadError:(id)sender
{
    NSLog(@"%s: self:0x%p\n", __func__, self); 
    [lblStatus setText:@"上传失败"];
}

-(IBAction) onProgressSelector:(id)sender{
    HttpUploader * http=sender;
    [lblStatus setText:[NSString stringWithFormat:@"已发送[%d]字节 共[%d]字节",[http totalBytesWritten],[http totalBytesExpectedToWrite]]];
}


//上传图片
-(IBAction)showSavedPhoto:(id)sender{
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
		imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
		imagePickerController.delegate = self;
		imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}
    /*
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
     UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
     imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
     imagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
     imagePickerController.allowsEditing = YES;
     imagePickerController.delegate = self;
     imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
     //currentPickerController = imagePickerController;
     [self presentModalViewController:imagePickerController animated:YES];
     [imagePickerController release];
     }
     */
}
//上传视频

- (IBAction)btnSaveVideo:(id)sender {
	NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	if([mediaTypes containsObject:@"public.movie"]){
		UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
		imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
		imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
		imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
		imagePickerController.delegate = self;
		imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}
    /*
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
     UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
     imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
     imagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
     imagePickerController.allowsEditing = NO;
     imagePickerController.delegate = self;
     imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
     //currentPickerController = imagePickerController;
     [self presentModalViewController:imagePickerController animated:YES];
     [imagePickerController release];
     }
     */
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //NSData *data=UIImagePNGRepresentation(image);
        NSData *data=UIImageJPEGRepresentation(image,0.5);
        [lblStatus setText:@"上传图片中...."];
        //http://221.7.245.196/up/file/recordTest.aac
        [[[HttpUploader alloc] initWithData:[NSURL URLWithString:@"http://221.7.245.196/up/Upload"]
                                   fileData:data
                                 remoteFile:[NSString stringWithFormat:@"recordTest.jpg"]
                                   delegate:self 
                               doneSelector:@selector(onUploadDone:)
                              errorSelector:@selector(onUploadError:)
                           progressSelector:@selector(onProgressSelector:)] autorelease];  
    }	else if ([mediaType isEqualToString:@"public.movie"]){
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		NSString *tempFilePath = [videoURL path];
        [lblStatus setText:@"上传视频中...."];
        //http://221.7.245.196/up/file/recordTest.aac
        [[[HttpUploader alloc] initWithURL:[NSURL URLWithString:@"http://221.7.245.196/up/Upload"]
                                  filePath:tempFilePath
                                remoteFile:[NSString stringWithFormat:@"recordTest1.mov"]
                                  delegate:self 
                              doneSelector:@selector(onUploadDone:)
                             errorSelector:@selector(onUploadError:)
                          progressSelector:@selector(onProgressSelector:)] autorelease]; 		
	}
    NSLog(@"%s: self:0x%p\n", __func__, self); 
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"%s: self:0x%p\n", __func__, self); 
	[picker dismissModalViewControllerAnimated:YES];
}


- (IBAction)btnShowHttpImage:(id)sender {
    //[imageView.image initWithData: [ NSData dataWithContentsOfURL: [ NSURL URLWithString: @"http://www.95013.com/images/v2index_img01.gif"]]];
    
    NSURL * imageURL = [NSURL URLWithString:@"http://221.7.245.196/up/file/recordTest.jpg"];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [imageView removeFromSuperview];
    [imageView release];
    imageView = [[UIImageView alloc] initWithImage: image];
    imageView.frame = CGRectMake(20, 345, 280, 95);  
    [self.view addSubview: imageView];    
    
}




//本地视频事件

- (IBAction)btnPlayLocalVideo:(id)sender
{//此方法只是 3。2以后的方法
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"sophie" ofType:@"mov"];
    NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
    MPMoviePlayerViewController* tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:url];
    if (tmpMoviePlayViewController)
    {
        self._moviePlayViewController=tmpMoviePlayViewController;
        
        [self presentMoviePlayerViewControllerAnimated:_moviePlayViewController];
        _moviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [_moviePlayViewController.moviePlayer play];
    }
    [tmpMoviePlayViewController release];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}

- (IBAction)btnPlayURLVideo:(id)sender{
    NSString *videoPath =@"http://221.7.245.196/up/file/recordTest1.mov";
    if (videoPath == NULL)
        return;
    
    [self initAndPlay:videoPath];
}


-(void) initAndPlay:(NSString *)videoURL
{
    if ([videoURL rangeOfString:@"http://"].location!=NSNotFound||[videoURL rangeOfString:@"https://"].location!=NSNotFound) 
    {
        NSURL *URL = [[NSURL alloc] initWithString:videoURL];
        if (URL) {
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 3.2)
            {//3。2以后
                
                MPMoviePlayerViewController* tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:URL];
                if (tmpMoviePlayViewController)
                {
                    self._moviePlayViewController=tmpMoviePlayViewController;
                    
                    [self presentMoviePlayerViewControllerAnimated:_moviePlayViewController];
                    _moviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
                    [_moviePlayViewController.moviePlayer play];
                }
                [tmpMoviePlayViewController release];    
            }
            else if([[[UIDevice currentDevice] systemVersion] doubleValue] < 3.2)
            {//3。2以前
                MPMoviePlayerController* tmpMoviePlayController=[[MPMoviePlayerController alloc] initWithContentURL:URL];
                if (tmpMoviePlayController)                      
                {
                    self._moviePlayerController=tmpMoviePlayController;
                    [_moviePlayerController play];
                }
                [tmpMoviePlayController release];
            }
            //视频播放完成通知
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        }
        [URL release];
    }
}
- (void) playbackDidFinish
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];  
    if (_moviePlayViewController)
    {
        [self dismissMoviePlayerViewControllerAnimated];
        [self._moviePlayViewController.moviePlayer stop];
        _moviePlayViewController.moviePlayer.initialPlaybackTime=-1.0;
        [_moviePlayViewController release];
        _moviePlayViewController=nil;
    }
    if (_moviePlayerController) 
    {
        [self._moviePlayerController stop];
        _moviePlayerController.initialPlaybackTime = -1.0;
        [_moviePlayerController release];
        _moviePlayerController = nil;
    }
}

- (void)dealloc
{
    [audioPlayer release];
    [audioRecorder release];
    [httpDataBuf release];
    [lblStatus release];
    [imageView release];
    [super dealloc];
}
@end
