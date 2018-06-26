//
//  MyImagePickerViewController.m
//  cameratestapp
//
//  Created by BTMani on 6/24/14.
//  Copyright (c) 2014 pavan krishnamurthy. All rights reserved.
//

#import "PKImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "AddProductDetails.h"
@interface PKImagePickerViewController ()

@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic,strong) AVCaptureDevice *captureDevice;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic,assign) BOOL isCapturingImage;
@property (nonatomic,strong) UIScrollView *imageScrollView;
@property(nonatomic,strong) UIImagePickerController *picker;
@property(nonatomic,strong) UIView *imageSelectedView;
@property(nonatomic,strong) UIImage *selectedImage;

@end

@implementation PKImagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark -Initialize View
-(void)loadView
{
    self.view = [[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds] autorelease];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(BOOL)shouldAutorotate
{
    return NO;
}


- (void)viewDidLoad
{
    //Appearance
    [self.view setBackgroundColor:BackGroundColor];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //Initalization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.captureSession = [[[AVCaptureSession alloc]init] autorelease];
    selectedImageArray = [[NSMutableArray alloc] init];
    [delegate.imageCapturedArray removeAllObjects];
    
    //Views
    UIView * headerView =[[[UIView alloc]init] autorelease];
    [headerView setBackgroundColor:clearcolor];
    [headerView setFrame:CGRectMake(0,0,delegate.windowWidth,64)];
    [self.view addSubview:headerView];
    
    
    
    self.imageScrollView = [[[UIScrollView alloc]init] autorelease];
    self.imageScrollView.frame = CGRectMake(0,delegate.windowHeight-180,delegate.windowWidth,80);
    self.imageScrollView.backgroundColor = TransparentBlack;
    self.imageScrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageScrollView];
    
    
    //If front camera enable it show front cam and flash
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count > 0) {
        self.captureVideoPreviewLayer = [[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession] autorelease];
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;
        self.captureVideoPreviewLayer.frame = CGRectMake(0,0,delegate.windowWidth,CGRectGetHeight(self.view.bounds)-190);
        [self.view.layer addSublayer:self.captureVideoPreviewLayer];
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        
        //Is it Device or simulator?
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
        
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        }
        else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        }
        UIButton *cancel = [[UIButton alloc]init];
        [cancel setFrame:CGRectMake(0,25,45,34)];
        cancel.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 8, 0);
        [cancel.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cancel setImage:[UIImage imageNamed:@"takeclose.png"] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancel];

        frontcamera = [[UIButton alloc]init];
        [frontcamera setFrame:CGRectMake(delegate.windowWidth-105,22,45,40)];
        frontcamera.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [frontcamera setImage:[UIImage imageNamed:@"camChange.png"] forState:UIControlStateNormal];
        [frontcamera addTarget:self action:@selector(showFrontCamera:) forControlEvents:UIControlEventTouchUpInside];
        [frontcamera setBackgroundColor:[UIColor clearColor]];
        [frontcamera.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:frontcamera];
        
        flashbutton = [[UIButton alloc]init];
        [flashbutton setFrame:CGRectMake(delegate.windowWidth-55,22,45,40)];
        flashbutton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [flashbutton setImage:[UIImage imageNamed:@"takeflash.png"] forState:UIControlStateNormal];
        [flashbutton addTarget:self action:@selector(flash:) forControlEvents:UIControlEventTouchUpInside];
        [flashbutton setBackgroundColor:[UIColor clearColor]];
        [flashbutton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:flashbutton];
        
        camerabutton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2-40, delegate.windowHeight-95,80,80)];
        [camerabutton setImage:[UIImage imageNamed:@"PKImageBundle.bundle/take-snap"] forState:UIControlStateNormal];
        [camerabutton addTarget:self action:@selector(capturePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [camerabutton setTintColor:[UIColor blueColor]];
        [camerabutton.layer setCornerRadius:20.0];
        [self.view addSubview:camerabutton];
    }
    
    UIButton *album = [[UIButton alloc]init];
    [album setFrame:CGRectMake(5,delegate.windowHeight-75,100,50)];
    [album setTitle:[delegate.languageDict objectForKey:@"gallery"] forState:UIControlStateNormal];
    [album setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [album.titleLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [album addTarget:self action:@selector(showalbum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:album];
    
    
    nextButton = [[UIButton alloc]init];
    [nextButton setFrame:CGRectMake(delegate.windowWidth-100,delegate.windowHeight-75,95,50)];
    [nextButton setTitle:[delegate.languageDict objectForKey:@"next"] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [nextButton addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:nextButton];
    
    self.picker = [[[UIImagePickerController alloc]init] autorelease];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];

    //Appearance
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        NSLog(@"Granted access1");
    //On Camera
#if TARGET_OS_SIMULATOR
#else
    [self.captureSession startRunning];
#endif
    [[self.imageScrollView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //If no data in image array remove all in selected photo array
    if([delegate.imageCapturedArray count]==0){
        [selectedImageArray removeAllObjects];
    }
    
    //Reload Image Views
    [self settingImageView:delegate.imageCapturedArray];
    
        // authorized
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        NSLog(@"Granted access2");
        
        UIView *alertview = [[UIView alloc]init];
        [alertview setFrame:CGRectMake(40, (delegate.windowHeight/3)+30, delegate.windowWidth-80, 150)];
        [alertview.layer setCornerRadius:5];
        alertview.layer.masksToBounds=YES;
        [alertview setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:alertview];

        UILabel *tittlelabel = [[UILabel alloc]init];
        [tittlelabel setText:[delegate.languageDict objectForKey:@"allow_access_camera"]];
       // [tittlelabel setTextColor:[UIColor grayColor]];
        [tittlelabel setTextAlignment:NSTextAlignmentCenter];
        [tittlelabel setFont:ButtonFont];
        [tittlelabel setFrame:CGRectMake(10,10,alertview.frame.size.width-20,20)];
        [alertview addSubview:tittlelabel];
        
        UILabel *contentLabel = [[UILabel alloc]init];
        [contentLabel setText:[delegate.languageDict objectForKey:@"Not have permission to access camera"]];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines=0;
       // [contentLabel setTextColor:[UIColor greenColor]];
        [contentLabel setTextAlignment:NSTextAlignmentCenter];
        [contentLabel setFont:SmallButtonFont];
        [contentLabel setFrame:CGRectMake(10,tittlelabel.frame.size.height+tittlelabel.frame.origin.y+5,alertview.frame.size.width-20,40)];
        [alertview addSubview:contentLabel];
        
        UIView *lineview = [[UIView alloc]init];
        [lineview setFrame:CGRectMake(0, contentLabel.frame.size.height+contentLabel.frame.origin.y+25, alertview.frame.size.width, 1)];
        [lineview setBackgroundColor:[UIColor grayColor]];
        [alertview addSubview:lineview];
        
        UIButton *alertAction = [[UIButton alloc]init];
        [alertAction setFrame:CGRectMake(0, lineview.frame.origin.y+10, alertview.frame.size.width, 30)];
        [alertAction addTarget:self action:@selector(GoalertAction) forControlEvents:UIControlEventTouchUpInside];
        [alertAction.titleLabel setFont:ButtonFont];
        [alertAction setTitle:@"Allow" forState:UIControlStateNormal];
        [alertAction setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [alertview addSubview:alertAction];
        
        camerabutton.userInteractionEnabled=NO;
        frontcamera.userInteractionEnabled=NO;
        flashbutton.userInteractionEnabled=NO;
        [nextButton setHidden:YES];
        
        
        
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
        NSLog(@"Granted access3");
        
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
        NSLog(@"Granted access4");
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access");
            } else {
                NSLog(@"Not granted access");
            }
        }];
    }
    
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.captureSession stopRunning];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:YES];
}



