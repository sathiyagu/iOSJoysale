//
//  ItemDetailPage.m
//  HSJoysale
//
//  Created by BTMANI on 02/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//


#import "ItemDetailPage.h"
#import <CoreLocation/CoreLocation.h>
#import "OmniGrid.h"
#import "NSString+FontAwesome.h"
#import "welcomeScreen.h"
#import "CommentPage.h"
#import "AddProductDetails.h"
#import "NewProfilePage.h"
#import "TabViewController.h"
#import "NSDate+DateMath.h"
#import "TPFloatRatingView.h"
#import "NSString+HTML.h"
@interface ItemDetailPage ()
{
    UIToolbar *numberToolbar;
}
#define opwhitecolor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9]
@end

@implementation ItemDetailPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    return 0;
}

#pragma mark - View did Load

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad detail");
    [UIMenuController sharedMenuController].menuVisible = NO;  //do not display the menu

    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = clearcolor;
                }
        //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //Initialize object
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_approve"]intValue]==1) {
        itemEnableFlag = YES;
    }
    //Appearance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.navigationController setNavigationBarHidden:YES];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //Initialization
    moreItemsArray = [[NSMutableArray alloc]initWithCapacity:0];
    locationnameArray = [[NSMutableArray alloc]init];
    dateFormatter=[[NSDateFormatter alloc]init];
   // makeAnOfferTxtView = [[UITextView alloc] init];
    dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setLocale:[NSLocale currentLocale]];
    [dateFormatter1 setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];

    //Properties
    [mainPageScrollView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight-heightChange)];
    [mainPageScrollView setDelegate:self];
    [mainPageScrollView setBackgroundColor:BackGroundColor];
    
    makeAnOfferBG.hidden = YES;
    typeYourOfferTxtView.delegate = self;
    makeAnOfferTxtView.delegate = self;

    //Makeoffer price button
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=AppThemeColor;
    [numberToolbar sizeToFit];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:[delegate.languageDict objectForKey:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneWithNumberPad)];
    UIBarButtonItem *flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
    
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:appFontBold size:15.0], NSFontAttributeName,
                                         whitecolor, NSForegroundColorAttributeName,
                                         nil] forState:UIControlStateNormal];
    numberToolbar.items = [NSArray arrayWithObjects:flex, rightButton, nil];
    typeYourOfferTxtView.tag = 10;
    typeYourOfferTxtView.inputAccessoryView = numberToolbar;
    numberToolbar.hidden = YES;
//    [makeoffersendBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [makeoffersendBtn setBackgroundColor:AppThemeColor];
    [makeoffersendBtn setImage:[UIImage imageNamed:@"send_icon_24.png"] forState:UIControlStateNormal];
    [makeoffersendBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [makeoffersendBtn setFrame:CGRectMake(delegate.windowWidth-55, makeoffersendBtn.frame.origin.y, 45, 40)];
    [makeoffersendBtn.layer setCornerRadius:5];
    [makeoffersendBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];

    [makeoffersendBtn.layer setMasksToBounds:YES];
     //Functionalities
    NSLog(@"detailPageArray:%@",[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]);

    itemimageHeight = (delegate.windowHeight)/1.75;
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"MMM dd, YYYY"];
    
    //Here we are creating the chat for this app
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                chatURL, NSHTTPCookieDomain,
                                @"/", NSHTTPCookiePath,
                                @"auth", NSHTTPCookieName,
                                @"56cdea636acdf132", NSHTTPCookieValue,
                                nil];
//    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
//    NSArray *cookies = [NSArray arrayWithObjects:cookie, nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"demo" forKey:@"joinid"];

    // connect to the socket.io server that is running locally at port 3000
//    socketIO.cookies = cookies;
    socketIO.useSecure = NO;
    [socketIO connectToHost:chatURL onPort:8080];
    [socketIO sendEvent:@"join" withData:dict];

    //Function Call
    
    [self barFunction];
    [self loadingIndicator];
    [self loadingbuynowIndicator];
    [self settingSubViewsToMainView];
    
    
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]isEqualToString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]]&&[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_approve"]intValue]==0)
    {
        [self performSelectorOnMainThread:@selector(increaseViewCount) withObject:nil waitUntilDone:YES];

        [self performSelectorOnMainThread:@selector(showPendingapprovalAlert) withObject:nil waitUntilDone:YES];
    }
    else
    {
        
        [self performSelectorOnMainThread:@selector(checkitemstatusapi) withObject:nil waitUntilDone:YES];

        
    }


    
    [makeANOfferUserNameLabel setFont:[UIFont fontWithName:appFontRegular size:14]];
    [lblPlaceholder  setFont:[UIFont fontWithName:appFontRegular size:14]];
    [typeYourOfferTxtView  setFont:[UIFont fontWithName:appFontRegular size:14]];
    
    [super viewDidLoad];
}
#pragma mark Textviewdelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{

    //[textView setSelectedRange:NSMakeRange(NSNotFound, 0)];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;  //do not display the menu
    [self resignFirstResponder];                      //do not allow the user to selected anything
    return NO;

}
- (BOOL)canBecomeFirstResponder {
    return NO;
}
-(void) showPendingapprovalAlert
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                                        message:[delegate.languageDict objectForKey:@"Product is waiting for admin Approval"]preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: [delegate.languageDict objectForKey:@"ok"]
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                                        }];
    [controller addAction: alertAction];
    [self presentViewController: controller animated: YES completion: nil];

}
-(void)checkitemstatusapi
{
    [proxy checkItemstatus:apiusername :apipassword :[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"id"]];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark View will appear

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void)viewDidAppear:(BOOL)animated{
   
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = clearcolor;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear detail");

    [self setNeedsStatusBarAppearanceUpdate];
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    //Appearance
    [self viewAppearance];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = clearcolor;
                }
        //    [[UIApplication sharedApplication] setStatusBarHidden:YES]
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    //Functionality
    buyNowFlag=YES; //enable action

    //If changes happen in other class it will replace array
    if (reloadFlag)
    {
        reloadFlag = NO;
        [detailItemsArray removeAllObjects];
        [detailItemsArray addObjectsFromArray:delegate.detailPageArray];
    }
    
    delegate.detailArraySelectedIndex = detailSelectedIndex;
    [delegate.detailPageArray removeAllObjects];
    [delegate.detailPageArray addObjectsFromArray:detailItemsArray];
    UILabel *cmtLbl = (UILabel *)[itemDescribtionView viewWithTag:1024];
    cmtLbl.text = [NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"comments_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"comments"]];
    
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [makeAnOfferTxtView setTextAlignment:NSTextAlignmentRight];
        [lblPlaceholder setTextAlignment:NSTextAlignmentRight];
        [typeYourOfferTxtView setTextAlignment:NSTextAlignmentRight];
        
    }
    [typeYourOfferTxtView setFrame:CGRectMake(10, typeYourOfferTxtView.frame.origin.y, delegate.windowWidth-20, typeYourOfferTxtView.frame.size.height)];
    [makeAnOfferTxtView setFrame:CGRectMake(5, makeAnOfferTxtView.frame.origin.y, delegate.windowWidth-20, makeAnOfferTxtView.frame.size.height)];
    [lblPlaceholder setFrame:CGRectMake(10, makeAnOfferTxtView.frame.origin.y+8, delegate.windowWidth-20,20)];

    //[lblPlaceholder setText:[delegate.languageDict objectForKey:@"type_your_message"]];
     [typeYourOfferTxtView setPlaceholder:[delegate.languageDict objectForKey:@"type_your_offer"]];
      
    //Function call
    [self settingSubViewsToMainView];
    [super viewWillAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{

//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
}


#pragma mark appearance

- (void) viewAppearance
{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    [delegate tabbarFrameHide];
    [self.view setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight+100)];
}

#pragma mark - NavigationView

