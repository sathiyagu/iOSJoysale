//
//  SignUpPage.m
//  HSJoysale
//
//  Created by BTMANI on 18/12/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import "SignUpPage.h"
#import "AppDelegate.h"
#import "welcomeScreen.h"
#import "TabViewController.h"
#import "SignInFrontPage.h"

@interface SignUpPage ()

@end

@implementation SignUpPage

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // Appearance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [delegate tabbarFrameHide];
    [self.view setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight+100)];
    
    firstTime = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];

    [self.view setBackgroundColor:whitecolor];
    [self.mainView setBackgroundColor:whitecolor];
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [skipBtn.titleLabel setFont:ButtonFont];
    skipBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);

    //Functionality
    numberOfSpaces = 0;

    //Fuction call
    [self setFrame];
    [self loadingIndicator];
}
-(void)keyboardFrameDidChange:(NSNotification*)notification
{
   
    NSDictionary* info = [notification userInfo];
    kKeyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    // [_mainView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight-kKeyBoardFrame.size.height)];
    [UIView commitAnimations];
    

    
}

#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - Set Frame to main view

-(void) setFrame
{
    float percentage = (delegate.windowHeight*1)/100;
    
    [_mainView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];

    
    [logoTextLabel setFrame:CGRectMake(30,(percentage*15)-40,delegate.windowWidth-60,40)];
    [descriptionLabel setFrame:CGRectMake(20,logoTextLabel.frame.size.height+logoTextLabel.frame.origin.y,delegate.windowWidth-40,percentage*13)];
    
    [emailTextField setFrame:CGRectMake(20,descriptionLabel.frame.size.height+descriptionLabel.frame.origin.y+40,delegate.windowWidth-40,40)];
    [usernameTextField setFrame:CGRectMake(20,emailTextField.frame.size.height+emailTextField.frame.origin.y+30,delegate.windowWidth-40,40)];
    [fullnameTextField setFrame:CGRectMake(20,usernameTextField.frame.size.height+usernameTextField.frame.origin.y+30,delegate.windowWidth-40,40)];
    [passwordTextField setFrame:CGRectMake(20,fullnameTextField.frame.size.height+fullnameTextField.frame.origin.y+30,delegate.windowWidth-40,40)];
    [cnfpasswordTextField setFrame:CGRectMake(20,passwordTextField.frame.size.height+passwordTextField.frame.origin.y+30,delegate.windowWidth-40,40)];

    [emailPHLabel setFrame:CGRectMake(20,descriptionLabel.frame.size.height+descriptionLabel.frame.origin.y+20,delegate.windowWidth-40,20)];
    [usernamePHLabel setFrame:CGRectMake(20,emailTextField.frame.size.height+emailTextField.frame.origin.y+10,delegate.windowWidth-40,20)];
    [fullnamePHLabel setFrame:CGRectMake(20,usernameTextField.frame.size.height+usernameTextField.frame.origin.y+10,delegate.windowWidth-40,20)];
    [passwordPHLabel setFrame:CGRectMake(20,fullnameTextField.frame.size.height+fullnameTextField.frame.origin.y+10,delegate.windowWidth-40,20)];
    [cnfpasswordPHLabel setFrame:CGRectMake(20,passwordTextField.frame.size.height+passwordTextField.frame.origin.y+10,delegate.windowWidth-40,20)];

    
    [registerBtn setFrame:CGRectMake(20,cnfpasswordTextField.frame.size.height+cnfpasswordTextField.frame.origin.y+20,delegate.windowWidth-40,40)];
    [loginBtn setFrame:CGRectMake(20,registerBtn.frame.size.height+registerBtn.frame.origin.y+10,delegate.windowWidth-40,40)];

    [registerBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:17]];
   // [registerBtn.titleLabel setFont:ButtonFont];
   // [loginBtn.titleLabel setFont:ButtonFont];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:17]];
    
    [registerBtn.layer setCornerRadius:5];
    [loginBtn.layer setCornerRadius:5];
    
    [registerBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setMasksToBounds:YES];


    [skipBtn setFrame:CGRectMake(0,30,40,40)];
    [skipBtn setImage:[UIImage imageNamed:@"back_btn_login.png"] forState:UIControlStateNormal];
    
    
