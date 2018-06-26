//
//  welcomeScreen.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 19/05/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
/*
 * User login page, if not a user it show. It redirect to login and signup
 */

#import "welcomeScreen.h"
#import "AppDelegate.h"
#import "SignInFrontPage.h"
#import "SignUpPage.h"
#import "HomePage.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <TwitterKit/TwitterKit.h>


@interface welcomeScreen ()<GIDSignInDelegate, GIDSignInUIDelegate>

@end

@implementation welcomeScreen
@synthesize accountStore;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialize class
    //Class initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    userDetailsArray = [[NSMutableArray alloc]initWithCapacity:0];
    twitter = [[NSMutableArray alloc]initWithCapacity:0];
    [twitter addObject:@""];
    [twitter addObject:@""];
    [twitter addObject:@""];
    [twitter addObject:@""];
    defaultTwitDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = clearcolor;
                    //[statusBar setTintColor:[UIColor blackColor]];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                }
    //For google
    [GIDSignInButton class];
    GIDSignIn *gidsignIn = [GIDSignIn sharedInstance];
    gidsignIn.shouldFetchBasicProfile = YES;
    gidsignIn.delegate = self;
    gidsignIn.uiDelegate = self;

    //Properties
    [_Mainview setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight)];
    
    [skipBtn setTitle:[delegate.languageDict objectForKey:@"skip"] forState:UIControlStateNormal];
    [loginBtn setTitle:[delegate.languageDict objectForKey:@"login"] forState:UIControlStateNormal];
    [signupBtn setTitle:[delegate.languageDict objectForKey:@"signup"] forState:UIControlStateNormal];
//    [descriptionLabel setText:[delegate.languageDict objectForKey:@"startmaking"]];
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    [signupBtn setBackgroundColor:[UIColor clearColor]];
    
    [loginBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [signupBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
   // [loginBtn setTitleColor:whitecolor forState:UIControlStateSelected];
   // [signupBtn setTitleColor:whitecolor forState:UIControlStateSelected];

    [skipBtn.titleLabel setFont:ButtonFont];
    [skipBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
//    signupBtn.layer.cornerRadius=5;
//    loginBtn.layer.cornerRadius=5;
    
    [loginBtn.layer setMasksToBounds:YES];
    [signupBtn.layer setMasksToBounds:YES];


    //Appearance
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self settingFrame];
}
-(void) settingFrame
{
    float percentage = (delegate.windowHeight*1)/100;
    
    [loginBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [signupBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:16]];

    
    
    // Define general attributes for the entire text
    
//    [descriptionLabel setText:[delegate.languageDict objectForKey:@"startmaking"]];

    
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[delegate.languageDict objectForKey:@"startmaking"] attributes:attribs];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[delegate.languageDict objectForKey:@"startmaking"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:3.0];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setFont:[UIFont fontWithName:appFontRegular size:18.0]];
    [elseLable setText:[delegate.languageDict objectForKey:@"or Continue with email"]];
    [elseLable setFont:[UIFont fontWithName:appFontRegular size:14.0]];
    [elseLable setTextColor:AppTextColor];
    [descriptionLabel setTextColor:AppThemeColor];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[delegate.languageDict objectForKey:@"startmaking"] length])];
    
    [descriptionLabel setAttributedText:attributedText];


    
    [logoImageView setFrame:CGRectMake((delegate.windowWidth-200)/2,(percentage*15)+20,200,percentage*25)];
    [descriptionLabel  setFrame:CGRectMake(30,logoImageView.frame.size.height+logoImageView.frame.origin.y+(percentage*2)-20,delegate.windowWidth-60,percentage*13)];
    [facebookBtn setFrame:CGRectMake(20,percentage*57,delegate.windowWidth-40,40)];
   // [twitterBtn setFrame:CGRectMake(20,facebookBtn.frame.size.height+facebookBtn.frame.origin.y+10,delegate.windowWidth-40,40)];
    [googlePlusBtn setFrame:CGRectMake(20,facebookBtn.frame.size.height+facebookBtn.frame.origin.y+10,delegate.windowWidth-40,40)];
    
    [elseLable setFrame:CGRectMake(20,delegate.windowHeight-80,delegate.windowWidth-40,20)];
    
    [loginBtn setFrame:CGRectMake(0,delegate.windowHeight-50,delegate.windowWidth/2, 50)];
    [signupBtn setFrame:CGRectMake(delegate.windowWidth/2,delegate.windowHeight-50,delegate.windowWidth/2, 50)];
    
    [seperator setFrame:CGRectMake(delegate.windowWidth/2,delegate.windowHeight-40,1,30)];
    [seperator setBackgroundColor:whitecolor];
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(delegate.windowWidth/2, 0,1,50);
    [rightBorder setBackgroundColor:whitecolor.CGColor];
    [self settingLoginButtons];

    
}