-(void) barFunction{

    itemDetailsView = [[UIView alloc]init];
    [itemDetailsView setFrame:CGRectMake(0,0,delegate.windowWidth,100)];
    
    UIImageView * transparent_img = [[[UIImageView alloc] init] autorelease];
    [transparent_img setImage:[UIImage imageNamed:@"ItemNavigationTransparent.png"]];
    [transparent_img setFrame:CGRectMake(0,0,delegate.windowWidth,100)];
    [self.view addSubview:transparent_img];
    [self.view addSubview:itemDetailsView];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:clearcolor];
    [backBtn setTag:1000];
    [backBtn setFrame:CGRectMake(0,20,45,40)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [backBtn setImage:[UIImage imageNamed:@"detail_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"detail_back.png"] forState:UIControlStateHighlighted];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [itemDetailsView addSubview:backBtn];
    
    UILabel * itemNameLabel = [[[UILabel alloc]init]autorelease];
    [itemNameLabel setNumberOfLines:1];
    [itemNameLabel setBackgroundColor:[UIColor clearColor]];
    [itemNameLabel setTextColor:[UIColor whiteColor]];
    [itemNameLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [itemNameLabel setText:[delegate attributestringtostring:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_title"]]];
    [itemNameLabel setFrame:CGRectMake(55,20,delegate.windowWidth-195,44)];
    [itemNameLabel setBackgroundColor:[UIColor clearColor]];
    [itemDetailsView addSubview:itemNameLabel];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]isEqualToString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]])
    {
        UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setFrame:CGRectMake(delegate.windowWidth-135,25,40,34)];
        [editBtn setImage:[UIImage imageNamed:@"editBtn.png"] forState:UIControlStateNormal];
        [editBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [editBtn addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemDetailsView addSubview:editBtn];
    }
    else
    {
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setFrame:CGRectMake(delegate.windowWidth-135,25,40,34)];
        if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"liked"] isEqualToString:@"yes"]){
            [likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        }else{
            [likeButton setImage:[UIImage imageNamed:@"unlike.png"] forState:UIControlStateNormal];
            
        }
        [likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateHighlighted];
        [likeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemDetailsView addSubview:likeButton];
    }
    
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(delegate.windowWidth-90,25,40,34)];
    [shareButton addTarget:self action:@selector(shareBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [itemDetailsView addSubview:shareButton];
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(delegate.windowWidth-45,25,40,34)];
    [moreBtn addTarget:self action:@selector(MoreBtnPopup) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"option.png"] forState:UIControlStateNormal];
    [moreBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [itemDetailsView addSubview:moreBtn];
}
#pragma mark  Navigation view ButtonAction
-(void) backBtnTapped
{
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    if([delegate.fromAddproduct isEqualToString:@"YES"]){
        delegate.fromAddproduct = @"NO";
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)shareBtnTapped
{
    
    NSArray * activityItems = @[[NSString stringWithFormat:@"%@",[delegate attributestringtostring:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_title"]]],[NSURL URLWithString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"product_url"]]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
    
    UIActivityViewController * activityController = [[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities] autorelease];
    activityController.excludedActivityTypes = excludeActivities;
    [self.view.window.rootViewController presentViewController:activityController animated:YES completion:nil];
}

#pragma mark  More button actions

-(void) MoreBtnPopup{
    MoreViewPopup = [[[UIView alloc] init] autorelease];
    [MoreViewPopup setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [MoreViewPopup setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7f]];
//    [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2f]
    
    self.popup = [KOPopupView popupView];
    [self.popup.handleView addSubview:MoreViewPopup];
    MoreViewPopup.center = CGPointMake(self.popup.handleView.frame.size.width/2.0,
                                       self.popup.handleView.frame.size.height/2.0);
    
    UIButton * closepopupBtn = [[[UIButton alloc] init] autorelease];
    [closepopupBtn setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [closepopupBtn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [MoreViewPopup addSubview:closepopupBtn];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]isEqualToString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]])
    {
        UIButton * soldBtn = [[[UIButton alloc] init] autorelease];
        [soldBtn setFrame:CGRectMake(10, delegate.windowHeight-215, delegate.windowWidth-20, 60)];
        [soldBtn setTitleColor:headercolor forState:UIControlStateNormal];
        [soldBtn setBackgroundColor:opwhitecolor];
        if([[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
            [soldBtn setTitle:[delegate.languageDict objectForKey:@"mark_as_sold"] forState:UIControlStateNormal];
            [soldBtn addTarget:self action:@selector(markAsSold) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [soldBtn setTitle:[delegate.languageDict objectForKey:@"back_to_sale"] forState:UIControlStateNormal];
            [soldBtn addTarget:self action:@selector(backToSale) forControlEvents:UIControlEventTouchUpInside];
        }
        [soldBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
        [soldBtn.layer setCornerRadius:2];
        [soldBtn.layer setMasksToBounds:YES];
        [MoreViewPopup addSubview:soldBtn];
        
        UIButton * DeleteBtn = [[[UIButton alloc] init] autorelease];
        [DeleteBtn setFrame:CGRectMake(10, delegate.windowHeight-150, delegate.windowWidth-20, 60)];
        [DeleteBtn addTarget:self action:@selector(deleteProduct) forControlEvents:UIControlEventTouchUpInside];
        [DeleteBtn setTitleColor:headercolor forState:UIControlStateNormal];
        [DeleteBtn setBackgroundColor:opwhitecolor];
        [DeleteBtn setTitle:[delegate.languageDict objectForKey:@"delete_product"] forState:UIControlStateNormal];
        [DeleteBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
        [DeleteBtn.layer setCornerRadius:2];
        [DeleteBtn.layer setMasksToBounds:YES];
        [MoreViewPopup addSubview:DeleteBtn];
    }
    else{
        
        
        reportBtn = [[[UIButton alloc] init] autorelease];
        [reportBtn setFrame:CGRectMake(10, delegate.windowHeight-150, delegate.windowWidth-20, 60)];
        [reportBtn addTarget:self action:@selector(reportThisItem) forControlEvents:UIControlEventTouchUpInside];
        [reportBtn setTitleColor:headercolor forState:UIControlStateNormal];
        [reportBtn setBackgroundColor:opwhitecolor];
        [reportBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
        [reportBtn.layer setCornerRadius:2];
        [reportBtn.layer setMasksToBounds:YES];
        
        if ([[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"report"]uppercaseString]isEqualToString:@"YES"])
        {
            [reportBtn setTitle:[delegate.languageDict objectForKey:@"undo_report"] forState:UIControlStateNormal];
        }
        else
        {
            [reportBtn setTitle:[delegate.languageDict objectForKey:@"report_product"] forState:UIControlStateNormal];
        }
        [MoreViewPopup addSubview:reportBtn];
    }
    UIButton * cancelBtn = [[[UIButton alloc] init] autorelease];
    [cancelBtn setFrame:CGRectMake(10, delegate.windowHeight-80, delegate.windowWidth-20, 60)];
    [cancelBtn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:AppThemeColor];
    [cancelBtn setTitle:[delegate.languageDict objectForKey:@"cancel"] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [cancelBtn.layer setCornerRadius:2];
    [cancelBtn.layer setMasksToBounds:YES];
    [MoreViewPopup addSubview:cancelBtn];
    [self.popup show];
}

-(void)closePopup
{
    [self.popup hideAnimated:TRUE];
}

-(void) ShowMorePopup{
    [self.popup show];
}
#pragma mark Attribute string size calculation

- (CGFloat)heightForAttributedString:(NSAttributedString *)text maxWidth:(CGFloat)maxWidth {
    if ([text isKindOfClass:[NSString class]] && !text.length) {
        // no text means no height
        return 0;
    }
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options context:nil].size;
    
    CGFloat height = size.height + 1; // add 1 point as padding
    
    NSLog(@"%f",height);
    if(height<30)
    {
        height = 30;
    }
    return height;
}

#pragma mark - Item Detail Page Design

-(void) settingSubViewsToMainView
{
    [mainPageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //Image Displaying Part
    {
        itemImageScrollView = [[UIScrollView alloc]init];
        [itemImageScrollView setBackgroundColor:[UIColor clearColor]];
        [itemImageScrollView setPagingEnabled:YES];
        [itemImageScrollView setDelegate:self];
        [itemImageScrollView setTag:1212];
        [mainPageScrollView addSubview:itemImageScrollView];
        
        float maxHeight = 0;
        for (int i=0; i<[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]count];i++)
        {
            UIImageView * itemImageView = [[[UIImageView alloc]init]autorelease];
            [itemImageView setBackgroundColor:whitecolor];
            [itemImageView setContentMode:UIViewContentModeScaleAspectFill];
            itemImageView.layer.masksToBounds=YES;
            [itemImageView setFrame:CGRectMake((i*delegate.windowWidth),0,delegate.windowWidth,itemimageHeight)];
            [itemImageView setBackgroundColor:[UIColor clearColor]];
            [itemImageView setTag:1000+i];
            [itemImageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *imagegesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagegesterAction:)];
            [itemImageView addGestureRecognizer:imagegesture];
            
            if (i==0)
            {
                [itemImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]objectAtIndex:i] objectForKey:@"item_url_main_350"]]]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {
                     pagenumber = i;
                 }];
            }
            else
            {
                [itemImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]objectAtIndex:i] objectForKey:@"item_url_main_350"]]]];
            }
            itemImageView.frame = CGRectMake(delegate.windowWidth*i,0,delegate.windowWidth,itemimageHeight);
            maxHeight = itemimageHeight;
            [itemImageScrollView addSubview:itemImageView];
        }
        [itemImageScrollView setFrame:CGRectMake(0,-20,delegate.windowWidth,itemimageHeight)];
        [itemImageScrollView setContentSize:CGSizeMake([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]count]*delegate.windowWidth,0)];
        
        
        imagePageControl = [[SMPageControl alloc]init];
        [imagePageControl setBackgroundColor:clearcolor];
        [imagePageControl setFrame:CGRectMake(0,maxHeight-50,delegate.windowWidth,20)];
        imagePageControl.numberOfPages = [[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]count];
        [imagePageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"currentPageDot"]];
        [imagePageControl setPageIndicatorImage:[UIImage imageNamed:@"pageDot"]];
        if ([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]count]!=1)
        {
            [mainPageScrollView addSubview:imagePageControl];
        }
        
        
        UIImageView * transparent_img = [[[UIImageView alloc] init] autorelease];
        [transparent_img setImage:[UIImage imageNamed:@"transbg.png"]];
        [transparent_img setFrame:CGRectMake(0,maxHeight-60,delegate.windowWidth,60)];
        [mainPageScrollView addSubview:transparent_img];
        
        timeDisplayView = [[UIView alloc]init];
        [timeDisplayView setFrame:CGRectMake(0,maxHeight-80,delegate.windowWidth,60)];
        [mainPageScrollView addSubview:timeDisplayView];
        
        double unixTimeStamp =[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"posted_time"] doubleValue];
        NSTimeInterval timeInterval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSString *dateString=[dateFormatter1 stringFromDate:date];
        
        UILabel * itemTimeDetailsLabel = [[[UILabel alloc]init]autorelease];
       // [itemTimeDetailsLabel setText:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"posted_time"]];
        [itemTimeDetailsLabel setText:[NSDate dateDiff:dateString]];
        [itemTimeDetailsLabel setTextColor:[UIColor whiteColor]];
        [itemTimeDetailsLabel setTextAlignment:NSTextAlignmentRight];
        [itemTimeDetailsLabel setFont:[UIFont fontWithName:appFontRegular size:15]];
        [itemTimeDetailsLabel setFrame:CGRectMake(20,30,delegate.windowWidth-40,20)];
        [timeDisplayView addSubview:itemTimeDetailsLabel];
    }
    //Item name and Price Displaying View
    {
        ItemTitleView = [[[UIView alloc]init]autorelease];
        [ItemTitleView setBackgroundColor:[UIColor whiteColor]];
        ItemTitleView.layer.masksToBounds=YES;
        [mainPageScrollView addSubview:ItemTitleView];
        
        NSString * ItemTitleStr = [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_title"];
        
        
        
        
        
        NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                initWithData: [ItemTitleStr dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];

        
        UILabel * ItemTitleLabel = [[[UILabel alloc]init]autorelease];
        [ItemTitleLabel setNumberOfLines:0];
        [ItemTitleLabel setBackgroundColor:clearcolor];
        [ItemTitleLabel setAttributedText:tittleattributedString];
        [ItemTitleLabel setTextColor:headercolor];
        [ItemTitleLabel setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
        [ItemTitleLabel setBackgroundColor:[UIColor clearColor]];
        CGSize itemnameSuggestionSize = [delegate.sizeMakeClass lableSuggetionSize:ItemTitleStr font:[UIFont fontWithName:appFontRegular size:delegate.headingSize] lableWidth:delegate.windowWidth-80 lableHeight:FLT_MAX];
        [ItemTitleLabel setFrame:CGRectMake(10,10,delegate.windowWidth-80,itemnameSuggestionSize.height)];
        [ItemTitleView addSubview:ItemTitleLabel];
        
        UILabel * productType = [[[UILabel alloc] init] autorelease];
        [productType setFont:[UIFont fontWithName:appFontRegular size:12]];
        [productType setTextColor:whitecolor];
        [productType setTextAlignment:NSTextAlignmentCenter];
        productType.layer.cornerRadius=2;
        productType.layer.masksToBounds=YES;
        productType.numberOfLines=2;
        
        if([[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
            if(![[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                [productType setText:[NSString stringWithFormat:@"\n%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"promotion_type"]]];
                if([[NSString stringWithFormat:@"\n%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                    [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];

                    [productType setBackgroundColor:redcolor];
                }else if([[NSString stringWithFormat:@"\n%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
                    [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"ad"]]];

                    [productType setBackgroundColor:AdColor];
                }
            }else{
                [productType setText:@""];
                [productType setBackgroundColor:clearcolor];
            }
        }else{
            [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"sold"]]];
            [productType setBackgroundColor:soldOutColor];
        }
        [productType setFrame:CGRectMake(delegate.windowWidth-productType.intrinsicContentSize.width-15, -4, productType.intrinsicContentSize.width+10, 30+4)];
        [ItemTitleView addSubview:productType];
        NSArray * currency =[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"currency_code"] componentsSeparatedByString:@"-"];
        NSString * currencyformat = [NSString stringWithFormat:@"%@ ",[currency objectAtIndex:0]];

        UILabel * itemPriceLabel = [[[UILabel alloc]init]autorelease];
        [itemPriceLabel setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
        [itemPriceLabel setText:[NSString stringWithFormat:@"%@%@",currencyformat,[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"price"]]];
        [itemPriceLabel setTextColor:headercolor];
        [itemPriceLabel setBackgroundColor:[UIColor clearColor]];
        [itemPriceLabel setFrame:CGRectMake(10,ItemTitleLabel.frame.size.height+ItemTitleLabel.frame.origin.y+5,delegate.windowWidth-20,25)];
        [ItemTitleView addSubview:itemPriceLabel];
        
        UILabel * productconditionlbl = [[[UILabel alloc] init] autorelease];
        [productconditionlbl setFont:[UIFont fontWithName:appFontRegular size:12]];
        [productconditionlbl setTextColor:whitecolor];
        [productconditionlbl setBackgroundColor:headercolor];
        [productconditionlbl setTextAlignment:NSTextAlignmentCenter];
        productconditionlbl.layer.cornerRadius=3;
        productconditionlbl.layer.masksToBounds=YES;
        productconditionlbl.numberOfLines=2;
        [productconditionlbl setText:[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_condition"]]];
        
        if ([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_condition"]length]!=0 && ![[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_condition"] isEqualToString:@"0"])
        {
            [productconditionlbl setFrame:CGRectMake(10, itemPriceLabel.frame.size.height+itemPriceLabel.frame.origin.y+10, productconditionlbl.intrinsicContentSize.width+15, 25)];
        }
        else
        {
            [productconditionlbl setFrame:CGRectMake(10, itemPriceLabel.frame.size.height+itemPriceLabel.frame.origin.y,0,0)];
        }
        [ItemTitleView addSubview:productconditionlbl];
        
        
        UIView * firstlineView = [[[UIView alloc]init]autorelease];
        [firstlineView setFrame:CGRectMake(10,productconditionlbl.frame.size.height+productconditionlbl.frame.origin.y+10,delegate.windowWidth-20,1)];
        [firstlineView setBackgroundColor:whitecolor];
        [ItemTitleView addSubview:firstlineView];
        [ItemTitleView setBackgroundColor:whitecolor];
        [ItemTitleView setFrame:CGRectMake(0,itemImageScrollView.frame.size.height+itemImageScrollView.frame.origin.y,delegate.windowWidth,firstlineView.frame.size.height+firstlineView.frame.origin.y)];
        
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [ItemTitleLabel setFrame:CGRectMake(70,10,delegate.windowWidth-80,itemnameSuggestionSize.height)];
            [ItemTitleLabel setTextAlignment:NSTextAlignmentRight];
            [itemPriceLabel setTextAlignment:NSTextAlignmentRight];
            [productType setFrame:CGRectMake(5, -4, productType.intrinsicContentSize.width+10, 30+4)];
            if ([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_condition"]length]!=0 && ![[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_condition"] isEqualToString:@"0"])
            {
                [productconditionlbl setFrame:CGRectMake(delegate.windowWidth-productconditionlbl.intrinsicContentSize.width-25, itemPriceLabel.frame.size.height+itemPriceLabel.frame.origin.y+10, productconditionlbl.intrinsicContentSize.width+15, 25)];
            }
        }
    }
    
    {
        //Item Description With Button Views
        
        itemDescribtionView = [[[UIView alloc]init] autorelease];
        [itemDescribtionView setBackgroundColor:[UIColor whiteColor]];
        [mainPageScrollView addSubview:itemDescribtionView];
        
        NSString * itemDescribtionStr = [NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_description"]];
        
        
        
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [itemDescribtionStr dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_description"]]);
        
        
//        NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//        NSData *htmlData = [attributedString dataFromRange:NSMakeRange(0, attributedString.length) documentAttributes:documentAttributes error:NULL];
//        NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"%@",htmlString);
        

//        
//        NSDictionary * const exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//        NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:attributedString.string];
//        NSData *htmlDatas = [attributed dataFromRange:NSMakeRange(0, attributed.length) documentAttributes:exportParams error:nil];
//        
//        NSLog(@"%@",[[NSString alloc] initWithData:htmlDatas encoding:NSUTF8StringEncoding]);
//        
////        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUnicodeStringEncoding];
        
        
        
        NSString * page_content = [NSString stringWithFormat:@"%@",attributedString.string];
//        page_content = [self convertHTML:page_content];
        

        
        UITextView * itemDescriptionTextView = [[[UITextView alloc]init]autorelease];
        [itemDescriptionTextView setDataDetectorTypes:UIDataDetectorTypeLink];
        [itemDescriptionTextView setDelegate:self];
        [itemDescriptionTextView setUserInteractionEnabled:YES];
        [itemDescriptionTextView setScrollEnabled:NO];
        [itemDescriptionTextView setEditable:NO];

//        [itemDescriptionTextView setFrame:CGRectMake(10,0,delegate.windowWidth-20,[self heightForAttributedString:attributedString maxWidth:delegate.windowWidth-20])];
        [itemDescriptionTextView setAttributedText:attributedString];
        [itemDescriptionTextView setTextColor:AppTextColor];

       /* [itemDescriptionTextView setFont:[UIFont fontWithName:appFontRegular size:delegate.smallText]];
        CGRect sizeContent =[page_content boundingRectWithSize: CGSizeMake( delegate.windowWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:appFontRegular size:delegate.smallText]} context:nil];

        [itemDescriptionTextView setFrame:CGRectMake(10,0,delegate.windowWidth-20,sizeContent.size.height)];
        
        itemDescriptionTextView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        [itemDescribtionView addSubview:itemDescriptionTextView];*/

//        NSLog(@"%f",itemDescriptionTextView.contentSize.height);
        
        [itemDescriptionTextView setFont:[UIFont fontWithName:appFontRegular size:17]];
        [itemDescriptionTextView setFrame:CGRectMake(10,0,delegate.windowWidth-20,[self heightForAttributedString:attributedString maxWidth:delegate.windowWidth-20])];
        itemDescriptionTextView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        [itemDescribtionView addSubview:itemDescriptionTextView];

        
        UIView * firstlineView = [[[UIView alloc]init]autorelease];
        [firstlineView setFrame:CGRectMake(10,itemDescriptionTextView.frame.origin.y+itemDescriptionTextView.frame.size.height,delegate.windowWidth-20,0.7)];
        
        
        [firstlineView setBackgroundColor:lineviewColor];
        [itemDescribtionView addSubview:firstlineView];
        
        CGFloat width = delegate.windowWidth/3;
        UIImageView * viewIconImageView = [[[UIImageView alloc]init] autorelease];
        [viewIconImageView setImage:[UIImage imageNamed:@"view.png"]];
        [viewIconImageView setContentMode:UIViewContentModeScaleAspectFit];
        [viewIconImageView setFrame:CGRectMake(10,firstlineView.frame.origin.y+firstlineView.frame.size.height+15,20,20)];
        [itemDescribtionView addSubview:viewIconImageView];
        
        
        UILabel * itemViewDetailsLabel = [[[UILabel alloc]init]autorelease];
        [itemViewDetailsLabel setTextColor:filterHeadercolor];
        [itemViewDetailsLabel setFont:[UIFont fontWithName:appFontRegular size:12]];
        [itemViewDetailsLabel setTextAlignment:NSTextAlignmentLeft];          [itemViewDetailsLabel setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"views_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"views"]]];
        [itemViewDetailsLabel setFrame:CGRectMake(viewIconImageView.frame.origin.x+viewIconImageView.frame.size.width+5,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,width-35,30)];
        [itemDescribtionView addSubview:itemViewDetailsLabel];
        
        UIView *likelineview = [[[UIView alloc] init] autorelease];
        [likelineview setFrame:CGRectMake(width,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,0.5,30)];
        [likelineview setBackgroundColor:lineviewColor];
        [itemDescribtionView addSubview:likelineview];
        
        UIImageView * favIconImageView = [[[UIImageView alloc]init] autorelease];
        [favIconImageView setImage:[UIImage imageNamed:@"like-count.png"]];
        [favIconImageView setContentMode:UIViewContentModeScaleAspectFit];
        [favIconImageView setFrame:CGRectMake(likelineview.frame.origin.x+likelineview.frame.size.width+10,firstlineView.frame.origin.y+firstlineView.frame.size.height+15,20,20)];
        [itemDescribtionView addSubview:favIconImageView];
        
        likeCountLbl = [[[UILabel alloc]init]autorelease];
        [likeCountLbl setTextColor:filterHeadercolor];
        [likeCountLbl setFont:[UIFont fontWithName:appFontRegular size:12]];
        [likeCountLbl setTextAlignment:NSTextAlignmentLeft];
        [itemDescribtionView addSubview:likeCountLbl];
        
        if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue]==0){
            [likeCountLbl setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"likes"]]];
        }else{
            [likeCountLbl setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"likes"]]];
        }
        [likeCountLbl setFrame:CGRectMake(favIconImageView.frame.origin.x+favIconImageView.frame.size.width+5,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,width-40,30)];
        
        UIView *commentlineview = [[[UIView alloc] init] autorelease];
        [commentlineview setFrame:CGRectMake((width*2)-10,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,0.5,30)];
        [commentlineview setBackgroundColor:lineviewColor];
        [itemDescribtionView addSubview:commentlineview];
        
        
        UIImageView * commentIconImageView = [[[UIImageView alloc]init] autorelease];
        [commentIconImageView setImage:[UIImage imageNamed:@"comment.png"]];
        [commentIconImageView setContentMode:UIViewContentModeScaleAspectFit];
        [commentIconImageView setFrame:CGRectMake(commentlineview.frame.origin.x+commentlineview.frame.size.width+10,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,30,30)];
        [itemDescribtionView addSubview:commentIconImageView];
        
        
        UILabel *  commentCountLbl= [[[UILabel alloc]init]autorelease];
        [commentCountLbl setTextColor:filterHeadercolor];
        delegate.commentCount =[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"comments_count"]intValue];
        [commentCountLbl setTag:1024];
        [commentCountLbl setFont:[UIFont fontWithName:appFontRegular size:12]];
        [commentCountLbl setTextAlignment:NSTextAlignmentLeft];
        if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"comments_count"] intValue]>1){
            [commentCountLbl setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"comments_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"comments"]]];
        }else{
            [commentCountLbl setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"comments_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"comments"]]];
        }
        [commentCountLbl setFrame:CGRectMake(commentIconImageView.frame.origin.x+commentIconImageView.frame.size.width,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,width-30,30)];
        [itemDescribtionView addSubview:commentCountLbl];
        
        
        UIButton *commentButton = [[[UIButton alloc] init] autorelease];
        [commentButton addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [commentButton setFrame:CGRectMake(commentIconImageView.frame.origin.x+commentIconImageView.frame.size.width,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,width-30,30)];
        [itemDescribtionView addSubview:commentButton];
        
        [itemDescribtionView setFrame:CGRectMake(0,ItemTitleView.frame.size.height+ItemTitleView.frame.origin.y,delegate.windowWidth,commentCountLbl.frame.origin.y+commentCountLbl.frame.size.height+10)];
        if([delegate.languageSelected isEqualToString:@"Arabic"])
        {
            [itemDescriptionTextView setTextAlignment:NSTextAlignmentRight];
            [itemDescriptionTextView setTextAlignment:NSTextAlignmentRight];
            [commentCountLbl setTextAlignment:NSTextAlignmentRight];
            [likeCountLbl setTextAlignment:NSTextAlignmentRight];
            [itemViewDetailsLabel setTextAlignment:NSTextAlignmentRight];
            [viewIconImageView setFrame:CGRectMake(delegate.windowWidth-40,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,25,25)];
            [itemViewDetailsLabel setFrame:CGRectMake(viewIconImageView.frame.origin.x-10-itemViewDetailsLabel.intrinsicContentSize.width,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,itemViewDetailsLabel.intrinsicContentSize.width,30)];
            [likelineview setFrame:CGRectMake(width*2,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,0.5,30)];
            [favIconImageView setFrame:CGRectMake(likelineview.frame.origin.x+likelineview.frame.size.width-40,firstlineView.frame.origin.y+firstlineView.frame.size.height+13,20,20)];
            [likeCountLbl setFrame:CGRectMake(favIconImageView.frame.origin.x-35-favIconImageView.intrinsicContentSize.width,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,likeCountLbl.intrinsicContentSize.width,25)];
            [commentlineview setFrame:CGRectMake((width),firstlineView.frame.origin.y+firstlineView.frame.size.height+10,0.5,30)];
            [commentIconImageView setFrame:CGRectMake(commentlineview.frame.origin.x+commentlineview.frame.size.width-40,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,30,30)];
            [commentCountLbl setFrame:CGRectMake(commentIconImageView.frame.origin.x-commentIconImageView.intrinsicContentSize.width-10,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,commentCountLbl.intrinsicContentSize.width,30)];
            [commentButton setFrame:CGRectMake(commentIconImageView.frame.origin.x-55,firstlineView.frame.origin.y+firstlineView.frame.size.height+10,width-30,30)];
        }
    }
    
    //LocationView
    
    {
        locationandUserView = [[[UIView alloc]init] autorelease];
        [locationandUserView setBackgroundColor:[UIColor whiteColor]];
        [mainPageScrollView addSubview:locationandUserView];
        
        
        CLGeocoder *ceo = [[[CLGeocoder alloc]init] autorelease];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"latitude"]doubleValue] longitude:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"longitude"]doubleValue]];
        [ceo reverseGeocodeLocation: loc completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             //String to hold address
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             [locationnameArray removeAllObjects];
             [locationnameArray addObject:[NSString stringWithFormat:@"%@",locatedAt]];
         }];
        
        
        UIImageView * locIconImageView = [[[UIImageView alloc]init] autorelease];
        [locIconImageView setImage:[UIImage imageNamed:@"location.png"]];
        [locIconImageView setContentMode:UIViewContentModeScaleAspectFit];
        [locIconImageView setFrame:CGRectMake(10,10,20,20)];
        [locationandUserView addSubview:locIconImageView];
        
        UILabel * itemLocationLabel = [[[UILabel alloc]init]autorelease];
        [itemLocationLabel setBackgroundColor:[UIColor whiteColor]];
        [itemLocationLabel setTextColor:headercolor];
        [itemLocationLabel setFont:[UIFont fontWithName:appFontRegular size:13]];
        [itemLocationLabel setText:[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"location"]]];
        [itemLocationLabel setTextAlignment:NSTextAlignmentLeft];
        [itemLocationLabel setFrame:CGRectMake(40,5,delegate.windowWidth-60,35)];
        [itemLocationLabel setBackgroundColor:clearcolor];
        [locationandUserView addSubview:itemLocationLabel];
        
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [locIconImageView setFrame:CGRectMake(delegate.windowWidth-35,10,20,20)];
            [itemLocationLabel setTextAlignment:NSTextAlignmentRight];
            [itemLocationLabel setFrame:CGRectMake(10,5,delegate.windowWidth-50,35)];

        }

        
        float mapHeight = 150;
        UIImageView * locationImageView = [[[UIImageView alloc]init]autorelease];
        [locationImageView setFrame:CGRectMake(0,45,delegate.windowWidth,mapHeight)];
        [locationandUserView addSubview:locationImageView];
        [locationImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%f,%f&zoom=15&size=%.0fx%.0f&sensor=false.jpg",mapURL,[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"latitude"]doubleValue],[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"longitude"]doubleValue],delegate.windowWidth,mapHeight]]];
        [locationImageView setContentMode:UIViewContentModeScaleAspectFill];
        locationImageView.layer.masksToBounds=YES;

        
        UIImageView * sellerImageView = [[[UIImageView alloc]init]autorelease];
        [sellerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_img"]]]placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
        [sellerImageView setContentMode:UIViewContentModeScaleAspectFill];
        sellerImageView.layer.masksToBounds=YES;
        [sellerImageView setUserInteractionEnabled:YES];
        [sellerImageView setTag:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]intValue]];