//    [skipBtn setTitle:[delegate.languageDict objectForKey:@"skip"] forState:UIControlStateNormal];
    [registerBtn setTitle:[delegate.languageDict objectForKey:@"register"] forState:UIControlStateNormal];
    [loginBtn setTitle:[delegate.languageDict objectForKey:@"already_member_login"] forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:AppThemeColor];
    [descriptionLabel setText:[delegate.languageDict objectForKey:@"startmaking"]];
    [logoTextLabel setText:[delegate.languageDict objectForKey:@"register"]];
    
    
    [fullnameTextField setTag:8];
    [usernameTextField setTag:9];
    [emailTextField setTag:10];
    [passwordTextField setTag:11];
    [cnfpasswordTextField setTag:12];

    [fullnamePHLabel setText:[delegate.languageDict objectForKey:@"fullname"]];
    [usernamePHLabel setText:[delegate.languageDict objectForKey:@"username"]];
    [emailPHLabel setText:[delegate.languageDict objectForKey:@"email"]];
    [passwordPHLabel setText:[delegate.languageDict objectForKey:@"password"]];
    [cnfpasswordPHLabel setText:[delegate.languageDict objectForKey:@"confirmpassword"]];
    
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [fullnameTextField setTextAlignment:NSTextAlignmentRight];
        [usernameTextField setTextAlignment:NSTextAlignmentRight];
        [emailTextField setTextAlignment:NSTextAlignmentRight];
        [passwordTextField setTextAlignment:NSTextAlignmentRight];
        [cnfpasswordTextField setTextAlignment:NSTextAlignmentRight];

        [fullnamePHLabel setTextAlignment:NSTextAlignmentRight];
        [usernamePHLabel setTextAlignment:NSTextAlignmentRight];
        [emailPHLabel setTextAlignment:NSTextAlignmentRight];
        [passwordPHLabel setTextAlignment:NSTextAlignmentRight];
        [cnfpasswordPHLabel setTextAlignment:NSTextAlignmentRight];
}
    loginBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    
    [_mainView setContentSize:CGSizeMake(0,loginBtn.frame.size.height+loginBtn.frame.origin.y+20)];
    [skipBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];

    
    [self settingColorForField];
}

