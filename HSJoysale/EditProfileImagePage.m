//
//  EditProfileImagePage.m
//  HSJoysale
//
//  Created by HitasoftMac2 on 05/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "EditProfileImagePage.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>

@interface EditProfileImagePage ()

@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic,strong) AVCaptureDevice *captureDevice;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic,strong) UIScrollView *imageScrollView;
@property(nonatomic,strong) UIImagePickerController *picker;
@property(nonatomic,strong) UIView *imageSelectedView;
@property(nonatomic,strong) UIImage *selectedImage;
@property(nonatomic,assign) BOOL isCapturingImage;

@end

@implementation EditProfileImagePage
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //class initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.captureSession = [[[AVCaptureSession alloc]init] autorelease];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    self.captureVideoPreviewLayer = [[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession] autorelease];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureVideoPreviewLayer.frame = CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight);
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    
    
    //Properties
    [self.frameForCapture setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [self.userImageView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [self.userImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.retakeButton setFrame:CGRectMake(_frameForCapture.frame.origin.x+15, delegate.windowHeight-60, 80, 30)];
    [self.retakeButton.titleLabel setFont:[UIFont fontWithName:appFontRegular size:22]];
    [self.retakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.usePhotoButton setFrame:CGRectMake(_frameForCapture.frame.size.width-140, delegate.windowHeight-60, 120, 30)];
    [self.usePhotoButton.titleLabel setFont:[UIFont fontWithName:appFontRegular size:22]];
    [self.usePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *cancel = [[UIButton alloc]init];
    [cancel setFrame:CGRectMake(0,20,45,34)];
    cancel.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 8, 0);
    [cancel.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cancel setImage:[UIImage imageNamed:@"takeclose.png"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count > 0) {
        self.captureDevice = devices[0];
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        if (input!=nil)
        {
            [self.captureSession addInput:input];
        }
        self.stillImageOutput = [[[AVCaptureStillImageOutput alloc]init] autorelease];
        NSDictionary * outputSettings = [[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil] autorelease];
        [self.stillImageOutput setOutputSettings:outputSettings];
        [self.captureSession addOutput:self.stillImageOutput];
        
        
        frontcamera = [[UIButton alloc]init];
        [frontcamera setFrame:CGRectMake(delegate.windowWidth-105,22,45,40)];
        frontcamera.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        
        [frontcamera setImage:[UIImage imageNamed:@"camChange.png"] forState:UIControlStateNormal];
        [frontcamera addTarget:self action:@selector(showFrontCamera:) forControlEvents:UIControlEventTouchUpInside];
        [frontcamera setBackgroundColor:[UIColor clearColor]];
        [frontcamera.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:frontcamera];
        [self.view bringSubviewToFront:frontcamera];
        
        flashbutton = [[UIButton alloc]init];
        [flashbutton setFrame:CGRectMake(delegate.windowWidth-55,22,45,40)];
        flashbutton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [flashbutton setImage:[UIImage imageNamed:@"takeflash.png"] forState:UIControlStateNormal];
        [flashbutton setImage:[UIImage imageNamed:@"takeflash.png"] forState:UIControlStateSelected];
        [flashbutton addTarget:self action:@selector(flash:) forControlEvents:UIControlEventTouchUpInside];
        [flashbutton setBackgroundColor:[UIColor clearColor]];
        [flashbutton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:flashbutton];
        [self.view bringSubviewToFront:flashbutton];
    }
    
    [self.view bringSubviewToFront:self.userImageView];
    [self.view bringSubviewToFront:self.retakeButton];
    [self.view bringSubviewToFront:self.usePhotoButton];
    
    [self.userImageView setHidden:YES];
    [self.retakeButton setHidden:YES];
    [self.usePhotoButton setHidden:YES];
    
    camerabutton = [[UIButton alloc]initWithFrame:CGRectMake(delegate.windowWidth/2-30,delegate.windowHeight-75, 60, 60)];
    [camerabutton setImage:[UIImage imageNamed:@"PKImageBundle.bundle/take-snap"] forState:UIControlStateNormal];
    [camerabutton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [camerabutton setTintColor:[UIColor blueColor]];
    [camerabutton.layer setCornerRadius:20.0];
    [self.view addSubview:camerabutton];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];

    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.captureSession startRunning];
    [[self.imageScrollView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(IBAction)showFrontCamera:(id)sender
{
    if (self.isCapturingImage != YES) {
        if (self.captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
            self.captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1];
            [frontcamera setFrame:CGRectMake(delegate.windowWidth-55,22,45,40)];
            [flashbutton setHidden:YES];
            
            
            [self.captureSession beginConfiguration];
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
            
            for (AVCaptureInput * oldInput in self.captureSession.inputs)
            {
                [self.captureSession removeInput:oldInput];
            }
            [self.captureSession addInput:newInput];
            [self.captureSession commitConfiguration];
        }
        else if (self.captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1]) {
            // front active, switch to rear
            [frontcamera setFrame:CGRectMake(delegate.windowWidth-105,22,45,40)];
            [flashbutton setFrame:CGRectMake(delegate.windowWidth-55,22,45,40)];
            [flashbutton setHidden:NO];
            
            self.captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
            [self.captureSession beginConfiguration];
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
            for (AVCaptureInput * oldInput in self.captureSession.inputs) {
                [self.captureSession removeInput:oldInput];
            }
            [self.captureSession addInput:newInput];
            [self.captureSession commitConfiguration];
        }
        // Need to reset flash btn
    }
}

-(IBAction)flash:(UIButton*)sender
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([self.captureDevice isFlashAvailable]) {
        if (self.captureDevice.flashActive) {
            if([self.captureDevice lockForConfiguration:nil]) {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                self.captureDevice.flashMode = AVCaptureFlashModeOff;
                [sender setTintColor:[UIColor grayColor]];
                [sender setSelected:NO];
            }
        }
        else {
            if([self.captureDevice lockForConfiguration:nil]) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                self.captureDevice.flashMode = AVCaptureFlashModeOn;
                [sender setTintColor:[UIColor blueColor]];
                [sender setSelected:YES];
            }
        }
        [self.captureDevice unlockForConfiguration];
    }
}


- (IBAction)retakeButtonTapped:(id)sender {
    [self.retakeButton setHidden:YES];
    [self.usePhotoButton setHidden:YES];
    [self.userImageView setHidden:YES];
    [self.frameForCapture setHidden:NO];
    [flashbutton setHidden:NO];
    [frontcamera setHidden:NO];
    [camerabutton setHidden:NO];
}

- (IBAction)usePhotoButtonTapped:(id)sender {
    
    [[delegate.userDetailTempArray objectAtIndex:0] setObject:self.userImageView.image forKey:@"user_img"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)takePhoto:(id)sender
{
    [self.frameForCapture setHidden:YES];
    [self.userImageView setHidden:NO];
    [flashbutton setHidden:YES];
    [frontcamera setHidden:YES];
    [camerabutton setHidden:YES];

    AVCaptureConnection *videoConnection = nil;
    for(AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for(AVCaptureInputPort *port in [connection inputPorts])
        {
            if([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    self.userImageView.image=nil;
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         if(imageDataSampleBuffer !=NULL){
             NSData *imageData= [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             UIImage *image = [UIImage imageWithData:imageData];

             self.userImageView.image=image;
             
         }
     }];
    [self.retakeButton setHidden:NO];
    [self.usePhotoButton setHidden:NO];
}

-(IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_frameForCapture release];
    [_userImageView release];
    [_retakeButton release];
    [_usePhotoButton release];
    [super dealloc];
}

@end
