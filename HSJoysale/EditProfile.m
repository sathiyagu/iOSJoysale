//
//  EditProfile.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 19/08/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "EditProfile.h"
#import "ChangePassword.h"
#import "LanguagePage.h"
#import "EditProfileImagePage.h"
#import "welcomeScreen.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JSON.h"
@interface EditProfile ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@end

@implementation EditProfile
@synthesize popup;

- (void)viewDidLoad {
    //Initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    fbVerifyArray = [[NSMutableArray alloc] initWithCapacity:0];
    [fbVerifyArray addObject:@""]; //id
    [fbVerifyArray addObject:@""]; //Firstname
    [fbVerifyArray addObject:@""]; //lastname
    [fbVerifyArray addObject:@""]; //email
    [fbVerifyArray addObject:@""]; //phonenumber
    [fbVerifyArray addObject:@""]; //profileurl
    
    
    //Appearance
    
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
    //    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //Properties
    UILabel *viewlabel = [[UILabel alloc] init];
    [viewlabel setFrame:CGRectMake(0, 0,delegate.windowWidth, 1)];
    [viewlabel setBackgroundColor:lineviewColor];
    [bottomView addSubview:viewlabel];
    
    [mainView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-64)];
    [OTPView setFrame:CGRectMake(0, -70, delegate.windowWidth, delegate.windowHeight+70)];
    [OTPView setBackgroundColor:clearcolor];
   // [OTPView setBackgroundColor:AppThemeColor];
    [hideOTPviewBtn setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight+70)];
    [editProfileTableview setFrame:CGRectMake(0, 0, delegate.windowWidth, mainView.frame.size.height-55)];
    [editProfileTableview setBackgroundColor:BackGroundClearColor];
    [bottomView setFrame:CGRectMake(0, mainView.frame.size.height-55, delegate.windowWidth, 55)];
    [gallerycontentView setFrame:CGRectMake((delegate.windowWidth/2)-(gallerycontentView.frame.size.width/2),((delegate.windowHeight-55)/2)-(gallerycontentView.frame.size.height/2),gallerycontentView.frame.size.width,gallerycontentView.frame.size.height)];
    [OTPcontentView setFrame:CGRectMake((delegate.windowWidth/2)-(OTPcontentView.frame.size.width/2),((delegate.windowHeight-55)/2)-(OTPcontentView.frame.size.height/2),OTPcontentView.frame.size.width,OTPcontentView.frame.size.height)];
    
    [OTPcontentView setFrame:CGRectMake(10, ((delegate.windowHeight-55)/2)-55, delegate.windowWidth-20, 110)];
    
    [OTPcontentView setFrame:CGRectMake(30,((delegate.windowHeight-90)/2)-45,delegate.windowWidth-60,150)];
    [OTPcontentView setBackgroundColor:[UIColor whiteColor]];
    [OTPcontentView.layer setCornerRadius:5.0f];
    [OTPcontentView.layer setMasksToBounds:YES];
    UILabel * headerLabel = [UILabel new];
    [headerLabel setText:@"Enter OTP"];
    [headerLabel setFont:[UIFont fontWithName:appFontBold size:18]];
    [headerLabel setFrame:CGRectMake(15,10,delegate.windowWidth-80,30)];
    [OTPcontentView addSubview:headerLabel];
    
    [OtpTextField setFrame:CGRectMake(15, 55, OTPcontentView.frame.size.width-30, 30)];
    OtpTextField.layer.cornerRadius = 0;
    [OtpTextField.layer setBorderColor:[UIColor clearColor].CGColor];
    OtpTextField.borderStyle = UITextBorderStyleNone;
    [OTPBtn setBackgroundColor:clearcolor];
  //  [OTPBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    OTPBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [OTPBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [OTPBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    OTPBtn.titleLabel.font=[UIFont fontWithName:appFontBold size:delegate.smallText];
    
   // [OTPBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [OTPBtn setFrame:CGRectMake(OTPcontentView.frame.size.width-170,100,70, 30)];
    
    UIButton * cancelBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBTN setBackgroundColor:clearcolor];
    [cancelBTN setFrame:CGRectMake(OTPcontentView.frame.size.width-80, 100, 70, 30)];
    //[cancelBTN setTitle:@"Cancel" forState:UIControlStateNormal];
   // [cancelBTN.titleLabel setFont:OTPBtn.titleLabel.font];
    //[cancelBTN setTitleColor:AppTextColor forState:UIControlStateNormal];
    [cancelBTN setTitle:[delegate.languageDict objectForKey:@"cancel"] forState:UIControlStateNormal];
    [cancelBTN setTitleColor:graycolor forState:UIControlStateNormal];
    cancelBTN.titleLabel.font=[UIFont fontWithName:appFontBold size:delegate.smallText];
    
    [cancelBTN addTarget:self action:@selector(closeOTPView:) forControlEvents:UIControlEventTouchUpInside];
    [OTPcontentView addSubview:cancelBTN];
    
    [hideOTPviewBtn setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7f]];
    [OTPView setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7f]];
    [galleryView setHidden:YES];
    [OTPView setHidden:YES];
    
    
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    numberToolbar.barTintColor=AppThemeColor;
    [numberToolbar sizeToFit];
    
    UIBarButtonItem *flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:[delegate.languageDict objectForKey:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneWithNumberPad)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:appFontBold size:15.0], NSFontAttributeName,
                                         whitecolor, NSForegroundColorAttributeName,
                                         nil] forState:UIControlStateNormal];
    numberToolbar.items = [NSArray arrayWithObjects:flex, rightButton, nil];
   // [OTPBtn setBackgroundColor:AppThemeColor];
    [savebtn setBackgroundColor:AppThemeColor];
    [cameraBg setBackgroundColor:AppThemeColor];
  //  [OTPBtn.titleLabel setFont:ButtonFont];
    showChange=NO;
    editFlag = NO;
    fbVerifyBtn = NO;
    //Function Call
    [self barButtonFunction];
    [self loadingIndicator];
    [self loadUserProfile];
    [super viewDidLoad];
    [self.view bringSubviewToFront:OTPView];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma  mark viewwillappear

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [self viewAppearance];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [savebtn setTitle:[delegate.languageDict objectForKey:@"save"] forState:UIControlStateNormal];
    [savebtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [savebtn.titleLabel setFont:ButtonFont];
    [savebtn.layer setCornerRadius:2];
    [savebtn.layer setMasksToBounds:YES];
    [editProfileTableview reloadData];
    [super viewWillAppear:YES];
}

#pragma mark - appearance

- (void) viewAppearance
{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.layer.zPosition = -1;
    [delegate tabbarFrameHide];
    [self.view setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight+100)];
}


#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 4.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_multiColorLoader setFrame:CGRectMake((delegate.windowWidth/2)-15, (delegate.windowHeight-150)/2, 30, 30)];
    [_multiColorLoader startAnimation];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view addSubview:_multiColorLoader];
}

-(void) startLoading
{
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
    [editProfileTableview setHidden:YES];
    [bottomView setHidden:YES];
}

-(void) stopLoading
{
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [editProfileTableview setHidden:NO];
    [bottomView setHidden:NO];
}

-(void) startsaveLoading
{
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
    [self.view setUserInteractionEnabled:NO];
}

-(void) stopSaveLoading
{
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark - barButtonFunctions
-(void) barButtonFunction
{
    UIView * leftNaviNaviButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,delegate.windowWidth, 44)];
    [leftNaviNaviButtonView setBackgroundColor:AppThemeColor];
    UIBarButtonItem * negativeSpacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]autorelease];
    if (isAboveiOSVersion7)
    {
        negativeSpacer.width = -20;
    }
    else
    {
        negativeSpacer.width = -16;
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setTag:1000];
    [backBtn setFrame:CGRectMake(0+[HSUtility adjustablePadding],2,45,40)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:backBtn];
    
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"edit_profile"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:delegate.titleSize]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    
    [leftNaviNaviButtonView release];
}
#pragma mark goto previous page

-(void)backBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Data parsing

- (void) loadUserProfile{
    [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:YES];
    [proxy profile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@""];
}

-(void)getOtp{
    [proxy Getotp:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"country_code"]];
}

-(void)confirmOtp
{
    if (OtpTextField.text.length!=0)
    {
        [proxy Confirmotp:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :OtpTextField.text :[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]];
        
    }
    else
    {
        [OTPBtn setEnabled:YES];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Enter the correct verification code"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert setTag:-99];
        [alert release];
        
    }
}

