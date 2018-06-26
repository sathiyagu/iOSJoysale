//
//  AppDelegate.m
//  HSJoysale
//
//  Created by Hitasoft on 04/12/15.
//  Copyright © 2015 Hitasoft.f All rights reserved.
//

#import "AppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "HomePage.h"
#import "welcomeScreen.h"
#import "NewProfilePage.h"
#import "CategoryTab.h"
#import "JsonParsing.h"
#import "PayPal.h"
#import "ISMessages.h"
#import "NotificationPage.h"
#import "AHKNavigationController.h"
#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>

NSString *BraintreeDemoAppDelegatePaymentsURLScheme = @"com.app.joysaleLite.payments";


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@implementation AppDelegate

@synthesize navi;
@synthesize hideBarFromDetailpage;
@synthesize homePageObj,CategoryTabObj,profilePageObj;
@synthesize defensiveClassObj,jsonParsingObj,buynowModuleFlag,exchangeModuleFlag,promotionModuleFlag;
@synthesize tabViewControllerObj,tabID;
@synthesize HomeSearchtempArray,HomeSearchArray,HomeDictForCatID,HomeDictForCatIDtemp;
@synthesize searchHistoryArray;
@synthesize advanceCategorySearchArray,advanceCategorySearchtempArray,advancesearchFlag,filterCategoryArray,CategoryDictForCatID,CategoryDictForCatIDtemp,addcategoryFilterDict,getcategoryDict,filterSubcategoryDic;
@synthesize exchangeDetaiArray,exchangeTypeIndex;
@synthesize currentlatitude,currentlongitude,currentPlacemark,selectedLocationArray;
@synthesize FilterFromFlag,favHomeFlag,CategoryTabbed,fromAddproduct,facebookflag,deleteProduct,promoteProduct;
@synthesize userDetailTempArray,UserDetailArray,editProfileArray,addProfilePhoto,userIDArray,languageSelected,followerIdArray,languageDict;
@synthesize receiverdataArray,currentChater,distancestring;
@synthesize imageCapturedArray,addProductPhotos,editFlag,editImageFlag,removedItemArray,postProductArray;
@synthesize detailPageArray,detailArraySelectedIndex,commentCount,buynowArray;
@synthesize windowWidth,windowHeight;
@synthesize sizeMakeClass,devicetokenArray;
@synthesize multiColorLoader;
@synthesize addproductView;
@synthesize chatfilter,Passwordfilter,Emailfilter,fullnamefilter,usernamefilter;
@synthesize bigFont,titleSize,headingSize,normalText,smallText;
@synthesize notificationredirectionFlag,showNotificationFlag;
@synthesize myorderParticularArray,mysaleParticularArray,myorderIndexpath,mysaleIndexpath;
@synthesize mapLocationArray;
@synthesize bannerDetailsArray,bannerEnable,countDetailDict,PromotionSuccessFlag,langchangeFlag;

static NSString * const kClientID =
@"703934394735-m99ur1f3h9r9jojjc8ntu005dg7e3t50.apps.googleusercontent.com";

