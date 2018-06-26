//
//  ChangePassword.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 17/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//


/*
 * Change Password for login User
 * Profile page> setting > change Password.
 * once password changed successfully redirect to edit profile
 */
#import "ChangePassword.h"

@interface ChangePassword ()

@end

@implementation ChangePassword

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialization
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    //Properties
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    [changepasswordView setFrame:CGRectMake(0, 0, delegate.windowWidth, changepasswordView.frame.size.height)];
    [showSecureTextBtn setHidden:YES];
    [oldPswdLabel setText:[delegate.languageDict objectForKey:@"currentpassword"]];
    [newPswdLabel setText:[delegate.languageDict objectForKey:@"newpassword"]];
    [reenterPswdLabel setText:[delegate.languageDict objectForKey:@"confirmpassword"]];
    [showSecureTextBtn setTitle:[delegate.languageDict objectForKey:@"show"] forState:UIControlStateNormal];
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [currentPasswordTField setTextAlignment:NSTextAlignmentRight];
        [newPasswordTField setTextAlignment:NSTextAlignmentRight];
        [cofirmPasswordTField setTextAlignment:NSTextAlignmentRight];
        [oldPswdLabel setTextAlignment:NSTextAlignmentRight];
        [reenterPswdLabel setTextAlignment:NSTextAlignmentRight];
        [newPswdLabel setTextAlignment:NSTextAlignmentRight];
        [showSecureTextBtn setFrame:CGRectMake(5, showSecureTextBtn.frame.origin.y, showSecureTextBtn.frame.size.width, showSecureTextBtn.frame.size.height)];
        [newPasswordTField setFrame:CGRectMake(showSecureTextBtn.frame.origin.x+showSecureTextBtn.frame.size.width, newPasswordTField.frame.origin.y, delegate.windowWidth-(showSecureTextBtn.frame.size.width+10), newPasswordTField.frame.size.height)];
    }
    
    [currentPasswordTField setFont:[UIFont fontWithName:appFontRegular size:17]];
    [newPasswordTField setFont:[UIFont fontWithName:appFontRegular size:17]];
    [cofirmPasswordTField setFont:[UIFont fontWithName:appFontRegular size:17]];
    [showSecureTextBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:13]];
    [oldPswdLabel setFont:[UIFont fontWithName:appFontRegular size:15]];
    [reenterPswdLabel setFont:[UIFont fontWithName:appFontRegular size:15]];
    [newPswdLabel setFont:[UIFont fontWithName:appFontRegular size:15]];

    UIView *saveview = [[UIView alloc]init];
    [saveview setFrame:CGRectMake(0, delegate.windowHeight-125, delegate.windowWidth, 65)];
    [saveview setBackgroundColor:whitecolor];
    [self.view addSubview:saveview];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundColor:AppThemeColor];
    [saveBtn setTag:1000];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [saveBtn setFrame:CGRectMake(10,10,delegate.windowWidth-20,40)];
    [saveBtn setTitle:[delegate.languageDict objectForKey:@"save"] forState:UIControlStateNormal];
    [saveBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    saveBtn.layer.masksToBounds=YES;
    saveBtn.layer.cornerRadius=5;
    [saveBtn setTitleColor:whitecolor forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(confirmBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [saveview addSubview:saveBtn];
    
    //Function
    [self barButtonFunction];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - NavigationItems

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
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:backBtn];
    
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"changepassword"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-110,30)];
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:clearcolor];
    
   
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark- barButtonFunctions

-(void)backBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField.tag == 2) {
        showSecureTextBtn.hidden = NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 2) {
        if (textField.text.length == 0) {
            showSecureTextBtn.hidden = YES;
        }else{
            showSecureTextBtn.hidden = NO;
        }
    }
    if (textField.text.length >= 6)
    {
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"Password should be in minimum six characters"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Show/hide password

- (IBAction)showSecureTextBtnTapped:(id)sender {
    [newPasswordTField resignFirstResponder];
    if([showSecureTextBtn.titleLabel.text isEqual:[delegate.languageDict objectForKey:@"show"]]){
        [showSecureTextBtn setTitle:[delegate.languageDict objectForKey:@"hide"] forState:UIControlStateNormal];
        newPasswordTField.secureTextEntry=NO;
    }else{
        [showSecureTextBtn setTitle:[delegate.languageDict objectForKey:@"show"] forState:UIControlStateNormal];
        newPasswordTField.secureTextEntry=YES;
    }
}

#pragma mark - ChangePasswordBtnTapped

-(void) confirmBtnTapped
{
    NSString * message =@"";
    
    if (currentPasswordTField.text.length==0)
    {
        message =[delegate.languageDict objectForKey:@"Please enter current password"];
    }
    else if (newPasswordTField.text.length==0)
    {
        message =[delegate.languageDict objectForKey:@"Please enter new password"];
    }
    else if (![cofirmPasswordTField.text isEqualToString:newPasswordTField.text])
    {
        message =[delegate.languageDict objectForKey:@"Please check the password and try again"];
    }
    else if (currentPasswordTField.text.length<6)
    {
        message =[delegate.languageDict objectForKey:@"Password should be in minimum six characters"];
    }
    
    if(![message isEqualToString:@""]){
                [self showAlertconroll:message tag:0 subject:[delegate.languageDict objectForKey:@"alert"]];
    }
    else
    {
        [self.view endEditing:YES];
        if ([delegate connectedToNetwork] == NO)
        {
            [delegate networkError];
        }
        else{
        [proxy changepassword:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :currentPasswordTField.text :newPasswordTField.text];
        }
    }
}

#pragma mark - ShowAlert

-(void) showAlertconroll:(NSString*)message tag:(int)tag subject:(NSString*)subject
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: subject message: message preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                style:UIAlertActionStyleDestructive handler: ^(UIAlertAction *action) {
                                                }];
    [controller addAction: alertAction];
    
    if (tag == 10) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: subject message: message preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                              style:UIAlertActionStyleDestructive handler: ^(UIAlertAction *action) {
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        [controller addAction: alertAction];
        [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];
    }
    [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];
}

#pragma mark WSDL DelegateMethod
//proxy finished, (id)data is the object of the relevant method service
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    if ([method isEqualToString:@"changepassword"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if ([[defaultDict objectForKey:@"status"]isEqualToString:@"true"])
        {
            [self showAlertconroll:[delegate.languageDict objectForKey:@"password_changed_successfully"] tag:10 subject:[delegate.languageDict objectForKey:@"success"]];
        }
        else
        {
            if([[defaultDict objectForKey:@"message"] isEqualToString:@"Old Password and new password are same, Please enter different one!"]){
                [self showAlertconroll:[delegate.languageDict objectForKey:@"old_password_and_new_password_are_same"] tag:0 subject:[delegate.languageDict objectForKey:@"failed"]];
            }else if([[defaultDict objectForKey:@"message"] isEqualToString:@"Old Password Incorrect"]){
                [self showAlertconroll:[delegate.languageDict objectForKey:@"old_password_incorrect"] tag:0 subject:[delegate.languageDict objectForKey:@"failed"]];
            }else{
                [self showAlertconroll:[defaultDict objectForKey:@"message"] tag:0 subject:[delegate.languageDict objectForKey:@"failed"]];
            }
        }
    }
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [changepasswordView release];
    [showSecureTextBtn release];
    [oldPswdLabel release];
    [newPswdLabel release];
    [reenterPswdLabel release];
    [super dealloc];
}

@end