-(void) settingLoginButtons
{
    UIImageView *fbImage = [[[UIImageView alloc]init]autorelease];
    UIImageView *twittImage = [[[UIImageView alloc]init]autorelease];
    UIImageView *googleImage = [[[UIImageView alloc]init]autorelease];

    
    UILabel * facebookLabel = [[[UILabel alloc]init]autorelease];
    [facebookLabel setFrame:CGRectMake(0,0,facebookBtn.frame.size.width,facebookBtn.frame.size.height)];
    [facebookLabel setTextColor:[UIColor whiteColor]];
    [facebookLabel setTextAlignment:NSTextAlignmentCenter];
    [facebookLabel setText:[delegate.languageDict objectForKey:@"Facebook"]];
    [facebookLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [facebookBtn addSubview:facebookLabel];
    
    UILabel * twitterLabel = [[[UILabel alloc]init]autorelease];
    [twitterLabel setFrame:CGRectMake(0,0,twitterBtn.frame.size.width,twitterBtn.frame.size.height)];
    [twitterLabel setTextColor:[UIColor whiteColor]];
    [twitterLabel setTextAlignment:NSTextAlignmentCenter];
    [twitterLabel setText:[delegate.languageDict objectForKey:@"Twitter"]];
    [twitterLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [twitterBtn addSubview:twitterLabel];
    
    UILabel * googleLabel = [[[UILabel alloc]init]autorelease];
    [googleLabel setFrame:CGRectMake(0,0,googlePlusBtn.frame.size.width,googlePlusBtn.frame.size.height)];
    [googleLabel setTextColor:[UIColor whiteColor]];
    [googleLabel setTextAlignment:NSTextAlignmentCenter];
    [googleLabel setText:[delegate.languageDict objectForKey:@"Google"]];
    [googleLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [googlePlusBtn addSubview:googleLabel];
    
    [fbImage setFrame:CGRectMake(3,5, facebookBtn.frame.size.height-3, facebookBtn.frame.size.height-10)];
    [twittImage setFrame:CGRectMake(3,5, facebookBtn.frame.size.height-3, facebookBtn.frame.size.height-10)];
    [googleImage setFrame:CGRectMake(3,5, facebookBtn.frame.size.height-3, facebookBtn.frame.size.height-10)];
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [fbImage setFrame:CGRectMake(facebookBtn.frame.size.width-(facebookBtn.frame.size.height),5, facebookBtn.frame.size.height-3, facebookBtn.frame.size.height-10)];
        [twittImage setFrame:CGRectMake(facebookBtn.frame.size.width-(facebookBtn.frame.size.height), 5, facebookBtn.frame.size.height-3, facebookBtn.frame.size.height-10)];
        [googleImage setFrame:CGRectMake(facebookBtn.frame.size.width-(facebookBtn.frame.size.height),5, facebookBtn.frame.size.height-3, facebookBtn.frame.size.height-10)];
    }
    [fbImage setImage:[UIImage imageNamed:@"fb_icon.png"]];
    [googleImage setImage:[UIImage imageNamed:@"g_icon.png"]];
    [twittImage setImage:[UIImage imageNamed:@"t_icon.png"]];
    [fbImage setContentMode:UIViewContentModeScaleAspectFit];
    [googleImage setContentMode:UIViewContentModeScaleAspectFit];
    [twittImage setContentMode:UIViewContentModeScaleAspectFit];
    [facebookBtn addSubview:fbImage];
    [twitterBtn addSubview:twittImage];
    [googlePlusBtn addSubview:googleImage];

    
    [facebookBtn.layer setCornerRadius:5];
    [twitterBtn.layer setCornerRadius:5];
    [googlePlusBtn.layer setCornerRadius:5];
    
    [facebookBtn.layer setMasksToBounds:YES];
    [twitterBtn.layer setMasksToBounds:YES];
    [googlePlusBtn.layer setMasksToBounds:YES];

    
}

#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(!delegate.hideBarFromDetailpage)
    {
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBottomBorderColor:lineviewColor height:0.7];
    }
    else
    {
        delegate.hideBarFromDetailpage = NO;
        [self.tabBarController.tabBar setHidden:YES];
        [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
        [self.navigationController.navigationBar setBottomBorderColor:lineviewColor height:0.7];

    }
    
    [super viewWillDisappear:YES];
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_Mainview release];
    [loginBtn release];
    [signupBtn release];
    [skipBtn release];
    [descriptionLabel release];
    [super dealloc];
}