//@"208289128788-qk1ssaao2ehc7fpk09i0ci1o0sa155he.apps.googleusercontent.com";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //For showing Splash Screen
    //Admin Data calling
    buynowModuleFlag = NO;
    exchangeModuleFlag = NO;
    PromotionSuccessFlag = NO;
    langchangeFlag = NO;

    [self performSelectorOnMainThread:@selector(adminchecking) withObject:nil waitUntilDone:YES];

    //sleep(5.0);
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    
    //Get current location
    [self performSelectorOnMainThread:@selector(getLocationnonvoid) withObject:nil waitUntilDone:YES];
    [[Twitter sharedInstance] startWithConsumerKey:@"av5hmOglp2fkTwLTEUuOOH2kw" consumerSecret:@"qzvMFT1YxCyYZi6aWMLOyuzmfhmtlsF9xeMQCsdr5vAcZLjYpV"];
    [Fabric with:@[[Twitter class]]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //Framework Access
    [PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_NONE];
    [Fabric with:@[[Crashlytics class]]];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    //TODO:Initialization
    
    tabViewControllerObj = [[TabViewController alloc]initWithNibName:@"TabViewController" bundle:nil];
    navi = [[AHKNavigationController alloc]initWithRootViewController:tabViewControllerObj];
    homePageObj = [[HomePage alloc]init];
    welcomeScreenObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
//    messagePageObj = [[MessagePage alloc]initWithNibName:@"MessagePage" bundle:nil];
    CategoryTabObj=[[CategoryTab alloc]initWithNibName:@"CategoryTab" bundle:nil];
    profilePageObj =[[NewProfilePage alloc]init];
    jsonParsingObj = [[JsonParsing alloc]init];
    defensiveClassObj = [[DefensiveClass alloc]init];
    sizeMakeClass = [[CGSuggestionSizeMake alloc]init];
    
    promotionModuleFlag = NO;
    searchHistoryArray = [[NSMutableArray alloc]init];


    hideBarFromDetailpage  = NO;
    //Array Initialization
    
    countDetailDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    selectedLocationArray = [[NSMutableArray alloc]initWithCapacity:0];
    imageCapturedArray = [[NSMutableArray alloc]initWithCapacity:0];
    detailPageArray = [[NSMutableArray alloc]initWithCapacity:0];
    exchangeDetaiArray = [[NSMutableArray alloc]initWithCapacity:0];
    removedItemArray = [[NSMutableArray alloc]initWithCapacity:0];
    addProductPhotos = [[NSMutableArray alloc]initWithCapacity:0];
    advanceCategorySearchArray = [[NSMutableArray alloc]initWithCapacity:0];
    advanceCategorySearchtempArray = [[NSMutableArray alloc]initWithCapacity:0];
    HomeSearchArray = [[NSMutableArray alloc]initWithCapacity:0];
    HomeSearchtempArray = [[NSMutableArray alloc]initWithCapacity:0];
    UserDetailArray = [[NSMutableArray alloc]initWithCapacity:0];
    filterCategoryArray = [[NSMutableArray alloc]initWithCapacity:0];
    receiverdataArray = [[NSMutableArray alloc]initWithCapacity:0];
    postProductArray = [[NSMutableArray alloc]initWithCapacity:0];
    editProfileArray = [[NSMutableArray alloc]initWithCapacity:0];
    followerIdArray = [[NSMutableArray alloc]initWithCapacity:0];
    userIDArray = [[NSMutableArray alloc]initWithCapacity:0];
    addProfilePhoto= [[NSMutableArray alloc]initWithCapacity:0];
    devicetokenArray = [[NSMutableArray alloc]initWithCapacity:0];
    userDetailTempArray = [[NSMutableArray alloc]initWithCapacity:0];
    myorderParticularArray = [[NSMutableArray alloc]initWithCapacity:0];
    mysaleParticularArray = [[NSMutableArray alloc]initWithCapacity:0];
    buynowArray = [[NSMutableArray alloc]initWithCapacity:0];
    mapLocationArray = [[NSMutableArray alloc]initWithCapacity:0];
    bannerDetailsArray = [[NSMutableArray alloc]initWithCapacity:0];
    //Dictionary intialization
    
    addcategoryFilterDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    getcategoryDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    filterSubcategoryDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    CategoryDictForCatID = [[NSMutableDictionary alloc]initWithCapacity:0];
    CategoryDictForCatIDtemp = [[NSMutableDictionary alloc]initWithCapacity:0];
    HomeDictForCatID = [[NSMutableDictionary alloc]initWithCapacity:0];
    HomeDictForCatIDtemp = [[NSMutableDictionary alloc]initWithCapacity:0];
    languageDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    
   
    
    dateformatter=[[NSDateFormatter alloc]init];
    
    //TODO:Functionality
    
    windowWidth = self.window.frame.size.width;
    windowHeight = self.window.frame.size.height;
    
    [dateformatter setLocale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    [selectedLocationArray addObject:@"0.0"]; //0.latitude
    [selectedLocationArray addObject:@"0.0"]; //1.longitude
    [selectedLocationArray addObject:@"WorldWide"]; //2.placemark
    
    [HomeSearchArray addObject:@""];//0.latitude
    [HomeSearchArray addObject:@""];//1.longitude
    [HomeSearchArray addObject:@"WorldWide"];//2.Current Placemark
    [HomeSearchArray addObject:@""];//3.distance
    [HomeSearchArray addObject:@""];//4.PostWithin
    [HomeSearchArray addObject:@""];//5.sortBy
    [HomeSearchArray addObject:@""];//6.Category
    [HomeSearchArray addObject:@""];//7.SubCategory
    [HomeSearchArray addObject:@""];//8.SubCategory
    
    [HomeSearchtempArray addObject:@""];//0.latitude
    [HomeSearchtempArray addObject:@""];//1.longitude
    [HomeSearchtempArray addObject:@""];//2.Current Placemark
    [HomeSearchtempArray addObject:@""];//3.distance
    [HomeSearchtempArray addObject:@""];//4.PostWithin
    [HomeSearchtempArray addObject:@""];//5.shortBy
    
    [advanceCategorySearchArray addObject:@""];//0.latitude
    [advanceCategorySearchArray addObject:@""];//1.longitude
    [advanceCategorySearchArray addObject:@"WorldWide"];//2.Current Placemark
    [advanceCategorySearchArray addObject:@""];//3.distance
    [advanceCategorySearchArray addObject:@""];//4.PostWithin
    [advanceCategorySearchArray addObject:@""];//5.sortBy
    [advanceCategorySearchArray addObject:@""];//6.Category
    [advanceCategorySearchArray addObject:@""];//7.SubCategory
    
    [advanceCategorySearchtempArray addObject:@""];//1.latitude
    [advanceCategorySearchtempArray addObject:@""];//2.longitude
    [advanceCategorySearchtempArray addObject:@""];//3.Current Placemark
    [advanceCategorySearchtempArray addObject:@""];//4.distance
    [advanceCategorySearchtempArray addObject:@""];//5.PostWithin
    [advanceCategorySearchtempArray addObject:@""];//6.shortBy
    
    [filterCategoryArray addObject:@""];//0.categoryID
    [filterCategoryArray addObject:@""];//1.categoryName
    [filterCategoryArray addObject:@""];//2.SubcategoryID
    [filterCategoryArray addObject:@""];//3.SubcategoryName
    
    [receiverdataArray addObject:@""];//0.UserID
    [receiverdataArray addObject:@""];//1.UserName
    [receiverdataArray addObject:@""];//2.Userimage
    [receiverdataArray addObject:@""];//3.call From (@"item",@"message")
    [receiverdataArray addObject:@""];//4.itemid
    [receiverdataArray addObject:@""];//5.itemimage
    [receiverdataArray addObject:@""];//6.item title
    [receiverdataArray addObject:@""];//7.fullname for show navigationbar name
    
    [postProductArray addObject:@""];//0.categoryID
    [postProductArray addObject:@""];//1.subcategoryID
    [postProductArray addObject:@""];//2.Title
    [postProductArray addObject:@""];//3.Description
    [postProductArray addObject:@""];//4.Price
    [postProductArray addObject:@"USD"];//5.CurrencyCode
    [postProductArray addObject:@""];//6.ProductCondition
    [postProductArray addObject:@""];//7.Location
    [postProductArray addObject:@""];//8.Exchange to Buy
    [postProductArray addObject:@""];//9.Fixeggd Price
    [postProductArray addObject:@""];//10.Latitude
    [postProductArray addObject:@""];//11.longitude
    [postProductArray addObject:@""];//12.Instant_buy
    [postProductArray addObject:@""];//13.paypalID
    [postProductArray addObject:@""];//14.shippingCost
    [postProductArray addObject:@""];//15.countryID

    [editProfileArray addObject:@""];//0.UserID
    [editProfileArray addObject:@""];//1.Fullname
    [editProfileArray addObject:@""];//2.UserImg
    [editProfileArray addObject:@""];//3.Facebook
    [editProfileArray addObject:@""];//4.Mobilenumber
    [editProfileArray addObject:@""];//5.Show mobilenumber
    
    [addProfilePhoto addObject:@""]; //for profile Photo
    
    [myorderParticularArray addObject:@""]; //for replace myorder datas
    [mysaleParticularArray addObject:@""]; //for replace mysale datas
    myorderIndexpath = @"";
    mysaleIndexpath = @"";

    deleteProduct = @"";
    promoteProduct=@"";
    languageSelected=@"English"; //Default Language
    fromAddproduct=@"NO";
    chatfilter=@"abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ ()*-+=.,@&amp;?#!$%:_&lt;&gt;&quot;^ ";
    Passwordfilter=@"abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ.$@#%-*:?!_,&amp;";
    Emailfilter=@"abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ.@-_";
    fullnamefilter=@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
    usernamefilter=@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    CategoryTabbed=@"Category";
    detailArraySelectedIndex = 0;
    
    //Allow notification
    showNotificationFlag = YES;
    currentChater = @"";
    distancestring = @"";
    //Font Customize size
    if (isAboveiOSVersion7) {
        bigFont=28;
        titleSize=20;
        headingSize=18;
        normalText=16;
        smallText=14;
    }
    else
    {
        bigFont=26;
        titleSize=18;
        headingSize=16;
        normalText=14;
        smallText=12;
    }
    
    
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = AppThemeColor;
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"location"]!=NULL)
    {
        [mapLocationArray addObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:0]];//set lat
        [mapLocationArray addObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:1]];//set lon
        [mapLocationArray addObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:2]];//set placemark
        [mapLocationArray addObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:3]];//current lat
        [mapLocationArray addObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:4]];//current lon
        [mapLocationArray addObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:5]];//current placemark
        [mapLocationArray addObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6]];//current Mode
        
        //Homepage
        
       
        
    }else{
        [mapLocationArray addObject:@""];//set lat
        [mapLocationArray addObject:@""];//set lon
        [mapLocationArray addObject:@""];//set placemark
        [mapLocationArray addObject:@""];//current lat
        [mapLocationArray addObject:@""];//current lon
        [mapLocationArray addObject:@""];//current placemark
        [mapLocationArray addObject:@"WorldWide"];//current Mode
        [[NSUserDefaults standardUserDefaults]  setValue:mapLocationArray forKey:@"location"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]!=NULL)
    {
    [HomeSearchArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:0]];//latitude 0
    [HomeSearchArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:1]];//longitude 1
    [HomeSearchArray replaceObjectAtIndex:2 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:2]];//Current Placemark 2
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"]!=NULL)
    {
        [postProductArray replaceObjectAtIndex:10 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"]objectAtIndex:0]];//latitude 0
        [postProductArray replaceObjectAtIndex:11 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"]objectAtIndex:1]];//longitude 1
        [postProductArray replaceObjectAtIndex:7 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"]objectAtIndex:2]];//Current Placemark 2
    }
    else{

        [postProductArray replaceObjectAtIndex:7 withObject:@""];

    }
    
    
    //Language Parsing
    //Check for first time set language english
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"language"]==NULL)
    {
        [[NSUserDefaults standardUserDefaults]  setValue:@"English" forKey:@"language"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        languageSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    }
    NSLog(@"languageSelected:%@",languageSelected);
    
    //TODO:fuctionCall
    [self performSelectorOnMainThread:@selector(changingLanguage) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(getProfileInfo) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(defaultDataParsing) withObject:nil waitUntilDone:YES];

//    [self adminchecking];
    
    
    //TODO: Push Notification
    

    [self PushnotificationFunction:launchOptions];
    
    //TODO:appearance
    
    [navi setNavigationBarHidden:YES];
    self.window.rootViewController = navi;
    self.window.backgroundColor = [UIColor whiteColor];
    
    //TODO:add Product
    
    addproductView = [[UIView alloc]init];
    [addproductView setFrame:CGRectMake(0-200,windowHeight-120,200, 50)];
    [addproductView setBackgroundColor:[UIColor clearColor]];
    [navi.view addSubview:addproductView];
    
    UIButton * takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * fromGalleryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [takePhotoBtn setFrame:CGRectMake(10,5,40,40)];
    [fromGalleryBtn setFrame:CGRectMake(150,5,40,40)];
    
    [takePhotoBtn setBackgroundColor:AppThemeColor];
    [fromGalleryBtn setBackgroundColor:AppThemeColor];
    
    [addproductView addSubview:takePhotoBtn];
    [addproductView addSubview:fromGalleryBtn];
    [self prefersStatusBarHidden];
    [application setStatusBarHidden:NO];
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    application.statusBarStyle = UIStatusBarStyleLightContent;

    
    return YES;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-(void) PushnotificationFunction:(NSDictionary *)launchOptions
{
    //TODO: Push Notification
    
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        if( launchOptions != nil )
        {
            NSLog( @"registerForPushWithOptions:" );
        }
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }
    

}

#pragma mark - App Agreement

-(void) addingWebSubView
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"appfirsttime"])
    {
        ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
        [proxy tos:apiusername :apipassword];

        htmlview = [[UIView alloc]init];
        [htmlview setBackgroundColor:BackGroundColor];
        [htmlview setFrame:CGRectMake(0, 0,windowWidth,windowHeight)];
        [self.window addSubview:htmlview];
        [self.window bringSubviewToFront:htmlview];

        UIImageView * appBarImage = [[UIImageView alloc]init];
        [appBarImage setImage:[UIImage imageNamed:@"applicatiobbarlogo.png"]];
        [appBarImage setFrame:CGRectMake(0,20,windowWidth,44)];
        [htmlview addSubview:appBarImage];

        UIImageView * bgImgView = [[UIImageView alloc]init];
        [bgImgView setImage:[UIImage imageNamed:@"bg.png"]];
        [bgImgView setFrame:CGRectMake(0,20,windowWidth,windowHeight-20)];
        [htmlview addSubview:bgImgView];

        UILabel * headerLabel = [[[UILabel alloc]init]autorelease];
        [headerLabel setText:AppName];
        [headerLabel setFont:[UIFont fontWithName:appFontBold size:20]];
        [headerLabel setTextColor:AppThemeColor];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [headerLabel setFrame:CGRectMake(0,20,windowWidth,44)];
        [htmlview addSubview:headerLabel];

//        NSURL *url = [NSURL URLWithString:webroot];
//        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//        UIWebView * webview = [[UIWebView alloc]init];
//        webview.delegate = self;
//        [webview loadRequest:requestObj];
//        [webview setFrame:CGRectMake(10,74,windowWidth-20,windowHeight-140)];
//        [htmlview addSubview:webview];

        TOSwebview = [[UIWebView alloc]init];
        TOSwebview.delegate = self;
        [TOSwebview setFrame:CGRectMake(10,74,windowWidth-20,windowHeight-140)];
        [htmlview addSubview:TOSwebview];

        multiColorLoader=[[BLMultiColorLoader alloc]init];
        multiColorLoader.lineWidth = 2.0;
        multiColorLoader.colorArray = [NSArray arrayWithObjects:[UIColor redColor],
                                       [UIColor purpleColor],
                                       [UIColor greenColor],
                                       [UIColor blueColor], nil];
        [multiColorLoader setFrame:CGRectMake((windowWidth-30)/2, (windowHeight-30)/2, 30, 30)];
        [multiColorLoader startAnimation];
        [htmlview addSubview:multiColorLoader];
        
        UIView * bgview = [UIView new];
        [bgview setBackgroundColor:[UIColor whiteColor]];
        [htmlview addSubview:bgview];


        UIButton * acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [acceptBtn setImage:[UIImage imageNamed:@"Accept.png"] forState:UIControlStateNormal];
        [acceptBtn addTarget:self action:@selector(acceptBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//        [acceptBtn setFrame:CGRectMake(((windowWidth/2)-144)/2,windowHeight-50, 144, 42)];
        [acceptBtn setBackgroundColor:AppThemeColor];
        [acceptBtn setTitle:[self.languageDict objectForKey:@"accept"] forState:UIControlStateNormal];
        [acceptBtn.titleLabel setFont:[UIFont fontWithName:appFontBold size:15]];
        [acceptBtn.layer setBorderWidth:1];
        [acceptBtn.layer setBorderColor:AppThemeColor.CGColor];
        [acceptBtn setTintColor:whitecolor];
        [acceptBtn.layer setCornerRadius:3];
        [acceptBtn.layer setMasksToBounds:YES];
        
        

        [htmlview addSubview:acceptBtn];

        UIButton * denyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [denyBtn setFrame:CGRectMake((windowWidth/2)+((windowWidth/2)-144)/2,windowHeight-50, 144, 42)];
        [denyBtn setBackgroundColor:whitecolor];
        [denyBtn.layer setBorderWidth:1];
        [denyBtn.layer setBorderColor:AppThemeColor.CGColor];
        [denyBtn setTintColor:AppThemeColor];
        [denyBtn setTitle:[languageDict objectForKey:@"deny"] forState:UIControlStateNormal];
        [denyBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
        [denyBtn setTitleColor:AppThemeColor forState:UIControlStateSelected];

        [denyBtn.titleLabel setFont:[UIFont fontWithName:appFontBold size:15]];
        [denyBtn.layer setCornerRadius:3];
        [denyBtn.layer setMasksToBounds:YES];
        
        [denyBtn setFrame:CGRectMake(5,windowHeight-45,(windowWidth/2)-10,35)];
        [acceptBtn setFrame:CGRectMake((windowWidth/2)+5, windowHeight-45, (windowWidth/2)-10,35)];
//        [denyBtn setImage:[UIImage imageNamed:@"Deny.png"] forState:UIControlStateNormal];
        [denyBtn addTarget:self action:@selector(denyBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [htmlview addSubview:denyBtn];

        [bgview setFrame:CGRectMake(0, windowHeight-55,windowWidth,55)];
        
        [bgview setBackgroundColor:[UIColor whiteColor]];

        
        [bgImgView release];
        [appBarImage release];
        
        

    }
}

#pragma mark  FirstTime Load for webview

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [multiColorLoader setHidden:YES];
}

-(void) acceptBtnTapped
{
    tabViewControllerObj = [[TabViewController alloc]initWithNibName:@"TabViewController" bundle:nil];
    navi = [[AHKNavigationController alloc]initWithRootViewController:tabViewControllerObj];
    [navi setNavigationBarHidden:YES];
    self.window.rootViewController = navi;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"appfirsttime"];
    [htmlview removeFromSuperview];
}

-(void) denyBtnTapped
{
    exit(0);
}

#pragma mark - tabbar
-(void) tabbarFrameHide{
    [tabViewControllerObj.tabBarController hideNewTabBar];
    [tabViewControllerObj.tabBarController.view setFrame:CGRectMake(0,0, windowWidth, windowHeight+50)];
}


#pragma mark - LocationManager
-(void) getLocationnonvoid
{
    //Check location Service Enabled
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager=[[CLLocationManager alloc] init];
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if(status!=2){
            [locationManager setDelegate:self];
            locationManager.distanceFilter = 100.0; //whenever we move
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager startUpdatingLocation];
            [locationManager startUpdatingHeading];
            
            geocoder = [[CLGeocoder alloc] init];
            CLLocation *location = [locationManager location];
            CLLocationCoordinate2D coordinate = [location coordinate];
            currentlongitude=coordinate.longitude;
            currentlatitude=coordinate.latitude;
            [self getPlacemark];
        }else{
            currentlongitude=0;
            currentlatitude=0;
            currentPlacemark=@"WorldWide";
        }
    }else{
        currentlongitude=0;
        currentlatitude=0;
        currentPlacemark=@"WorldWide";
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]!=NULL)
    {
        //Location already set
    }
    else
    {
        NSMutableArray * chooseArray = [[NSMutableArray alloc]init];
        [chooseArray addObject:@""];//latitude
        [chooseArray addObject:@""];//longitude
        [chooseArray addObject:@"WorldWide"];//Current Placemark
        [[NSUserDefaults standardUserDefaults]setObject:chooseArray forKey:@"choosedDataArray"];
    }
}

