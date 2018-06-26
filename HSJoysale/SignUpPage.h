//
//  SignUpPage.h
//  HSJoysale
//
//  Created by BTMANI on 18/12/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"
#import "ACFloatingTextField.h"
@class AppDelegate;

@interface SignUpPage : UIViewController<UITextFieldDelegate,Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate>
{
    //class Declaration
    AppDelegate * delegate;

    //UI Declaration
    IBOutlet ACFloatingTextField * emailTextField;
    IBOutlet ACFloatingTextField * usernameTextField;
    IBOutlet ACFloatingTextField * fullnameTextField;
    IBOutlet ACFloatingTextField * passwordTextField;
    IBOutlet ACFloatingTextField * cnfpasswordTextField;
    
    IBOutlet UILabel * emailPHLabel;
    IBOutlet UILabel * usernamePHLabel;
    IBOutlet UILabel * fullnamePHLabel;
    IBOutlet UILabel * passwordPHLabel;
    IBOutlet UILabel * cnfpasswordPHLabel;

    
    IBOutlet UIButton * loginBtn;
    IBOutlet UIButton * registerBtn;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel * logoTextLabel;
    IBOutlet UIButton *skipBtn;
    
    CGRect kKeyBoardFrame;
    BOOL firstTime;

    
    //Variable Declaration
    int numberOfSpaces;


}
- (IBAction)signupBtnTapped:(id)sender;
- (IBAction)loginBtnTapped:(id)sender;
- (IBAction)skipBtnTapped:(id)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *mainView;
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;
@end