//        [sellerImageView setFrame:CGRectMake((delegate.windowWidth/2)-35,160,70,70)];
        [sellerImageView setFrame:CGRectMake(10,180,70,70)];

        [sellerImageView.layer setCornerRadius:35];
        [sellerImageView.layer masksToBounds];
        [sellerImageView setBackgroundColor:[UIColor clearColor]];
        //[sellerImageView.layer setBorderWidth:1.5];
        //[sellerImageView.layer setBorderColor:AppThemeColor.CGColor];
        
        UITapGestureRecognizer *usergesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usergesterAction:)];
        [sellerImageView addGestureRecognizer:usergesture];
        [locationandUserView addSubview:sellerImageView];
        
        UIImageView * Verifiedsymbol = [[[UIImageView alloc]init]autorelease];
//        [Verifiedsymbol setFrame:CGRectMake((delegate.windowWidth/2)+15,210,20,20)];
        [Verifiedsymbol setFrame:CGRectMake(65,220,15,15)];

        [Verifiedsymbol setBackgroundColor:[UIColor whiteColor]];
        [Verifiedsymbol.layer setBorderColor:[UIColor whiteColor].CGColor];
        [Verifiedsymbol setImage:[UIImage imageNamed:@"tick-red.png"]];
        
        [Verifiedsymbol.layer masksToBounds];
        [Verifiedsymbol.layer setCornerRadius:7];

        
        if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"facebook_verification"] isEqualToString:@"true"] || [[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"email_verification"] isEqualToString:@"true"] || [[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"mobile_verification"] isEqualToString:@"true"]){
           // [locationandUserView addSubview:Verifiedsymbol];
        }
        
        UILabel * sellerNameLabel = [[[UILabel alloc]init]autorelease];
        [sellerNameLabel setText:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_name"]];
        [sellerNameLabel setTextColor:AppTextColor];
        [sellerNameLabel setFont:[UIFont fontWithName:appFontRegular size:17]];
        [sellerNameLabel setTextAlignment:NSTextAlignmentLeft];
        [locationandUserView addSubview:sellerNameLabel];
        
        UIImageView * mobileVerified = [[[UIImageView alloc]init]autorelease];
        if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"mobile_verification"] isEqualToString:@"true"]){
            [mobileVerified setImage:[UIImage imageNamed:@"mob-veri.png"]];
        }else{
            [mobileVerified setImage:[UIImage imageNamed:@"mob-unveri.png"]];
        }
        [mobileVerified.layer setMasksToBounds:YES];
        [locationandUserView addSubview:mobileVerified];
        
        UIImageView * faceBookVerified = [[[UIImageView alloc]init]autorelease];
        if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"facebook_verification"] isEqualToString:@"true"]){
            [faceBookVerified setImage:[UIImage imageNamed:@"fac-veri.png"]];
        }else{
            [faceBookVerified setImage:[UIImage imageNamed:@"fac-unveri.png"]];
        }
        [faceBookVerified.layer setMasksToBounds:YES];
        [locationandUserView addSubview:faceBookVerified];
        
        UIImageView * mailVerified = [[[UIImageView alloc]init]autorelease];
        if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"email_verification"] isEqualToString:@"true"]){
            [mailVerified setImage:[UIImage imageNamed:@"mail-veri.png"]];
        }else{
            [mailVerified setImage:[UIImage imageNamed:@"mail-unveri.png"]];
        }
        [mailVerified.layer setMasksToBounds:YES];
        
        [sellerNameLabel setFrame:CGRectMake(100,200,delegate.windowWidth-100,25)];
        
        
        

        
        UIButton * callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [callButton setBackgroundColor:AppThemeColor];
        [callButton setTitleColor:whitecolor forState:UIControlStateNormal];
        [callButton setTitle:[delegate.languageDict objectForKey:@"Call"] forState:UIControlStateNormal];
        [callButton setTitle:[delegate.languageDict objectForKey:@"Call"] forState:UIControlStateSelected];
        [callButton.titleLabel setFont:[UIFont fontWithName:appFontRegular size:14]];
        [callButton.layer setCornerRadius:3];
        [callButton.layer setMasksToBounds:YES];
        [callButton addTarget:self action:@selector(callButtonTapped) forControlEvents:UIControlEventTouchUpInside];

        if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]isEqualToString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]])
        {
            if ([[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"show_seller_mobile"]uppercaseString]isEqualToString:@"TRUE"])
            {
                [locationandUserView addSubview:callButton];
            }
        }

        [locationandUserView addSubview:mailVerified];
         if([delegate.languageSelected isEqualToString:@"Arabic"]){
             [mobileVerified setFrame:CGRectMake((delegate.windowWidth/2)+15,255,30,30)];
             [mailVerified setFrame:CGRectMake((delegate.windowWidth/2)-45,255,30,30)];
         }
        
      
        
        {
            [mobileVerified setFrame:CGRectMake(95,225,30,30)];
            [faceBookVerified setFrame:CGRectMake(130,225,30,30)];
            [mailVerified setFrame:CGRectMake(165,225,30,30)];
            [callButton setFrame:CGRectMake(delegate.windowWidth-80,222,70,30)];

            [locationandUserView setFrame:CGRectMake(0,itemDescribtionView.frame.size.height+itemDescribtionView.frame.origin.y+5,delegate.windowWidth,270)];

        }

        
    }
    
    //More Products
    {
        
        moreItemsView = [[[UIView alloc]init] autorelease];
        [moreItemsView setBackgroundColor:clearcolor];
        [moreItemsView setFrame:CGRectMake(0,locationandUserView.frame.size.height+locationandUserView.frame.origin.y+5,delegate.windowWidth,320)];
        [mainPageScrollView addSubview:moreItemsView];
        
        UILabel * moreItemFromLabel = [[[UILabel alloc]init]autorelease];
        [moreItemFromLabel setTextColor:headercolor];
        [moreItemFromLabel setText:[NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"more_items_from"],[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_name"]]];
        [moreItemFromLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
        [moreItemFromLabel setFrame:CGRectMake(10,5,delegate.windowWidth-40,25)];
        [moreItemsView addSubview:moreItemFromLabel];
        
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [moreItemFromLabel setTextAlignment:NSTextAlignmentRight];
        }
        moreItemsgridView = [[OmniGridView alloc] init];
        moreItemsgridView.gridDelegate = self;
        [moreItemsgridView setBackgroundColor:BackGroundColor];
        [moreItemsgridView setFrame:CGRectMake(5,35,delegate.windowWidth-10,250)];
        [moreItemsgridView setBackgroundColor:BackGroundColor];
        [moreItemsView addSubview:moreItemsgridView];
        
        reportItemLabel = [[UILabel alloc]init];
        [reportItemLabel setTextColor:[UIColor grayColor]];
        if ([[[[delegate.detailPageArray objectAtIndex:selectedIndexvalue]objectForKey:@"report"]uppercaseString]isEqualToString:@"YES"])
        {
            [reportItemLabel setText:[delegate.languageDict objectForKey:@"undo_report"]];
        }
        else
        {
            [reportItemLabel setText:[delegate.languageDict objectForKey:@"report_product"]];
        }
        [reportItemLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [reportItemLabel setFrame:CGRectMake(5,moreItemsView.frame.size.height+moreItemsView.frame.origin.y+40,200,25)];
        
        reportUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportUsButton setFrame:CGRectMake(5,moreItemsView.frame.size.height+moreItemsView.frame.origin.y+40,200,25)];
        [reportUsButton addTarget:self action:@selector(reportThisItem) forControlEvents:UIControlEventTouchUpInside];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]isEqualToString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]])
        {
            [reportItemLabel setHidden:YES];
            [reportUsButton setHidden:YES];
        }
        
        [mainPageScrollView setContentSize:CGSizeMake(0,moreItemsView.frame.size.height+moreItemsView.frame.origin.y+70)];
    }
    
    
    //Sticky Button View

    {
        buttonsView = [[[UIView alloc] initWithFrame:CGRectMake(0, delegate.windowHeight-60,delegate.windowWidth, 60)] autorelease];
        UILabel *viewlabel = [[UILabel alloc] init];
        [viewlabel setFrame:CGRectMake(0, 0,delegate.windowWidth, 1)];
        if (delegate.promotionModuleFlag)
        {
            [buttonsView setBackgroundColor:[UIColor whiteColor]];
            [buttonsView setBackgroundColor:whitecolor];
            [viewlabel setBackgroundColor:BackGroundColor];
            [buttonsView addSubview:viewlabel];
        }
        else
        {
            [buttonsView setBackgroundColor:[UIColor clearColor]];
        }
        buttonsView.layer.masksToBounds = NO;
        [self.view addSubview:buttonsView];
        
    }
    //Load Seller Products
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]isEqualToString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]]&&[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_approve"]intValue]==0)
    {
        if (!callSimilarDataFunction) {
            [self performSelectorOnMainThread:@selector(loadingsimalarPageData) withObject:nil waitUntilDone:YES];
        }
    }
}
#pragma mark - Convert HTML to string format