#pragma  mark - redirect to login page

- (IBAction)loginBtnTapped:(id)sender {
    //[self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];

    SignInFrontPage * pageObj = [[SignInFrontPage alloc]initWithNibName:@"SignInFrontPage" bundle:nil];
    
   // [self.view.window.rootViewController presentModalViewController:pageObj animated:NO];

   // [self.navigationController pushViewController:pageObj animated:YES];
    
    [self presentViewController:pageObj animated:YES completion:nil];
    [pageObj release];



}

#pragma  mark - redirect to signup page

- (IBAction)signupBtnTapped:(id)sender {
    SignUpPage * signupPageObj = [[SignUpPage alloc]initWithNibName:@"SignUpPage" bundle:nil];
   // [self.navigationController pushViewController:signupPageObj animated:YES];
    [self presentViewController:signupPageObj animated:YES completion:nil];

    [signupPageObj release];
}

#pragma  mark - redirect to rootViewnavigation

- (IBAction)skipBtnTapped:(id)sender {
        delegate.tabID = 0;
    [self viewWillDisappear:YES];

    
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];

//    [self.navigationController popToRootViewControllerAnimated:YES];
//        [delegate.tabViewControllerObj.tabBarController selectTab:0];
    //[self .navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Facebook Action

-(IBAction)facebookButtonTapped:(id)sender
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    twitterFlag = NO;
    delegate.facebookflag=YES;
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
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
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            nil];
    loginButton.readPermissions = permissions;
    [permissions release];
    [self facebookOpenSession];
}

