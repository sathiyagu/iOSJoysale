//
//  welcomeScreen.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 19/05/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Accounts/Accounts.h>

@class AppDelegate;

@interface welcomeScreen : UIViewController<Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate>{
    //Class object declaration
    AppDelegate * delegate;
    
    //UI Declaration
    IBOutlet UIButton *loginBtn;
    IBOutlet UIButton *signupBtn;
    IBOutlet UIButton *skipBtn;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UIImageView * logoImageView;

    IBOutlet UIButton * facebookBtn;
    IBOutlet UIButton * twitterBtn;
    IBOutlet UIButton * googlePlusBtn;
    IBOutlet UILabel * elseLable;
    IBOutlet UIView*seperator;

    //Variable declaration
    NSMutableArray * userDetailsArray;
    NSMutableDictionary *defaultTwitDict;
    NSMutableArray*twitter;
    int flag;
    BOOL twitterFlag;

    
}
@property (retain, nonatomic) IBOutlet UIView *Mainview;
- (IBAction)loginBtnTapped:(id)sender;
- (IBAction)signupBtnTapped:(id)sender;
- (IBAction)skipBtnTapped:(id)sender;

-(IBAction)facebookButtonTapped:(id)sender;
-(IBAction)twitterButtonTapped:(id)sender;
-(IBAction)googleButtonTapped:(id)sender;
@property (nonatomic,retain) ACAccountStore * accountStore;
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;


@end