-(NSString *)convertHTML:(NSString *)html
{
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    while ([myScanner isAtEnd] == NO) {
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        [myScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSString *decodedString = [html stringByDecodingHTMLEntities];
    return [self replaceHTMLEntitiesInString:html];

}
- (NSString *) replaceHTMLEntitiesInString:(NSString *) htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NSString *decodedString = [htmlString stringByDecodingHTMLEntities];
    
    return decodedString;
}


#pragma mark - View Item image
-(void)imagegesterAction:(UITapGestureRecognizer *) sender
{
    NSMutableArray * array = [[NSMutableArray new] autorelease];
    [array addObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]];
    NSMutableArray *photosarray = [[NSMutableArray new] autorelease];
    [photosarray addObjectsFromArray:[IDMPhoto photosWithURLs:[[array objectAtIndex:0]valueForKey:@"item_url_main_original"]]];
    IDMPhotoBrowser *browser = [[[IDMPhotoBrowser alloc] initWithPhotos:photosarray] autorelease];
    browser.delegate = self;
    browser.displayCounterLabel = YES;
    browser.displayActionButton = NO;
    [browser.doneButton setTitle:[delegate.languageDict objectForKey:@"Done"] forState:UIControlStateNormal];
    [browser.doneButton setTitle:[delegate.languageDict objectForKey:@"Done"] forState:UIControlStateSelected];
    [self.view.window.rootViewController presentViewController:browser animated:YES completion:nil];
}