-(void) settingColorForField
{
    [descriptionLabel setFont:[UIFont fontWithName:appFontRegular size:16.0]];
    [logoTextLabel setFont:[UIFont fontWithName:appFontBold size:30.0]];
    [logoTextLabel setTextColor:SignSignupTextColor];
    [descriptionLabel setTextColor:SignSignupTextColor];

    [skipBtn setTitleColor:SignSignupTextColor forState:UIControlStateNormal];
    [skipBtn setTitleColor:SignSignupTextColor forState:UIControlStateSelected];

    
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.borderColor = AppThemeColor.CGColor;
    [loginBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [loginBtn setTitleColor:AppThemeColor forState:UIControlStateSelected];
    


    
    [emailTextField setBackgroundColor:[UIColor clearColor]];
    emailTextField.selectedLineColor = lineviewColor;
    emailTextField.placeHolderColor = SignSignupTextColor;
    emailTextField.selectedPlaceHolderColor = SignSignupTextColor;
    emailTextField.textColor = SignSignupTextColor;
    emailTextField.lineColor = lineviewColor;
    [emailTextField setFont:[UIFont fontWithName:appFontRegular size:16]];

    
    [fullnameTextField setBackgroundColor:[UIColor clearColor]];
    fullnameTextField.selectedLineColor = lineviewColor;
    fullnameTextField.placeHolderColor = SignSignupTextColor;
    fullnameTextField.selectedPlaceHolderColor = SignSignupTextColor;
    fullnameTextField.textColor = SignSignupTextColor;
    fullnameTextField.lineColor = lineviewColor;
    [fullnameTextField setFont:[UIFont fontWithName:appFontRegular size:16]];

    
    [usernameTextField setBackgroundColor:[UIColor clearColor]];
    usernameTextField.selectedLineColor = lineviewColor;
    usernameTextField.placeHolderColor = SignSignupTextColor;
    usernameTextField.selectedPlaceHolderColor = SignSignupTextColor;
    usernameTextField.textColor = SignSignupTextColor;
    usernameTextField.lineColor = lineviewColor;
    [usernameTextField setFont:[UIFont fontWithName:appFontRegular size:16]];

    
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    passwordTextField.selectedLineColor = lineviewColor;
    passwordTextField.placeHolderColor = SignSignupTextColor;
    passwordTextField.selectedPlaceHolderColor = SignSignupTextColor;
    passwordTextField.textColor = SignSignupTextColor;
    passwordTextField.lineColor = lineviewColor;
    [passwordTextField setFont:[UIFont fontWithName:appFontRegular size:16]];

    
    [cnfpasswordTextField setBackgroundColor:[UIColor clearColor]];
    cnfpasswordTextField.selectedLineColor = lineviewColor;
    cnfpasswordTextField.placeHolderColor = SignSignupTextColor;
    cnfpasswordTextField.selectedPlaceHolderColor = SignSignupTextColor;
    cnfpasswordTextField.textColor = SignSignupTextColor;
    cnfpasswordTextField.lineColor = lineviewColor;
    [cnfpasswordTextField setFont:[UIFont fontWithName:appFontRegular size:16]];

    
    [usernamePHLabel setFont:[UIFont fontWithName:appFontRegular size:13]];
    [fullnamePHLabel setFont:[UIFont fontWithName:appFontRegular size:13]];
    [emailPHLabel setFont:[UIFont fontWithName:appFontRegular size:13]];
    [passwordPHLabel setFont:[UIFont fontWithName:appFontRegular size:13]];
    [cnfpasswordPHLabel setFont:[UIFont fontWithName:appFontRegular size:13]];

    [usernamePHLabel setTextColor:graycolor];
    [fullnamePHLabel setTextColor:graycolor];
    [emailPHLabel setTextColor:graycolor];
    [passwordPHLabel setTextColor:graycolor];
    [cnfpasswordPHLabel setTextColor:graycolor];

    
    
}


#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 4.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_multiColorLoader setFrame:CGRectMake((delegate.windowWidth-15)/2, (delegate.windowHeight-150)/2, 30, 30)];
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

#pragma mark - Redirect to mainviewController

- (IBAction)skipBtnTapped:(id)sender {
    delegate.tabID = 0;
    welcomeScreen * signupPageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
    [self presentViewController:signupPageObj animated:YES completion:nil];

   // [delegate.tabViewControllerObj.tabBarController selectTab:0];
}

#pragma mark - TextField Delegate

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (firstTime)
    {
        
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    [_mainView setContentOffset:CGPointMake(0,textField.frame.origin.y-kKeyBoardFrame.size.height)];
    }
    else
    {
        firstTime = YES;
    }
    
   /* if (textField.tag==10)
    {
        [_mainView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];
    }
    else if (textField.tag==11)
    {
        [_mainView setFrame:CGRectMake(0,-100,delegate.windowWidth,delegate.windowHeight)];
    }
    else if (textField.tag==12)
    {
        [self.view setFrame:CGRectMake(0,-160,delegate.windowWidth,delegate.windowHeight)];
    }
    else
    {
        [self.view setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];
    }*/
    [UIView commitAnimations];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [_mainView setContentOffset:CGPointMake(0,0)];
    [_mainView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];


    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                   withString:string];
    if (textField == fullnameTextField)
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if ([string rangeOfCharacterFromSet:whitespace].location != NSNotFound)
        {
            numberOfSpaces = numberOfSpaces+1;
            if (numberOfSpaces > 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                                message:[delegate.languageDict objectForKey:@"More than one space not allowed"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
        else
        {
            numberOfSpaces = 0;
            return YES;
        }
    }
    else if (textField == usernameTextField)
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if ([string rangeOfCharacterFromSet:whitespace].location != NSNotFound)
        {
            numberOfSpaces = numberOfSpaces+1;
            if (numberOfSpaces > 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                                message:[delegate.languageDict objectForKey:@"Space not allowed"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
        else
        {
            numberOfSpaces = 0;
            return YES;
        }
    }
    else
    {
        return YES;
    }
    if(textField.tag==8){
        if([delegate.fullnamefilter containsString:string] || string.length==0){
            return resultText.length <= 30;
        }else{
            return false;
        }
    }else if(textField.tag==9){
        if([delegate.usernamefilter containsString:string] || string.length==0){
            return resultText.length <= 30;
        }else{
            return false;
        }
    }
    else{
        return resultText.length <= 50;
    }
    
    return YES;
}

#pragma mark - signup button tapped


- (IBAction)signupBtnTapped:(id)sender
{
    [usernameTextField resignFirstResponder];
    [fullnameTextField resignFirstResponder];
    [cnfpasswordTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    if (fullnameTextField.text==NULL||fullnameTextField.text.length==0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"fullnamealert"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
        [alert release];

    }
    else if(fullnameTextField.text.length <3 || fullnameTextField.text.length >31)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"First name allows atleast 3 to 30 charcters"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if (usernameTextField.text==NULL||usernameTextField.text.length==0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Please enter the Username"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
        [alert release];

    }
    else if(usernameTextField.text.length <3 || usernameTextField.text.length >31)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Last name allows atleast 3 to 30 charcters"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
        [alert release];
    }

    else if (emailTextField.text==NULL||emailTextField.text.length==0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Please enter valid Email address"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if (passwordTextField.text==NULL||passwordTextField.text.length==0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Please enter the password"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if (passwordTextField.text.length<6)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Password should be in minimum six characters"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if (![delegate validateEmail:emailTextField.text])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Please enter valid Email address"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        if ([passwordTextField.text isEqualToString:cnfpasswordTextField.text]) {
            [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
            ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
            if ([delegate connectedToNetwork] == NO)
            {
                [delegate networkError];
            }else{
                [proxy signup:apiusername :apipassword :usernameTextField.text :fullnameTextField.text :emailTextField.text :passwordTextField.text];
            }
        }
        else
        {
            [self showAlertconroll:[delegate.languageDict objectForKey:@"Password and confirm password is not matching"]title:[delegate.languageDict objectForKey:@"error"] tag:0];
        }
    }
    
    
}


#pragma mark - Redirect to login page

- (IBAction)loginBtnTapped:(id)sender
{

    
    SignInFrontPage * signupPageObj = [[SignInFrontPage alloc]initWithNibName:@"SignInFrontPage" bundle:nil];
    [self presentViewController:signupPageObj animated:YES completion:nil];
    // [self.navigationController pushViewController:signupPageObj animated:YES];
    [signupPageObj release];
//    [self.navigationController pushViewController:signinPageObj animated:YES];
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
    NSLog(@"Service %@ Done signup!",method);
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    //please_activate_your_account
    //unable_to_create_user
    if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
    {
        
        if([[defaultDict objectForKey:@"message"]isEqualToString:@"account has been created, Amazing products are waiting for you, kindly login."])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"success"]
                                                            message:[delegate.languageDict objectForKey:[defaultDict objectForKey:@"message"]]
                                                           delegate:self
                                                  cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                                  otherButtonTitles:nil];
            [alert setTag:1001];
            [alert show];
        }
        else
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"success"]
                                                        message:[delegate.languageDict objectForKey:@"signup_true_response"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert setTag:1001];
        [alert show];
        }
    }
    else
    {
        NSString * message =@"" ;
        if([[defaultDict objectForKey:@"message"] isEqualToString:@"Sorry, unable to create user, please try again later"]){
            message = [delegate.languageDict objectForKey:@"unable_to_create_user"];
        }else if([[defaultDict objectForKey:@"message"] isEqualToString:@"Email already exists"]){
            message= [delegate.languageDict objectForKey:@"email_already_exists"];
        }else if([[defaultDict objectForKey:@"message"] isEqualToString:@"Username already exists"]){
            message= [delegate.languageDict objectForKey:@"username_already_exists"];
        }else{
            message = [defaultDict objectForKey:@"message"];
        }

        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"failed"] message:message delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
        
    }
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
}

-(void) showAlertconroll:(NSString*)message title:(NSString*)title tag:(int)tag
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: title
                                                                        message: message
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                        }];
   
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];
}

-(void) showAlertconroll:(NSString*)message tag:(int)tag
{
    NSString * subject = [delegate.languageDict objectForKey:@"alert"];
    if (tag==0)
    {
        subject = [delegate.languageDict objectForKey:@"success"];
    }
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: subject
                                                                        message: message
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                        }];
    
    [controller addAction: alertAction];
    
    [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    passwordTextField.text = @"";
    cnfpasswordTextField.text = @"";
    
    if(alertView.tag==1000)
    {
        if (buttonIndex == 0)
        {
            
            [self .navigationController popViewControllerAnimated:YES];
            
        }
    }
    else if(alertView.tag==1001)
    {
        //[self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        
        welcomeScreen * signinPageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        
        [self presentViewController:signinPageObj animated:YES completion:nil];
        //    [self.navigationController pushViewController:signinPageObj animated:YES];
        [signinPageObj release];
        
        
//        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
//        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
//        
//        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
}


#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_mainView release];
    [descriptionLabel release];
    [super dealloc];
}


@end