- (void)facebookOpenSession
{
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"email", @"user_friends",nil];//@"user_birthday",@"basic_info",@"user_location",@"user_likes",@"email",@"public_profile",@"user_hometown",@"user_about_me",nil];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: permissions
     fromViewController:self.view.window.rootViewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error) {
             [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
         } else if (result.isCancelled) {
             [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
         } else {
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                    parameters:@{@"fields": @"picture, email,name,first_name,last_name"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          if ([result objectForKey:@"email"]!=NULL)
                          {
                              [self newFbLoginFunction:result];
                          }
                          else
                          {
                              UIAlertView * alert  = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"error"] message:[NSString stringWithFormat:@"%@",[delegate.languageDict objectForKey:@"FailedLogin"]] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
                              [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                              [alert release];
                          }
                      }
                      else{
                      }
                  }];
             }
             else
             {
                 UIAlertView * alert  = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"error"] message:[NSString stringWithFormat:@"%@",[delegate.languageDict objectForKey:@"FBPermissionError"]] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
                 [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                 [alert release];
                 
             }
         }
     }];
}
-(void) newFbLoginFunction:(id)user
{
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    [userDetailsArray addObject:[user objectForKey:@"id"]];
    [userDetailsArray addObject:[user objectForKey:@"name"]];
    [userDetailsArray addObject:[user objectForKey:@"last_name"]];
    [userDetailsArray addObject:[user objectForKey:@"email"]];
    NSUserDefaults *userinfodefaults=[NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [userinfodefaults setObject:userDetailsArray forKey:@"userinfo"];
    [userinfodefaults synchronize];
    NSString * imageurl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=9999",[user objectForKey:@"id"]];
    imageurl = [imageurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self socialSignIn:@"facebook" sID:[user objectForKey:@"id"] sFname:[user objectForKey:@"first_name"] sLname:[user objectForKey:@"last_name"] sMail:[user objectForKey:@"email"] imageurl:imageurl];
}
#pragma mark - Google Action

-(IBAction)googleButtonTapped:(id)sender
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];

    twitterFlag = NO;
    delegate.facebookflag=NO;
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] signIn];
}
#pragma mark  GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    [self reportAuthStatus];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    [self reportAuthStatus];
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self.view.window.rootViewController presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)presentSignInViewController:(UIViewController *)viewController
{
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

#pragma mark  Helper methods

// Updates the GIDSignIn shared instance and the GIDSignInButton
// to reflect the configuration settings that the user set
- (void)adoptUserSettings {
    // There should only be one selected color scheme
}

- (void)reportAuthStatus {
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo {
    if ([GIDSignIn sharedInstance].currentUser.userID!=NULL)
    {
        NSURL *imageURL =
        [[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:500];
        
        NSString * imageurl = [NSString stringWithFormat:@"%@",imageURL];
        imageurl = [imageurl stringByReplacingOccurrencesOfString:@"https://" withString:@"http"];
        
        [self socialSignIn:@"google" sID:[GIDSignIn sharedInstance].currentUser.userID sFname:[GIDSignIn sharedInstance].currentUser.profile.name sLname:@"" sMail:[GIDSignIn sharedInstance].currentUser.profile.email imageurl:imageurl];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - twitter Action

-(BOOL)isEmpty:(NSString *)str{
    if([str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str isEqualToString:@"NULL"]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]||[str isEqualToString:@"Json Error"]||[str isEqualToString:@"0"]){
        return YES;
    }
    return NO;
}
-(IBAction)twitterButtonTapped:(id)sender
{
    [self.view.window.rootViewController dismissViewControllerAnimated:NO completion:nil];

    twitterFlag = YES;
    [[Twitter sharedInstance] logOut];
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         NSLog(@"USER ID %@",[session userID]);
         if (![self isEmpty:[session userID]]) {
             [self GetTwitterUserDetailsAssociateWithTwitterID:[session userID]];
         }
     }];
    /* [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
     twitterFlag = YES;
     accountStore = [[ACAccountStore alloc] init];
     
     if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
     {
     // Create an account type that ensures Twitter accounts are retrieved.
     ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
     
     // Request access from the user to use their Twitter accounts.
     //    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
     [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
     flag = 0;
     if(granted) {
     // Get the list of Twitter accounts.
     NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
     if ([arrayOfAccounts count]==0)
     {
     [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
     [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
     }
     else
     {
     for (int i=0; i<[arrayOfAccounts count]; i++)
     {
     
     if ([arrayOfAccounts count] > 0) {
     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
     NSDictionary *message = @{@"status": AppName};
     NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
     SLRequest *postRequest = [SLRequest
     requestForServiceType:SLServiceTypeTwitter
     requestMethod:SLRequestMethodGET
     URL:requestURL parameters:message];
     postRequest.account = acct;
     
     [postRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse
     *urlResponse, NSError *error)
     {
     if (!error)
     {
     NSError *jsonError = nil;
     NSMutableDictionary *str = [NSJSONSerialization JSONObjectWithData:responseData
     options:0
     error:&jsonError];
     [twitter removeAllObjects];
     NSMutableArray *twitterArr = [[NSMutableArray alloc] init];
     NSArray * array = [[str objectForKey:@"name"]componentsSeparatedByString:@" "];
     [twitterArr addObject:[array objectAtIndex:0]];
     [twitterArr addObject:[str objectForKey:@"id_str"]];
     if ([array count]==2)
     {
     [twitterArr addObject:[array objectAtIndex:1]];
     }
     else
     {
     [twitterArr addObject:@""];
     }
     NSString * imageurl = [str objectForKey:@"profile_image_url"];
     [twitterArr addObject:imageurl];
     [twitterArr addObject:@""];
     [twitter addObjectsFromArray:twitterArr];
     [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
     [self twitterTesting:[str objectForKey:@"id_str"]];
     }];
     }
     else
     {
     UIAlertView*errorAlert=[[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"error"] message:[NSString stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
     [errorAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
     [errorAlert release];
     [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
     }
     }];
     }
     }
     }
     }
     else
     {
     [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
     [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
     }
     }
     ];
     }
     else
     {
     [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
     [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
     }*/
}
-(void)GetTwitterUserDetailsAssociateWithTwitterID:(NSString *)userID
{
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/users/show.json";
    NSDictionary *params = @{@"user_id": userID};
    
    NSError *clientError;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                             URLRequestWithMethod:@"GET"
                             URL:statusesShowEndpoint
                             parameters:params
                             error:&clientError];
    
    if (request) {
        [[[Twitter sharedInstance] APIClient]
         sendTwitterRequest:request
         completion:^(NSURLResponse *response,
                      NSData *data,
                      NSError *connectionError) {
             if (data) {
                 // handle the response data e.g.
                 NSError *jsonError;
                 NSDictionary *twitterDict = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:0
                                              error:&jsonError];
                 NSLog(@"TWITTER RESPONSE %@",twitterDict);
                 
                 if ([self validateEmailWithString:[twitterDict valueForKey:@"name"]]) {
                     [self socialSignIn:@"twitter" sID:userID sFname:[twitterDict valueForKey:@"screen_name"] sLname:[twitterDict valueForKey:@"screen_name"] sMail:[twitterDict valueForKey:@"name"] imageurl:[twitterDict valueForKey:@"profile_image_url"]];
                     
                 }else{
                     [self socialSignIn:@"twitter" sID:userID sFname:[twitterDict valueForKey:@"screen_name"] sLname:@"" sMail:@"" imageurl:[twitterDict valueForKey:@"profile_image_url"]];
                     
                     [twitter replaceObjectAtIndex:0 withObject:[twitterDict valueForKey:@"screen_name"]];
                     [twitter replaceObjectAtIndex:1 withObject:userID];
                     // [twitter replaceObjectAtIndex:2 withObject:[twitterDict valueForKey:@"screen_name"]];
                     [twitter replaceObjectAtIndex:3 withObject:[twitterDict valueForKey:@"profile_image_url"]];
                     
                     
                 }
                 
                 
             }
             else {
                 NSLog(@"Error code: %ld | Error description: %@", (long)[connectionError code], [connectionError localizedDescription]);
             }
         }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void) twitterTesting:(NSString*) sID
{
    [self socialSignIn:@"twitter" sID:sID sFname:[twitter objectAtIndex:2] sLname:[twitter objectAtIndex:2] sMail:@"" imageurl:[twitter objectAtIndex:3]];
}

-(void) showAlert
{
    UIAlertView*a1=[[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"phonesettingserror"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
    [a1 show];
    [a1 release];
}
-(void) alertControlForTwitter
{
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:[delegate.languageDict objectForKey:@"twitterlogin"]
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString([delegate.languageDict objectForKey:@"emailaddress"], [delegate.languageDict objectForKey:@"email"]);
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *login = alertController.textFields.firstObject;
                                   [login resignFirstResponder];
                                   if ([delegate validateEmail:login.text])
                                   {
                                       [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
                                       [self socialSignIn:@"twitter" sID:[twitter objectAtIndex:1] sFname:[twitter objectAtIndex:0] sLname:[twitter objectAtIndex:2] sMail:login.text imageurl:[twitter objectAtIndex:3]];
                                   }
                               }];
    [alertController addAction: okAction];
    [self.view.window.rootViewController presentViewController: alertController animated: YES completion: nil];
}


#pragma mark - send Request Proxy

-(void)socialSignIn:(NSString*)type sID:(NSString*)idval sFname:(NSString*)sFname sLname:(NSString*)sLname sMail:(NSString*)sMail imageurl:(NSString*)imageurl
{
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        [proxy sociallogin:apiusername :apipassword :type :idval:sFname :sLname :sMail :imageurl];
    }
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
    if ([method isEqualToString:@"adddeviceid"])
    {
    }
    else
    {
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
                [self alertControlForTwitter];
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
                if ([[[defaultDict objectForKey:@"message"]uppercaseString]isEqualToString:@"ACCOUNT NOT FOUND"])
                {
                    [self alertControlForTwitter];
                }
                else
                {
                    [self showAlertconroll:[defaultDict objectForKey:@"message"]tag:1];
                }
            }
            else
            {
                [self showAlertconroll:[defaultDict objectForKey:@"message"]tag:1];
            }
        }
    }
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
}

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

#pragma  mark - alert




-(void) showAlertconroll:(NSString*)message tag:(int)tag
{
    NSString * subject = [delegate.languageDict objectForKey:@"alertHeader"];
    if (tag==0)
    {
        subject = [delegate.languageDict objectForKey:@"successHeader"];
    }
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: subject
                                                                        message: message
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: [delegate.languageDict objectForKey:@"ok"]
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            
                                                        }];
    [controller addAction: alertAction];
    
    [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];
}


@end