#pragma mark  IDMPhotoBrowser Delegate

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)pageIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    NSLog(@"Did didShowPhotoAtIndex photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)pageIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    NSLog(@"Did willDismissAtPageIndex photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)pageIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    NSLog(@"Did dismiss photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:photoIndex];
    NSLog(@"Did dismiss actionSheet with photo index: %zu, photo caption: %@", photoIndex, photo.caption);
    
    NSString *title = [NSString stringWithFormat:@"Option %zu", buttonIndex+1];
    [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil] show];
}

-(void)callButtonTapped
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]!=NULL)
    {
        if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
        {
            if (itemEnableFlag)
            {
                NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"mobile_no"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                
            }
            else
            {
                [self performSelectorOnMainThread:@selector(showPendingapprovalAlert) withObject:nil waitUntilDone:YES];
            }

            
        }
    }
    else
    {
        delegate.hideBarFromDetailpage = YES;
        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
    
    

}



#pragma mark - Make offer popup

- (IBAction)closeMakeOffPopupButton:(id)sender {
    [self.view endEditing:YES];
    makeAnOfferBG.hidden = YES;
    MoreViewPopup.hidden = YES;
    [buttonsView setHidden:NO];
}

#pragma mark  Make offer Numberkeypad
-(void)doneWithNumberPad{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification object:nil];
    
    [self.view endEditing:YES];
}

-(void)makeAnOfferPopup
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
    [self closePopup];
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        if (itemEnableFlag)
        {
            [makeANOfferUserNameLabel setFont:[UIFont fontWithName:appFontBold size:16]];
            [MoreViewPopup setHidden:YES];
            [buttonsView setHidden:YES];
            [typeYourOfferTxtView setKeyboardType:UIKeyboardTypeDecimalPad];
            
            [makeAnOfferBG setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7f]];
            [makeAnOffUserImageView.layer setCornerRadius:35];
            [makeAnOfferBG setHidden:NO];
            makeAnOfferBG.frame = CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight);
            [self.view bringSubviewToFront:makeAnOfferBG];
            
            makeAnOffUserImageView.layer.borderWidth = 2;
            makeAnOffUserImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            [makeAnOffUserImageView.layer setMasksToBounds:YES];
            [makeAnOffUserImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_img"]]]placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
            
            [makeANOfferUserNameLabel setTextColor:AppTextColor];
            [makeANOfferUserNameLabel setFont:[UIFont fontWithName:appFontRegular size:delegate.headingSize]];
            [makeANOfferUserNameLabel setTextAlignment:NSTextAlignmentCenter];
            [makeANOfferUserNameLabel setText:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_name"]];
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showPendingapprovalAlert) withObject:nil waitUntilDone:YES];
        }

    }
    else
    {
        delegate.hideBarFromDetailpage = YES;

        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
}

