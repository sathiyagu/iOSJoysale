//
//  EditProfile.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 19/08/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"
#import "KOPopupView.h"

@interface EditProfile : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate>
{
    //Class Declaration
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;

    //Variable Declaration
    NSMutableArray * fbVerifyArray;
    BOOL showChange;
    BOOL fbVerifyBtn;
    BOOL editFlag;

    UITextField * phoneTextField;
    UITextField * ccTextField;
    UITextField * otpTextField;
    //UI Declaration
    IBOutlet UIView *mainView;
    IBOutlet UITableView *editProfileTableview;
    IBOutlet UIButton *savebtn;
    IBOutlet UIView *bottomView;
    IBOutlet UIButton *cameraBtn;
    IBOutlet UIButton *galleryBtn;
    IBOutlet UIButton *hideGalleryBtn;
    IBOutlet UIView *galleryView;
    IBOutlet UIView *OTPView;
    IBOutlet UIButton *hideOTPviewBtn;
    IBOutlet UITextField *OtpTextField;
    IBOutlet UIButton *OTPBtn;
    UITextField *actifText;
    UIToolbar* numberToolbar;
    IBOutlet UIView *gallerycontentView;
    IBOutlet UIView *OTPcontentView;

    IBOutlet UIImageView *cameraBg;
    UIView * verifyView;
    UIView * otpView;
    
    BOOL allowCallsflag;
}

- (IBAction)saveBtnTapped:(id)sender;
- (IBAction)cameraBtnTapped:(id)sender;
- (IBAction)closeOTPView:(id)sender;
- (IBAction)closeGalleryView:(id)sender;
- (IBAction)OTPBtnTapped:(id)sender;
- (IBAction)galleryBtnTapped:(id)sender;
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;
@property (nonatomic, strong) KOPopupView *popup;

@end