-(void)verifyFaceBookid
{
    fbVerifyBtn=YES;
    //    -(void)Editprofile:(NSString *)api_username :(NSString *)api_password :(NSString *)user_id :(NSString *)fb_email :(NSString *)fb_firstname :(NSString *)fb_lastname :(NSString *)fb_phone :(NSString *)fb_profileurl :(NSString *)full_name :(NSString *)user_img :(NSString *)facebook_id :(NSString *)mobile_no {
    
    NSString * mobileShow = @"";
    if (allowCallsflag)
    {
        mobileShow = @"true";
    }
    else
    {
        mobileShow = @"fales";
    }
    
    
    [proxy Editprofile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[fbVerifyArray objectAtIndex:3] :[fbVerifyArray objectAtIndex:1] :[fbVerifyArray objectAtIndex:2] :[fbVerifyArray objectAtIndex:4] :[fbVerifyArray objectAtIndex:5] :[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"full_name"] :[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"user_img"] :[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"facebook_id"] :[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"mobile_no"] :mobileShow];
}


#pragma mark - WSDL DelegateMethod

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(stopSaveLoading) withObject:nil waitUntilDone:YES];
    [OTPBtn setEnabled:YES];
    
}

-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method{
    NSLog(@"Service %@ Done!",method);
    NSLog(@"Data: %@",data);
    if ([method isEqualToString:@"profile"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [delegate.UserDetailArray removeAllObjects];
            [delegate.UserDetailArray addObjectsFromArray:[delegate.defensiveClassObj profileParsing:[defaultDict objectForKey:@"result"]]];
            [delegate.userDetailTempArray removeAllObjects];
            [delegate.userDetailTempArray addObjectsFromArray:[delegate.defensiveClassObj profileParsing:[defaultDict objectForKey:@"result"]]];
            
            [[NSUserDefaults standardUserDefaults]setObject:[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"full_name"] forKey:@"full_name"];
            [[NSUserDefaults standardUserDefaults]setObject:[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"user_img"] forKey:@"photo"];
            
            
        }
        
        [editProfileTableview reloadData];
        
    }
    if([method isEqualToString:@"Editprofile"]){
        
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [delegate.UserDetailArray removeAllObjects];
            [delegate.UserDetailArray addObjectsFromArray:[delegate.defensiveClassObj profileParsing:[defaultDict objectForKey:@"result"]]];
            
            if (allowCallsflag)
            {
                [[delegate.userDetailTempArray objectAtIndex:0] setObject:@"true" forKey:@"show_mobile_no"];
                
            }
            else
            {
                [[delegate.userDetailTempArray objectAtIndex:0] setObject:@"false" forKey:@"show_mobile_no"];
            }
            
            if(fbVerifyBtn){
                fbVerifyBtn=NO;
            }else{
                [delegate.userDetailTempArray removeAllObjects];
                [delegate.userDetailTempArray addObjectsFromArray:[delegate.defensiveClassObj profileParsing:[defaultDict objectForKey:@"result"]]];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"success"] message:[delegate.languageDict objectForKey:@"Successfully Changed"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                [alert setTag:101];
                [alert release];
            }
        }
        [editProfileTableview reloadData];
    }
    else if ([method isEqualToString:@"Getotp"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [self performSelectorOnMainThread:@selector(stopSaveLoading) withObject:nil waitUntilDone:YES];
        
        if ([[defaultDict objectForKey:@"status"] isEqualToString:@"true"]) {
            [OtpTextField setText:@""];
            //            [OtpTextField setText:[defaultDict objectForKey:@"otp"]];
            [self ShowOTPPopup];
        }else{
            [[delegate.userDetailTempArray objectAtIndex:0] setObject:@"0" forKey:@"mobile_no"];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      [delegate.languageDict objectForKey:@"alert"] message:[defaultDict objectForKey:@"message"] delegate:self
                                                     cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
            
            [alertView show];
            
        }
        [editProfileTableview reloadData];
        
    }else if ([method isEqualToString:@"Confirmotp"])
    {
        
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        
        [OTPBtn setEnabled:YES];
        
        if ([[defaultDict objectForKey:@"status"] isEqualToString:@"true"]) {
            [[delegate.userDetailTempArray objectAtIndex:0] setObject:@"true" forKey:@"mob_no_verify"];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"Alert"] message:[defaultDict objectForKey:@"message"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
            [alert setTag:111];
            [alert show];
            [alert release];
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"Alert"] message:[defaultDict objectForKey:@"message"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        [editProfileTableview reloadData];
        
        
    }else if ([method isEqualToString:@"pushsignout"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [editProfileTableview reloadData];
        
    }
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(stopSaveLoading) withObject:nil waitUntilDone:YES];
    
}

-(void) verifyMobileNumberPopUp
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        //statusBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
        [statusBar setBackgroundColor:clearcolor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        delegate.navi.navigationBar.backgroundColor = AppThemeColor;
    }
    if (verifyView!=nil)
    {
        [[verifyView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
    
    
    
    verifyView = [UIView new];
    [verifyView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];
    [verifyView setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7f]];
    self.popup = [KOPopupView popupView];
    [self.popup.handleView addSubview:verifyView];
    verifyView.center = CGPointMake(self.popup.handleView.frame.size.width/2.0,
                                    self.popup.handleView.frame.size.height/2.0);
    
    UIView * moreView = [UIView new];
    [moreView setFrame:CGRectMake(30,((delegate.windowHeight-300)/2)+50,delegate.windowWidth-60,180)];
    [moreView setBackgroundColor:whitecolor];
    [moreView.layer setCornerRadius:5];
    [moreView.layer setMasksToBounds:YES];
    
    UIButton * closepopupBtn = [UIButton new];
    [closepopupBtn setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [closepopupBtn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [verifyView addSubview:closepopupBtn];
    
    
    UILabel * headerLabel = [UILabel new];
    if([[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
        [headerLabel setText:[delegate.languageDict objectForKey:@"Enter your number"]];
    }
    else
    {
        [headerLabel setText:[delegate.languageDict objectForKey:@"Change your number"]];
        
    }
    [headerLabel setFont:[UIFont fontWithName:appFontBold size:18]];
    
    
    
    UILabel * ccLable = [[[UILabel alloc]init]autorelease];
    [ccLable setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
    [ccLable setTextAlignment:NSTextAlignmentLeft];
    [ccLable setTextColor:headercolor];
    [ccLable setBackgroundColor:[UIColor clearColor]];
    [ccLable setNumberOfLines:0];
    [ccLable setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSString * descSrting = [delegate.languageDict objectForKey:@"NumberDescription"];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:descSrting];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:3.0];
    [ccLable setNumberOfLines:0];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [descSrting length])];
    
    [ccLable setAttributedText:attributedText];
    
    ccTextField = [[[UITextField alloc] init] autorelease];
    
    [ccTextField setTextColor:headercolor];
    [ccTextField setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
    
    if([[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
        [ccTextField setText:@""];
    }else{
        [ccTextField setText:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]];
    }
    [ccTextField setText:@""];
    [ccTextField setPlaceholder:[delegate.languageDict objectForKey:@"countrycode"]];
    [ccTextField setTextColor:headercolor];
    [ccTextField setDelegate:self];
    [ccTextField setTextAlignment:NSTextAlignmentLeft];
    [ccTextField setTag:503];
    [ccTextField setKeyboardType:UIKeyboardTypeNumberPad];
    ccTextField.inputAccessoryView = numberToolbar;
    
    phoneTextField = [[[UITextField alloc] init] autorelease];
    
    [phoneTextField setTextColor:headercolor];
    [phoneTextField setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
    if([[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
        [phoneTextField setText:@""];
    }else{
        [phoneTextField setText:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]];
    }
    [phoneTextField setText:@""];
    
    [phoneTextField setPlaceholder:[delegate.languageDict objectForKey:@"phonenumber"]];
    [phoneTextField setTextColor:headercolor];
    [phoneTextField setDelegate:self];
    [phoneTextField setTextAlignment:NSTextAlignmentLeft];
    [phoneTextField setTag:502];
    [phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    phoneTextField.inputAccessoryView = numberToolbar;
    
    UIView * lineview = [[UIView alloc] init];
    [lineview setBackgroundColor:lineviewColor];
    
    
    UIButton *changeMobNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeMobNumBtn setBackgroundColor:[UIColor clearColor]];
    [changeMobNumBtn setTag:200];
    changeMobNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [changeMobNumBtn setTitle:[delegate.languageDict objectForKey:@"verify"] forState:UIControlStateNormal];
    [changeMobNumBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    changeMobNumBtn.titleLabel.font=[UIFont fontWithName:appFontBold size:delegate.smallText];
    [changeMobNumBtn addTarget:self action:@selector(changeMobNumber) forControlEvents:UIControlEventTouchUpInside];
    if(editFlag){
        [changeMobNumBtn setHidden:NO];
    }else{
        [changeMobNumBtn setHidden:YES];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelBtn setTitle:[delegate.languageDict objectForKey:@"cancel"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:graycolor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont fontWithName:appFontBold size:delegate.smallText];
    [cancelBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    //    [ccLable setTextAlignment:NSTextAlignmentCenter];
    
    [headerLabel setFrame:CGRectMake(15,10,delegate.windowWidth-80,30)];
    [ccLable setFrame:CGRectMake(15,50, delegate.windowWidth-80,40)];
    [ccTextField setFrame:CGRectMake(15,100, 100, 30)];
    [phoneTextField setFrame:CGRectMake(135,100,delegate.windowWidth-185, 30)];
    [lineview setFrame:CGRectMake(120,105, 1,20)];
    [changeMobNumBtn setFrame:CGRectMake(delegate.windowWidth-220,130,70, 30)];
    [cancelBtn setFrame:CGRectMake(delegate.windowWidth-140,130,70, 30)];
    
    [verifyView addSubview:moreView];
    
    [moreView addSubview:ccLable];
    [moreView addSubview:ccTextField];
    [moreView addSubview:lineview];
    [moreView addSubview:phoneTextField];
    [moreView addSubview:changeMobNumBtn];
    [moreView addSubview:cancelBtn];
    [moreView addSubview:headerLabel];
    [changeMobNumBtn setHidden:NO];
    
    
    /*if([delegate.languageSelected isEqualToString:@"Arabic"]){
     [nameLable setTextAlignment:NSTextAlignmentRight];
     [ccLable setTextAlignment:NSTextAlignmentRight];
     [ccTextField setTextAlignment:NSTextAlignmentRight];
     [phoneTextField setTextAlignment:NSTextAlignmentRight];
     [verifiedlbl setTextAlignment:NSTextAlignmentLeft];
     editMobNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     
     [ccTextField setFrame:CGRectMake(delegate.windowWidth-95, 62, 80, 30)];
     [changeMobNumBtn setFrame:CGRectMake(15, 62, changeMobNumBtn.titleLabel.intrinsicContentSize.width+10 , 30)];
     
     [phoneTextField setFrame:CGRectMake(changeMobNumBtn.frame.origin.x+changeMobNumBtn.titleLabel.intrinsicContentSize.width+30, 62, delegate.windowWidth-(changeMobNumBtn.frame.origin.x+changeMobNumBtn.titleLabel.intrinsicContentSize.width+30)-105-20, 30)];
     [lineview setFrame:CGRectMake(phoneTextField.frame.origin.x+phoneTextField.frame.size.width+10, 62, 1, 30)];
     
     [editMobNumBtn setFrame:CGRectMake(15, 5, 80 , 30)];
     
     
     }*/
    
    //  [self changeMobShowhide];
    
    [self.popup show];
    
}

-(void)cancelBtnTapped
{
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        //statusBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
//        [statusBar setBackgroundColor:AppThemeColor];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    }
    [ccTextField setText:@""];
    [phoneTextField setText:@""];
    [proxy profile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@""];
    [self.popup hideAnimated:TRUE];
    
}
-(void)closePopup
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        //statusBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
        [statusBar setBackgroundColor:AppThemeColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [ccTextField setText:@""];
    [phoneTextField setText:@""];
    [proxy profile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@""];
    [self.popup hideAnimated:TRUE];
}
#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([delegate.userDetailTempArray count]!=0){
        return 3;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        if(indexPath.row==0)
            return 85;
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            return 71;
        }else if(indexPath.row==1){
            return 71;
        }else if(indexPath.row==2){
            return 75;
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            return 71;
        }else if(indexPath.row==1){
            /*if(editFlag){
             return 101;
             }if(editFlag && ![[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
             return 101;
             }
             else if([[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
             return 101;
             }*/
            return 71;
        }else if(indexPath.row==2){
            if([[[[delegate.userDetailTempArray objectAtIndex:0] objectForKey:@"fb_verify"] uppercaseString] isEqualToString:@"TRUE"]){
                return 51;
            }else{
                return 71;
            }
        }else if(indexPath.row==3){
            return 71;
        }
        else if(indexPath.row==4){
            return 55;
        }
    }else if(indexPath.section==3){
        return 55;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }else if(section==1){
        return 3;
    }else if(section==2){
        return 5;
    }else if(section==3){
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView * contentView = [[[UIView alloc] init] autorelease];
    [contentView setBackgroundColor:redcolor];
    
    if(indexPath.section==0){
        [contentView setBackgroundColor:whitecolor];
        [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 80)];
        UIImageView * userImageview = [[[UIImageView alloc]init]autorelease];
        [userImageview setFrame:CGRectMake(15,10,60,60)];
        
        NSLog(@"%@",[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"]);
        
        if (![[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"] isKindOfClass:[UIImage class]])
        {
            [userImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"]]]placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
        }
        else
        {
            [userImageview setImage:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"]];
        }
        
        [userImageview setContentMode:UIViewContentModeScaleAspectFill];
        userImageview.layer.cornerRadius = 30;
        userImageview.layer.masksToBounds=YES;
        [contentView addSubview:userImageview];
        
        UILabel * editLabel = [[[UILabel alloc]init]autorelease];
        [editLabel setText:[delegate.languageDict objectForKey:@"Edit"]];
        [editLabel setTextColor:headercolor];
        [editLabel setFont:[UIFont fontWithName:appFontRegular size:delegate.normalText]];
        [editLabel setFrame:CGRectMake(85,10,delegate.windowWidth-100,60)];
        [editLabel setTextAlignment:NSTextAlignmentLeft];
        [contentView addSubview:editLabel];
        
        UIImageView *arrowImg = [[[UIImageView alloc] init] autorelease];
        [arrowImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
        [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
        [arrowImg setFrame:CGRectMake(delegate.windowWidth-40, 35, 20, 20)];
        [contentView addSubview:arrowImg];
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [userImageview setFrame:CGRectMake(delegate.windowWidth-70,10,60,60)];
            [editLabel setFrame:CGRectMake(50,10,delegate.windowWidth-130,60)];
            [editLabel setTextAlignment:NSTextAlignmentRight];
            [arrowImg setFrame:CGRectMake(10, 30, 20, 20)];
            [arrowImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
            
        }
    }
    else if(indexPath.section==1){
        UILabel * nameLable = [[[UILabel alloc]init]autorelease];
        [nameLable setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
        [nameLable setTextAlignment:NSTextAlignmentLeft];
        [nameLable setTextColor:SecondaryTextColor];
        [nameLable setFrame:CGRectMake(15,8,delegate.windowWidth-30,25)];
        [nameLable setBackgroundColor:clearcolor];
        [contentView addSubview:nameLable];
        
        if(indexPath.row==0){
            [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 70)];
            [contentView setBackgroundColor:whitecolor];
            
            [nameLable setText:[delegate.languageDict objectForKey:@"Name"]];
            
            UITextField * nameTextField = [[[UITextField alloc] init] autorelease];
            [nameTextField setFrame:CGRectMake(15, 32, delegate.windowWidth-30, 30)];
            [nameTextField setTextColor:headercolor];
            [nameTextField setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
            [nameTextField setText:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"full_name"]];
            [nameTextField setTextColor:headercolor];
            [nameTextField setDelegate:self];
            [nameTextField setTextAlignment:NSTextAlignmentLeft];
            [nameTextField setTag:501];
            [contentView addSubview:nameTextField];
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [nameLable setTextAlignment:NSTextAlignmentRight];
                [nameTextField setTextAlignment:NSTextAlignmentRight];
            }
        }else if(indexPath.row==1){
            [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 70)];
            [contentView setBackgroundColor:whitecolor];
            
            [nameLable setText:[delegate.languageDict objectForKey:@"Username"]];
            
            UILabel * usernameLable = [[[UILabel alloc]init]autorelease];
            [usernameLable setText:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_name"]];
            [usernameLable setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
            [usernameLable setTextAlignment:NSTextAlignmentLeft];
            [usernameLable setTextColor:headercolor];
            [usernameLable setFrame:CGRectMake(15, 32, delegate.windowWidth-30 , 30)];
            [usernameLable setBackgroundColor:clearcolor];
            [contentView addSubview:usernameLable];
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [nameLable setTextAlignment:NSTextAlignmentRight];
                [usernameLable setTextAlignment:NSTextAlignmentRight];
            }
            
        }else if(indexPath.row==2){
            [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 70)];
            [contentView setBackgroundColor:whitecolor];
            
            [nameLable setText:[[delegate.languageDict objectForKey:@"changepassword"] uppercaseString]];
            
            UILabel * changePasswordlbl = [[[UILabel alloc]init]autorelease];
            [changePasswordlbl setText:@"**********"];
            [changePasswordlbl setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
            [changePasswordlbl setTextAlignment:NSTextAlignmentLeft];
            [changePasswordlbl setTextColor:headercolor];
            [changePasswordlbl setFrame:CGRectMake(15, 32, delegate.windowWidth-30 , 30)];
            [changePasswordlbl setBackgroundColor:clearcolor];
            [contentView addSubview:changePasswordlbl];
            
            UIImageView *arrowImg = [[[UIImageView alloc] init] autorelease];
            [arrowImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
            [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
            [arrowImg setFrame:CGRectMake(delegate.windowWidth-40, 25, 20, 20)];
            [contentView addSubview:arrowImg];
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [nameLable setTextAlignment:NSTextAlignmentRight];
                [changePasswordlbl setTextAlignment:NSTextAlignmentRight];
                [changePasswordlbl setFrame:CGRectMake(10, 32, delegate.windowWidth-20 , 30)];
                [arrowImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
                [arrowImg setFrame:CGRectMake(10, 25, 20, 20)];
            }
            
        }
    }
    else if(indexPath.section==2){
        
        [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 70)];
        [contentView setBackgroundColor:whitecolor];
        
        UILabel * nameLable = [[[UILabel alloc]init]autorelease];
        [nameLable setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
        [nameLable setTextAlignment:NSTextAlignmentLeft];
        [nameLable setTextColor:SecondaryTextColor];
        [nameLable setFrame:CGRectMake(15,8,delegate.windowWidth-30,25)];
        [nameLable setBackgroundColor:clearcolor];
        
        UILabel * verifiedlbl = [[[UILabel alloc]init]autorelease];
        [verifiedlbl setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
        [verifiedlbl setTextAlignment:NSTextAlignmentRight];
        
        [verifiedlbl setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *emailCheckicon = [[[UIImageView alloc] init] autorelease];
        [emailCheckicon setImage:[UIImage imageNamed:@"tick-green.png"]];
        [emailCheckicon setContentMode:UIViewContentModeScaleAspectFit];
        
        if(indexPath.row==0){
            
            [nameLable setText:[[delegate.languageDict objectForKey:@"Email"] uppercaseString]];
            [contentView addSubview:nameLable];
            
            UILabel * emailLable = [[[UILabel alloc]init]autorelease];
            [emailLable setText:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"email"]];
            [emailLable setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
            [emailLable setTextAlignment:NSTextAlignmentLeft];
            [emailLable setTextColor:headercolor];
            [emailLable setFrame:CGRectMake(15, 32, delegate.windowWidth-30 , 30)];
            [emailLable setBackgroundColor:clearcolor];
            [contentView addSubview:emailLable];
            
            if([[[[delegate.userDetailTempArray objectAtIndex:0] objectForKey:@"email_verify"] uppercaseString] isEqualToString:@"TRUE"]){
                [emailCheckicon setImage:[UIImage imageNamed:@"tick-green.png"]];
                [verifiedlbl setText:[delegate.languageDict objectForKey:@"verified"]];
                
            }else{
                [emailCheckicon setImage:[UIImage imageNamed:@"cancel-1.png"]];
                [verifiedlbl setText:[delegate.languageDict objectForKey:@"unverified"]];
                [verifiedlbl setTextColor:headercolor];
            }
            [verifiedlbl setTextColor:AppTextColor];
            [contentView addSubview:verifiedlbl];
            [contentView addSubview:emailCheckicon];
            [verifiedlbl setFrame:CGRectMake(delegate.windowWidth-verifiedlbl.intrinsicContentSize.width-20, 8, verifiedlbl.intrinsicContentSize.width, 25)];
            
            [emailCheckicon setFrame:CGRectMake(verifiedlbl.frame.origin.x-20, 12, 15, 15)];
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [nameLable setTextAlignment:NSTextAlignmentRight];
                [emailLable setTextAlignment:NSTextAlignmentRight];
                [verifiedlbl setTextAlignment:NSTextAlignmentLeft];
                [verifiedlbl setFrame:CGRectMake(15,20, verifiedlbl.intrinsicContentSize.width, 30)];
                [emailCheckicon setFrame:CGRectMake(verifiedlbl.frame.origin.x+verifiedlbl.intrinsicContentSize.width+10, 24, 15, 15)];
            }
            
        }else if(indexPath.row==1){
            [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 70)];
            [contentView setBackgroundColor:whitecolor];
            
            [nameLable setText:[[delegate.languageDict objectForKey:@"Phone"] uppercaseString]];
            [contentView addSubview:nameLable];
            
            UILabel * ccLable = [[[UILabel alloc]init]autorelease];
            [ccLable setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
            [ccLable setTextAlignment:NSTextAlignmentLeft];
            [ccLable setTextColor:headercolor];
            [ccLable setFrame:CGRectMake(15, 32, delegate.windowWidth-30, 30)];
            [ccLable setBackgroundColor:clearcolor];
            [ccLable setNumberOfLines:0];
            [ccLable setLineBreakMode:NSLineBreakByWordWrapping];
            
            //            UITextField * ccTextField = [[[UITextField alloc] init] autorelease];
            //            [ccTextField setFrame:CGRectMake(15, 62, 80, 30)];
            //            [ccTextField setTextColor:headercolor];
            //            [ccTextField setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
            //            if([[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
            //                [ccTextField setText:@""];
            //            }else{
            //                [ccTextField setText:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]];
            //            }
            //            [ccTextField setText:@""];
            //            [ccTextField setPlaceholder:[delegate.languageDict objectForKey:@"countrycode"]];
            //            [ccTextField setTextColor:headercolor];
            //            [ccTextField setDelegate:self];
            //            [ccTextField setTextAlignment:NSTextAlignmentLeft];
            //            [ccTextField setTag:503];
            //            [ccTextField setKeyboardType:UIKeyboardTypeNumberPad];
            //            ccTextField.inputAccessoryView = numberToolbar;
            //
            //            UITextField * phoneTextField = [[[UITextField alloc] init] autorelease];
            //            [phoneTextField setFrame:CGRectMake(120, 62, delegate.windowWidth-183, 30)];
            //            [phoneTextField setTextColor:headercolor];
            //            [phoneTextField setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
            //            if([[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
            //                [phoneTextField setText:@""];
            //            }else{
            //                [phoneTextField setText:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]];
            //            }
            //            [phoneTextField setText:@""];
            //
            //            [phoneTextField setPlaceholder:[delegate.languageDict objectForKey:@"phonenumber"]];
            //            [phoneTextField setTextColor:headercolor];
            //            [phoneTextField setDelegate:self];
            //            [phoneTextField setTextAlignment:NSTextAlignmentLeft];
            //            [phoneTextField setTag:502];
            //            [phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
            //            phoneTextField.inputAccessoryView = numberToolbar;
            
            UIButton *editMobNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [editMobNumBtn setBackgroundColor:[UIColor darkGrayColor]];
            [editMobNumBtn setTag:200];
            editMobNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [editMobNumBtn setTitle:[delegate.languageDict objectForKey:@"change"] forState:UIControlStateNormal];
            [editMobNumBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
            [editMobNumBtn setTitleColor:whitecolor forState:UIControlStateNormal];
            editMobNumBtn.titleLabel.font=[UIFont fontWithName:appFontRegular size:delegate.smallText];
            editMobNumBtn.layer.masksToBounds=YES;
            editMobNumBtn.layer.cornerRadius=2;
            [editMobNumBtn addTarget:self action:@selector(editMobNumber) forControlEvents:UIControlEventTouchUpInside];
            [editMobNumBtn setFrame:CGRectMake(delegate.windowWidth-80, 22, 60 , 25)];
            [contentView addSubview:editMobNumBtn];
            
            //            UIView * lineview = [[UIView alloc] init];
            //            [lineview setBackgroundColor:lineviewColor];
            //            [lineview setFrame:CGRectMake(100, 62, 1, 30)];
            
            //            UIButton *changeMobNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [changeMobNumBtn setBackgroundColor:AppThemeColor];
            //            [changeMobNumBtn setTag:200];
            //            changeMobNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //            [changeMobNumBtn setTitle:[delegate.languageDict objectForKey:@"verify"] forState:UIControlStateNormal];
            //            [changeMobNumBtn setTitleColor:whitecolor forState:UIControlStateNormal];
            //            changeMobNumBtn.titleLabel.font=[UIFont fontWithName:appFontRegular size:delegate.smallText];
            //            [changeMobNumBtn addTarget:self action:@selector(changeMobNumber) forControlEvents:UIControlEventTouchUpInside];
            //            [changeMobNumBtn setFrame:CGRectMake(delegate.windowWidth-(changeMobNumBtn.titleLabel.intrinsicContentSize.width+25), 62, changeMobNumBtn.titleLabel.intrinsicContentSize.width+10 , 30)];
            //            if(editFlag){
            //                [changeMobNumBtn setHidden:NO];
            //            }else{
            //                [changeMobNumBtn setHidden:YES];
            //            }
            
            
            if(editFlag && ![[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"] && ![[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@""]){
                [ccLable setText:[NSString stringWithFormat:@"%@",[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]]];
                [verifiedlbl setText:[delegate.languageDict objectForKey:@"verified"]];
                [emailCheckicon setImage:[UIImage imageNamed:@"tick-green.png"]];
                
                [contentView addSubview:ccLable];
                //                [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 100)];
                //                [contentView addSubview:ccTextField];
                //                [contentView addSubview:lineview];
                //                [contentView addSubview:phoneTextField];
                //                [contentView addSubview:changeMobNumBtn];
                //                [changeMobNumBtn setHidden:NO];
                
            }
            else if([[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
                [emailCheckicon setImage:[UIImage imageNamed:@"cancel-1.png"]];
                
                [ccLable setText:[delegate.languageDict objectForKey:@"give_your_mobile_number"]];
                [contentView addSubview:ccLable];
                [verifiedlbl setText:[delegate.languageDict objectForKey:@"unverified"]];
                [verifiedlbl setTextColor:headercolor];
                //                [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 100)];
                
                //                [contentView addSubview:lineview];
                //                [contentView addSubview:ccTextField];
                //                [contentView addSubview:phoneTextField];
                //                [contentView addSubview:changeMobNumBtn];
                //                [changeMobNumBtn setHidden:NO];
                
            }
            else if(!editFlag && ![[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
                [ccLable setText:[NSString stringWithFormat:@"%@",[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]]];
                
                [verifiedlbl setText:[delegate.languageDict objectForKey:@"verified"]];
                
                [contentView addSubview:ccLable];
                [contentView addSubview:editMobNumBtn];
                
            }else if(editFlag){
                [contentView addSubview:ccLable];
                [contentView addSubview:editMobNumBtn];
                
                //                [contentView addSubview:ccTextField];
                //                [contentView addSubview:lineview];
                //                [contentView addSubview:phoneTextField];
                //                [contentView addSubview:changeMobNumBtn];
                //                [changeMobNumBtn setHidden:NO];
                
                //                [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 100)];
                
            }
            
            [verifiedlbl setFrame:CGRectMake(editMobNumBtn.frame.origin.x-verifiedlbl.intrinsicContentSize.width-10, 25, verifiedlbl.intrinsicContentSize.width, 25)];
            [emailCheckicon setFrame:CGRectMake(verifiedlbl.frame.origin.x-20, 29, 15, 15)];
            
            [contentView addSubview:verifiedlbl];
            [verifiedlbl setTextColor:AppTextColor];
            [contentView addSubview:emailCheckicon];
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [nameLable setTextAlignment:NSTextAlignmentRight];
                [ccLable setTextAlignment:NSTextAlignmentRight];
                //                [ccTextField setTextAlignment:NSTextAlignmentRight];
                //                [phoneTextField setTextAlignment:NSTextAlignmentRight];
                [verifiedlbl setTextAlignment:NSTextAlignmentCenter];
                editMobNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [verifiedlbl setTextColor:AppTextColor];
                
                //                [ccTextField setFrame:CGRectMake(delegate.windowWidth-95, 62, 80, 30)];
                //                [changeMobNumBtn setFrame:CGRectMake(15, 62, changeMobNumBtn.titleLabel.intrinsicContentSize.width+10 , 30)];
                
                //                [phoneTextField setFrame:CGRectMake(changeMobNumBtn.frame.origin.x+changeMobNumBtn.titleLabel.intrinsicContentSize.width+30, 62, delegate.windowWidth-(changeMobNumBtn.frame.origin.x+changeMobNumBtn.titleLabel.intrinsicContentSize.width+30)-105-20, 30)];
                //                [lineview setFrame:CGRectMake(phoneTextField.frame.origin.x+phoneTextField.frame.size.width+10, 62, 1, 30)];
                
                [editMobNumBtn setFrame:CGRectMake(15, 22, editMobNumBtn.intrinsicContentSize.width, 25)];
                [verifiedlbl setFrame:CGRectMake(editMobNumBtn.frame.origin.x+editMobNumBtn.frame.size.width+10,24, verifiedlbl.intrinsicContentSize.width, 25)];
                [emailCheckicon setFrame:CGRectMake(verifiedlbl.frame.origin.x+verifiedlbl.frame.size.width+10, 26, 32, 15)];
                
                
            }
            
            //  [self changeMobShowhide];
            
        }else if(indexPath.row==2){
            [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 70)];
            [contentView setBackgroundColor:whitecolor];
            UILabel * facebooklbl = [[[UILabel alloc]init]autorelease];
            
            if([[[[delegate.userDetailTempArray objectAtIndex:0] objectForKey:@"fb_verify"] uppercaseString] isEqualToString:@"TRUE"]){
                [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth,50)];
                [nameLable setText:[@"Facebook" uppercaseString]];
                [nameLable setFrame:CGRectMake(15,10,delegate.windowWidth-30,30)];
                [nameLable setTextColor:headercolor];
                [contentView addSubview:nameLable];
                
                
                [emailCheckicon setImage:[UIImage imageNamed:@"tick-green.png"]];
                
                [verifiedlbl setText:[delegate.languageDict objectForKey:@"verified"]];
                [verifiedlbl setTextColor:AppTextColor];
                
                //65
            }else{
                [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 70)];
                [nameLable setText:[@"Facebook" uppercaseString]];
                [contentView addSubview:nameLable];
                
                [facebooklbl setText:[delegate.languageDict objectForKey:@"link_your_account"]];
                [facebooklbl setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
                [facebooklbl setTextAlignment:NSTextAlignmentLeft];
                [facebooklbl setTextColor:headercolor];
                //                [facebooklbl setFrame:CGRectMake(15, 20, delegate.windowWidth-120, 30)];
                [facebooklbl setBackgroundColor:clearcolor];
                [contentView addSubview:facebooklbl];
                [emailCheckicon setImage:[UIImage imageNamed:@"cancel-1.png"]];
                
                [verifiedlbl setText:[delegate.languageDict objectForKey:@"unverified"]];
                [verifiedlbl setTextColor:headercolor];
                
                [nameLable setFrame:CGRectMake(15,8,delegate.windowWidth-30,25)];
                [facebooklbl setFrame:CGRectMake(15, 32, delegate.windowWidth-30, 30)];
                
                
            }
            [verifiedlbl setFrame:CGRectMake(delegate.windowWidth-verifiedlbl.intrinsicContentSize.width-20, 10, verifiedlbl.intrinsicContentSize.width , 30)];
            [emailCheckicon setFrame:CGRectMake(verifiedlbl.frame.origin.x-20, 18, 15, 15)];
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [nameLable setTextAlignment:NSTextAlignmentRight];
                [verifiedlbl setTextAlignment:NSTextAlignmentLeft];
                [verifiedlbl setFrame:CGRectMake(15, 20, 80 , 30)];
                [facebooklbl setFrame:CGRectMake(delegate.windowWidth-facebooklbl.intrinsicContentSize.width-10,20, facebooklbl.intrinsicContentSize.width, 30)];
                [emailCheckicon setFrame:CGRectMake(105, 30, 15, 15)];
                
                if([[[[delegate.userDetailTempArray objectAtIndex:0] objectForKey:@"fb_verify"] uppercaseString] isEqualToString:@"TRUE"]){
                    [verifiedlbl setFrame:CGRectMake(15, 10, verifiedlbl.intrinsicContentSize.width , 30)];
                    [facebooklbl setFrame:CGRectMake(15,10, delegate.windowWidth-120, 30)];
                    [emailCheckicon setFrame:CGRectMake(verifiedlbl.frame.origin.x+verifiedlbl.intrinsicContentSize.width+10, 17, 15, 15)];
                }
            }
            [contentView addSubview:verifiedlbl];
            [contentView addSubview:emailCheckicon];
            
            
        }
        else if(indexPath.row==3){
            
            [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth,70)];
            
            [nameLable setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
            [nameLable setText:[[delegate.languageDict objectForKey:@"Allow calls"] uppercaseString]];
            [contentView addSubview:nameLable];
            
            
            [contentView setBackgroundColor:whitecolor];
            
            UILabel * allowCalls = [[[UILabel alloc]init]autorelease];
            [allowCalls setText:[delegate.languageDict objectForKey:@"language"]];
            [allowCalls setText:[delegate.languageDict objectForKey:@"Allow user to call you"]];
            
            [allowCalls setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
            [allowCalls setTextAlignment:NSTextAlignmentLeft];
            [allowCalls setTextColor:headercolor];
            [allowCalls setFrame:CGRectMake(15,32,delegate.windowWidth-30,30)];
            [allowCalls setBackgroundColor:clearcolor];
            [contentView addSubview:allowCalls];
            
            
            //            UIImageView *arrowImg = [[[UIImageView alloc] init] autorelease];
            //            [arrowImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
            //            [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
            //            [arrowImg setFrame:CGRectMake(delegate.windowWidth-40, 35, 30, 30)];
            //            [contentView addSubview:arrowImg];
            
            UISwitch * switchObj = [UISwitch new];
            [switchObj addTarget: self action: @selector(allowCallSwitch:) forControlEvents: UIControlEventValueChanged];
            [switchObj setOnTintColor:AppThemeColor];
            [contentView addSubview:switchObj];
            [switchObj setFrame:CGRectMake(delegate.windowWidth-68,20,40,25)];
            
            if ([[[[delegate.userDetailTempArray objectAtIndex:0] objectForKey:@"show_mobile_no"] uppercaseString] isEqualToString:@"TRUE"])
            {
                [switchObj setOn:YES];
                allowCallsflag = YES;
            }
            else
            {
                [switchObj setOn:NO];
                
                allowCallsflag = NO;
                
                
            }
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                
                [nameLable setTextAlignment:NSTextAlignmentRight];
                [allowCalls setTextAlignment:NSTextAlignmentRight];
                [switchObj setFrame:CGRectMake(10, 20, 40, 25)];
            }
        }
        else if(indexPath.row==4){
            
            [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 50)];
            [contentView setBackgroundColor:whitecolor];
            UILabel * nameLable = [[[UILabel alloc]init]autorelease];
            [nameLable setText:[delegate.languageDict objectForKey:@"language"]];
            [nameLable setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
            [nameLable setTextAlignment:NSTextAlignmentLeft];
            [nameLable setTextColor:headercolor];
            [nameLable setFrame:CGRectMake(15,10,delegate.windowWidth-30,30)];
            [nameLable setBackgroundColor:clearcolor];
            [contentView addSubview:nameLable];
            
            UILabel * languagelbl = [[[UILabel alloc]init]autorelease];
            [languagelbl setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"language"]];
            [languagelbl setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
            [languagelbl setTextAlignment:NSTextAlignmentRight];
            [languagelbl setTextColor:CommentDaysTextColor];
            [languagelbl setFrame:CGRectMake(delegate.windowWidth/2, 10, (delegate.windowWidth/2)-40 , 30)];
            [languagelbl setBackgroundColor:clearcolor];
            [contentView addSubview:languagelbl];
            
            UIImageView *arrowImg = [[[UIImageView alloc] init] autorelease];
            [arrowImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
            [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
            [arrowImg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
            [contentView addSubview:arrowImg];
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [nameLable setTextAlignment:NSTextAlignmentRight];
                [arrowImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
                [arrowImg setFrame:CGRectMake(10, 15, 20, 20)];
                [languagelbl setFrame:CGRectMake(50, 10, (delegate.windowWidth/2)-40 , 30)];
                [languagelbl setTextAlignment:NSTextAlignmentLeft];
            }
        }
    }
    else if(indexPath.section==3){
        [contentView setFrame:CGRectMake(0, 1, delegate.windowWidth, 50)];
        [contentView setBackgroundColor:whitecolor];
        UILabel * nameLable = [[[UILabel alloc]init]autorelease];
        [nameLable setText:[delegate.languageDict objectForKey:@"logout"]];
        [nameLable setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
        [nameLable setTextAlignment:NSTextAlignmentLeft];
        [nameLable setTextColor:CommentDaysTextColor];
        [nameLable setFrame:CGRectMake(15,10,delegate.windowWidth-30,30)];
        [nameLable setBackgroundColor:clearcolor];
        [contentView addSubview:nameLable];
        
        
        UIImageView *logoutImg = [[[UIImageView alloc] init] autorelease];
        [logoutImg setImage:[UIImage imageNamed:@"logout.png"]];
        [logoutImg setContentMode:UIViewContentModeScaleAspectFit];
        [logoutImg setFrame:CGRectMake(delegate.windowWidth-40, 10, 30, 30)];
        //        logoutImg.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [contentView addSubview:logoutImg];
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [nameLable setTextAlignment:NSTextAlignmentRight];
            [logoutImg setFrame:CGRectMake(10, 10, 30, 30)];
        }
    }
    
    [cell.contentView addSubview:contentView];
    [cell.contentView setBackgroundColor:clearcolor];
    [cell setBackgroundColor:clearcolor];
    return cell;
}


#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if(indexPath.row==0){
            //            [self ShowMorePopup];
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            if (@available(iOS 11.0, *)) {
                UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
                    //[statusBar setTintColor:[UIColor blackColor]];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            }
            else
            {
                UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    //statusBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
                    [statusBar setBackgroundColor:[UIColor clearColor]];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            }
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                    //[statusBar setTintColor:[UIColor blackColor]];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
                // Cancel button tappped.
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self.view endEditing:YES];
                [self pickPhoto];
            }]];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                // OK button tapped.
                
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusAuthorized) {
                    // do your logic
                    [self.view endEditing:YES];
                    EditProfileImagePage * editProfileImagePageObj = [[EditProfileImagePage alloc]initWithNibName:@"EditProfileImagePage" bundle:nil];
                    [self.navigationController pushViewController:editProfileImagePageObj animated:YES];
                    [editProfileImagePageObj release];
                    [galleryView setHidden:YES];
                    
                }  else {
                    NSLog(@"6");
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"Alert"] message:@"Permission disabled. Kindly enable camera permission in settings"  delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
                    [alert setTag:210];
                    [alert show];
                    
                    // impossible, unknown authorization status
                }
                
                
            }]];
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
            
        }
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            
        }else if(indexPath.row==1){
            
        }else if(indexPath.row==2){
            [self changePassword];
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            
        }else if(indexPath.row==1){
            
        }else if(indexPath.row==2){
            //            [self getFaceBookVerfied];
            
            if([[[[delegate.userDetailTempArray objectAtIndex:0] objectForKey:@"fb_verify"] uppercaseString] isEqualToString:@"TRUE"]){
                
            }else{
                [self getFaceBookVerfied];
            }
        }else if(indexPath.row==4){
            [self changeLanguage];
        }
    }else if(indexPath.section==3){
        [self SignOutDesigns];
    }
}


#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    actifText = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    actifText = nil;
    //tag 501 for name
    if(textField.tag==501){
        [[delegate.userDetailTempArray objectAtIndex:0] setObject:textField.text forKey:@"full_name"];
    }
    //tag 502 for Phone
    if (textField.tag==502){
        [[delegate.userDetailTempArray objectAtIndex:0] setObject:textField.text forKey:@"mobile_no"];
    }
    if (textField.tag==503)
    {
        [[delegate.userDetailTempArray objectAtIndex:0] setObject:textField.text forKey:@"country_code"];
        
    }
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                   withString:string];
    
    if (textField.tag==502)
    {
        showChange=YES;
        //[self changeMobShowhide];
    }
    if(textField.tag==501){
        if([delegate.usernamefilter containsString:string] || string.length==0){
            return resultText.length <= 30;
        }else{
            return false;
        }
    }
    else{
        return resultText.length <= 50;
    }
}
#pragma mark show/hide keyboard
/*-(void) keyboardWillShow:(NSNotification *)note
 {
 CGRect keyboardBounds;
 [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
 // Detect orientation
 UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
 CGRect frame= CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-115);
 
 // Start animation
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:0.3f];
 
 // Reduce size of the Table view
 if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
 frame.size.height -= keyboardBounds.size.height;
 frame.size.height = frame.size.height+64;
 }
 else
 frame.size.height -= keyboardBounds.size.width;
 
 
 // Scroll the table view to see the TextField just above the keyboard
 if(actifText.tag==503){
 
 }
 else if (actifText)
 {
 // Apply new size of table view
 editProfileTableview.frame = frame;
 CGRect textFieldRect = [editProfileTableview convertRect:actifText.bounds fromView:actifText];
 [editProfileTableview scrollRectToVisible:textFieldRect animated:NO];
 }
 
 [UIView commitAnimations];
 }
 
 
 -(void) keyboardWillHide:(NSNotification *)note
 {
 CGRect keyboardBounds;
 [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
 
 // Detect orientation
 UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
 CGRect frame = editProfileTableview.frame;
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationBeginsFromCurrentState:YES];
 [UIView setAnimationDuration:0.3f];
 
 // Increase size of the Table view
 if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
 frame.size.height += keyboardBounds.size.height;
 frame.size.height = frame.size.height-64;
 }
 else
 frame.size.height += keyboardBounds.size.width;
 
 if(actifText.tag==503){
 
 }
 else if (actifText)
 {
 // Apply new size of table view
 editProfileTableview.frame = frame;
 }
 [UIView commitAnimations];
 }*/

-(void) keyboardWillShow:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo];
    NSValue *keyboardBoundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [keyboardBoundsValue CGRectValue].size.height;
    UIEdgeInsets insets = [editProfileTableview contentInset];
    [editProfileTableview setContentInset:UIEdgeInsetsMake(insets.top, insets.left, keyboardHeight, insets.right)];
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification *)note
{
    UIEdgeInsets insets = [editProfileTableview contentInset];
    [editProfileTableview setContentInset:UIEdgeInsetsMake(insets.top, insets.left, 0., insets.right)];
    [UIView commitAnimations];
}


#pragma mark mobile number end

-(void)doneWithNumberPad
{
    UITextField * ctf = (UITextField*)[self.view viewWithTag:503];
    UITextField * ptf = (UITextField*)[self.view viewWithTag:502];
    
    [ctf resignFirstResponder];
    [ptf resignFirstResponder];
    
    [self.view endEditing:YES];
    [self.popup endEditing:YES];
}

#pragma mark - show / hide Change button
-(void) changeMobShowhide{
    UIButton *dummyButton = (UIButton*)[self.view viewWithTag:200];
    //    if(showChange){
    
    if(editFlag){
        [dummyButton setHidden:NO];
    }if(editFlag && ![[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
        [dummyButton setHidden:NO];
    }
    else if([[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"mobile_no"] isEqualToString:@"0"]){
        [dummyButton setHidden:NO];
    }
    else{
        [dummyButton setHidden:YES];
    }
    
}
#pragma mark - show / hide Change button
-(void) changeeditShowhide{
    UIButton *dummyButton = (UIButton*)[self.view viewWithTag:201];
    if(editFlag){
        [dummyButton setHidden:NO];
    }else{
        [dummyButton setHidden:YES];
    }
    
}

#pragma mark - redirection

#pragma mark signout
-(void)SignOutDesigns
{
    [self.view endEditing:YES];
    UIAlertView * signOutAlert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[delegate.languageDict objectForKey:@"reallySignOut"]
                                                           delegate:self
                                                  cancelButtonTitle:[delegate.languageDict objectForKey:@"cancel"]
                                                  otherButtonTitles:[delegate.languageDict objectForKey:@"ok"],nil];
    [signOutAlert show];
}

#pragma mark change password

-(void) changePassword
{
    [self.view endEditing:YES];
    
    ChangePassword * changePasswordPageObj = [[ChangePassword alloc]initWithNibName:@"ChangePassword" bundle:nil];
    [self.navigationController pushViewController:changePasswordPageObj animated:YES];
    [changePasswordPageObj release];
}

#pragma mark change language

-(void) changeLanguage
{
    [self.view endEditing:YES];
    
    LanguagePage * languagePageObj = [[LanguagePage alloc]initWithNibName:@"LanguagePage" bundle:nil];
    [self.navigationController pushViewController:languagePageObj animated:YES];
    [languagePageObj release];
}

#pragma mark - mobile number actions
-(void) changeMobNumber{
    [self.view endEditing:YES];
    NSLog(@"%@",delegate.userDetailTempArray);
    UITextField *mobileTxt = (UITextField *)[self.popup viewWithTag:502];
    // [self performSelectorOnMainThread:@selector(startsaveLoading) withObject:nil waitUntilDone:YES];
    if ([[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"country_code"]&&![[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"country_code"]isEqualToString:@""]&&[mobileTxt.text length]!=0)
    {
        [self cancelBtnTapped];
       // [self.popup hideAnimated:true];
        [self performSelectorOnMainThread:@selector(startsaveLoading) withObject:nil waitUntilDone:YES];
        [self getOtp];
        
    }
    else if([mobileTxt.text length]==0)
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                           message:[delegate.languageDict objectForKey:@"Please enter the Mobile number"]
                                          delegate:nil
                                 cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                 otherButtonTitles:nil];
        [alert  performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
        
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                           message:[delegate.languageDict objectForKey:@"Please Enter the Country code"]
                                          delegate:nil
                                 cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                 otherButtonTitles:nil];
        [alert  performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
    }
    // [self getOtp];
}
#pragma mark - mobile number actions
-(void) editMobNumber{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self.view endEditing:YES];
    editFlag = YES;
    [self verifyMobileNumberPopUp];
    [editProfileTableview reloadData];
}
#pragma mark - facebook Verifi

-(void)getFaceBookVerfied
{
    [self.view endEditing:YES];
    
    delegate.facebookflag=YES;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    [self facebookOpenSession];
}

- (void)facebookOpenSession
{
    [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:YES];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"email", @"user_friends",nil];
    //@"user_birthday",@"basic_info",@"user_location",@"user_likes",@"email",@"public_profile",@"user_hometown",@"user_about_me",nil
    //    NSArray *permissions = [[NSArray alloc] initWithObjects:@"",nil];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: permissions
     fromViewController:self.view.window.rootViewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         //         (fb_email, fb_firstname, fb_lastname, fb_phone)
         if (error) {
         }else{
             if ([FBSDKAccessToken currentAccessToken])
             {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                    parameters:@{@"fields": @"picture, email,name,first_name,last_name"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"result:%@",result);
                          [[delegate.userDetailTempArray objectAtIndex:0] setObject:[result objectForKey:@"id"] forKey:@"facebook_id"];
                          [[delegate.userDetailTempArray objectAtIndex:0] setObject:@"true" forKey:@"fb_verify"];
                          [fbVerifyArray replaceObjectAtIndex:0 withObject:[result objectForKey:@"id"]];
                          [fbVerifyArray replaceObjectAtIndex:1 withObject:[result objectForKey:@"first_name"]];
                          [fbVerifyArray replaceObjectAtIndex:2 withObject:[result objectForKey:@"last_name"]];
                          if ([result objectForKey:@"email"]!=NULL)
                          {
                              [fbVerifyArray replaceObjectAtIndex:3 withObject:[result objectForKey:@"email"]];
                          }
                          [fbVerifyArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"https://www.facebook.com/app_scoped_user_id/%@",[result objectForKey:@"email"]]];
                          
                          NSLog(@"fbVerifyArray:%@",fbVerifyArray);
                          [self verifyFaceBookid];
                      }
                      else{
                          NSLog(@"%@", [error localizedDescription]);
                      }
                  }];
             }
             else{
                 [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
             }
         }
     }];
}


#pragma mark Profile Popup

-(void) ShowMorePopup{
    [self.view endEditing:YES];
    
    [galleryView setHidden:NO];
    
    galleryView.alpha = 0.0;
    [UIView animateWithDuration:1.0
                     animations:^{
                         galleryView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void) ShowOTPPopup{
    [OTPView setHidden:NO];
}
- (IBAction)saveBtnTapped:(id)sender {
    [self.view endEditing:YES];
    
    
    if ([[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"full_name"] isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"Alert"] message:[NSString stringWithFormat:@"Name %@",[delegate.languageDict objectForKey:@"Should not be Empty, Please Enter some text"]]  delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
        [alert setTag:210];
        [alert show];
    }
    else{
        
        [self performSelectorOnMainThread:@selector(startsaveLoading) withObject:nil waitUntilDone:YES];
        fbVerifyBtn=NO;
        [self uploadfunction];
        
    }
    
    
    
}

- (IBAction)cameraBtnTapped:(id)sender {
    [self.view endEditing:YES];
    
    EditProfileImagePage * editProfileImagePageObj = [[EditProfileImagePage alloc]initWithNibName:@"EditProfileImagePage" bundle:nil];
    [self.navigationController pushViewController:editProfileImagePageObj animated:YES];
    [editProfileImagePageObj release];
    [galleryView setHidden:YES];
}

- (IBAction)closeOTPView:(id)sender {
    
    //    showChange=NO;
    //    [self changeMobShowhide];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
        [OTPView setHidden:YES];
}

- (IBAction)closeGalleryView:(id)sender {
    [galleryView setHidden:YES];
}

- (IBAction)OTPBtnTapped:(id)sender {
    [OTPBtn setEnabled:NO];
    [self confirmOtp];
}

- (IBAction)galleryBtnTapped:(id)sender {
    [self.view endEditing:YES];
    [galleryView setHidden:YES];
    [self pickPhoto];
}
-(void) pickPhoto
{
    UIImagePickerController *picker ;
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker    didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image;
    image=(UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[delegate.userDetailTempArray objectAtIndex:0] setObject:image forKey:@"user_img"];
        [editProfileTableview reloadData];
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    
    if (alertView.tag == 111) {
        showChange=NO;
        [self changeMobShowhide];
        [OTPView setHidden:YES];
    }else if(alertView.tag==101){
        [self.navigationController popViewControllerAnimated:NO];
    }else if(alertView.tag==210)
    {
        
    }else if (buttonIndex == 1) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
        
        NSUserDefaults*defaultuser=[NSUserDefaults standardUserDefaults];
        [defaultuser removeObjectForKey:@"USERID"];
        [defaultuser removeObjectForKey:@"user_name"];
        [defaultuser removeObjectForKey:@"photo"];
        [defaultuser removeObjectForKey:@"full_name"];
        
        [defaultuser synchronize ];
        [delegate.UserDetailArray removeAllObjects];
        
        [self deleteDeviceForDeviceToken];
        delegate.tabID = 0;
        
        delegate.tabViewControllerObj = [[TabViewController alloc]initWithNibName:@"TabViewController" bundle:nil];
        
        delegate.navi = [[AHKNavigationController alloc]initWithRootViewController:delegate.tabViewControllerObj];
        
        
        [delegate.navi setNavigationBarHidden:YES];
        
        delegate.window.rootViewController = delegate.navi;
        
        //        UINavigationController * vc = [delegate.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:delegate.tabID];
        [delegate.userIDArray removeAllObjects];
        
        welcomeScreen *firstpageObj=[[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [firstpageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:firstpageObj animated:YES completion:nil];
        
        //        [vc pushViewController:firstpageObj animated:YES];
        //        [firstpageObj release];
        
    }
    
}

-(void)allowCallSwitch:(id) sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    
    if ([rez isEqualToString:@"YES"])
    {
        allowCallsflag = YES;
    }
    else
    {
        allowCallsflag = NO;
        
    }
    
    NSLog(@"%@",rez);
}


-(void) deleteDeviceForDeviceToken
{
    if ([delegate.devicetokenArray count]!=0)
    {
        if ([delegate.devicetokenArray count]!=0)
        {
            [proxy pushsignout:apiusername :apipassword :[delegate.devicetokenArray objectAtIndex:0]];
        }
    }
}
#pragma mark - upload image


-(void)uploadfunction
{
    if (![[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"]isKindOfClass:[UIImage class]])
    {
        
        //        [proxy Editprofile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[fbVerifyArray objectAtIndex:3] :[fbVerifyArray objectAtIndex:1] :[fbVerifyArray objectAtIndex:2] :[fbVerifyArray objectAtIndex:4] :[fbVerifyArray objectAtIndex:5] :[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"full_name"] :[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"user_img"] :[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"facebook_id"] :[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"mobile_no"]];
        
        if ([[[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"]componentsSeparatedByString:@"/"]count]>1)
        {
            [self Editprofile:apiusername api_password:apipassword user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] fb_email:[fbVerifyArray objectAtIndex:3] fb_firstname:[fbVerifyArray objectAtIndex:1] fb_lastname:[fbVerifyArray objectAtIndex:2] fb_phone:[fbVerifyArray objectAtIndex:4] fb_profileurl:[fbVerifyArray objectAtIndex:5] full_name:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"full_name"] user_img:@"" facebook_id:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"facebook_id"] mobile_no:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] showMobile:@""];
        }
        else
        {
            [self Editprofile:apiusername api_password:apipassword user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] fb_email:[fbVerifyArray objectAtIndex:3] fb_firstname:[fbVerifyArray objectAtIndex:1] fb_lastname:[fbVerifyArray objectAtIndex:2] fb_phone:[fbVerifyArray objectAtIndex:4] fb_profileurl:[fbVerifyArray objectAtIndex:5] full_name:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"full_name"] user_img:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"] facebook_id:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"facebook_id"] mobile_no:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"] showMobile:@""];
            
        }
        
        //        [proxy Editprofile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"full_name"] :[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"] :[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"facebook_id"] :[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"mobile_no"]];
        
    }else{
        [self performSelectorInBackground:@selector(encodePhotoInBackground:) withObject:[self scaleAndRotateImage:[[delegate.userDetailTempArray objectAtIndex:0]objectForKey:@"user_img"]]];
    }
}
-(void)Editprofile:(NSString *)api_username api_password:(NSString *)api_password user_id:(NSString *)user_id fb_email:(NSString *)fb_email fb_firstname:(NSString *)fb_firstname fb_lastname:(NSString *)fb_lastname fb_phone:(NSString *)fb_phone fb_profileurl:(NSString *)fb_profileurl full_name:(NSString *)full_name user_img:(NSString *)user_img facebook_id:(NSString *)facebook_id mobile_no:(NSString *)mobile_no showMobile:(NSString *)showMobile{
    
    if (allowCallsflag)
    {
        showMobile = @"true";
    }
    else
    {
        showMobile = @"false";
    }
    [proxy Editprofile:api_username :api_password :user_id :fb_email :fb_firstname :fb_lastname :fb_phone :fb_profileurl :full_name :user_img :facebook_id :mobile_no :showMobile];
}
#pragma mark  Upload Img Data

- (void)encodePhotoInBackground:(UIImage*)image {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*500;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    [self performSelectorOnMainThread:@selector(saveImageData:) withObject:imageData waitUntilDone:NO];
    [pool release];
}

- (void)saveImageData:(NSData*)imageData
{
    UIImage * image = [UIImage imageWithData:imageData];
    [self uploadProfileImages:image];
}

#pragma mark uploadphoto
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertView *alert;
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:[delegate.languageDict objectForKey:@"error"]]
                                           message:[error localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                 otherButtonTitles:nil];
        [alert  performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
    }
}


- (void) uploadProfileImages:(UIImage *)img
{
    NSData *imageData = UIImageJPEGRepresentation(img,1.0);
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    //http://162.243.6.9/beta/imageuploadapi.php
    [request setURL:[NSURL URLWithString:userImageurl]];//need to add url
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"images\"; filename=\"ipodfile.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

// percentage of upload
-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    //        float num = totalBytesWritten;
    //        float total = totalBytesExpectedToWrite;
    //        float percent = num/total;
    //     NSLog(@"%f",percent);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    dict = [returnString JSONValue];
    [[delegate.userDetailTempArray objectAtIndex:0] setObject:[[dict objectForKey:@"Image"]objectForKey:@"Name"] forKey:@"user_img"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[[dict objectForKey:@"Image"]objectForKey:@"Name"] forKey:@"photo"];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self uploadfunction];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(stopSaveLoading) withObject:nil waitUntilDone:YES];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"failed"] message:[delegate.languageDict objectForKey:@"Image uploading failed"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [alert release];
    UIActionSheet * addMediaAction=[[UIActionSheet alloc] initWithTitle:[delegate.languageDict objectForKey:@"imageuploadfailedtryagain"] delegate:self
                                                      cancelButtonTitle:[delegate.languageDict objectForKey:@"cancel"]
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:[delegate.languageDict objectForKey:@"save"],[delegate.languageDict objectForKey:@"Dont Save"],nil];
    [addMediaAction setTag:1];
    [addMediaAction showInView:self.view];
    [addMediaAction release];
}

#pragma mark Rotate
- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 640; // Or whatever
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution)
    {
        CGFloat ratio = width/height;
        if (ratio > 1)
        {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else
        {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

#pragma mark - memoryWarning / Dealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [cameraBg release];
    [mainView release];
    [editProfileTableview release];
    [bottomView release];
    [savebtn release];
    [galleryView release];
    [hideGalleryBtn release];
    [galleryBtn release];
    [cameraBtn release];
    [OTPView release];
    [hideOTPviewBtn release];
    [OtpTextField release];
    [OTPBtn release];
    [gallerycontentView release];
    [OTPcontentView release];
    [super dealloc];
}


@end