#pragma mark - set image in imagescroll

-(void) settingImageView:(NSMutableArray*) imagesArray
{
    [[self.imageScrollView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<[imagesArray count]; i++)
    {
        UIImageView * imagesView = [[[UIImageView alloc]init] autorelease];
        if (![[imagesArray objectAtIndex:i]isKindOfClass:[UIImage class]])
        {
            [imagesView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[imagesArray objectAtIndex:i] objectForKey:@"item_url_main_350"]]]];
        }
        else
        {
            [imagesView setImage:[imagesArray objectAtIndex:i]];
        }
        [imagesView setFrame:CGRectMake((i*74)+5,5,70,70)];
        [imagesView setContentMode:UIViewContentModeScaleAspectFill];
        [imagesView.layer setCornerRadius:3];
        imagesView.layer.masksToBounds=YES;
        [imagesView.layer setBorderWidth:1];
        [imagesView.layer setBorderColor:[UIColor whiteColor].CGColor
         ];
        [self.imageScrollView addSubview:imagesView];
        
        UIButton * selectedImgBtn = [[[UIButton alloc] init] autorelease];
        [selectedImgBtn setFrame:CGRectMake((i*74)+5,5,70,70)];
        [selectedImgBtn setTag:i];
        [selectedImgBtn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        [selectedImgBtn setBackgroundColor:[UIColor clearColor]];
        if (![[imagesArray objectAtIndex:i]isKindOfClass:[UIImage class]])
        {
            if([selectedImageArray isEqual:[NSString stringWithFormat:@"%@",[imagesArray objectAtIndex:i]]]){
                [selectedImgBtn setImage:[UIImage imageNamed:@"CheckBoxWhite.png"] forState:UIControlStateNormal];
                [selectedImgBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];

            }
        }else{
            if([selectedImageArray containsObject:[imagesArray objectAtIndex:i]]){
                [selectedImgBtn setImage:[UIImage imageNamed:@"CheckBoxWhite.png"] forState:UIControlStateNormal];
                [[selectedImgBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
                selectedImgBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                [selectedImgBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];

            }
        }
        [self.imageScrollView addSubview:selectedImgBtn];
    }
    [self.imageScrollView setContentSize:CGSizeMake([imagesArray count]*74, 0)];
    [camerabutton setEnabled:YES];
}

-(void)addingNewImage:(NSMutableArray*)imagesArray
{
    UIImageView * imagesView = [[[UIImageView alloc]init] autorelease];
    [imagesView setImage:[imagesArray objectAtIndex:([imagesArray count]-1)]];
    [imagesView setFrame:CGRectMake((([imagesArray count]-1)*74)+5,5,70,70)];
    [imagesView.layer setCornerRadius:3];
    imagesView.layer.masksToBounds=YES;
    [imagesView.layer setBorderWidth:1];
    [imagesView.layer setBorderColor:[UIColor whiteColor].CGColor
     ];
    
    [imagesView setContentMode:UIViewContentModeScaleAspectFill];
    imagesView.layer.masksToBounds=YES;
    
    UIButton * selectedImgBtn = [[[UIButton alloc] init] autorelease];
    [selectedImgBtn setFrame:CGRectMake((([imagesArray count]-1)*74)+5,5,70,70)];
    [selectedImgBtn setTag:([imagesArray count]-1)];
    [selectedImgBtn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imageScrollView addSubview:selectedImgBtn];
    [self.imageScrollView addSubview:imagesView];
    [self.imageScrollView setContentSize:CGSizeMake([imagesArray count]*74, 0)];
    [camerabutton setEnabled:YES];
}

#pragma mark - Capture image via camera

-(IBAction)capturePhoto:(id)sender
{
    
        if([delegate.imageCapturedArray count]<5)
        {
            [camerabutton setEnabled:NO];
            self.isCapturingImage = YES;
            AVCaptureConnection *videoConnection = nil;
            for (AVCaptureConnection *connection in _stillImageOutput.connections)
            {
                for (AVCaptureInputPort *port in [connection inputPorts])
                {
                    if ([[port mediaType] isEqual:AVMediaTypeVideo] )
                    {
                        videoConnection = connection;
                        break;
                    }
                }
                if (videoConnection) { break; }
            }
            [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                if (imageSampleBuffer != NULL) {
                    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                    UIImage *capturedImage = [[[UIImage alloc]initWithData:imageData scale:0] autorelease];
                    self.isCapturingImage = NO;
                    self.selectedImage = capturedImage;
                    [delegate.imageCapturedArray addObject:capturedImage];
                    [self addingNewImage:delegate.imageCapturedArray];
                    imageData = nil;
                }
            }];
        }
        else
        {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: [delegate.languageDict objectForKey:@"alert"]
                                                                                message: [delegate.languageDict objectForKey:@"Please Add upto 5 images!!!"]
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: [delegate.languageDict objectForKey:@"ok"]
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                }];
            
            [controller addAction: alertAction];
            [self presentViewController: controller animated: YES completion: nil];
        }
        
     
    
}

