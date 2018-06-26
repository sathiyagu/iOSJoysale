//
//  SignInFrontPage.m
//  HSJoysale
//
//  Created by BTMANI on 05/12/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import "SignInFrontPage.h"
#import "AppDelegate.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "SignUpPage.h"
#import "TabViewController.h"
@interface SignInFrontPage ()

@end

@implementation SignInFrontPage
@synthesize accountStore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Class initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    userDetailsArray = [[NSMutableArray alloc]initWithCapacity:0];
    twitter = [[NSMutableArray alloc]initWithCapacity:0];
    defaultTwitDict = [[NSMutableDictionary alloc]initWithCapacity:0];


    //Properties
    [_MainView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];
    forgetPopUp = [[UIView alloc]init];
//    [forgetPopUp setHidden:YES];
//    [skipBtn setTitle:[delegate.languageDict objectForKey:@"skip"] forState:UIControlStateNormal];
    [signinBtn setTitle:[delegate.languageDict objectForKey:@"login"] forState:UIControlStateNormal];
    [signupBtn setTitle:[delegate.languageDict objectForKey:@"signup_not_member"] forState:UIControlStateNormal];
    [ForgetPassword setTitle:[delegate.languageDict objectForKey:@"forgetpassword"] forState:UIControlStateNormal];
    [ForgetPassword.titleLabel setAdjustsFontSizeToFitWidth:YES];
//    [userNameTextField setPlaceholder:[delegate.languageDict objectForKey:@"email"]];
//    [passwordTextField setPlaceholder:[delegate.languageDict objectForKey:@"password"]];
    
    [userPlaceHolderLabel setText:[delegate.languageDict objectForKey:@"email"]];
    [passwordPlaceHolderLabel setText:[delegate.languageDict objectForKey:@"password"]];

    
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [userNameTextField setTextAlignment:NSTextAlignmentRight];
        userNameTextField.adjustsFontSizeToFitWidth = YES;
        [passwordTextField setTextAlignment:NSTextAlignmentRight];
        [userPlaceHolderLabel setTextAlignment:NSTextAlignmentRight];
        [passwordPlaceHolderLabel setTextAlignment:NSTextAlignmentRight];

    }
    [signinBtn setBackgroundColor:AppThemeColor];

    //Apperance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view setBackgroundColor:whitecolor];
    [self.view addSubview:forgetPopUp];
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    
    [self.navigationController setNavigationBarHidden:YES];
    [skipBtn.titleLabel setFont:ButtonFont];
    [skipBtn setImage:[UIImage imageNamed:@"back_btn_login.png"] forState:UIControlStateNormal];
    skipBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);

    //Function call
    [self loadingIndicator];
    [self setFrame];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - Set View to main frame

-(void) setFrame
{
    float percentage = (delegate.windowHeight*1)/100;

    [skipBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [logoTextLabel setFrame:CGRectMake(30,percentage*15,delegate.windowWidth-60,40)];
    [descriptionLabel setFrame:CGRectMake(20,logoTextLabel.frame.size.height+logoTextLabel.frame.origin.y,delegate.windowWidth-40,percentage*13)];
    
    [userPlaceHolderLabel setFrame:CGRectMake(30,descriptionLabel.frame.size.height+descriptionLabel.frame.origin.y+30,delegate.windowWidth-60,20)];
    [userNameTextField setFrame:CGRectMake(30,descriptionLabel.frame.size.height+descriptionLabel.frame.origin.y+50,delegate.windowWidth-60,40)];
    [passwordPlaceHolderLabel setFrame:CGRectMake(30,userNameTextField.frame.size.height+userNameTextField.frame.origin.y+10,delegate.windowWidth-60,20)];
    [passwordTextField setFrame:CGRectMake(30,userNameTextField.frame.size.height+userNameTextField.frame.origin.y+30,delegate.windowWidth-60,40)];
    
    [signinBtn setFrame:CGRectMake(30,passwordTextField.frame.size.height+passwordTextField.frame.origin.y+20,delegate.windowWidth-60,40)];
    [signupBtn setFrame:CGRectMake(30,signinBtn.frame.size.height+signinBtn.frame.origin.y+10,delegate.windowWidth-60,40)];
    
    [signinBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:17]];
    [signupBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:17]];