-(void) getPlacemark
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:currentlatitude longitude:currentlongitude];
    currentPlacemark=@"WorldWide";
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  //String to hold address
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
                  NSLog(@"I am currently at %@",locatedAt);
                  currentPlacemark=[NSString stringWithFormat:@"%@",locatedAt];

                  [mapLocationArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%f",currentlatitude]];
                  [mapLocationArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%f",currentlongitude]];
                  [mapLocationArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%@",currentPlacemark]];

              }
     ];
}

- (void)requestWhenInUseAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        UIAlertView *alertViews = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:[languageDict objectForKey:@"cancel"]
                                                   otherButtonTitles:@"Settings", nil];
        [alertViews setTag:121];
        [alertViews performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D location=newLocation.coordinate;
    currentlongitude=location.longitude;
    currentlatitude=location.latitude;
    NSLog(@"current longitude:%f, current latitude:%f",currentlongitude,currentlatitude);
    if ([[selectedLocationArray objectAtIndex:1]floatValue]==0)
    {
        [selectedLocationArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",currentlatitude]];
        [selectedLocationArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",currentlongitude]];
        [selectedLocationArray performSelectorOnMainThread:@selector(getLocationName) withObject:nil waitUntilDone:YES];
    }
    [mapLocationArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%f",currentlatitude]];
    [mapLocationArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%f",currentlongitude]];
}


-(void) getLocationName
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:currentlatitude longitude:currentlongitude];
    //insert your coordinates
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  //String to hold address
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
                  currentPlacemark=[NSString stringWithFormat:@"%@",locatedAt];

                  //Print the location to console
                  NSLog(@"I am currently at %@",locatedAt);
                  NSLog(@"I am currently at %@",placemark);
                  [selectedLocationArray replaceObjectAtIndex:2 withObject:currentPlacemark];
                  [mapLocationArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%f",currentlatitude]];
                  [mapLocationArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%f",currentlongitude]];
                  [mapLocationArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%@",currentPlacemark]];

              }
     ];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations == nil)
        return;
    CLLocation *location = [manager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    currentlongitude=coordinate.longitude;
    currentlatitude=coordinate.latitude;
    NSLog(@"locationManager old%f,%f",currentlongitude,currentlatitude);
    [self getPlacemark];
    [[NSUserDefaults standardUserDefaults]  setValue:mapLocationArray forKey:@"location"];
    NSLog(@"Location:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"location"]);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            //            [locationManager startUpdatingLocation];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}

#pragma mark AlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==121)
    {
        if (buttonIndex==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}





#pragma mark - network connection
/**
 To check the network connection in the app
 */

- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

-(void) networkError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:[languageDict objectForKey:@"alert"]
                              message:[languageDict objectForKey:@"Could not connect to Joysale.Please check your network connection and try again."]
                              delegate:self
                              cancelButtonTitle:[languageDict objectForKey:@"ok"]
                              otherButtonTitles:nil, nil];
    
    [alertView show];
    
}
-(void) adminchecking{
    
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    [proxy admindatas:apiusername :apipassword :[self gettingLanguageCode]];
}

#pragma mark - Notification
-(void) addMessageFromRemoteNotification:(NSDictionary*)userInfo
{
    NSString * alretStr = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    NSRange r;
    while ((r = [alretStr rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        alretStr = [alretStr stringByReplacingCharactersInRange:r withString:@""];
    
    NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                  initWithData: [alretStr dataUsingEncoding:NSUnicodeStringEncoding]
                                                  options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                  documentAttributes: nil
                                                  error: nil
                                                  ];
    
    
    NSString * alertStr = tittleattributedString.string;
    ISMessages* alert = [ISMessages cardAlertWithTitle:AppName
                                               message:alertStr
                                             iconImage:[UIImage imageNamed:@"applogo.png"]
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeCustom
                                         alertPosition:0];
    
    alert.titleLabelFont = SmallButtonFont;
    alert.titleLabelTextColor = whitecolor;
    
    alert.messageLabelFont = SmallButtonFont;
    alert.messageLabelTextColor = whitecolor;
    
    alert.alertViewBackgroundColor =LightBlackBGcolor;
    
    [alert show:^{
//        if([[[userInfo objectForKey:@"aps"] objectForKey:@"type"]isEqualToString:@"notification"])
//        {
//            UINavigationController * vc = [tabViewControllerObj.tabBarController.viewControllers objectAtIndex:tabID];
//            NotificationPage * NotificationPageObj = [[NotificationPage alloc]initWithNibName:@"NotificationPage" bundle:nil];
//            [vc pushViewController:NotificationPageObj animated:YES];
//            [NotificationPageObj release];
//        }
//        else
//        {
//            [tabViewControllerObj.tabBarController selectTab:3];
//        }
    } didHide:nil];
    
    
    
    
    
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[languageDict objectForKey:@"Message from Joysale"] message:tittleattributedString.string delegate:self cancelButtonTitle:[languageDict objectForKey:@"ok"] otherButtonTitles: nil];
//    [alert show];
//    [alert release];
}
#pragma mark - Data Parsing
-(void) defaultDataParsing
{
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    [proxy productbeforeadd:apiusername :apipassword:[self gettingLanguageCode]];
    
    [self performSelectorOnMainThread:@selector(defaultCategoryParsing) withObject:nil waitUntilDone:YES];
}
-(void) defaultCategoryParsing
{
    ApiControllerServiceProxy *categoryproxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    [categoryproxy getcategory:apiusername :apipassword :[self gettingLanguageCode] ];

}

-(void) resetBadgeId
{
    ApiControllerServiceProxy *categoryproxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([devicetokenArray count]!=0)
    {
        [categoryproxy resetbadge:apiusername :apipassword :[devicetokenArray objectAtIndex:0]];

    }
    else
    {
        [categoryproxy resetbadge:apiusername :apipassword :@"aaa"];
    }
    
}


-(void) getProfileInfo
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=NULL)
    {
        ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
        [proxy profile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@""];
    }
}




#pragma mark - WSDL DelegateMethod
//proxy finished, (id)data is the object of the relevant method service
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method{
    NSLog(@"Service %@ Done! data:%@",method,data);

    if ([method isEqualToString:@"profile"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [UserDetailArray removeAllObjects];
            [UserDetailArray addObjectsFromArray:[defensiveClassObj profileParsing:[defaultDict objectForKey:@"result"]]];
            
            [[NSUserDefaults standardUserDefaults]setObject:[[UserDetailArray objectAtIndex:0]objectForKey:@"full_name"] forKey:@"full_name"];
            [[NSUserDefaults standardUserDefaults]setObject:[[UserDetailArray objectAtIndex:0]objectForKey:@"user_img"] forKey:@"photo"];

        }
    }else if ([method isEqualToString:@"admindatas"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            
            NSLog(@"result:%@",[defaultDict objectForKey:@"result"]);
            NSLog(@"promotion:%@",[[defaultDict objectForKey:@"result"] objectForKey:@"promotion"]);
            
          
            
            
            if([[[defaultDict objectForKey:@"result"] objectForKey:@"banner"] isEqualToString:@"disable"]){
                bannerEnable = NO;
            }else{
                bannerEnable = YES;
                @try {
                    [bannerDetailsArray removeAllObjects];
                    [bannerDetailsArray addObjectsFromArray:[[defaultDict objectForKey:@"result"] objectForKey:@"bannerData"]];
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            }
        }
        
    }
    else if ([method isEqualToString:@"productbeforeadd"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [addcategoryFilterDict addEntriesFromDictionary:[defaultDict objectForKey:@"result"]];
        NSMutableArray * countryListArray = [[NSMutableArray alloc]initWithCapacity:0];
        [countryListArray addObjectsFromArray:[addcategoryFilterDict objectForKey:@"country"]];
        for (int i=0;i<[[addcategoryFilterDict objectForKey:@"country"]count]; i++)
        {
            if ([[[[countryListArray objectAtIndex:i]objectForKey:@"country_name"]uppercaseString]isEqualToString:@"OTHERS"])
            {
                [countryListArray removeObjectAtIndex:i];
                [addcategoryFilterDict setObject:countryListArray forKey:@"country"];
                break;
            }
        }
    }
    else if ([method isEqualToString:@"getcategory"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [getcategoryDict removeAllObjects];
        [getcategoryDict addEntriesFromDictionary:[defaultDict objectForKey:@"result"]];
    }    else if ([method isEqualToString:@"tos"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [TOSwebview loadHTMLString:[defaultDict objectForKey:@"message"] baseURL:nil];
        [TOSwebview.scrollView setBounces:NO];
        [TOSwebview.scrollView setBouncesZoom:NO];
        
    }
}



#pragma mark - Upgrade Language

-(void) changingLanguage
{
    NSString * languageStr = @"language";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"language"]isEqualToString:@"English"])
    {
        languageStr = @"English";
    }
    else
    {
        languageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    }
    languageSelected=[[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    [languageDict removeAllObjects];
    NSError *error;
    NSData *languagedata=[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:languageStr ofType:@"json"]];
    [languageDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:languagedata options:kNilOptions error:&error]];
}

#pragma mark - Validation
/**
 It is used to validate Numeric String
 */
-(BOOL)isNumeric:(NSString*)inputString
{
    NSCharacterSet *charcter =[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[inputString componentsSeparatedByCharactersInSet:charcter] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}

/**
 It is used to validate AlphaNumeric String
 */

-(BOOL)isAlphaNumeric:(NSString*)inputString
{
    NSCharacterSet *charcter =[[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[inputString componentsSeparatedByCharactersInSet:charcter] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}
/**
 It is used to validate Alphabet String
 */

-(BOOL)isAlpha:(NSString*)inputString
{
    NSCharacterSet *charcter =[[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "] invertedSet];
    NSString *filtered;
    filtered = [[inputString componentsSeparatedByCharactersInSet:charcter] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}

/**
 This function is used to get Date from the unix time stamp
 */

-(NSString *)dateDiff:(NSString *)origDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    NSDate *convertedDate = [df dateFromString:origDate];
    [df release];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"Just now";
    } else 	if (ti < 60) {
        return @"Just now";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 604800) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    }
    else if (ti < 2629743)
    {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    }
    else if (ti < 31556916) {
        int diff = round(ti / 30 / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d month ago", diff];
    }
    else
    {
        int diff = round(ti / 12 / 30 / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d Year ago", diff];
    }
}

/**
 Its used to validate email address
 */
-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}
-(NSString*)gettingLanguageCode
{
    NSString * languageCode = @"en";
    if([languageSelected isEqualToString:@"English"]){
        languageCode = @"en";
    }else if([languageSelected isEqualToString:@"French"]){
        languageCode = @"fr";
    }else if([languageSelected isEqualToString:@"Arabic"]){
        languageCode = @"ar";
    }else{
        languageCode = @"en";
    }

    
    return languageCode;
    
}


/**
 Its used to encode and decode the string
 */

-(NSString*) decodeString:(NSString*) encodedStr
{
    return encodedStr;
}

-(NSString*)attributestringtostring:(NSString*) attributeString
{
    NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                  initWithData: [attributeString dataUsingEncoding:NSUnicodeStringEncoding]
                                                  options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                  documentAttributes: nil
                                                  error: nil
                                                  ];
    
    return tittleattributedString.string;
    
}



#pragma mark - FB and Google login

/**
 Its is used for facebook and google plus login
 */

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (BOOL)application:(__unused UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([[url.scheme lowercaseString] isEqualToString:[BraintreeDemoAppDelegatePaymentsURLScheme lowercaseString]]) {
    }
    else if (!facebookflag) {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        
    }
    else
    {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                      openURL:url
                                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        return handled;
    }

    return YES;
}
#endif


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
   if (!facebookflag) {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }
    else
    {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation];
        return handled;
    }
}


#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application   didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString   *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
        NSLog(@"Decline");
    }
    else if ([identifier isEqualToString:@"answerAction"]){
        NSLog(@"answerAction");
    }
}
#endif

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"register failed %@", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    const unsigned* tokenBytes = [deviceToken bytes];
    NSString* deviceTokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                   ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                   ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                   ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceTokenString%@", deviceTokenString);
    [devicetokenArray removeAllObjects];
    [devicetokenArray addObject:deviceTokenString];
    [[NSUserDefaults standardUserDefaults]setObject:deviceTokenString forKey:@"DToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    UIApplication *application = [UIApplication sharedApplication];

    if (application.applicationState==UIApplicationStateActive)
    {
        NSArray* foo = [[[notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"alert"] componentsSeparatedByString: @" : "];
        NSString* firstBit = [foo objectAtIndex: 0];
        NSLog(@"firstBit:%@",firstBit);
        //showNotificationFlag = Yess; //Call Function
        //else showNotificationFlag = Yes
        //        if(showNotificationFlag){
        if(![currentChater isEqualToString:firstBit]){
            [self addMessageFromRemoteNotification:notification.request.content.userInfo];
        }else{
            showNotificationFlag=NO;
        }
        //        [self addMessageFromRemoteNotification:userInfo];
        
    }
    else
    {
        if([[[notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"type"]isEqualToString:@"notification"])
        {
            UINavigationController * vc = [tabViewControllerObj.tabBarController.viewControllers objectAtIndex:tabID];
            NotificationPage * NotificationPageObj = [[NotificationPage alloc]initWithNibName:@"NotificationPage" bundle:nil];
            [vc pushViewController:NotificationPageObj animated:YES];
            [NotificationPageObj release];
        }
        else
        {
            [tabViewControllerObj.tabBarController selectTab:3];
        }
        
        
    }
//    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive)
    {
        NSArray* foo = [[[response.notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"alert"] componentsSeparatedByString: @" : "];
        NSString* firstBit = [foo objectAtIndex: 0];
        NSLog(@"firstBit:%@",firstBit);
        //showNotificationFlag = Yess; //Call Function
        //else showNotificationFlag = Yes
        //        if(showNotificationFlag){
        if(![currentChater isEqualToString:firstBit]){
            [self addMessageFromRemoteNotification:response.notification.request.content.userInfo];
        }else{
            showNotificationFlag=NO;
        }
        //        [self addMessageFromRemoteNotification:userInfo];
        
    }
    else
    {
        if([[[response.notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"type"]isEqualToString:@"notification"])
        {
            AHKNavigationController * vc = [tabViewControllerObj.tabBarController.viewControllers objectAtIndex:tabID];
            NotificationPage * NotificationPageObj = [[NotificationPage alloc]initWithNibName:@"NotificationPage" bundle:nil];
            [vc pushViewController:NotificationPageObj animated:YES];
            [NotificationPageObj release];
        }
        else
        {
            [tabViewControllerObj.tabBarController selectTab:3];
        }
        
        
    }

    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"Received notification: %@", userInfo);
    NSLog(@"Received notification: %@", [userInfo objectForKey:@"aps"]);
    NSLog(@"Received notification: %@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    NSLog(@"currentChater:%@",currentChater);
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //notificationredirectionFlag
    
    if (application.applicationState==UIApplicationStateActive)
    {
        NSArray* foo = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] componentsSeparatedByString: @" : "];
        NSString* firstBit = [foo objectAtIndex: 0];
        NSLog(@"firstBit:%@",firstBit);
        //showNotificationFlag = Yess; //Call Function
        //else showNotificationFlag = Yes
//        if(showNotificationFlag){
        if(![currentChater isEqualToString:firstBit]){
        [self addMessageFromRemoteNotification:userInfo];
        }else{
            showNotificationFlag=NO;
        }
//        [self addMessageFromRemoteNotification:userInfo];

    }
    else
    {
        if([[[userInfo objectForKey:@"aps"] objectForKey:@"type"]isEqualToString:@"notification"])
        {
        AHKNavigationController * vc = [tabViewControllerObj.tabBarController.viewControllers objectAtIndex:tabID];
        NotificationPage * NotificationPageObj = [[NotificationPage alloc]initWithNibName:@"NotificationPage" bundle:nil];
        [vc pushViewController:NotificationPageObj animated:YES];
        [NotificationPageObj release];
        }
        else
        {
            [tabViewControllerObj.tabBarController selectTab:3];
        }


    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;

    [self performSelectorOnMainThread:@selector(resetBadgeId) withObject:nil waitUntilDone:YES];

    [FBSDKAppEvents activateApp];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