#pragma mark - Flash button action
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
            if([self.captureDevice lockForConfiguration:nil])
            {
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

#pragma mark - Front camera button action

-(IBAction)showFrontCamera:(id)sender
{
    if (self.isCapturingImage != YES) {
        if (self.captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
            // rear active, switch to front
            [frontcamera setFrame:CGRectMake(delegate.windowWidth-55,22,45,40)];
            [flashbutton setHidden:YES];
            
            self.captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1];
            [self.captureSession beginConfiguration];
            
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
            for (AVCaptureInput * oldInput in self.captureSession.inputs) {
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
    }
}

#pragma mark - Gallery button action

-(IBAction)showalbum:(id)sender
{
    if([delegate.imageCapturedArray count]<5)
    {
        [self presentViewController:self.picker animated:YES completion:nil];
    }
    else
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: [delegate.languageDict objectForKey:@"alert"]
                                                                            message:[delegate.languageDict objectForKey:@"Please Add upto 5 images!!!"]
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:[delegate.languageDict objectForKey:@"ok"]
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
    }
}

#pragma mark - close view

-(IBAction)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(imageSelectionCancelled)]) {
        [self.delegate imageSelectionCancelled];
    }
    if(delegate.editFlag || delegate.editImageFlag)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - select Image

-(void) selectImage:(id) sender
{
    if(![selectedImageArray containsObject:[delegate.imageCapturedArray objectAtIndex:(int) [sender tag]]]){
        [selectedImageArray addObject:[delegate.imageCapturedArray objectAtIndex:(int) [sender tag]]];
    }else{
        for(int i=0;i<[selectedImageArray count];i++){
            if([[selectedImageArray objectAtIndex:i] isEqual: [delegate.imageCapturedArray objectAtIndex:(int) [sender tag]]]){
                [selectedImageArray removeObjectAtIndex:i];
            }
        }
    }
    if([delegate.imageCapturedArray count]>1){
        [self addingNewImage:delegate.imageCapturedArray];
    }
    [self settingImageView:delegate.imageCapturedArray];
}