//    [signinBtn.titleLabel setFont:ButtonFont];
//    [signupBtn.titleLabel setFont:ButtonFont];

    [signinBtn.layer setCornerRadius:5];
    [signupBtn.layer setCornerRadius:5];
    
    [signinBtn.layer setMasksToBounds:YES];
    [signupBtn.layer setMasksToBounds:YES];

    
    [ForgetPassword setFrame:CGRectMake(delegate.windowWidth-150,30,140,30)];
    [skipBtn setFrame:CGRectMake(0,30,50,40)];

    
    [self setColorForView];
    
//    [descriptionLabel setText:[delegate.languageDict objectForKey:@"startmaking"]];
    [logoTextLabel setText:[delegate.languageDict objectForKey:@"login"]];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[delegate.languageDict objectForKey:@"startmaking"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:3.0];
    [descriptionLabel setNumberOfLines:0];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[delegate.languageDict objectForKey:@"startmaking"] length])];
    
    [descriptionLabel setAttributedText:attributedText];


    
    [signupView setFrame:CGRectMake(5, (delegate.windowHeight/2)-(signupView.frame.size.height/2), delegate.windowWidth-10, signupView.frame.size.height)];
    
    ForgetPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [ForgetPassword addTarget:self action:@selector(popupDesign) forControlEvents:UIControlEventTouchUpInside];
    signupBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    
    [newUserLabel setText:@"New User?"];
    [newUserLabel setFont:[UIFont fontWithName:appFontBold size:12]];
    [newUserLabel setTextAlignment:NSTextAlignmentRight];
    [newUserLabel setTextColor:AppTextColor];
    
   // [self popupDesign];
    
    
}

-(void) setColorForView
{
    
    [descriptionLabel setFont:[UIFont fontWithName:appFontRegular size:16.0]];
    [logoTextLabel setFont:[UIFont fontWithName:appFontBold size:30.0]];
    [ForgetPassword.titleLabel setFont:[UIFont fontWithName:appFontRegular size:15.0]];

    
    [logoTextLabel setTextColor:SignSignupTextColor];
    [descriptionLabel setTextColor:SignSignupTextColor];
    [ForgetPassword setTitleColor:SignSignupTextColor forState:UIControlStateNormal];
    [ForgetPassword setTitleColor:SignSignupTextColor forState:UIControlStateSelected];
    //[skipBtn setTitleColor:SignSignupTextColor forState:UIControlStateNormal];
    //[skipBtn setTitleColor:SignSignupTextColor forState:UIControlStateSelected];

    
    signupBtn.layer.borderWidth = 1;
    signupBtn.layer.borderColor = AppThemeColor.CGColor;
    [signupBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [signupBtn setTitleColor:AppThemeColor forState:UIControlStateSelected];


    
    [userNameTextField setBackgroundColor:[UIColor clearColor]];
    userNameTextField.selectedLineColor = lineviewColor;
    userNameTextField.placeHolderColor = SignSignupTextColor;
    userNameTextField.selectedPlaceHolderColor = SignSignupTextColor;
    userNameTextField.textColor = SignSignupTextColor;
    userNameTextField.lineColor = lineviewColor;
    [userNameTextField setFont:[UIFont fontWithName:appFontRegular size:16]];
    
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    passwordTextField.selectedLineColor = lineviewColor;
    passwordTextField.placeHolderColor = SignSignupTextColor;
    passwordTextField.selectedPlaceHolderColor = SignSignupTextColor;
    passwordTextField.textColor = SignSignupTextColor;
    passwordTextField.lineColor = lineviewColor;
    [passwordTextField setFont:[UIFont fontWithName:appFontRegular size:16]];
    [passwordTextField setSecureTextEntry:YES];
    
    
    [userPlaceHolderLabel setFont:[UIFont fontWithName:appFontRegular size:13]];
    [passwordPlaceHolderLabel setFont:[UIFont fontWithName:appFontRegular size:13]];
    [userPlaceHolderLabel setTextColor:graycolor];
    [passwordPlaceHolderLabel setTextColor:graycolor];
    


    
    [[UITextField appearance] setTintColor:SignSignupTextColor];

}


#pragma mark - go to mainViewController

- (IBAction)skipBtnTapped:(id)sender {
    delegate.tabID = 0;
    welcomeScreen * signupPageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
    [self presentViewController:signupPageObj animated:YES completion:nil];
}

#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 4.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_multiColorLoader setFrame:CGRectMake((delegate.windowWidth-15)/2, (delegate.windowHeight-50)/2, 30, 30)];
    [_multiColorLoader startAnimation];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view addSubview:_multiColorLoader];
}

-(void) startLoadig
{
    [delegate.window setUserInteractionEnabled:NO];
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
    
}
-(void) stopLoading
{
    [delegate.window setUserInteractionEnabled:YES];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    
}
#pragma mark - Signup Action