- (IBAction)makeOfferSendButton:(id)sender
{
    [self.view endEditing:YES];
    NSString *trimmedString = [makeAnOfferTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([typeYourOfferTxtView.text isEqualToString:@""] && [makeAnOfferTxtView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"Should not be Empty, Please Enter some text"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([typeYourOfferTxtView.text isEqualToString:[delegate.languageDict objectForKey:@"type_your_offer"]] || [typeYourOfferTxtView.text  isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"Please fill all fields"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([makeAnOfferTxtView.text isEqualToString:[delegate.languageDict objectForKey:@"type_your_message"]] || [trimmedString isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"Please fill all fields"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }else if([typeYourOfferTxtView.text intValue]>=[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"price"] intValue]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"Offer price should less than product price"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }else if([makeAnOfferTxtView.text length]>500){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"Maximum 500 Character only allowed"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [makeoffersendBtn setEnabled:NO];
        if (trimmedString.length != 0)
        {
            [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
            [self getChatIdValue];
        }
    }
    [self.view endEditing:YES];
}
-(void) sendChatAfterId
{
    //    UITextView * textView = (UITextView*)[self.view viewWithTag:999];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *messagedict = [NSMutableDictionary dictionary];
    NSDate * currentDate = [NSDate date];
    [messagedict setObject:makeAnOfferTxtView.text forKey:@"message"];
    [messagedict setObject:[NSString stringWithFormat:@"%@/%@",userURL,[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_img"]] forKey:@"userImage"];
    [messagedict setObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_name"] forKey:@"userName"];
    [messagedict setObject:[dateFormatter stringFromDate:currentDate] forKey:@"chatTime"];
    [dict setObject:messagedict forKey:@"message"];
    [dict setObject:@"demo" forKey:@"receiverId"];
    [dict setObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_name"] forKey:@"senderId"];
    [socketIO sendEvent:@"message" withData:dict];
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    //    -(void)Sendofferreq:(NSString *)api_username :(NSString *)api_password :(NSString *)sender_id :(NSString *)source_id :(NSString *)chat_id :(NSString *)created_date :(NSString *)message :(NSString *)offer_price ;
    if (proxy==nil)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    [proxy Sendofferreq:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"] :chatIDValue :[NSString stringWithFormat:@"%ld",unixTime] :makeAnOfferTxtView.text :typeYourOfferTxtView.text ];
}

#pragma mark - Loading Progresswheel Initialize (makeOffer send & Buynow)

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 2.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:headercolor, nil];
    [_multiColorLoader setFrame:CGRectMake(10, 10, 15, 15)];
    [_multiColorLoader startAnimation];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [makeoffersendBtn addSubview:_multiColorLoader];
}
-(void) startLoadig
{
    [_multiColorLoader setFrame:CGRectMake(10, 10, 15, 15)];
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
    [self.view setUserInteractionEnabled:NO];
    [makeOffbgBtn setEnabled:NO];
}
-(void) stopLoading
{
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [makeOffbgBtn setEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
}
-(void) loadingbuynowIndicator
{
    _buyNowmultiColorLoader=[[BLMultiColorLoader alloc]init];
    _buyNowmultiColorLoader.lineWidth = 4.0;
    _buyNowmultiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_buyNowmultiColorLoader setFrame:CGRectMake((delegate.windowWidth/2)-7.5, (delegate.windowHeight/2)-15, 30, 30)];
    [_buyNowmultiColorLoader startAnimation];
    [_buyNowmultiColorLoader setHidden:YES];
    [_buyNowmultiColorLoader stopAnimation];
    [self.view addSubview:_buyNowmultiColorLoader];
}

-(void) startBuynowLoading
{
    [_buyNowmultiColorLoader setHidden:NO];
    [_buyNowmultiColorLoader startAnimation];
    [self.view setUserInteractionEnabled:NO];
}
-(void) stopBuynowLoading
{
    [_buyNowmultiColorLoader setHidden:YES];
    [_buyNowmultiColorLoader stopAnimation];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark  Parsing Function for chat id make offer

-(void) getChatIdValue
{
    if (proxy==nil)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    
    [proxy getchatid:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]];
}

#pragma mark - redirect to Other class
#pragma mark  Comment Perfomance

-(void) commentButtonTapped:(id) sender
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        reloadFlag = YES;
        CommentPage * commentPagePageObj = [[CommentPage alloc]initWithNibName:@"CommentPage" bundle:nil];
        [commentPagePageObj loadingComment:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"]];
        [self.navigationController pushViewController:commentPagePageObj animated:YES];
        [commentPagePageObj release];
    }
    else
    {
        delegate.hideBarFromDetailpage = YES;

        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
}

#pragma mark Edit product

-(void)editButtonTapped:(id)sender
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        [self.tabBarController.tabBar setHidden:YES];
        [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
        delegate.editFlag = YES;
        [delegate.removedItemArray removeAllObjects];
        AddProductDetails * addproductPageDetailsObj = [[AddProductDetails alloc]initWithNibName:@"AddProductDetails" bundle:nil];
        [self.navigationController pushViewController:addproductPageDetailsObj animated:YES];
        [addproductPageDetailsObj release];
    }
    else
    {
        delegate.hideBarFromDetailpage = YES;
        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
}

#pragma mark  redirect to profile

-(void)usergesterAction:(UITapGestureRecognizer *) sender
{
    if([[NSString stringWithFormat:@"%ld",(long)(UIGestureRecognizer*)[sender.view tag]] intValue]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"user_not_registered_yet"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
        
    }else{
        reloadFlag = NO;
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = AppThemeColor;
        }
        UINavigationController * vc = [delegate.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:delegate.tabID];
        [delegate.userIDArray removeAllObjects];
        [delegate.userIDArray addObject:[NSString stringWithFormat:@"%ld",(long)(UIGestureRecognizer*)[sender.view tag]]];
        NewProfilePage * newprofilePageObj = [[[NewProfilePage alloc]init] autorelease];
        [newprofilePageObj loadingOtherUserData:[NSString stringWithFormat:@"%ld",(long)(UIGestureRecognizer*)[sender.view tag]]:@"NO"];
        [vc pushViewController:newprofilePageObj animated:YES];
    }
}

#pragma  mark  redirect to CreateExchange

-(void) swapButtonTapped:(id) sender
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
    [self closePopup];
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    
    reloadFlag = NO;
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        if (itemEnableFlag) {

        }

    }
    else
    {
        delegate.hideBarFromDetailpage = YES;
        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
        //        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
}


#pragma  mark  buynow (dataparsing)

-(void) redirectBuynow
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        if(buyNowFlag){
            if (itemEnableFlag)
            {
                buyNowFlag = NO; //disable
                [self performSelectorOnMainThread:@selector(startBuynowLoading) withObject:nil waitUntilDone:YES];
                NSLog(@"[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]:%@",[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]);
                
                [self apigetShippingAddress:apiusername api_password:apipassword user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"id"]];

            }
            else
            {
                [self performSelectorOnMainThread:@selector(showPendingapprovalAlert) withObject:nil waitUntilDone:YES];
            }
        }

    }
    else
    {
        delegate.hideBarFromDetailpage = YES;
        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
}
-(void) apigetShippingAddress:(NSString *)api_username api_password:(NSString *)api_password user_id:(NSString *)user_id item_id:(NSString *)item_id
{
    NSLog(@"api_username :%@ api_password :%@  user_id :%@  item_id :%@  ",api_username ,api_password ,user_id ,item_id );
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];

    [proxy getShippingAddress:api_username :api_password :user_id :item_id];
}

#pragma  mark  redirect To buynow (shipping/addshipping)

-(void) redirecttoSelectShipping
{
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
    }
}
-(void) redirecttoaddShipping
{
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
    }
}
#pragma  mark - Again sell sold out products

-(void) backToSale
{
    [self closePopup];
    if (proxy==nil)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }

    [proxy solditem:apiusername :apipassword :@"0" :[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"]];
}

#pragma  mark  Mark product as sold and end promotion

-(void) markAsSold
{
    [self closePopup];
    if (proxy==nil)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }

    [proxy solditem:apiusername :apipassword :@"1" :[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"]];
}

#pragma  mark  Delete own products

-(void) deleteProduct
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                    message:[delegate.languageDict objectForKey:@"Do you want to surely delete this product?"]
                                                   delegate:self
                                          cancelButtonTitle:[delegate.languageDict objectForKey:@"cancel"]
                                          otherButtonTitles:[delegate.languageDict objectForKey:@"ok"],nil];
    [alert show];
    alert.tag=100;
    [self closePopup];
}

#pragma  mark - Update product Views

-(void) increaseViewCount
{
    if (proxy==nil)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    [proxy updateview:apiusername :apipassword :[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"]];
}

#pragma  mark - Scroll Delegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==1212)
    {
        int page;
        CGFloat pageWidth = scrollView.frame.size.width;
        page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
        if(page >= [[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]count] || page < 0 || page == pagenumber) {
            return;
        }
        pagenumber = page;
        [imagePageControl setCurrentPage:page];
    }
}
#pragma mark  if no more items found reduce scroll size
-(void) showOrHideMoreFunction
{
    if ([moreItemsArray count]==0)
    {
        [moreItemsView setFrame:CGRectMake(0,locationandUserView.frame.size.height+locationandUserView.frame.origin.y+5,delegate.windowWidth,0)];
        [moreItemsView setHidden:YES];
        [reportItemLabel setFrame:CGRectMake(5,moreItemsView.frame.size.height+moreItemsView.frame.origin.y+10,200,25)];
        [mainPageScrollView setContentSize:CGSizeMake(0,moreItemsView.frame.size.height+moreItemsView.frame.origin.y+80)];
    }
    else
    {
        [moreItemsView setHidden:NO];
        [moreItemsView setFrame:CGRectMake(0,locationandUserView.frame.size.height+locationandUserView.frame.origin.y+5,delegate.windowWidth,320)];
        [reportItemLabel setFrame:CGRectMake(5,moreItemsView.frame.size.height+moreItemsView.frame.origin.y+40,200,25)];
        [mainPageScrollView setContentSize:CGSizeMake(0,moreItemsView.frame.size.height+moreItemsView.frame.origin.y+80)];
    }
}

#pragma mark - ParsingFunction

-(void) loadingsimalarPageData
{
    @try
    {
        callSimilarDataFunction = YES;
        [self apiCallingFunction:apiusername api_password:apipassword type:@"moreitems" price:@"" search_key:@"" category_id:@"" subcategory_id:@"" user_id:@"" item_id:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"] seller_id:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"] sorting_id:@"" offset:@"0" limit:@"20" lat:@"9.925201" lon:@"78.119775" posted_within:@"100"distance:@""];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
}

#pragma mark CallingApiModal
-(void) apiCallingFunction:(NSString*)api_username api_password:(NSString*)api_password type:(NSString *)type price:(NSString *)price search_key:(NSString *)search_key category_id:(NSString *)category_id subcategory_id:(NSString *)subcategory_id user_id:(NSString *)user_id item_id:(NSString *)item_id seller_id:(NSString *)seller_id sorting_id:(NSString *)sorting_id offset:(NSString *)offset limit:(NSString *)limit lat:(NSString *)lat lon:(NSString *)lon posted_within:(NSString *)posted_within distance:(NSString*)distance
{
    
    [backBtn addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    if (proxy==nil)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :user_id :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within :distance];
}



#pragma mark - LIKE button performance

#pragma mark views and likes in short code

-(NSString *)abbreviateNumber:(int)num withDecimal:(int)dec {
    
    NSString *abbrevNum = [NSString stringWithFormat:@"%d",num];
    float number = (float)num;
    
    NSArray *abbrev = @[@"K", @"M", @"B"];
    
    for (int i = (unsigned)[abbrev count]-1; i >= 0; i--) {
        
        // Convert array index to "1000", "1000000", etc
        int size = pow(10,(i+1)*3);
        
        if(size <= number) {
            // Here, we multiply by decPlaces, round, and then divide by decPlaces.
            // This gives us nice rounding to a particular decimal place.
            number = round(number*dec/size)/dec;
            
            NSString *numberString = [self floatToString:number];
            
            // Add the letter for the abbreviation
            abbrevNum = [NSString stringWithFormat:@"%@%@", numberString, [abbrev objectAtIndex:i]];
        }
    }
    return abbrevNum;
}
- (NSString *) floatToString:(float) val {
    
    NSString *ret = [NSString stringWithFormat:@"%.1f", val];
    unichar c = [ret characterAtIndex:[ret length] - 1];
    
    while (c == 48 || c == 46) { // 0 or .
        ret = [ret substringToIndex:[ret length] - 1];
        c = [ret characterAtIndex:[ret length] - 1];
    }
    return ret;
}

-(void) likeButtonTapped:(id)sender
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = clearcolor;
                }
    if (proxy==nil)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];

    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        if (itemEnableFlag)
        {
            [likeButton setImage:[UIImage imageNamed:@"unlike.png"] forState:UIControlStateNormal];
            likeButton.alpha = 1.0f;
            //        [self startFlashingbutton];
            [proxy Itemlike:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"]];

        }
        else
        {
            [self performSelectorOnMainThread:@selector(showPendingapprovalAlert) withObject:nil waitUntilDone:YES];
        }
        
    }
    else
    {
        delegate.hideBarFromDetailpage = YES;
        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
}
#pragma mark  animate like btn

-(void) startFlashingbutton
{
    if (buttonFlashing) return;
    buttonFlashing = YES;
    likeButton.alpha = 1.0f;
//    [UIView animateWithDuration:0.4
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveLinear |
//     UIViewAnimationOptionRepeat |
//     UIViewAnimationOptionAutoreverse |
//     UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         [likeButton setTransform:CGAffineTransformRotate(likeButton.transform, M_PI)];
//                     }
//                     completion:^(BOOL finished){
//                     }];
}
-(void) stopFlashingbutton
{
    if (!buttonFlashing) return;
    buttonFlashing = NO;
//    [UIView animateWithDuration:0.4
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveLinear |
//     UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         [likeButton setTransform:CGAffineTransformRotate(likeButton.transform, M_PI)];
//                     }
//                     completion:^(BOOL finished){
//                         // Do nothing
//                     }];
}



#pragma mark - OMNIGridView

- (OmniGridCell *)gridCellAt:(OmniGridLoc *)gridLoc inGridView:(OmniGridView *)gridView {
    OmniGridCell *gridCell = [gridView dequeueReusableGridCell];
    if (!gridCell)
    {
        gridCell = [[OmniGridCell alloc] init];
        
    }
    if ([delegate connectedToNetwork] && [moreItemsArray count]!=0 && [moreItemsArray count]>gridLoc.col)
    {
        float gridWidth = (delegate.windowWidth/2)-25;
        if (gridLoc.col==0)
        {
            gridWidth = (delegate.windowWidth/2)-10;
        }
        else
        {
            gridWidth = (delegate.windowWidth/2)-10;
        }
        float gridHeight = 250.0;
        UIScrollView * itemScrollView = [[UIScrollView alloc]init];
        if(gridLoc.col==0)
        {
            [itemScrollView setFrame:CGRectMake(5,0, gridWidth-5,gridHeight)];
        }
        else
        {
            [itemScrollView setFrame:CGRectMake(5,0, gridWidth-5,gridHeight)];
        }
        [itemScrollView setUserInteractionEnabled:YES];
        [itemScrollView setBackgroundColor:whitecolor];
        itemScrollView.layer.cornerRadius=2;
        itemScrollView.layer.masksToBounds=YES;
        
        
        UIImageView * imageView = [[[UIImageView alloc]init]autorelease];
        [imageView setBackgroundColor:whitecolor];
        [imageView setFrame:CGRectMake(0,0,itemScrollView.frame.size.width,gridHeight-78)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setTag:66];
        [imageView setUserInteractionEnabled:YES];
        imageView.layer.masksToBounds=YES;
        if ([[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"photos"]count]!=0)
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"photos"]objectAtIndex:0] objectForKey:@"item_url_main_350"]]]];
        }
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.layer.masksToBounds=YES;
        [itemScrollView addSubview:imageView];
        
        UIImageView * PlaceholderImage =[[[UIImageView alloc]init] autorelease];
        [PlaceholderImage setImage:[UIImage imageNamed:@"ItemTransparentImg"]];
        [PlaceholderImage setFrame:CGRectMake(0, imageView.frame.size.height-50, itemScrollView.frame.size.width,50 )];
        [itemScrollView addSubview:PlaceholderImage];
        
        UILabel * productType = [[[UILabel alloc] init] autorelease];
        [productType setFont:[UIFont fontWithName:appFontRegular size:12]];
        [productType setTextColor:whitecolor];
        [productType setBackgroundColor:clearcolor];
        [productType setTextAlignment:NSTextAlignmentCenter];
        productType.layer.cornerRadius=2;
        productType.layer.masksToBounds=YES;
        productType.numberOfLines=2;
        if([[NSString stringWithFormat:@"%@",[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
            if(![[NSString stringWithFormat:@"%@",[[moreItemsArray objectAtIndex:gridLoc.col] objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                [productType setText:[NSString stringWithFormat:@"\n%@",[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"promotion_type"]]];
                if([[NSString stringWithFormat:@"\n%@",[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                    [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];
                    [productType setBackgroundColor:redcolor];
                }else if([[NSString stringWithFormat:@"\n%@",[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
                    [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"ad"]]];
                    [productType setBackgroundColor:AdColor];
                }
                
            }else{
                [productType setText:@""];
                [productType setBackgroundColor:clearcolor];
                
            }
        }else{
            [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"sold"]]];
            [productType setBackgroundColor:soldOutColor];
            
        }
        [productType setFrame:CGRectMake(itemScrollView.frame.size.width-productType.intrinsicContentSize.width-15, -4, productType.intrinsicContentSize.width+10, 30+4)];
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [productType setFrame:CGRectMake(15, -4, productType.intrinsicContentSize.width+10, 30+4)];
        }
        [itemScrollView addSubview:productType];
        
        
        
        UILabel * PostedTime = [[[UILabel alloc] init] autorelease];
        [PostedTime setFont:[UIFont fontWithName:appFontRegular size:13]];
        [PostedTime setTextColor:whitecolor];
        [PostedTime setBackgroundColor:clearcolor];
        [PostedTime setTextAlignment:NSTextAlignmentRight];
        double unixTimeStamp =[[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"posted_time"] doubleValue];
        NSTimeInterval timeInterval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSString *dateString=[dateFormatter1 stringFromDate:date];
        [PostedTime setText:[NSDate dateDiff:dateString]];
        
       // [PostedTime setText:[NSString stringWithFormat:@"%@",[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"posted_time"]]];
        [PostedTime setFrame:CGRectMake(0, imageView.frame.size.height-30,  itemScrollView.frame.size.width-5,30)];
        [itemScrollView addSubview:PostedTime];
        
        UIView * headerView = [[[UIView alloc]init]autorelease];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        [headerView setFrame:CGRectMake(0,gridHeight-78,itemScrollView.frame.size.width,78)];
        [itemScrollView addSubview:headerView];
        
        NSArray * currency =[[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"currency_code"] componentsSeparatedByString:@"-"];
        NSLog(@"currency:%@",currency);
        NSString * currencyformat = [NSString stringWithFormat:@"%@ ",[currency objectAtIndex:0]];

        UILabel * priceLable = [[[UILabel alloc]init]autorelease];
        [priceLable setTag:22];
        [priceLable setFrame:CGRectMake(10, 0, itemScrollView.frame.size.width-10, 30)];
        priceLable.text = [NSString stringWithFormat:@"%@%@",currencyformat,[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"price"]];
        [priceLable setFont:[UIFont fontWithName:appFontBold size:14]];
        [priceLable setTextColor:AppTextColor];
        [priceLable setBackgroundColor:clearcolor];
        [headerView addSubview:priceLable];
        
        UILabel * itemnameLable = [[[UILabel alloc]init]autorelease];
        [itemnameLable setTag:11];
        [itemnameLable setFrame:CGRectMake(10, 18, itemScrollView.frame.size.width-10,30 )];

       // itemnameLable.text  = [delegate attributestringtostring:[[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"item_title"]];
         itemnameLable.text  = [[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"item_title"];
        [itemnameLable setFont:[UIFont fontWithName:appFontRegular size:14]];
        [itemnameLable setTextColor:AppTextColor];
        [itemnameLable setBackgroundColor:clearcolor];
        [headerView addSubview:itemnameLable];
        
        UIView * bottomView = [[[UIView alloc]init]autorelease];
        [bottomView setFrame:CGRectMake(0, 48, itemScrollView.frame.size.width, 1)];
        [bottomView setBackgroundColor:BackGroundColor];
        [headerView addSubview:bottomView];
        
        UILabel * locationLable = [[[UILabel alloc]init]autorelease];
        [locationLable setTag:11];
        [locationLable setFrame:CGRectMake(10, 48, itemScrollView.frame.size.width-10,30 )];
        locationLable.text  = [[moreItemsArray objectAtIndex:gridLoc.col]objectForKey:@"location"];
        [locationLable setFont:[UIFont fontWithName:appFontRegular size:12]];
        [locationLable setTextColor:ThirdryTextColor];
        [locationLable setBackgroundColor:clearcolor];
        [headerView addSubview:locationLable];
        
        if([delegate.languageSelected isEqualToString:@"Arabic"]){

        }
        [itemImageScrollView setUserInteractionEnabled:YES];
        [gridCell addSubview:itemScrollView];
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [priceLable setTextAlignment:NSTextAlignmentRight];
            [itemnameLable setTextAlignment:NSTextAlignmentRight];
            [locationLable setTextAlignment:NSTextAlignmentRight];
        }else{
            [priceLable setTextAlignment:NSTextAlignmentLeft];
            [itemnameLable setTextAlignment:NSTextAlignmentLeft];
            [locationLable setTextAlignment:NSTextAlignmentLeft];
        }

        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        [gridCell addGestureRecognizer:rec];
        gridCell.userInteractionEnabled = YES;
        [gridCell setTag:gridLoc.col];
        
    }
    return gridCell;
}


- (float)gridCellHeightInGridView:(OmniGridView *)gridView {
    return 250;
}

- (float)gridCellWidthInGridView:(OmniGridView *)gridView {
    
    return (delegate.windowWidth/2)-10;
}

- (int)numberOfGridCellsInRow:(int)row inGridView:(OmniGridView *)gridView
{
    return 1;
    
}
- (int)numberOfRowsInGridView:(OmniGridView *)gridView {
    
    if ([moreItemsArray count]==0)
    {
        return 1;
        
    }
    else
    {
        return (int)[moreItemsArray count];
    }
}
-(void)gridView:(OmniGridView *)gridView didSelectCellAtLoc:(OmniGridLoc *)gridLoc
{
    reloadFlag = NO;
    ItemDetailPage * detailPage = [[ItemDetailPage alloc]initWithNibName:@"ItemDetailPage" bundle:nil];
    
    int viewCount =[[[moreItemsArray objectAtIndex:(int)gridLoc.col]objectForKey:@"views_count"]intValue];
    viewCount = viewCount+1;
    
    if ([NSString stringWithFormat:@"%d",viewCount] != (NSString*)[NSNull null])
    {
        [[moreItemsArray objectAtIndex:(int)gridLoc.col]setObject:[NSString stringWithFormat:@"%d",viewCount] forKey:@"views_count"];
    }
    
    [detailPage detailPageArray:moreItemsArray selectedIndex:(int)gridLoc.col];
    
    [self.navigationController pushViewController:detailPage animated:YES];
    [detailPage release];
}

#pragma mark  select more item Gesture Action
-(void)gestureAction:(UITapGestureRecognizer *) sender
{
    reloadFlag = NO;
    int viewCount =[[[moreItemsArray objectAtIndex:(int)(UIGestureRecognizer*)[sender.view tag]]objectForKey:@"views_count"]intValue];
    viewCount = viewCount+1;
    if ([NSString stringWithFormat:@"%d",viewCount] != (NSString*)[NSNull null])
    {
        [[moreItemsArray objectAtIndex:(int)(UIGestureRecognizer*)[sender.view tag]]setObject:[NSString stringWithFormat:@"%d",viewCount] forKey:@"views_count"];
    }
    ItemDetailPage * detailPage = [[ItemDetailPage alloc]initWithNibName:@"ItemDetailPage" bundle:nil];
    [detailPage detailPageArray:moreItemsArray selectedIndex:(int)(UIGestureRecognizer*)[sender.view tag]];
    
    [self.navigationController pushViewController:detailPage animated:YES];
    [detailPage release];
}

#pragma mark - Report product
-(void)reportThisItem
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
    [self closePopup];
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        NSString * message;
        if ([[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"report"]uppercaseString]isEqualToString:@"YES"])
        {
            message = [delegate.languageDict objectForKey:@"Did you like to undo report this item?"];
        }
        else
        {
            message = [delegate.languageDict objectForKey:@"Did you like to report this item?"];
        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"alert"] message:message delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"yes"] otherButtonTitles:[delegate.languageDict objectForKey:@"no"],nil];
        [alert setTag:5000];
        [alert show];
        [alert release];
    }
    else
    {
        delegate.hideBarFromDetailpage = YES;
        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
    
}

#pragma mark - TextView Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 10) {
        numberToolbar.hidden = NO;
        [textField setKeyboardType:UIKeyboardTypeDecimalPad];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
        
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
        
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification object:nil];
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
   [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification object:nil];
    
    [self.view endEditing:YES];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                   withString:string];
    if(textField.tag==10){
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        
        // allow backspace
        if (range.length == 0 && [string length] == 0){
            return YES;
        }
        if ([string isEqualToString:@"."] ){
            if (range.location == 0) {
                return NO;
            }
            if(dotLocation == 0){
                dotLocation = range.location;
                return YES;
            }
            else{
                return NO;
            }
        }
        if (range.location == dotLocation && string.length==0) {
            dotLocation = 0;
        }
        if (dotLocation > 0 && range.location > dotLocation+2) {
            return NO;
        }
        if(range.location >= 6)
        {
            //dotLocation = range.location;
            if (dotLocation>=6 || string.length==0) {
                return YES;
            }
            else if(range.location > dotLocation+2){
                return NO;
            }
            
        }
        
        NSString *newValue = [[textField text] stringByReplacingCharactersInRange:range withString:string];
        newValue = [[newValue componentsSeparatedByCharactersInSet:nonNumberSet] componentsJoinedByString:@""];
        textField.text = newValue;
        
        return NO;
        
        
        //return resultText.length <= 9;
    }
    else{
        return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([textView.text length]>0){
        NSString *lastChar = [textView.text substringFromIndex:[textView.text length] - 1];
        if([lastChar isEqualToString:@" "]){
            if([text isEqualToString:lastChar]){
                return NO;
            }
        }
    }
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return makeAnOfferTxtView.text.length + (text.length - range.length) <= 180;
    return YES;
}


