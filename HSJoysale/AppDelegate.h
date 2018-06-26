//
//  AppDelegate.h
//  HSJoysale
//
//  Created by Hitasoft on 04/12/15.
//  Copyright © 2015 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CoreLocation/CoreLocation.h>
#import <netinet/in.h>

#import "ApiControllerServiceProxy.h"
#import "DefensiveClass.h"
#import "BLMultiColorLoader.h"
#import "TabViewController.h"

#import "NewProfilePage.h"
#import <UserNotifications/UserNotifications.h>
#import "AHKNavigationController.h"
@class welcomeScreen;
@class HomePage;
@class NewProfilePage;
//@class MessagePage;
@class ProfilePage;
@class CategoryTab;
@class JsonParsing;


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIWebViewDelegate,CLLocationManagerDelegate,Wsdl2CodeProxyDelegate,UNUserNotificationCenterDelegate>
{
    //Class Object Declaration
    welcomeScreen * welcomeScreenObj;
    DefensiveClass * defensiveClassObj;
    
    //Html view for App Install Agreement
    UIView * htmlview;
    UIWebView *TOSwebview;
    //For access Loction
    CLLocationManager * locationManager;
    CLGeocoder * geocoder;
    
    //For convent UnixtimeStamp to Date
    NSDateFormatter *dateformatter;
}

#pragma mark - Network

// Check Network Available
- (BOOL) connectedToNetwork;
//If no network it show alert
-(void) networkError;
-(void) adminchecking;

//Data to Date Convertor
-(NSString *)dateDiff:(NSString *)origDate;
@property (nonatomic,retain) NSMutableArray * mapLocationArray;

#pragma mark - Device Window Height and width ,font

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) float windowWidth,windowHeight;
@property (nonatomic) float bigFont,titleSize,headingSize,normalText,smallText;


#pragma mark - class Declaration

//For TabbarPage
@property (nonatomic,retain) TabViewController * tabViewControllerObj;
//For Home page
@property (nonatomic,retain) HomePage * homePageObj;
//For Category page
@property (nonatomic,retain) CategoryTab * CategoryTabObj;
//For Chat page
//@property (nonatomic,retain) MessagePage * messagePageObj;
//For Profile page
@property (nonatomic,retain) NewProfilePage * profilePageObj;
//For Defensive JSON formatting
@property (nonatomic,retain) DefensiveClass * defensiveClassObj;
//For Parsing JSON
@property (nonatomic,retain) JsonParsing * jsonParsingObj;
//For Label CGSuggestionsize
@property (nonatomic,retain) CGSuggestionSizeMake * sizeMakeClass;
@property (nonatomic,retain) NSMutableArray *searchHistoryArray;


#pragma mark - NavigationController

//This Main navigation Store tabbar windows
@property (nonatomic,retain) AHKNavigationController * navi;

#pragma mark - App Agreement

-(void) addingWebSubView;
// Load agreement Conten
@property (retain, nonatomic) BLMultiColorLoader *multiColorLoader;
@property (nonatomic) BOOL buynowModuleFlag;
@property (nonatomic) BOOL hideBarFromDetailpage;
@property (nonatomic) BOOL exchangeModuleFlag;
@property (nonatomic) BOOL promotionModuleFlag;

#pragma mark - Location Access

-(void) requestWhenInUseAuthorization;
-(void) getLocationnonvoid;
//Store current location when app launch
@property (nonatomic) float currentlongitude,currentlatitude;
@property (nonatomic,retain) NSString * currentPlacemark;
//Store Location latitude, logitute and placemark
@property (nonatomic,retain) NSMutableArray * selectedLocationArray;

#pragma mark - Tabbar

//It store selected tabbar Id
@property (nonatomic) int tabID;
-(void) tabbarFrameHide;


#pragma mark - Profile page

#pragma mark myorder
@property (nonatomic,retain) NSMutableArray * myorderParticularArray;
@property (nonatomic,retain) NSString * myorderIndexpath;

#pragma mark mysale
@property (nonatomic,retain) NSMutableArray * mysaleParticularArray;
@property (nonatomic,retain) NSString * mysaleIndexpath;


// Get Profile Information
-(void) getProfileInfo;


#pragma mark - loginPage

//For Login With facebook or Google
@property (nonatomic) BOOL facebookflag;
//Store Device id and submit to proxy for receive notification
@property (nonatomic,retain) NSMutableArray * devicetokenArray;
// Mail Validation for sign in and signup page
-(BOOL) validateEmail: (NSString *) email;
-(NSString*)gettingLanguageCode;

#pragma mark - Addproductpage

//For AddProduct Capture Image
/* imageCapturedArray Used to store capture image by snap or pick image from gallery,when enter PKImagePickerViewController class it remove all objects and add datas from user, when user select pictures those image are store to another selected array by using this imageCapturedArray.
 */
@property (nonatomic,retain) NSMutableArray * imageCapturedArray;

/* addProductPhotos copy array from edit product photos or selected image by user. This array only show image in image scroll in addProduct page.
 */
@property (nonatomic,retain) NSMutableArray * addProductPhotos;

/* when edit product, remove image are send to proxy so we store removed image in this array and concat all image
 */
@property (nonatomic,retain) NSMutableArray * removedItemArray;

/* addcategoryFilterDict store country information,Currency code with symbol and Category Information used for product Before add we need to load it.
 */
@property (nonatomic,retain) NSMutableDictionary * addcategoryFilterDict;

// After select Parent Category it store subcategory
@property (nonatomic,retain) NSMutableDictionary * filterSubcategoryDic;

