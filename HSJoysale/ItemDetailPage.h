//
//  ItemDetailPage.h
//  HSJoysale
//
//  Created by BTMANI on 02/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//
// solai
#import <UIKit/UIKit.h>
#import "OmniGrid.h"
#import "SocketIO.h"
#import "SMPageControl.h"
#import "KOPopupView.h"
#import "IDMPhotoBrowser.h"
#import "BLMultiColorLoader.h"


@interface ItemDetailPage : UIViewController<UIScrollViewDelegate,OmniGridViewDelegate,Wsdl2CodeProxyDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,SocketIODelegate,UIAlertViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate,IDMPhotoBrowserDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{

    //Class object declaration
    
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;
    SocketIO *socketIO; //Socket IO is used of chatting
    OmniGridView * moreItemsgridView; //For display more from this user items
    //for more than one photos it show count of buttons
    SMPageControl *imagePageControl;

    //Variable declaration
    
    NSMutableArray * locationnameArray; //Store location Details
    NSMutableArray * moreItemsArray; //store more from this user items
    NSMutableArray * detailItemsArray; //store current item details
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatter1;
    NSString * chatIDValue;
    int selectedIndexvalue; //for selected index in homearray
    int detailSelectedIndex; //for selected index in homearray
    int pagenumber;
    float itemimageHeight;
    BOOL reloadFlag;
    BOOL buttonFlashing;
    BOOL buyNowFlag;
    BOOL itemEnableFlag;
    BOOL callSimilarDataFunction;

    //UI Declaration
    
    IBOutlet UIScrollView * mainPageScrollView; // Main page scroll view
    IBOutlet UIView *makeAnOfferBG;
    IBOutlet UIImageView *makeAnOffUserImageView;
    IBOutlet UIButton *makeOffbgBtn;
    IBOutlet UIButton *makeoffersendBtn;
    IBOutlet UILabel *makeANOfferUserNameLabel;
    IBOutlet UITextView *makeAnOfferTxtView;
    IBOutlet UITextField *typeYourOfferTxtView;
    IBOutlet UILabel * lblPlaceholder;
    UIScrollView * itemImageScrollView; //Item Image scroll view
    UILabel * likeCountLbl;
    UILabel * reportItemLabel;
    UIButton * likeButton;
    UIButton * reportUsButton;
    UIButton * reportBtn;
    UIButton * backBtn;
    UIView * moreItemsView;
    UIView * itemDescribtionView;
    UIView * ItemTitleView;
    UIView * buttonsView;
    UIView * timeDisplayView;
    UIView * locationandUserView;
    UIView * itemDetailsView;
    UIView * MoreViewPopup;
    UIView * contactSellerView;
    
    int dotLocation;

}
-(void) detailPageArray:(NSMutableArray*)locdetailPageArray selectedIndex:(int)selectedIndex;

- (IBAction)closeMakeOffPopupButton:(id)sender;
- (IBAction)makeOfferSendButton:(id)sender;

@property (nonatomic, strong) KOPopupView *popup;
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *buyNowmultiColorLoader;

@end