-(void) textViewDidChange:(UITextView *)textView
{
    
    if(![textView hasText])
    {
        lblPlaceholder.hidden = NO;
    }
    else
    {
        lblPlaceholder.hidden = YES;
    }

}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    
    UITextView *dummyTxtView = [self.view viewWithTag:101];
    UITextView *dummyTxtView1 = [self.view viewWithTag:201];
    UITextView *dummyTxtView2 = [self.view viewWithTag:202];

    
    if (dummyTxtView)
    {
        
        dummyTxtView.text = textView.text;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];

    }
    
    if (dummyTxtView1){
//        textView.text = @"";
        dummyTxtView2.text = [delegate.languageDict objectForKey:@"type_your_message"];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];

    }
    
    if (dummyTxtView2){
//        textView.text = @"";//
        dummyTxtView1.text = [delegate.languageDict objectForKey:@"type_your_offer"];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];

    }
    
    
    if (![textView hasText])
    {
        lblPlaceholder.hidden = NO;
    }
    else
    {
        lblPlaceholder.hidden = YES;
    }
    return YES;

    
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification object:nil];
    return YES;
    
}


- (void) keyboardWillShow:(NSNotification *)note
{
    // Assign new frame to your view
    if (typeYourOfferTxtView) {
        [makeAnOfferBG setFrame:CGRectMake(0, -255, delegate.windowWidth, delegate.windowHeight)];
        
        //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
        
    }
    
    if (makeAnOfferTxtView) {
        [makeAnOfferBG setFrame:CGRectMake(0, -210, delegate.windowWidth, delegate.windowHeight)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
        
    }
    
    
}

- (void) keyboardWillHide:(NSNotification *)note
{
    [makeAnOfferBG setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    
}


#pragma mark - WSDL DelegateMethod
//proxy finished, (id)data is the object of the relevant method service
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    [self performSelectorOnMainThread:@selector(stopBuynowLoading) withObject:nil waitUntilDone:YES];

    if([method isEqualToString:@"Sendofferreq"]){
        [makeoffersendBtn setEnabled:true];
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    }
    if ([method isEqualToString:@"Itemlike"])
    {
//        [self stopFlashingbutton];
    }
    if ([method isEqualToString:@"getShippingAddress"])
    {
        buyNowFlag=YES;
    }
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    NSLog(@" Data:%@",data);
    [self performSelectorOnMainThread:@selector(stopBuynowLoading) withObject:nil waitUntilDone:YES];
    
    if ([method isEqualToString:@"getchatid"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        chatIDValue = [defaultDict objectForKey:@"chat_id"];
        [self sendChatAfterId];
    }
    else if ([method isEqualToString:@"checkItemstatus"])
    {
        [self performSelectorOnMainThread:@selector(increaseViewCount) withObject:nil waitUntilDone:YES];
        if (!callSimilarDataFunction) {
            [self performSelectorOnMainThread:@selector(loadingsimalarPageData) withObject:nil waitUntilDone:YES];
        }

        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]isEqualToString:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_id"]])
            {
                NSLog(@"%@",defaultDict);
                if ([[defaultDict objectForKey:@"item_approve"]intValue]==0)
                {
                    itemEnableFlag = NO;
                    [self performSelectorOnMainThread:@selector(showPendingapprovalAlert) withObject:nil waitUntilDone:YES];

                }
                else
                {
                    itemEnableFlag = YES;

                }

            }
            else
            {
                itemEnableFlag = YES;

            }
        }
        
    }

    else if ([method isEqualToString:@"getShippingAddress"])
    {
        
        if(!buyNowFlag){
            buyNowFlag=YES;
            
            NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
            [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
            NSLog(@"defaultDict:%@",defaultDict);
            NSMutableDictionary * buynowDict = [[NSMutableDictionary alloc]init];
            [buynowDict setObject:[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] forKey:@"item"];
            [buynowDict setObject:@"" forKey:@"address"];
            [delegate.buynowArray removeAllObjects];
            [delegate.buynowArray addObject:buynowDict];
            
            if ([[defaultDict objectForKey:@"status"]isEqualToString:@"true"])
            {
                [self redirecttoSelectShipping];
            }else{
                [self redirecttoaddShipping];
            }
            
        }
        
        //        buyNowFlag=NO;
        
        //        [delegate.buynowArray addObject:<#(nonnull id)#>]
    }
    else if([method isEqualToString:@"updateview"])
    {
    }
    else if([method isEqualToString:@"reportitem"])
    {
        NSMutableDictionary * defaultDict = [[[NSMutableDictionary alloc]init] autorelease];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
        if ([[defaultDict objectForKey:@"message"]isEqualToString:@"Reported Successfully"]) {
            [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:@"yes" forKey:@"report"];
            [reportItemLabel setText:[delegate.languageDict objectForKey:@"undo_report"]];
            [reportBtn setTitle:[delegate.languageDict objectForKey:@"undo_report"] forState:UIControlStateNormal];
            [self showAlertconroll:[delegate.languageDict objectForKey:@"reported_successfully"] tag:0];
            
        }
        else
        {
            [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:@"no" forKey:@"report"];
            
            [reportItemLabel setText:[delegate.languageDict objectForKey:@"report_product"]];
            [reportBtn setTitle:[delegate.languageDict objectForKey:@"report_product"] forState:UIControlStateNormal];
            [self showAlertconroll:[delegate.languageDict objectForKey:@"unreported_successfully"] tag:0];
        }
    }
    else if ([method isEqualToString:@"Itemlike"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        
        int likecount=[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex] objectForKey:@"likes_count"] intValue];
        //        [self stopFlashingbutton];
        if ([[defaultDict objectForKey:@"status"]isEqualToString:@"true"])
        {
            if([[defaultDict objectForKey:@"result"]isEqualToString:@"Item Liked Successfully"]){
                likecount=likecount+1;
                [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:@"yes" forKey:@"liked"];
                [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:[NSString stringWithFormat:@"%d",likecount] forKey:@"likes_count"];
                if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue]==0){
                    [likeCountLbl setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"likes"]]];
                }else{
                    [likeCountLbl setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"likes"]]];
                }
                [likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
            }else{
                likecount=likecount-1;
                [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:@"no" forKey:@"liked"];
                [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:[NSString stringWithFormat:@"%d",likecount] forKey:@"likes_count"];
                if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue]==0){
                    [likeCountLbl setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"likes"]]];
                }else{
                    [likeCountLbl setText:[NSString stringWithFormat:@"%@ %@",[self abbreviateNumber:[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"likes_count"]intValue] withDecimal:2],[delegate.languageDict objectForKey:@"likes"]]];
                }
                [likeButton setImage:[UIImage imageNamed:@"unlike.png"] forState:UIControlStateNormal];
            }
        }
        else if([method isEqualToString:@"sendchat"])
        {
        }
        else{
            [self showAlertconroll:[defaultDict objectForKey:@"result"] tag:0];
        }
    }else if([method isEqualToString:@"Sendofferreq"]){
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if([[defaultDict objectForKey:@"status"] isEqualToString:@"true"]){
            makeAnOfferBG.hidden = YES;
            MoreViewPopup.hidden = YES;
            [buttonsView setHidden:NO];
            [lblPlaceholder setHidden:NO];
            typeYourOfferTxtView.text = @"";
            makeAnOfferTxtView.text = @"";
            [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      [delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"message_send_successfully"] delegate:self
                                                     cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
            
            [alertView show];
            [makeoffersendBtn setEnabled:true];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                      [delegate.languageDict objectForKey:@"alert"] message:[delegate.languageDict objectForKey:@"Something Went wrong, Try again later"] delegate:self
                                                     cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
            
            [alertView show];
            [makeoffersendBtn setEnabled:true];
            typeYourOfferTxtView.text = @"";
            makeAnOfferTxtView.text = @"";
            [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
            
            
        }
        
    }
    else if([method isEqualToString:@"solditem"]){
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if([[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
            [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:@"sold" forKey:@"item_status"];
        }else{
            [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:@"onsale" forKey:@"item_status"];
            [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:@"Normal" forKey:@"promotion_type"];
        }
        [self settingSubViewsToMainView];
    }
    else if([method isEqualToString:@"deleteproduct"]){
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"product_deleted_duccessfully"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
        if([[defaultDict objectForKey:@"status"] isEqualToString:@"true"]){
            delegate.deleteProduct=@"YES";
            alert.tag=101;
        }
    }
    else
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj testingHomePageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
        [moreItemsArray removeAllObjects];
        [moreItemsArray addObjectsFromArray:[[defaultDict objectForKey:@"result"]objectForKey:@"items"]];
        [moreItemsgridView reloadData];
        [self performSelectorOnMainThread:@selector(showOrHideMoreFunction) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - Alert
-(void) showAlertconroll:(NSString*)message tag:(int)tag
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                        message: message
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: [delegate.languageDict objectForKey:@"ok"]
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            
                                                        }];
    [controller addAction: alertAction];
    [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (proxy==nil)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }

    if(alertView.tag==100){
        if (buttonIndex == 0) {
            //for cancel
        }else{
            //for ok
            [proxy deleteproduct:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"]];
        }
    }if(alertView.tag==101){
        if (buttonIndex == 0) {
            //for ok
            [self.tabBarController.tabBar setHidden:NO];
            [delegate.tabViewControllerObj.tabBarController showNewTabBar];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag==5000)
    {
        if (buttonIndex==0)
        {
            //-(void)reportitem:(NSString *)api_username :(NSString *)api_password :(NSString *)user_id :(NSString *)item_id ;
            [proxy reportitem:apiusername :apipassword:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"]];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"shouldReceiveTouch");
    
   
    return YES;
}

#pragma mark TableViewDelagate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
#pragma mark TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [makeAnOfferBG release];
    [makeAnOffUserImageView release];
    [typeYourOfferTxtView release];
    [makeAnOfferTxtView release];
    [makeoffersendBtn release];
    [makeANOfferUserNameLabel release];
    [makeOffbgBtn release];
    [super dealloc];
}

/**
 Right now we are not using this function it will be used in the future
 */

-(void) detailPageArray:(NSMutableArray*)locdetailPageArray selectedIndex:(int)selectedIndex
{
    NSLog(@"%@",locdetailPageArray);
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    detailSelectedIndex = selectedIndex;
    detailItemsArray = [[NSMutableArray alloc]initWithCapacity:0];
    [detailItemsArray addObjectsFromArray:locdetailPageArray];
    delegate.detailArraySelectedIndex = selectedIndex;
    [delegate.detailPageArray removeAllObjects];
    [delegate.detailPageArray addObjectsFromArray:detailItemsArray];
}

@end