// When newly added product set edit flag NO otherwise YES for navigation control
@property (nonatomic) BOOL editFlag;

// When add more image from add product or edit product set editImageFlag YES Otherwise NO
@property (nonatomic) BOOL editImageFlag;

// Store new or edit product detail to submit data
@property (nonatomic,retain) NSMutableArray * postProductArray;

/* after edit product data it show itemdetail page when click back it go root view otherwise it redirect to particular page.
 */
@property (nonatomic,retain) NSString *fromAddproduct;


#pragma mark - Product Customize

/* For Customize own product If user delete or promoter his own product means, it will set to Yes and refresh ongoing page.
 */
@property (nonatomic,retain) NSString * deleteProduct;
@property (nonatomic,retain) NSString * promoteProduct;

#pragma mark - ItemDetailPage

//For ItemDetailPage
/* detailPageArray used to store all array values from another array(eg.Homepagearray) and display particular index data(selected index store in this int detailArraySelectedIndex). what ever user changes in that page(like,comment count...) it will replace on this array and original data(eg.homePageArray) when out from this class.
 */
@property (nonatomic,retain) NSMutableArray * detailPageArray;
@property (nonatomic) int detailArraySelectedIndex;
@property (nonatomic,retain) NSMutableArray * buynowArray;

#pragma mark - Comment page

//For comment Page
/*If user comment in particular product means, comment count will change, it will change in detailpageArray when user post comment
 */
@property (nonatomic)int commentCount;

#pragma mark - ExchangeDetailPage

@property (nonatomic,retain) NSMutableArray * exchangeDetaiArray;
/*For back button show root page or exchange page.Because when user create exchange it show directly exchange detail.Otherwise it show exchange page
 */
@property (nonatomic) int exchangeTypeIndex;

#pragma mark - Filter page

//For Advance searchPAge
//For Filter button tapped
@property (nonatomic) BOOL advancesearchFlag;
/*Filter arrays for category and subcategory it show parent category in subcategory Page
 */
@property (nonatomic,retain) NSMutableArray * filterCategoryArray;
//From home or category for replace temp values
@property (nonatomic,retain) NSString * FilterFromFlag;

#pragma mark - profile page

//For Profile page
// Store other user / own user information
@property (nonatomic,retain) NSMutableArray *userDetailTempArray;

@property (nonatomic,retain) NSMutableArray * userIDArray;
@property (nonatomic,retain) NSMutableArray * UserDetailArray;
//It store follower ID Array
@property (nonatomic,retain) NSMutableArray * followerIdArray;

#pragma mark Edit ProfileImage Page
@property (nonatomic,retain) NSMutableArray * addProfilePhoto;
@property (nonatomic,retain) NSMutableArray * editProfileArray;

#pragma mark Language Page
@property (nonatomic,retain) NSString *languageSelected;
//Store data depend on selected language
@property(nonatomic,retain) NSMutableDictionary * languageDict;


#pragma mark - Home page

//For Home Page
//Replace homepageArray values using this flag checking
@property (nonatomic) BOOL favHomeFlag;
// Load data based on those array values
@property (nonatomic,retain) NSMutableArray * HomeSearchArray;
@property (nonatomic,retain) NSMutableDictionary * HomeDictForCatID;
// For apply filter store temp values once save it replace homesearchArray value
@property (nonatomic,retain) NSMutableArray * HomeSearchtempArray;
@property (nonatomic,retain) NSMutableDictionary * HomeDictForCatIDtemp;

#pragma mark - Category page

//For Category Tab
//To store category Information
@property (nonatomic,retain) NSMutableDictionary * getcategoryDict;
// Load data based on those array values
@property (nonatomic,retain) NSMutableArray * advanceCategorySearchArray;
@property (nonatomic,retain) NSMutableDictionary * CategoryDictForCatID;
// For apply filter store temp values once save it replace advanceCategorySearchArray value
@property (nonatomic,retain) NSMutableArray * advanceCategorySearchtempArray;
@property (nonatomic,retain) NSMutableDictionary * CategoryDictForCatIDtemp;
// When click category tab it check to show Main category or category result
@property (nonatomic,retain) NSString * CategoryTabbed;
// For category filter
@property (nonatomic) BOOL filterBtnTapped;

#pragma mark - Chat Detail page

//For Chat Detail Page
@property (nonatomic,retain) NSMutableArray * receiverdataArray;

@property (nonatomic) BOOL notificationredirectionFlag;
@property (nonatomic) BOOL showNotificationFlag;
@property (nonatomic,retain) NSString *currentChater;

@property (nonatomic,retain) NSMutableArray *bannerDetailsArray;
@property (nonatomic) BOOL bannerEnable;
@property (nonatomic) BOOL PromotionSuccessFlag;
@property (nonatomic) BOOL langchangeFlag;
@property (nonatomic,retain) NSString *distancestring;

#pragma mark - Textfield Validation
@property (nonatomic,retain) NSString *chatfilter;
@property (nonatomic,retain) NSString *Passwordfilter;
@property (nonatomic,retain) NSString *Emailfilter;
@property (nonatomic,retain) NSString *fullnamefilter;
@property (nonatomic,retain) NSString *usernamefilter;

#pragma mark - Unwanted
-(BOOL)isNumeric:(NSString*)inputString;
-(BOOL)isAlphaNumeric:(NSString*)inputString;
-(BOOL)isAlpha:(NSString*)inputString;
@property (nonatomic,retain)UIView * addproductView;

#pragma mark CountDetails
@property (nonatomic,retain) NSMutableDictionary *countDetailDict;
-(NSString*)attributestringtostring:(NSString*) attributeString;
@end


