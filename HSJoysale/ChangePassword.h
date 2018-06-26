//
//  ChangePassword.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 17/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface ChangePassword : UIViewController<Wsdl2CodeProxyDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    ApiControllerServiceProxy *proxy;
    AppDelegate * delegate;
    
    IBOutlet UIView *changepasswordView;
    IBOutlet UITextField * currentPasswordTField;
    IBOutlet UITextField * newPasswordTField;
    IBOutlet UITextField * cofirmPasswordTField;
    IBOutlet UIButton *showSecureTextBtn;
    IBOutlet UILabel *oldPswdLabel;
    IBOutlet UILabel *reenterPswdLabel;
    IBOutlet UILabel *newPswdLabel;
    
}
- (IBAction)showSecureTextBtnTapped:(id)sender;
@end