-(IBAction)signupButtonTapped:(id)sender
{
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    SignUpPage * signupPageObj = [[SignUpPage alloc]initWithNibName:@"SignUpPage" bundle:nil];
    [self presentViewController:signupPageObj animated:YES completion:nil];
   // [self.navigationController pushViewController:signupPageObj animated:YES];
    [signupPageObj release];
}

#pragma mark - Joysale Login Action

-(IBAction)loginButtonTapped:(id)sender
{
    
 
    [self.view endEditing:YES];
    twitterFlag = NO;
    if (userNameTextField.text.length!=0 && passwordTextField.text.length!=0)
    {
        if ([delegate validateEmail:userNameTextField.text])
        {
            [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
            ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
            if ([delegate connectedToNetwork] == NO)
            {
                [delegate networkError];
            }else{
            [proxy login:apiusername :apipassword :userNameTextField.text :passwordTextField.text];
            }
        }
        else
        {
            [self showAlertconroll:[delegate.languageDict objectForKey:@"Please enter valid Email address"] tag:1];
        }
    }
    else
    {
        [self showAlertconroll:[delegate.languageDict objectForKey:@"Please fill all the details and continue"] tag:1];
    }
}

#pragma mark - Forget password Action

-(void)popupDesign
{
    
    //    [forgetPopUp setHidden:NO];
    //    [forgetPopUp setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    
    self.popup = [KOPopupView popupView];
    [self.popup.handleView addSubview:forgetPopUp];
    forgetPopUp.center = CGPointMake(self.popup.handleView.frame.size.width/2.0,
                                     self.popup.handleView.frame.size.height/2.0);
    
    
    [forgetPopUp setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];
    [[forgetPopUp subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView setAnimationDuration:0.5];
    //    [UIView commitAnimations];
    
    UIView *forgetpopupView = [[[UIView alloc]init]autorelease];
    UILabel *titleLbl = [[[UILabel alloc]init]autorelease];
    UIButton *resetbtn = [[[UIButton alloc]init]autorelease];
    UIButton *cancelbtn = [[[UIButton alloc]init]autorelease];
    UIButton *popHideBtn = [[[UIButton alloc]init]autorelease];
    UIView *lineView = [[[UIView alloc]init] autorelease];

    recoverEmail = [[UITextField alloc]init];
    [recoverEmail becomeFirstResponder];
    
    [popHideBtn setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [popHideBtn setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2f]];
    
    [forgetpopupView setFrame:CGRectMake(30, ((forgetPopUp.frame.size.height-180)/2)-35, delegate.windowWidth-60, 180)];
    [titleLbl setFrame:CGRectMake(0, 20, forgetpopupView.frame.size.width, 30)];
    [recoverEmail setFrame:CGRectMake(20, titleLbl.frame.origin.y+titleLbl.frame.size.height+30, forgetpopupView.frame.size.width-40, 30)];
    [lineView setFrame:CGRectMake(23, recoverEmail.frame.size.height+recoverEmail.frame.origin.y, forgetpopupView.frame.size.width-40, 1)];

    [lineView setBackgroundColor:lineviewColor];
    [forgetpopupView.layer setCornerRadius:5.0];
    UIView *empaddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0,5,10)]autorelease];
    
    [resetbtn setFrame:CGRectMake(forgetpopupView.frame.size.width-160, 135, 80, 35)];
    [resetbtn setTitle:[delegate.languageDict objectForKey:@"reset"] forState:UIControlStateNormal];
    [resetbtn.titleLabel setFont:[UIFont fontWithName:appFontBold size:15]];
    [resetbtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [resetbtn addTarget:self action:@selector(resetButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [resetbtn setBackgroundColor:[UIColor clearColor]];
    [resetbtn.titleLabel setAdjustsFontSizeToFitWidth:YES];

    [cancelbtn setFrame:CGRectMake(resetbtn.frame.size.width+resetbtn.frame.origin.x, 135, 80, 35)];
    [cancelbtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelbtn.titleLabel setFont:[UIFont fontWithName:appFontBold size:15]];
    [cancelbtn setTitleColor:AdvanceSearchPageColor forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(hidePopUPView) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn setBackgroundColor:[UIColor clearColor]];
    [cancelbtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    [recoverEmail setPlaceholder:@"Enter your email address"];
    [recoverEmail setDelegate:self];
    [recoverEmail setFont:[UIFont fontWithName:appFontRegular size:14]];
    //[recoverEmail setBorderStyle:UITextBorderStyleNone];
    //[recoverEmail.layer setBorderWidth:1];
    //[recoverEmail.layer setBorderColor:AdvanceSearchPageColor.CGColor];
    recoverEmail.leftView = empaddingView;
    [recoverEmail setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    recoverEmail.leftViewMode = UITextFieldViewModeAlways;
    recoverEmail.delegate = self;
    [recoverEmail resignFirstResponder];
    
    

    
    [titleLbl setText:[delegate.languageDict objectForKey:@"forgetpassword"]];
    [titleLbl setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLbl setTextColor:[UIColor blackColor]];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [resetbtn.layer setCornerRadius:5.0];
    
    [popHideBtn addTarget:self action:@selector(hidePopUPView) forControlEvents:UIControlEventTouchUpInside];
    [forgetpopupView setBackgroundColor:[UIColor whiteColor]];
    [forgetpopupView addSubview:titleLbl];
    [forgetpopupView addSubview:recoverEmail];
    [forgetpopupView addSubview:resetbtn];
    [forgetpopupView addSubview:cancelbtn];
    [forgetpopupView addSubview:lineView];
    [forgetPopUp addSubview:popHideBtn];
    [forgetPopUp addSubview:forgetpopupView];
    //    [self.view bringSubviewToFront:forgetPopUp];
     [self ShowMorePopup];
}

-(void)showForgetPopup
{
    [self ShowMorePopup];
}

-(void)hidePopUPView
{
    [self closePopup];
//    [forgetPopUp setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];
//    [forgetPopUp setBackgroundColor:[UIColor clearColor]];
//    [recoverEmail resignFirstResponder];
//
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.5];
//    [forgetPopUp setFrame:CGRectMake(0,-delegate.windowHeight,delegate.windowWidth,delegate.windowHeight)];
//    [UIView commitAnimations];
}
-(void)resetButtonTapped
{
    if (recoverEmail.text.length!=0)
    {
        if ([delegate validateEmail:recoverEmail.text])
        {
            ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
            if ([delegate connectedToNetwork] == NO)
            {
                [delegate networkError];
            }
            else{
            [proxy forgetpassword:apiusername :apipassword :recoverEmail.text];
            [recoverEmail setText:@""];
            }
        }
        else
        {
            UIAlertView*a1=[[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"error"] message:[delegate.languageDict objectForKey:@"enteremail"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
            [a1 show];
            [a1 release];
        }

    }
    else
    {
        UIAlertView*a1=[[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"error"] message:[delegate.languageDict objectForKey:@"entersometext"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
        [a1 show];
        [a1 release];
    }
}

#pragma mark AddingDevice
-(void) addingDeviceForDeviceToken
{
    if ([delegate.devicetokenArray count]!=0)
    {
        ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
        if ([delegate connectedToNetwork] == NO)
        {
            [delegate networkError];
        }else{
            [proxy adddeviceid:apiusername :apipassword :[delegate.devicetokenArray objectAtIndex:0] :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@"0" :[delegate.devicetokenArray objectAtIndex:0]:devicemodeValue :[delegate gettingLanguageCode]];
        }
    }
}

#pragma mark - WSDL DelegateMethod
//proxy finished, (id)data is the object of the relevant method service
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    if ([method isEqualToString:@"forgetpassword"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        
        NSLog(@"%@",defaultDict);
        
        if ([[defaultDict objectForKey:@"status"]isEqualToString:@"true"])
        {
            if( [[defaultDict objectForKey:@"message"] isEqualToString:@"Reset password link has been mailed to you" ]){
            [self showAlertconroll:[delegate.languageDict objectForKey:@"resetPassword_true"]tag:0];
            }else if([[defaultDict objectForKey:@"message"] isEqualToString:@"Reset password link has been mailed to you"]){
                [self showAlertconroll:[delegate.languageDict objectForKey:@"resetPassword_verified"]tag:0];
            }else if([[defaultDict objectForKey:@"message"] isEqualToString:@"User not found"]){
                [self showAlertconroll:[delegate.languageDict objectForKey:@"User not registered yet"]tag:1];
            }else if([[defaultDict objectForKey:@"message"] isEqualToString:@"User not verified yet, activate the account from the email"]){
                [self showAlertconroll:[delegate.languageDict objectForKey:@"resetPassword_verified"]tag:1];
            }
            else
            {
                [self showAlertconroll:[defaultDict objectForKey:@"message"]tag:1];

            }
        }
        else
        {
            if ([[defaultDict objectForKey:@"message"] isEqualToString:@"User not found" ])
            {
                [self showAlertconroll:[delegate.languageDict objectForKey:@"User not registered yet"]tag:1];

            }
            else
            {
                [self showAlertconroll:[delegate.languageDict objectForKey:@"admin_disabled"]tag:1];

            }
        }
        
        [forgetPopUp setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];
        [forgetPopUp setBackgroundColor:[UIColor clearColor]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [forgetPopUp setFrame:CGRectMake(0,-delegate.windowHeight,delegate.windowWidth,delegate.windowHeight)];
        [UIView commitAnimations];
    }
    else if ([method isEqualToString:@"adddeviceid"])
    {
    }
    else
    {
        if (passwordTextField.text.length!=0)
        {
            [[NSUserDefaults standardUserDefaults]setObject:passwordTextField.text forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        
        NSLog(@"%@",defaultDict);
        
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[defaultDict objectForKey:@"user_id"] forKey:@"USERID"];
            [[NSUserDefaults standardUserDefaults]setObject:[defaultDict objectForKey:@"YES"] forKey:@"MEMBERFLAG"];
            [[NSUserDefaults standardUserDefaults]setObject:[defaultDict objectForKey:@"user_name"] forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults]setObject:[defaultDict objectForKey:@"photo"] forKey:@"photo"];
            [[NSUserDefaults standardUserDefaults]setObject:[defaultDict objectForKey:@"full_name"] forKey:@"full_name"];
            [[NSUserDefaults standardUserDefaults]setObject:[defaultDict objectForKey:@"rating"] forKey:@"rating"];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self addingDeviceForDeviceToken];
            [delegate getProfileInfo];
            
            delegate.tabViewControllerObj = [[TabViewController alloc]initWithNibName:@"TabViewController" bundle:nil];
            if([[defaultDict objectForKey:@"user_id"]isEqualToString:[defaultDict objectForKey:@"user_name"]])
            {
//                [self alertControlForTwitter];
            }
            else
            {
                delegate.tabID = 0;
                delegate.tabViewControllerObj = [[TabViewController alloc]initWithNibName:@"TabViewController" bundle:nil];
                delegate.navi = [[AHKNavigationController alloc]initWithRootViewController:delegate.tabViewControllerObj];
                [delegate.navi setNavigationBarHidden:YES];
                delegate.window.rootViewController = delegate.navi;
            }
        }
        else
        {
            if(twitterFlag)
            {
               if([method isEqualToString:@"sociallogin"]){
                   if ([[[defaultDict objectForKey:@"message"]uppercaseString]isEqualToString:@"ACCOUNT NOT FOUND"])
                   {
//                       [self alertControlForTwitter];
                   }
                   else
                   {//your_account_blocked_by_admin
                       [self showAlertconroll:[delegate.languageDict objectForKey:@"your_account_blocked_by_admin"]tag:1];
                   }
               }else{
                   [self showAlertconroll:[defaultDict objectForKey:@"message"]tag:1];
               }
               
            }
            else
            {
                [self showAlertconroll:[delegate.languageDict objectForKey:@"Please enter the correct email and password"] tag:1];
            }
        }
    }
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    passwordTextField.text = @"";
}

#pragma mark - TextfieldDelegate
#pragma mark  UITextfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length==0)
    {
//        [textField setFont:[UIFont fontWithName:AppFontBold size:30]];
        
    }
    else
    {
//        [textField setFont:[UIFont fontWithName:AppFont size:20]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



#pragma  mark - alert




-(void) showAlertconroll:(NSString*)message tag:(int)tag
{
    NSString * subject = [delegate.languageDict objectForKey:@"alertHeader"];
    if (tag==0)
    {
        subject = [delegate.languageDict objectForKey:@"successHeader"];
    }else{
    }
//    UIAlertController *controller = [UIAlertController alertControllerWithTitle: subject
//                                                                        message: message
//                                                                 preferredStyle: UIAlertControllerStyleAlert];
//    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: [delegate.languageDict objectForKey:@"ok"]
//                                                          style: UIAlertActionStyleDestructive
//                                                        handler: ^(UIAlertAction *action) {
//
//                                                        }];
//
//    [controller addAction: alertAction];

    UIAlertView*a1=[[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:message delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
    [a1 show];
    [a1 release];
    [self hidePopUPView];

  //  [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [signupView release];
    [ForgetPassword release];
    [_MainView release];
    [descriptionLabel release];
    [super dealloc];
}

-(void)closePopup
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    [self.popup hideAnimated:TRUE];
}

-(void) ShowMorePopup{
    [self.popup show];
}


@end