#pragma mark - Move to Add product Page

-(void) nextButtonTapped:(id) sender
{
    if ([delegate.addProductPhotos count]+[selectedImageArray count]<=5)
    {
        if([delegate.imageCapturedArray count]!=0)
        {
            if([delegate.imageCapturedArray count]==1){
                if([selectedImageArray count]==0){
                    [selectedImageArray addObject:[delegate.imageCapturedArray objectAtIndex:0]];
                }
            }
            if([selectedImageArray count]!=0){
                UINavigationController * vc = [delegate.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:delegate.tabID];
                [delegate.addProductPhotos addObjectsFromArray:selectedImageArray];
                if (!delegate.editImageFlag)
                {
                    AddProductDetails * addProductObj = [[AddProductDetails alloc]initWithNibName:@"AddProductDetails" bundle:nil];
                    [vc pushViewController:addProductObj animated:YES];
                    [addProductObj release];
                }
                else if(delegate.editImageFlag)
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }else
            {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle: [delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Please Select images to continue"] preferredStyle: UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle: [delegate.languageDict objectForKey:@"ok"] style: UIAlertActionStyleDestructive handler: ^(UIAlertAction *action) {
                }];
                [controller addAction: alertAction];
                [self presentViewController: controller animated: YES completion: nil];
            }
        }
        else
        {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:[delegate.languageDict objectForKey:@"error"]
                                                                                message:[delegate.languageDict objectForKey:@"Please add some images to continue"]
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:[delegate.languageDict objectForKey:@"ok"]
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                    
                                                                }];
            [controller addAction: alertAction];
            [self presentViewController: controller animated: YES completion: nil];
        }
    }
    else
    {
        int eligible = 5-(int)[delegate.addProductPhotos count];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:[delegate.languageDict objectForKey:@"error"] message:[NSString stringWithFormat:@"%@ %d %@",[delegate.languageDict objectForKey:@"Only"],eligible,[delegate.languageDict objectForKey:@"Images are allowed to add"]]  preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDestructive handler: ^(UIAlertAction *action) {
        }];
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
    }
}

#pragma mark - add image via Gallery
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [delegate.imageCapturedArray addObject:self.selectedImage];
        [self addingNewImage:delegate.imageCapturedArray];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)GoalertAction
{
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
}


#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
