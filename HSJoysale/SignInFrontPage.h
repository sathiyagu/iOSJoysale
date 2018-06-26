//
//  SignInFrontPage.h
//  HSJoysale
//
//  Created by BTMANI on 05/12/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Accounts/Accounts.h>
#import "BLMultiColorLoader.h"
#import "ACFloatingTextField.h"
#import "KOPopupView.h"

@class AppDelegate;
@interface SignInFrontPage : UIViewController<Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    //class declaration
    AppDelegate * delegate;
    
    //UI declaration
    IBOutlet UIButton *ForgetPassword;
//    IBOutlet UIButton * facebookBtn;
//    IBOutlet UIButton * twitterBtn;
//    IBOutlet UIButton * googlePlusBtn;
    IBOutlet UIButton * signinBtn;
    IBOutlet UIButton * signupBtn;
    IBOutlet UIButton *skipBtn;
    IBOutlet ACFloatingTextField * userNameTextField;
    IBOutlet ACFloatingTextField * passwordTextField;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel * logoTextLabel;
    IBOutlet UILabel * newUserLabel;
    IBOutlet UIView *signupView;
    IBOutlet UILabel * userPlaceHolderLabel;
    IBOutlet UILabel * passwordPlaceHolderLabel;

    UIView *forgetPopUp;
    UITextField *recoverEmail;

    //Variable declaration
    NSMutableArray * userDetailsArray;
    NSMutableDictionary *defaultTwitDict;
    NSMutableArray*twitter;
    int flag;
    BOOL twitterFlag;
}
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;
@property (retain, nonatomic) IBOutlet UIView *MainView;
-(IBAction)loginButtonTapped:(id)sender;
-(IBAction)signupButtonTapped:(id)sender;
- (IBAction)skipBtnTapped:(id)sender;
@property (nonatomic,retain) ACAccountStore * accountStore;
@property (nonatomic, strong) KOPopupView *popup;

@end
