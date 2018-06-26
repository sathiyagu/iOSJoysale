//
//  AddProductDetails.m
//  HSJoysale
//
//  Created by BTMANI on 17/07/15.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "AddProductDetails.h"
#import "AppDelegate.h"
#import "AddProductMapview.h"
#import "AddproductCategory.h"
#import "AddproductCondition.h"
#import "ItemDetailPage.h"
#import "PKImagePickerViewController.h"
#import "JSON.h"
#import "NSString+HTML.h"
#import "EditProfile.h"

//For table view
#define placeholderFont [UIFont fontWithName:appFontRegular size:12]
#define textFont [UIFont fontWithName:appFontRegular size:14]
#define titleFont [UIFont fontWithName:appFontRegular size:15]

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
#import <objc/runtime.h>
#import "ZSSBarButtonItem.h"
#import "HRColorUtil.h"
#import "ZSSTextView.h"
@import JavaScriptCore;

/**
 
 UIWebView modifications for hiding the inputAccessoryView
 
 **/
@interface UIWebView (HackishAccessoryHiding)
@property (nonatomic, assign) BOOL hidesInputAccessoryView;
@end

@implementation UIWebView (HackishAccessoryHiding)

static const char * const hackishFixClassName = "UIWebBrowserViewMinusAccessoryView";
static Class hackishFixClass = Nil;

- (UIView *)hackishlyFoundBrowserView {
    UIScrollView *scrollView = self.scrollView;
    
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIWebBrowserView"]) {
            browserView = subview;
            break;
        }
    }
    return browserView;
}

- (id)methodReturningNil {
    return nil;
}

- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {
    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
        class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
        objc_registerClassPair(newClass);
        
        hackishFixClass = newClass;
    }
}

- (BOOL) hidesInputAccessoryView {
    UIView *browserView = [self hackishlyFoundBrowserView];
    return [browserView class] == hackishFixClass;
}

- (void) setHidesInputAccessoryView:(BOOL)value {
    UIView *browserView = [self hackishlyFoundBrowserView];
    if (browserView == nil) {
        return;
    }
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
    
    if (value) {
        object_setClass(browserView, hackishFixClass);
    }
    else {
        Class normalClass = objc_getClass("UIWebBrowserView");
        object_setClass(browserView, normalClass);
    }
    [browserView reloadInputViews];
}

@end



@interface AddProductDetails ()

//Add photo page
@property (nonatomic,strong) PKImagePickerViewController *imagePicker;

/*
 *  Scroll view containing the toolbar
 */
@property (nonatomic, strong) UIScrollView *toolBarScroll;

/*
 *  Toolbar containing ZSSBarButtonItems
 */
@property (nonatomic, strong) UIToolbar *toolbar;

/*
 *  Holder for all of the toolbar components
 */
@property (nonatomic, strong) UIView *toolbarHolder;

/*
 *  String for the HTML
 */
@property (nonatomic, strong) NSString *htmlString;

/*
 *  UIWebView for writing/editing/displaying the content
 */
@property (nonatomic, strong) UIWebView *editorView;

/*
 *  ZSSTextView for displaying the source code for what is displayed in the editor view
 */
//@property (nonatomic, strong) ZSSTextView *sourceView;
@property (nonatomic, retain) ZSSTextView *storyTextview;

/*
 *  CGRect for holding the frame for the editor view
 */
@property (nonatomic) CGRect editorViewFrame;

/*
 *  BOOL for holding if the resources are loaded or not
 */
@property (nonatomic) BOOL resourcesLoaded;

/*
 *  Array holding the enabled editor items
 */
@property (nonatomic, strong) NSArray *editorItemsEnabled;

/*
 *  Alert View used when inserting links/images
 */
@property (nonatomic, strong) UIAlertView *alertView;

/*
 *  NSString holding the selected links URL value
 */
@property (nonatomic, strong) NSString *selectedLinkURL;

/*
 *  NSString holding the selected links title value
 */
@property (nonatomic, strong) NSString *selectedLinkTitle;

/*
 *  NSString holding the selected image URL value
 */
@property (nonatomic, strong) NSString *selectedImageURL;

/*
 *  NSString holding the selected image Alt value
 */
@property (nonatomic, strong) NSString *selectedImageAlt;

/*
 *  CGFloat holdign the selected image scale value
 */
@property (nonatomic, assign) CGFloat selectedImageScale;

/*
 *  NSString holding the base64 value of the current image
 */
@property (nonatomic, strong) NSString *imageBase64String;

/*
 *  Bar button item for the keyboard dismiss button in the toolbar
 */
@property (nonatomic, strong) UIBarButtonItem *keyboardItem;

/*
 *  Array for custom bar button items
 */
@property (nonatomic, strong) NSMutableArray *customBarButtonItems;

/*
 *  Array for custom ZSSBarButtonItems
 */
@property (nonatomic, strong) NSMutableArray *customZSSBarButtonItems;

/*
 *  NSString holding the html
 */
@property (nonatomic, strong) NSString *internalHTML;

/*
 *  NSString holding the css
 */
@property (nonatomic, strong) NSString *customCSS;

/*
 *  BOOL for if the editor is loaded or not
 */
@property (nonatomic) BOOL editorLoaded;

/*
 *  Image Picker for selecting photos from users photo library
 */
@property (nonatomic, strong) UIImagePickerController *myimagePicker;

/*
 *  Method for getting a version of the html without quotes
 */
- (NSString *)removeQuotesFromHTML:(NSString *)html;

/*
 *  Method for getting a tidied version of the html
 */
- (NSString *)tidyHTML:(NSString *)html;

/*
 * Method for enablign toolbar items
 */
- (void)enableToolbarItems:(BOOL)enable;

/*
 *  Setter for isIpad BOOL
 */
- (BOOL)isIpad;



@end

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end

@implementation AddProductDetails
@synthesize storyTextview;
@synthesize editorView;
//Scale image from device
//static CGFloat kJPEGCompression = 0.8;
static CGFloat kDefaultScale = 0.5;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    @try {
        
        
        //Initialization
        delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [self richtexteditorfunction];
        
        self.imagePicker = [[PKImagePickerViewController alloc]init];
        
        // Register notification when the keyboard will be hide
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        //Appearance
        [self.view setBackgroundColor:BackGroundColor];
//        [self profileDataParsing];
        [postBtn setUserInteractionEnabled:YES];
        [addproductTableView setUserInteractionEnabled:YES];
        [backBtn setUserInteractionEnabled:YES];
        [Laterbtn setUserInteractionEnabled:YES];
        [Laterbtn setUserInteractionEnabled:YES];

        //Properties
        
        
        [mainView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-65)];
        
        [addproductTableView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-125)];
        [addproductTableView setBackgroundColor:BackGroundColor];
        [addproductTableView setTag:1000];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerTapped:)];
        [addproductTableView addGestureRecognizer:tapRecognizer];
        [tapRecognizer setNumberOfTapsRequired:1];
        
        
        
        [BottomView  setFrame:CGRectMake(0, delegate.windowHeight-124,delegate.windowWidth, 60)];
        [BottomView setBackgroundColor:whitecolor];
        BottomView.layer.masksToBounds = NO;
        [BottomView addSubview:postBtn];
        [BottomView addSubview:Laterbtn];
        
        [Laterbtn setFrame:CGRectMake(5, 10, (delegate.windowWidth/2)-7.5, 40)];
        Laterbtn.layer.borderWidth = 1;
        Laterbtn.layer.borderColor = AppThemeColor.CGColor;
        Laterbtn.layer.cornerRadius=4;
        Laterbtn.layer.masksToBounds=YES;
        [Laterbtn.titleLabel setFont:ButtonFont];
        [postBtn setFrame:CGRectMake((delegate.windowWidth/2)+2.5, 10, (delegate.windowWidth/2)-7.5, 40)];
        postBtn.layer.borderWidth = 1;
        postBtn.layer.borderColor = AppThemeColor.CGColor;
        postBtn.layer.cornerRadius=4;
        postBtn.layer.masksToBounds=YES;
        [postBtn.titleLabel setFont:ButtonFont];
        [postBtn setTitle:[delegate.languageDict objectForKey:@"post"] forState:UIControlStateNormal];
        [Laterbtn setTitle:[delegate.languageDict objectForKey:@"cancel"] forState:UIControlStateNormal];
        [postBtn setBackgroundColor:AppThemeColor];
        [Laterbtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
        numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        numberToolbar.barTintColor=AppThemeColor;
        [numberToolbar sizeToFit];
        
        UIBarButtonItem *flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:[delegate.languageDict objectForKey:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneWithNumberPad)];
        [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:appFontBold size:15.0], NSFontAttributeName,
                                             whitecolor, NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateNormal];
        numberToolbar.items = [NSArray arrayWithObjects:flex, rightButton, nil];
        
        
        //Fuctionalities :
        item_id =0;
        
        //Initialization
        responseStr = [[NSMutableArray alloc]initWithCapacity:0];
        userDetailsArray = [[NSMutableArray alloc]initWithCapacity:0];

        //        [delegate adminchecking];
        //Reset array
        
        [delegate.postProductArray replaceObjectAtIndex:0 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:1 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:2 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:3 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:4 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:5 withObject:[[[delegate.addcategoryFilterDict objectForKey:@"currency"]objectAtIndex:0]objectForKey:@"symbol"]];
        [delegate.postProductArray replaceObjectAtIndex:6 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:7 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:8 withObject:@"No"];
        [delegate.postProductArray replaceObjectAtIndex:9 withObject:@"No"];
        [delegate.postProductArray replaceObjectAtIndex:12 withObject:@"No"];
        [delegate.postProductArray replaceObjectAtIndex:13 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:14 withObject:@""];
        [delegate.postProductArray replaceObjectAtIndex:15 withObject:@""];
        
        if (delegate.currentlatitude!=0)
        {
            [delegate.postProductArray replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%@",[delegate.selectedLocationArray objectAtIndex:2]]];
            [delegate.postProductArray replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@",[delegate.selectedLocationArray objectAtIndex:0]]];
            [delegate.postProductArray replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@",[delegate.selectedLocationArray objectAtIndex:1]]];
        }
        if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6] isEqualToString:@"WorldWide"]){
            if(![[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:3] isEqualToString:@""] && ![[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:3] isEqualToString:@"0"]){
                [delegate.postProductArray replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:5]]];
                [delegate.postProductArray replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:3]]];
                [delegate.postProductArray replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:4]]];
                
            }
        }else if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6] isEqualToString:@"setLocation"]){
            [delegate.postProductArray replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:2]]];
            [delegate.postProductArray replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:0]]];
            [delegate.postProductArray replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:1]]];
        }
        
        if (delegate.editFlag)
        {
            
            NSLog(@"detailArray:%@",[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]);
            
            
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithData: [[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_description"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                    options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                    documentAttributes: nil
                                                    error: nil
                                                    ];
            editorContentHeight = [self heightForAttributedString:attributedString maxWidth:delegate.windowWidth-20]*2;            
            [delegate.postProductArray replaceObjectAtIndex:0 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"category_id"]];
            [delegate.postProductArray replaceObjectAtIndex:1 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"subcat_id"]];
            [delegate.postProductArray replaceObjectAtIndex:2 withObject:[delegate attributestringtostring:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_title"]]];
            [delegate.postProductArray replaceObjectAtIndex:3 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_description"]];
            //item_description
            [delegate.postProductArray replaceObjectAtIndex:4 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"price"]];
            NSArray * currency = [[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"currency_code"] componentsSeparatedByString:@"-"];
            NSString * currencyformat = [NSString stringWithFormat:@"%@-%@",[currency objectAtIndex:1],[currency objectAtIndex:0]];
            [delegate.postProductArray replaceObjectAtIndex:5 withObject:currencyformat];
            [delegate.postProductArray replaceObjectAtIndex:6 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"item_condition"]];
            [delegate.postProductArray replaceObjectAtIndex:7 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"location"]];
            [delegate.postProductArray replaceObjectAtIndex:10 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"latitude"]];
            [delegate.postProductArray replaceObjectAtIndex:11 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"longitude"]];
            [delegate.postProductArray replaceObjectAtIndex:15 withObject:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"country_id"]];
            
            if([[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"exchange_buy"] uppercaseString] isEqualToString:@"1"]){
                [delegate.postProductArray replaceObjectAtIndex:8 withObject:@"Yes"];
            }else{
                [delegate.postProductArray replaceObjectAtIndex:8 withObject:@"No"];
            }
            
            if([[[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"make_offer"] uppercaseString] isEqualToString:@"1"]){
                [delegate.postProductArray replaceObjectAtIndex:9 withObject:@"Yes"];
            }else{
                [delegate.postProductArray replaceObjectAtIndex:9 withObject:@"No"];
            }

            [delegate.addProductPhotos removeAllObjects];
            if([[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"] count]>=1){
                [delegate.addProductPhotos addObjectsFromArray:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"photos"]];
            }
            
        }
        else
        {
            editorContentHeight = 90;
        }
        
        //FunctionCall
        [self performSelectorOnMainThread:@selector(defaultDataParsing) withObject:nil waitUntilDone:YES];
        [self loadingIndicator];
        [self pickerSetting];
        [self barButtonFunction];
        
    } @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:@"Oops someThing Went Wrong, Check your internet connection"
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    } @finally {
    }
    
    
}
-(void) richtexteditorfunction
{
    //Initialise variables
    self.editorLoaded = NO;
    self.receiveEditorDidChangeEvents = NO;
    self.alwaysShowToolbar = NO;
    self.shouldShowKeyboard = NO;
    self.formatHTML = YES;
    
    //Initalise enabled toolbar items array
    self.enabledToolbarItems = [[NSArray alloc] init];
    
    //Frame for the source view and editor view
    CGRect frame = CGRectMake(5, 48, delegate.windowWidth-20,95);
    
    //Source View
    [self createSourceViewWithFrame:frame];
    
    //Editor View
    [self createEditorViewWithFrame:frame];
    
    //Image Picker used to allow the user insert images from the device (base64 encoded)
    [self setUpImagePicker];
    
    //Scrolling View
    [self createToolBarScroll];
    
    //Toolbar with icons
    [self createToolbar];
    
    //Parent holding view
    [self createParentHoldingView];
    
    //Hide Keyboard
    if (![self isIpad]) {
     
     // Toolbar holder used to crop and position toolbar
     UIView *toolbarCropper = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-44, 0, 44, 44)];
     toolbarCropper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
     toolbarCropper.clipsToBounds = YES;
     
     // Use a toolbar so that we can tint
     UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(-7, -1, 44, 44)];
     [toolbarCropper addSubview:keyboardToolbar];
     
     self.keyboardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSkeyboard.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
     keyboardToolbar.items = @[self.keyboardItem];
     [self.toolbarHolder addSubview:toolbarCropper];
     
     UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.6f, 44)];
     line.backgroundColor = [UIColor lightGrayColor];
     line.alpha = 0.7f;
     [toolbarCropper addSubview:line];
     
     }
     
//     [self.view addSubview:self.toolbarHolder];
//     
//     //Build the toolbar
//     [self buildToolbar];
    
    //Load Resources
    if (!self.resourcesLoaded) {
        
        [self loadResources];
        
    }
}
#pragma mark Attribute string size calculation

- (CGFloat)heightForAttributedString:(NSAttributedString *)text maxWidth:(CGFloat)maxWidth {
    if ([text isKindOfClass:[NSString class]] && !text.length) {
        // no text means no height
        return 0;
    }
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options context:nil].size;
    
    CGFloat height = ceilf(size.height) + 1; // add 1 point as padding
    
    return height;
}

#pragma mark - View will Appear

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];

    [postBtn setUserInteractionEnabled:YES];
    [addproductTableView setUserInteractionEnabled:YES];
    [backBtn setUserInteractionEnabled:YES];
    [Laterbtn setUserInteractionEnabled:YES];

    //Add observers for keyboard showing or hiding notifications
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"] != (NSString*)[NSNull null] && [[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"] != nil){
        [delegate.postProductArray replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"]objectAtIndex:2]]];
        [delegate.postProductArray replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"]objectAtIndex:0]]];
        [delegate.postProductArray replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"addchoosedDataArray"]objectAtIndex:1]]];
    }
    //Appearance
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    [addproductTableView reloadData];
    
    [self performSelectorOnMainThread:@selector(profileDataParsing) withObject:nil waitUntilDone:YES];
//    [self performSelector:@selector(dismissKeyboard) withObject:nil afterDelay:0.6];

}
#pragma mark - View Will Disappear Section
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 4.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_multiColorLoader setFrame:CGRectMake((delegate.windowWidth/2)-15, (delegate.windowHeight-150)/2, 30, 30)];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view bringSubviewToFront:_multiColorLoader];
    [self.view addSubview:_multiColorLoader];
}

-(void) startLoading
{
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
//    [delegate.window setUserInteractionEnabled:NO];
}

-(void) stopLoading
{
    [delegate.window setUserInteractionEnabled:YES];
    [_multiColorLoader setHidden:YES];
//    [_multiColorLoader stopAnimation];
}

#pragma mark - Navigation Items

-(void) barButtonFunction
{
    UIView * leftNaviNaviButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,delegate.windowWidth, 44)];
    [leftNaviNaviButtonView setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem * negativeSpacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]autorelease];
    if (isAboveiOSVersion7)
    {
        negativeSpacer.width = -20;
    }
    else
    {
        negativeSpacer.width = -10;
    }
    
     backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:clearcolor];
    [backBtn setFrame:CGRectMake(0+[HSUtility adjustablePadding],2,45,40)];
     backBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:backBtn];
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"add_your_stuff"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [leftNaviNaviButtonView addSubview:titleLabel];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark  back Button Clicked

-(void)backBtnClicked
{
    if(delegate.editFlag){
        delegate.editImageFlag = YES;
        [delegate.imageCapturedArray removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}



#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1000){
        if(indexPath.section==0){
            //For image scroll
            return 105;
        }else if(indexPath.section==1){
            //Product title and description
            return 147;
        }else if(indexPath.section==2){
            //Product price,category,location
            return 157;
        }else if(indexPath.section==3){
            //Product condition,exchange buy, fixed price
            BOOL productCondition=NO;
            BOOL exchangeBuy=NO;
            BOOL fixedBuy=NO;
            for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"category"] count];i++){
                if ([[delegate.postProductArray objectAtIndex:0] isEqualToString:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_id"]]) {
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"product_condition"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"product_condition"] isEqualToString:@"enable"]){
                            productCondition=YES;
                        }}
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"exchange_buy"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"exchange_buy"] isEqualToString:@"enable"] && delegate.exchangeModuleFlag){
                            exchangeBuy=YES;
                        }
                    }
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"make_offer"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"make_offer"] isEqualToString:@"enable"]){
                            fixedBuy=YES;
                        }
                    }
                }
            }
            CGFloat height=0;
            if(productCondition){
                height+=50;
            }if(exchangeBuy){
                height+=50;
            }if(fixedBuy){
                height+=50;
            }
            if(height==0){
                return 0;
            }
            return height+10;
        }else if(indexPath.section==4){
            //instant_buy
            BOOL instant_buy=NO;
            for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"category"] count];i++){
                if ([[delegate.postProductArray objectAtIndex:0] isEqualToString:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_id"]]) {
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"instant_buy"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"instant_buy"] isEqualToString:@"enable"]){
                            instant_buy=YES;
                        }}
                }
            }
            if(instant_buy)
                if(![[delegate.postProductArray objectAtIndex:12] isEqualToString:@"Yes"])
                    return 100;
                else
                    return 155;
                else
                    return 0;
        }
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(tableView.tag==1000){
        UIView * contentview = [[[UIView alloc]init]autorelease];
        [contentview setBackgroundColor:BackGroundColor];
        
        UIView * lineviewbottom = [[[UIView alloc]init]autorelease];
        [lineviewbottom setBackgroundColor:BackGroundColor];
        
        if(indexPath.section==0){
            [contentview setFrame:CGRectMake(0, 0, delegate.windowWidth, 100)];
            
            UIScrollView *filterScroll=[[UIScrollView alloc] init];
            [filterScroll setFrame:CGRectMake(0, 0, delegate.windowWidth, 100)];
            [filterScroll setShowsVerticalScrollIndicator:YES];
            [filterScroll setScrollEnabled:YES];
            [filterScroll setBackgroundColor:clearcolor];
            for (UIView *subview in filterScroll.subviews) {
                [subview removeFromSuperview];
            }
            [self.view addSubview:filterScroll];
            
            float width=10;//Calculate next image x origin
            
            int count = 0;
            if ([delegate.addProductPhotos count]>=5)
            {
                count = (int)[delegate.addProductPhotos count];
            }
            else
            {
                count = (int)[delegate.addProductPhotos count]+1;
            }
            
            for(int i=0;i<count;i++){
                UIView *Filterview =[[UIView alloc] init];
                [Filterview setBackgroundColor:clearcolor];
                Filterview.layer.masksToBounds=YES;
                [Filterview setFrame:CGRectMake(width,10, 80, 80)];
                
                UIImageView * itemImageView = [[[UIImageView alloc]init]autorelease];
                [itemImageView setFrame:CGRectMake(0, 0, 80, 80)];
                [itemImageView setBackgroundColor:clearcolor];
                itemImageView.layer.cornerRadius=3;
                [itemImageView setUserInteractionEnabled:YES];
                [itemImageView setContentMode:UIViewContentModeScaleAspectFill];
                itemImageView.layer.masksToBounds=YES;
                [Filterview addSubview:itemImageView];
                
                UIButton * filtercloseBtn = [[UIButton alloc] init];
                [filtercloseBtn setTag:i];
                [filtercloseBtn addTarget:self action:@selector(removeFilter:) forControlEvents:UIControlEventTouchUpInside];
                [filtercloseBtn setFrame:CGRectMake(50,0,30,30)];
                
                
                UIButton * filtercloseimage = [[UIButton alloc] init];
                [filtercloseimage setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
                [filtercloseimage setFrame:CGRectMake(55,5,20,20)];
                
                
                if(i+1==count && [delegate.addProductPhotos count]<5){ // For Add Image
                    [itemImageView setImage:[UIImage imageNamed:@"plus_sign.png"]];
                    UITapGestureRecognizer *usergesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editgestureAction:)];
                    [itemImageView addGestureRecognizer:usergesture];
                    itemImageView.userInteractionEnabled = YES;
                }else{
                    if (![[delegate.addProductPhotos objectAtIndex:i]isKindOfClass:[UIImage class]])
                    {
                        [itemImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[delegate.addProductPhotos objectAtIndex:i] objectForKey:@"item_url_main_350"]]]];
                    }
                    else
                    {
                        [itemImageView setImage:[delegate.addProductPhotos objectAtIndex:i]];
                    }
                    
                    [Filterview addSubview:filtercloseimage];
                    [Filterview addSubview:filtercloseBtn];
                    
                }
                [filterScroll addSubview:Filterview];
                width=Filterview.frame.size.width+Filterview.frame.origin.x+7;
            }
            [filterScroll setContentSize:CGSizeMake(width, 45)];
            [contentview addSubview:filterScroll];
        }
        if(indexPath.section==1){
            [contentview setBackgroundColor:whitecolor];
            [contentview setFrame:CGRectMake(0,0,delegate.windowWidth,150)];
            
            UITextView * nameTextView = [[[UITextView alloc]init]autorelease];
            [nameTextView setFrame:CGRectMake(5, 10, delegate.windowWidth-20, 30)];
            [nameTextView setBackgroundColor:[UIColor whiteColor]];
            [nameTextView setKeyboardType:UIKeyboardTypeASCIICapable];
            
            if([[delegate.postProductArray objectAtIndex:2] isEqualToString:@""]){
                [nameTextView setText:[delegate.languageDict objectForKey:@"what_are_you_selling"]];
                [nameTextView setTextColor:headercolor];
            }
            else{
                [nameTextView setText:[delegate.postProductArray objectAtIndex:2]];
                [nameTextView setTextColor:headercolor];
            }
            [nameTextView setFont:textFont];
            [nameTextView setDelegate:self];
            [nameTextView setTag:100];
            if ([[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:2]] length]!=0) {
                [nameTextView setText:[delegate.postProductArray objectAtIndex:2]];
                
            }
            CGFloat topCorrect = ([nameTextView bounds].size.height - [nameTextView contentSize].height * [nameTextView zoomScale])/2.0;
            topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
            nameTextView.contentOffset = (CGPoint){ .x = 0, .y = -topCorrect};
            [nameTextView setTag:100];
            if ([[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:2]] length]!=0) {
                [nameTextView setText:[delegate.postProductArray objectAtIndex:2]];
                [nameTextView setTextColor:headercolor];
            }
            
            UIView * titleline = [[[UIView alloc] init] autorelease];
            [titleline setFrame:CGRectMake(0,53, delegate.windowWidth, 7)];
            [titleline setBackgroundColor:BackGroundColor];
            [contentview addSubview:titleline];
            
            //            UILabel * DescriptionTitlelbl = [[[UILabel alloc] init] autorelease];
            //            [DescriptionTitlelbl setFrame:CGRectMake(14, 44, delegate.windowWidth-20, 20)];
            //            [DescriptionTitlelbl setText:[delegate.languageDict objectForKey:@"describe_your_listing"]];
            //            [DescriptionTitlelbl setTextColor:headercolor];
            //            [DescriptionTitlelbl setFont:titleFont];
            //            [contentview addSubview:DescriptionTitlelbl];
            
            [storyTextview setFont:textFont];
            [storyTextview setTag:101];

            [storyTextview setKeyboardType:UIKeyboardTypeASCIICapable];
            
            if([[delegate.languageDict objectForKey:@"describe_your_listing"] isEqualToString:@""]){
                [storyTextview setText:@""];
                [storyTextview setTextColor:headercolor];
                [self setPlaceholder:[delegate.languageDict objectForKey:@"describe_your_listing"]];
                
            }
            else{
                if (delegate.editFlag)
                {
                    if ([self getText].length==0)
                    {
                        [self setHTML:[delegate.postProductArray objectAtIndex:3]];

                    }
                    else
                    {
                        [self setHTML:[self getHTML]];

                    }

                }
                
                [storyTextview setTextColor:headercolor];

            }
            
            if ([[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:3]] length]!=0) {
                //                NSAttributedString *attributedString = [[NSAttributedString alloc]
                //                                                        initWithData: [[delegate.postProductArray objectAtIndex:3] dataUsingEncoding:NSUnicodeStringEncoding]
                //                                                        options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                //                                                        documentAttributes: nil
                //                                                        error: nil
                //                                                        ];
                //                [storyTextview setAttributedText:attributedString];
                if (delegate.editFlag)
                {
                if ([self getText].length==0)
                {
                    [self setHTML:[delegate.postProductArray objectAtIndex:3]];
                    
                }
                else
                {
                [self setHTML:[self getHTML]];
                }
                }
                
                [storyTextview setFont:textFont];
                [storyTextview setTextColor:headercolor];
            }
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [nameTextView setTextAlignment:NSTextAlignmentRight];
                [storyTextview setTextAlignment:NSTextAlignmentRight];
            }
            
            
            
            [editorscrollView setFrame:CGRectMake(5, 52, delegate.windowWidth-20,95)];
            [editorscrollView setContentSize:CGSizeMake(0,editorContentHeight)];
            
            [editorView setFrame:CGRectMake(0,15, delegate.windowWidth-20,editorView.scrollView.contentSize.height)];
            [editorView.scrollView setScrollEnabled:NO];
            [contentview addSubview:nameTextView];
            [contentview addSubview:storyTextview];
            [contentview addSubview:editorscrollView];
            [editorscrollView addSubview:editorView];

        }
        if(indexPath.section==2){
            [contentview setFrame:CGRectMake(0,10,delegate.windowWidth-0,150)];
            [contentview setBackgroundColor:whitecolor];
            
            UILabel * PriceTitlelbl = [[[UILabel alloc] init] autorelease];
            [PriceTitlelbl setFrame:CGRectMake(10, 10, (delegate.windowWidth/2)-10, 30)];
            [PriceTitlelbl setText:[delegate.languageDict objectForKey:@"price"]];
            [PriceTitlelbl setTextColor:headercolor];
            [PriceTitlelbl setFont:titleFont];
            [contentview addSubview:PriceTitlelbl];
            
            UITextField * PriceTxt = [[[UITextField alloc] init] autorelease];
            [PriceTxt setFrame:CGRectMake((delegate.windowWidth/2)-50, 10, (delegate.windowWidth/2)-40 , 30)];
            if([[delegate.postProductArray objectAtIndex:4] isEqualToString:@""]){
                [PriceTxt setTextColor:Placeholdercolor];
                [PriceTxt setFont:placeholderFont];
                [PriceTxt setPlaceholder:[delegate.languageDict objectForKey:@"enter_your_price"]];
            }else{
                [PriceTxt setTextColor:headercolor];
                [PriceTxt setFont:textFont];
                [PriceTxt setText:[delegate.postProductArray objectAtIndex:4]];
            }
            
            [PriceTxt setTextColor:headercolor];
            [PriceTxt setDelegate:self];
            [PriceTxt setTextAlignment:NSTextAlignmentRight];
            [PriceTxt setTag:501];
            [PriceTxt setKeyboardType:UIKeyboardTypeDecimalPad];
            PriceTxt.inputAccessoryView = numberToolbar;
            [contentview addSubview:PriceTxt];
            
            UIView * priceline = [[[UIView alloc] init] autorelease];
            [priceline setFrame:CGRectMake(delegate.windowWidth-71,10, 1, 30)];
            [priceline setBackgroundColor:BackGroundColor];
            [contentview addSubview:priceline];
            
            
            
            UILabel * currencyLable = [[[UILabel alloc]init]autorelease];
            [currencyLable setFrame:CGRectMake(delegate.windowWidth-70,10,60,30)];
            [currencyLable setFont:titleFont];
            [currencyLable setBackgroundColor:clearcolor];
            [currencyLable setText:[NSString stringWithFormat:@"  %@",[delegate.postProductArray objectAtIndex:5]]];
            [currencyLable setTextColor:AppThemeColor];
            [currencyLable setTextAlignment:NSTextAlignmentCenter];
            [contentview addSubview:currencyLable];
            
            UIButton * currencyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [currencyBtn setFrame:CGRectMake(delegate.windowWidth-70,10,60,30)];
            [currencyBtn addTarget:self action:@selector(currencyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            [contentview addSubview:currencyBtn];
            
            UIView * dividerone = [[[UIView alloc] init] autorelease];
            [dividerone setFrame:CGRectMake(10,50, delegate.windowWidth-20, 1)];
            [dividerone setBackgroundColor:BackGroundColor];
            [contentview addSubview:dividerone];
            
            UILabel * CategoryTitlelbl = [[[UILabel alloc] init] autorelease];
            [CategoryTitlelbl setFrame:CGRectMake(10, 60, (delegate.windowWidth/2)-10, 30)];
            [CategoryTitlelbl setText:[delegate.languageDict objectForKey:@"category"]];
            [CategoryTitlelbl setTextColor:headercolor];
            [CategoryTitlelbl setFont:titleFont];
            [contentview addSubview:CategoryTitlelbl];
            
            UILabel * selectedCategorylbl = [[[UILabel alloc] init] autorelease];
            [selectedCategorylbl setFrame:CGRectMake((delegate.windowWidth/2)-50, 60, (delegate.windowWidth/2) , 30)];
            if([[delegate.postProductArray objectAtIndex:0] isEqualToString:@""]){
                [selectedCategorylbl setText:[delegate.languageDict objectForKey:@"select_your_category"]];
                [selectedCategorylbl setTextColor:Placeholdercolor];
                [selectedCategorylbl setFont:placeholderFont];
            }else{
                for(int i=0;i<[[delegate.getcategoryDict objectForKey:@"category"] count];i++){
                    if ([[delegate.postProductArray objectAtIndex:0] isEqualToString:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_id"]]) {
                        [selectedCategorylbl setText:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_name"]];
                        [selectedCategorylbl setTextColor:headercolor];
                        [selectedCategorylbl setFont:textFont];
                    }
                }
            }
            
            [selectedCategorylbl setTextAlignment:NSTextAlignmentRight];
            [selectedCategorylbl setBackgroundColor:clearcolor];
            [contentview addSubview:selectedCategorylbl];
            
            UIImageView *dropdwnImg = [[[UIImageView alloc] init] autorelease];
            [dropdwnImg setFrame:CGRectMake(delegate.windowWidth-40, 65, 20, 20)];
            [dropdwnImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
            [dropdwnImg setContentMode:UIViewContentModeScaleAspectFit];
            [contentview addSubview:dropdwnImg];
            
            
            
            UIView * dividertwo = [[[UIView alloc] init] autorelease];
            [dividertwo setFrame:CGRectMake(10,100, delegate.windowWidth-20, 1)];
            [dividertwo setBackgroundColor:BackGroundColor];
            [contentview addSubview:dividertwo];
            
            UILabel * Locationlbl = [[[UILabel alloc] init] autorelease];
            [Locationlbl setFrame:CGRectMake(10, 110, (delegate.windowWidth/2)-10, 30)];
            [Locationlbl setText:[delegate.languageDict objectForKey:@"location"]];
            [Locationlbl setTextColor:headercolor];
            [Locationlbl setFont:titleFont];
            [contentview addSubview:Locationlbl];
            
            UILabel * SelectedLocationLbl = [[[UILabel alloc] init] autorelease];
            [SelectedLocationLbl setFrame:CGRectMake((delegate.windowWidth/2)-50, 110, (delegate.windowWidth/2) , 30)];
            [SelectedLocationLbl setNumberOfLines:2];
            if([[delegate.postProductArray objectAtIndex:7] isEqualToString:@""]){
                [SelectedLocationLbl setText:[delegate.languageDict objectForKey:@"change_location"]];
                [SelectedLocationLbl setTextColor:Placeholdercolor];
                [SelectedLocationLbl setFont:placeholderFont];
            }else{
                [SelectedLocationLbl setText:[delegate.postProductArray objectAtIndex:7]];
                [SelectedLocationLbl setTextColor:headercolor];
                [SelectedLocationLbl setFont:placeholderFont];
            }
            [SelectedLocationLbl setTextAlignment:NSTextAlignmentRight];
            [SelectedLocationLbl setBackgroundColor:clearcolor];
            [contentview addSubview:SelectedLocationLbl];
            
            UIImageView *LocationdropdwnImg = [[[UIImageView alloc] init] autorelease];
            [LocationdropdwnImg setFrame:CGRectMake(delegate.windowWidth-40, 115, 20, 20)];
            [LocationdropdwnImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
            [LocationdropdwnImg setContentMode:UIViewContentModeScaleAspectFit];
            [contentview addSubview:LocationdropdwnImg];
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [PriceTitlelbl setFrame:CGRectMake(delegate.windowWidth-185, 10, delegate.windowWidth-200, 30)];
                [PriceTxt setFrame:CGRectMake(90, 10, 100 , 30)];
                [priceline setFrame:CGRectMake(79,10, 1, 30)];
                [currencyLable setFrame:CGRectMake(10,10,60,30)];
                [currencyBtn setFrame:CGRectMake(10,10,60,30)];
                [PriceTitlelbl setTextAlignment:NSTextAlignmentRight];
                [PriceTxt setTextAlignment:NSTextAlignmentLeft];
                [currencyLable setTextAlignment:NSTextAlignmentLeft];
                
                [CategoryTitlelbl setFrame:CGRectMake((delegate.windowWidth/2)+60, 60, (delegate.windowWidth -((delegate.windowWidth/2)+60))-10, 30)];
                [selectedCategorylbl setFrame:CGRectMake(50, 60, (delegate.windowWidth/2) , 30)];
                [dropdwnImg setFrame:CGRectMake(10, 65, 20, 20)];
                [dropdwnImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
                [CategoryTitlelbl setTextAlignment:NSTextAlignmentRight];
                [selectedCategorylbl setTextAlignment:NSTextAlignmentLeft];
                
                [Locationlbl setTextAlignment:NSTextAlignmentRight];
                [SelectedLocationLbl setTextAlignment:NSTextAlignmentLeft];
                [Locationlbl setFrame:CGRectMake((delegate.windowWidth/2)+60, 110, (delegate.windowWidth -((delegate.windowWidth/2)+60))-10, 30)];
                [SelectedLocationLbl setFrame:CGRectMake(50, 110, (delegate.windowWidth/2) , 30)];
                [LocationdropdwnImg setFrame:CGRectMake(10, 115, 20, 20)];
                [LocationdropdwnImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
                
            }
            UIButton *categoryBtn = [[[UIButton alloc] init] autorelease];
            [categoryBtn setFrame:CGRectMake(0, 60, delegate.windowWidth, 30)];
            [categoryBtn addTarget:self action:@selector(redirectToCategory) forControlEvents:UIControlEventTouchUpInside];
            [contentview addSubview:categoryBtn];
            
            UIButton *LocationBtn = [[[UIButton alloc] init] autorelease];
            [LocationBtn setFrame:CGRectMake(0, 110, delegate.windowWidth, 30)];
            [LocationBtn addTarget:self action:@selector(redirectTomap) forControlEvents:UIControlEventTouchUpInside];
            [contentview addSubview:LocationBtn];
            
            
        }
        if(indexPath.section==3){
            [contentview setFrame:CGRectMake(0,10,delegate.windowWidth-0,150)];
            [contentview setBackgroundColor:whitecolor];
            BOOL productCondition=NO;
            BOOL exchangeBuy=NO;
            BOOL fixedBuy=NO;
            for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"category"] count];i++){
                if ([[delegate.postProductArray objectAtIndex:0] isEqualToString:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_id"]]) {
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"product_condition"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"product_condition"] isEqualToString:@"enable"]){
                            productCondition=YES;
                        }}
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"exchange_buy"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"exchange_buy"] isEqualToString:@"enable"] && delegate.exchangeModuleFlag){
                            exchangeBuy=YES;
                        }
                    }
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"make_offer"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"make_offer"] isEqualToString:@"enable"]){
                            fixedBuy=YES;
                        }
                    }
                }
            }
            
            UILabel * Productlbl = [[[UILabel alloc] init] autorelease];
            [Productlbl setFrame:CGRectMake(10, 0, (delegate.windowWidth/2)-10, 50)];
            [Productlbl setText:[delegate.languageDict objectForKey:@"itemcondition"]];
            [Productlbl setTextColor:headercolor];
            [Productlbl setFont:titleFont];
            [contentview addSubview:Productlbl];
            
            UILabel * selectedProductlbl = [[[UILabel alloc] init] autorelease];
            [selectedProductlbl setFrame:CGRectMake((delegate.windowWidth/2)-50, 10, (delegate.windowWidth/2) , 30)];
            if([[delegate.postProductArray objectAtIndex:6] isEqualToString:@""] || [[delegate.postProductArray objectAtIndex:6] isEqualToString:@"0"]){
                [selectedProductlbl setText:@""];
                [selectedProductlbl setTextColor:Placeholdercolor];
                [selectedProductlbl setFont:placeholderFont];
            }else{
                [selectedProductlbl setText:[delegate.postProductArray objectAtIndex:6]];
                [selectedProductlbl setTextColor:headercolor];
                [selectedProductlbl setFont:textFont];
            }
            
            [selectedProductlbl setTextAlignment:NSTextAlignmentRight];
            [selectedProductlbl setBackgroundColor:clearcolor];
            [contentview addSubview:selectedProductlbl];
            
            UIImageView *dropdwnImg = [[[UIImageView alloc] init] autorelease];
            [dropdwnImg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
            [dropdwnImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
            [dropdwnImg setContentMode:UIViewContentModeScaleAspectFit];
            [contentview addSubview:dropdwnImg];
            
            UIButton *ProductBtn = [[[UIButton alloc] init] autorelease];
            [ProductBtn setFrame:CGRectMake(0, 10, delegate.windowWidth, 30)];
            [ProductBtn addTarget:self action:@selector(redirectconditionType) forControlEvents:UIControlEventTouchUpInside];
            [contentview addSubview:ProductBtn];
            
            UIView * dividerone = [[[UIView alloc] init] autorelease];
            [dividerone setFrame:CGRectMake(10,50, delegate.windowWidth-20, 1)];
            [dividerone setBackgroundColor:BackGroundColor];
            [contentview addSubview:dividerone];
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                
                [Productlbl setFrame:CGRectMake((delegate.windowWidth/2)+60, 0, (delegate.windowWidth -((delegate.windowWidth/2)+60))-10, 50)];
                [selectedProductlbl setFrame:CGRectMake(50, 10, (delegate.windowWidth/2) , 30)];
                [dropdwnImg setFrame:CGRectMake(10, 15, 20, 20)];
                [dropdwnImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
                [ProductBtn setFrame:CGRectMake(50, 10, (delegate.windowWidth/2) , 30)];
                [Productlbl setTextAlignment:NSTextAlignmentRight];
                [selectedProductlbl setTextAlignment:NSTextAlignmentLeft];
            }
            if(!productCondition){
                [Productlbl setFrame:CGRectMake(10, 0, (delegate.windowWidth/2)-10, 0)];
                [selectedProductlbl setFrame:CGRectMake((delegate.windowWidth/2)-50, 10, (delegate.windowWidth/2) , 0)];
                [dropdwnImg setFrame:CGRectMake(delegate.windowWidth-40, 10, 30, 0)];
                [ProductBtn setFrame:CGRectMake(0, 10, delegate.windowWidth, 0)];
                [dividerone setFrame:CGRectMake(10,Productlbl.frame.origin.y+Productlbl.frame.size.height, delegate.windowWidth-20, 0)];
            }
            
            UILabel * exchangetobuyLabel = [[[UILabel alloc]init]autorelease];
            [exchangetobuyLabel setFont:titleFont];
            [exchangetobuyLabel setFrame:CGRectMake(10,dividerone.frame.origin.y+dividerone.frame.size.height,delegate.windowWidth-20,50)];
            [exchangetobuyLabel setTextColor:headercolor];
            [exchangetobuyLabel setText:[delegate.languageDict objectForKey:@"exchangetobuy"]];
            [contentview addSubview:exchangetobuyLabel];
            
            //            UIButton * exchangeBtn = [[UIButton alloc] init];
            //            [exchangeBtn setTag:3];
            //            [exchangeBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
            //            [exchangeBtn setFrame:CGRectMake(delegate.windowWidth-55,dividerone.frame.origin.y+dividerone.frame.size.height+3.5,45,45)];
            //            [exchangeBtn addTarget:self action:@selector(expandablecell:) forControlEvents:UIControlEventTouchUpInside];
            //            [contentview addSubview:exchangeBtn];
            
            UISwitch *exchangeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(delegate.windowWidth-65,dividerone.frame.origin.y+dividerone.frame.size.height+10,45,45)];
            [exchangeSwitch setTag:3];
            [exchangeSwitch setOnTintColor:AppThemeColor];
            [exchangeSwitch addTarget:self action:@selector(expandablecell:) forControlEvents:UIControlEventValueChanged];
            [contentview addSubview:exchangeSwitch];
            
            if([[delegate.postProductArray objectAtIndex:8] isEqualToString:@"Yes"]){
                //                [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"selectedmode.png"] forState:UIControlStateNormal];
                
                [exchangeSwitch setOn:YES];
            }else{
                //                [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"deselectedmode.png"] forState:UIControlStateNormal];
                
                [exchangeSwitch setOn:NO];
                
            }
            
            
            UIView * exchangetobuyline = [[[UIView alloc] init] autorelease];
            [exchangetobuyline setFrame:CGRectMake(10,exchangetobuyLabel.frame.origin.y+exchangetobuyLabel.frame.size.height, delegate.windowWidth-20, 1)];
            [exchangetobuyline setBackgroundColor:BackGroundColor];
            [contentview addSubview:exchangetobuyline];
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [exchangetobuyLabel setTextAlignment:NSTextAlignmentRight];
                [exchangetobuyLabel setFrame:CGRectMake(10,dividerone.frame.origin.y+dividerone.frame.size.height,delegate.windowWidth-20,50)];
                //                [exchangeBtn setFrame:CGRectMake(10,dividerone.frame.origin.y+dividerone.frame.size.height+3.5,45,45)];
                
                [exchangeSwitch setFrame:CGRectMake(10,dividerone.frame.origin.y+dividerone.frame.size.height+3.5,45,45)];
                
                [exchangeSwitch setHidden:NO];
                
            }
            
            if(!exchangeBuy){
                [exchangetobuyLabel setFrame:CGRectMake(10,dividerone.frame.origin.y+dividerone.frame.size.height,delegate.windowWidth-20,0)];
                //                [exchangeBtn setFrame:CGRectMake(delegate.windowWidth-55,dividerone.frame.origin.y+dividerone.frame.size.height+3.5,45,0)];
                [exchangeSwitch setFrame:CGRectMake(delegate.windowWidth-55,dividerone.frame.origin.y+dividerone.frame.size.height+3.5,45,0)];
                
                [exchangetobuyline setFrame:CGRectMake(10,exchangetobuyLabel.frame.origin.y+exchangetobuyLabel.frame.size.height, delegate.windowWidth-20, 0)];
                
                [exchangeSwitch setHidden:YES];
                
            }
            
            UILabel * FixedPriceLabel = [[[UILabel alloc]init]autorelease];
            FixedPriceLabel.backgroundColor = whitecolor;
            [FixedPriceLabel setFont:titleFont];
            [FixedPriceLabel setFrame:CGRectMake(10,exchangetobuyline.frame.origin.y+exchangetobuyline.frame.size.height,delegate.windowWidth-20,50)];
            [FixedPriceLabel setTextColor:headercolor];
            [FixedPriceLabel setText:[delegate.languageDict objectForKey:@"fixedprice"]];
            [contentview addSubview:FixedPriceLabel];
            
            //            UIButton * fixedBtn = [[UIButton alloc] init];
            //            [fixedBtn setTag:4];
            //            [fixedBtn setFrame:CGRectMake(delegate.windowWidth-55,exchangetobuyline.frame.origin.y+exchangetobuyline.frame.size.height+3.5,45,45)];
            //            [fixedBtn addTarget:self action:@selector(expandablecell:) forControlEvents:UIControlEventTouchUpInside];
            //            [contentview addSubview:fixedBtn];
            
            UISwitch *fixedSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(delegate.windowWidth-65,exchangetobuyline.frame.origin.y+exchangetobuyline.frame.size.height+10,45,45)];
            [fixedSwitch setOnTintColor:AppThemeColor];
            [fixedSwitch addTarget:self action:@selector(expandablecell:) forControlEvents:UIControlEventValueChanged];
            [contentview addSubview:fixedSwitch];
            [fixedSwitch setTag:4];
            
            
            
            
            if([[delegate.postProductArray objectAtIndex:9] isEqualToString:@"Yes"]){
                //                [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"selectedmode.png"] forState:UIControlStateNormal];
                
                [fixedSwitch setOn:YES animated:NO];
            }else{
                //                [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"deselectedmode.png"] forState:UIControlStateNormal];
                
                [fixedSwitch setOn:NO animated:NO];
                
            }
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [FixedPriceLabel setTextAlignment:NSTextAlignmentRight];
                [fixedSwitch setFrame:CGRectMake(10,exchangetobuyline.frame.origin.y+exchangetobuyline.frame.size.height+3.5,45,45)];
                [fixedSwitch setHidden:NO];
            }
            
            if(!fixedBuy){
                [FixedPriceLabel setFrame:CGRectMake(10,exchangetobuyline.frame.origin.y+exchangetobuyline.frame.size.height,delegate.windowWidth-20,0)];
                [fixedSwitch setFrame:CGRectMake(delegate.windowWidth-55,exchangetobuyline.frame.origin.y+exchangetobuyline.frame.size.height+3.5,45,0)];
                [fixedSwitch setHidden:YES];
                
            }
            [contentview setFrame:CGRectMake(0,10,delegate.windowWidth-0,FixedPriceLabel.frame.origin.y+FixedPriceLabel.frame.size.height)];
        }
        if(indexPath.section==4){
            [contentview setFrame:CGRectMake(0,10,delegate.windowWidth-0,150)];
            [contentview setBackgroundColor:whitecolor];
            BOOL instant_buy=NO;
            for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"category"] count];i++){
                if ([[delegate.postProductArray objectAtIndex:0] isEqualToString:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_id"]]) {
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"instant_buy"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"instant_buy"] isEqualToString:@"enable"]){
                            instant_buy=YES;
                        }}
                }
            }
            
            UILabel * instantlbl = [[[UILabel alloc] init] autorelease];
            [instantlbl setFrame:CGRectMake(10, 0, (delegate.windowWidth/2)-10, 50)];
            [instantlbl setText:[delegate.languageDict objectForKey:@"instantbuy"]];
            [instantlbl setTextColor:headercolor];
            [instantlbl setFont:titleFont];
            [contentview addSubview:instantlbl];
            
            
            //            UIButton * instantBtn = [[UIButton alloc] init];
            //            [instantBtn setTag:5];
            //            [instantBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
            //            [instantBtn setFrame:CGRectMake(delegate.windowWidth-55,3.5,45,45)];
            //            [instantBtn addTarget:self action:@selector(expandablecell:) forControlEvents:UIControlEventTouchUpInside];
            //            [contentview addSubview:instantBtn];
            
            
            UISwitch *instantSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(delegate.windowWidth-65,10,45,45)];
            [instantSwitch addTarget:self action:@selector(expandablecell:) forControlEvents:UIControlEventValueChanged];
            [instantSwitch setOnTintColor:AppThemeColor];

            [contentview addSubview:instantSwitch];
            [instantSwitch setTag:5];
            
            
            
            if([[delegate.postProductArray objectAtIndex:12] isEqualToString:@"Yes"]){
                //                [instantBtn setBackgroundImage:[UIImage imageNamed:@"selectedmode.png"] forState:UIControlStateNormal];
                
                [instantSwitch setOn:YES animated:NO];
                
                
            }else{
                [instantSwitch setOn:NO animated:NO];
            }
            
            
            UIView * instantbuyline = [[[UIView alloc] init] autorelease];
            [instantbuyline setFrame:CGRectMake(10,instantlbl.frame.origin.y+instantlbl.frame.size.height, delegate.windowWidth-20, 1)];
            [instantbuyline setBackgroundColor:BackGroundColor];
            [contentview addSubview:instantbuyline];
            
            
            
            UILabel * paypallbl = [[[UILabel alloc] init] autorelease];
            [paypallbl setFrame:CGRectMake(10, instantbuyline.frame.origin.y+instantbuyline.frame.size.height, (delegate.windowWidth/2)-10, 50)];
            [paypallbl setText:[delegate.languageDict objectForKey:@"paypalID"]];
            [paypallbl setTextColor:headercolor];
            [paypallbl setFont:titleFont];
            [contentview addSubview:paypallbl];
            
            UITextField * paypalTxt = [[[UITextField alloc] init] autorelease];
            [paypalTxt setFrame:CGRectMake((delegate.windowWidth/2)-50, instantbuyline.frame.origin.y+instantbuyline.frame.size.height, (delegate.windowWidth/2)+35, 50)];
            if([[delegate.postProductArray objectAtIndex:13] isEqualToString:@""]){
                [paypalTxt setTextColor:Placeholdercolor];
                [paypalTxt setFont:placeholderFont];
                [paypalTxt setPlaceholder:[delegate.languageDict objectForKey:@"enterpaypalID"]];
                [paypalTxt setKeyboardType:UIKeyboardTypeEmailAddress];
            }else{
                [paypalTxt setTextColor:headercolor];
                [paypalTxt setFont:textFont];
                [paypalTxt setText:[delegate.postProductArray objectAtIndex:13]];
            }
            [paypalTxt setKeyboardType:UIKeyboardTypeEmailAddress];
            [paypalTxt setTextColor:headercolor];
            [paypalTxt setDelegate:self];
            [paypalTxt setTextAlignment:NSTextAlignmentRight];
            [paypalTxt setTag:502];
            [contentview addSubview:paypalTxt];
            
            UIView * paypalline = [[[UIView alloc] init] autorelease];
            [paypalline setFrame:CGRectMake(10,paypalTxt.frame.origin.y+paypalTxt.frame.size.height, delegate.windowWidth-20, 1)];
            [paypalline setBackgroundColor:BackGroundColor];
            [contentview addSubview:paypalline];
            
            UILabel * shippinglbl = [[[UILabel alloc] init] autorelease];
            [shippinglbl setFrame:CGRectMake(10, paypalline.frame.origin.y+paypalline.frame.size.height, (delegate.windowWidth/2)-10, 50)];
            [shippinglbl setText:[delegate.languageDict objectForKey:@"shippingcost"]];
            [shippinglbl setTextColor:headercolor];
            [shippinglbl setFont:titleFont];
            [contentview addSubview:shippinglbl];
            
            UITextField * shippingTxt = [[[UITextField alloc] init] autorelease];
            [shippingTxt setFrame:CGRectMake((delegate.windowWidth/2)-50, paypalline.frame.origin.y+paypalline.frame.size.height, (delegate.windowWidth/2)+35, 50)];
            if([[delegate.postProductArray objectAtIndex:14] isEqualToString:@""]){
                [shippingTxt setTextColor:Placeholdercolor];
                [shippingTxt setFont:placeholderFont];
                [shippingTxt setPlaceholder:[delegate.languageDict objectForKey:@"entershippingcost"]];
            }else{
                [shippingTxt setTextColor:headercolor];
                [shippingTxt setFont:textFont];
                [shippingTxt setText:[delegate.postProductArray objectAtIndex:14]];
            }
            
            [shippingTxt setTextColor:headercolor];
            [shippingTxt setDelegate:self];
            [shippingTxt setTextAlignment:NSTextAlignmentRight];
            [shippingTxt setTag:503];
            [shippingTxt setKeyboardType:UIKeyboardTypeDecimalPad];
            shippingTxt.inputAccessoryView = numberToolbar;
            [contentview addSubview:shippingTxt];
            
            UIView * shippingline = [[[UIView alloc] init] autorelease];
            [shippingline setFrame:CGRectMake(10,shippinglbl.frame.origin.y+shippinglbl.frame.size.height, delegate.windowWidth-20, 1)];
            [shippingline setBackgroundColor:BackGroundColor];
            [contentview addSubview:shippingline];
            if(!instant_buy){
                [instantSwitch setHidden:YES];
                [instantlbl setFrame:CGRectMake(10, 0, (delegate.windowWidth/2)-10, 0)];
                [instantSwitch setFrame:CGRectMake(delegate.windowWidth-55,0,45,0)];
                [instantbuyline setFrame:CGRectMake(10,instantlbl.frame.origin.y+instantlbl.frame.size.height, delegate.windowWidth-20, 0)];
                [paypallbl setFrame:CGRectMake(10, instantbuyline.frame.origin.y+instantbuyline.frame.size.height, (delegate.windowWidth/2)-10, 0)];
                [paypalTxt setFrame:CGRectMake((delegate.windowWidth/2)-50, instantbuyline.frame.origin.y+instantbuyline.frame.size.height, (delegate.windowWidth/2)+35, 0)];
                [paypalline setFrame:CGRectMake(10,paypalTxt.frame.origin.y+paypalTxt.frame.size.height, delegate.windowWidth-20, 0)];
                [shippinglbl setFrame:CGRectMake(10, paypalline.frame.origin.y+paypalline.frame.size.height, (delegate.windowWidth/2)-10, 0)];
                [shippingTxt setFrame:CGRectMake((delegate.windowWidth/2)-50, paypalline.frame.origin.y+paypalline.frame.size.height, (delegate.windowWidth/2)+35, 0)];
                [shippingline setFrame:CGRectMake(10,shippinglbl.frame.origin.y+shippinglbl.frame.size.height, delegate.windowWidth-20, 0)];
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,0)];
                [paypalTxt setHidden:YES];
                [shippingTxt setHidden:YES];
                
            }else{
                if([delegate.languageSelected isEqualToString:@"Arabic"]){
                    [instantSwitch setHidden:NO];
                    [instantlbl setFrame:CGRectMake(10, 0, delegate.windowWidth-20, 50)];
                    [instantSwitch setFrame:CGRectMake(10,3.5,45,45)];
                    [instantlbl setTextAlignment:NSTextAlignmentRight];
                    [paypallbl setTextAlignment:NSTextAlignmentRight];
                    [paypalTxt setTextAlignment:NSTextAlignmentLeft];
                    [shippinglbl setTextAlignment:NSTextAlignmentRight];
                    [shippingTxt setTextAlignment:NSTextAlignmentLeft];
                    [paypallbl setFrame:CGRectMake((delegate.windowWidth/2)+5, instantbuyline.frame.origin.y+instantbuyline.frame.size.height, (delegate.windowWidth/2)-15, 50)];
                    [paypalTxt setFrame:CGRectMake(10, instantbuyline.frame.origin.y+instantbuyline.frame.size.height, (delegate.windowWidth/2)-15, 50)];
                    [shippinglbl setFrame:CGRectMake((delegate.windowWidth/2)+5, paypalline.frame.origin.y+paypalline.frame.size.height, (delegate.windowWidth/2)-15, 50)];
                    [shippingTxt setFrame:CGRectMake(10, paypalline.frame.origin.y+paypalline.frame.size.height, (delegate.windowWidth/2)-15, 50)];
                }
                if(![[delegate.postProductArray objectAtIndex:12] isEqualToString:@"Yes"]){
                    [paypallbl setFrame:CGRectMake(10, instantbuyline.frame.origin.y+instantbuyline.frame.size.height, (delegate.windowWidth/2)-10, 0)];
                    [paypalTxt setFrame:CGRectMake((delegate.windowWidth/2)-50, instantbuyline.frame.origin.y+instantbuyline.frame.size.height, (delegate.windowWidth/2)+35, 0)];
                    [paypalline setFrame:CGRectMake(10,paypalTxt.frame.origin.y+paypalTxt.frame.size.height, delegate.windowWidth-20, 0)];
                    [shippinglbl setFrame:CGRectMake(10, paypalline.frame.origin.y+paypalline.frame.size.height, (delegate.windowWidth/2)-10, 0)];
                    [shippingTxt setFrame:CGRectMake((delegate.windowWidth/2)-50, paypalline.frame.origin.y+paypalline.frame.size.height, (delegate.windowWidth/2)+35, 0)];
                    [shippingline setFrame:CGRectMake(10,shippinglbl.frame.origin.y+shippinglbl.frame.size.height, delegate.windowWidth-20, 0)];
                    [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,0)];
                    [paypalTxt setHidden:YES];
                    [shippingTxt setHidden:YES];
                }
                [contentview setFrame:CGRectMake(0,10,delegate.windowWidth-0,shippingline.frame.origin.y+shippingline.frame.size.height)];
            }
        }
        [cell.contentView addSubview:contentview];
        
    }
    [cell.contentView setBackgroundColor:BackGroundColor];
    [cell setBackgroundColor:BackGroundColor];
    return cell;
}

- (void)tapRecognizerTapped:(UITapGestureRecognizer*)sender {
    
    [self.view endEditing:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[[UIView alloc]init]autorelease];
    [view setFrame:CGRectMake(0,0,0,0)];
    [view setBackgroundColor:whitecolor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma mark  TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    
    if (scrollView.tag==1000)
    {
        if (scrollEnabled)
        {
            [self.view endEditing:YES];
        }
    }
}


#pragma mark - PickerView Initalization

-(void) pickerSetting
{
    pickerSelectedIndex=0;
    
    PickerBGView =[[UIView alloc]init];
    [PickerBGView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-65)];
    [PickerBGView setBackgroundColor:clearcolor];
    [self.view addSubview:PickerBGView];
    
    UIButton * hidePickerBtn = [[[UIButton alloc] init] autorelease];
    [hidePickerBtn setBackgroundImage:[UIImage imageNamed:@"transparentBtn.png"] forState:UIControlStateNormal];
    [hidePickerBtn setFrame:CGRectMake(0, 0, delegate.windowWidth, PickerBGView.frame.size.height-200)];
    [hidePickerBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [PickerBGView addSubview:hidePickerBtn];
    
    pickerview=[[UIView alloc]init];
    [pickerview setFrame:CGRectMake(0,PickerBGView.frame.size.height-250,delegate.windowWidth, 250)];
    [pickerview setBackgroundColor:whitecolor];
    [PickerBGView addSubview:pickerview];
    
    CGRect pickerFrame=CGRectMake(0, 44, delegate.windowWidth, 206);
    myPickerView=[[UIPickerView alloc]initWithFrame:pickerFrame];
    [myPickerView setBackgroundColor:clearcolor];
    myPickerView.delegate=self;
    if (!isAboveiOSVersion7)
    {
        myPickerView.showsSelectionIndicator = YES;
    }
    [pickerview addSubview:myPickerView];
    
    
    UIToolbar *toolBar=[[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 44)]autorelease];
    [toolBar sizeToFit];
    toolBar.translucent=NO;
    toolBar.barTintColor=AppThemeColor;
    
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[delegate.languageDict objectForKey:@"cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *spacer=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]autorelease];
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[delegate.languageDict objectForKey:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton,spacer,doneButton, nil]animated:NO];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:appFontRegular size:15.0], NSFontAttributeName,
                                          whitecolor, NSForegroundColorAttributeName,
                                          nil] forState:UIControlStateNormal];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:appFontRegular size:15.0], NSFontAttributeName,
                                        whitecolor, NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
    [pickerview addSubview:toolBar];
    [PickerBGView setHidden:YES];
}

#pragma mark  Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerIndex==3)
    {
        return [[delegate.addcategoryFilterDict objectForKey:@"currency"]count];
    }
    return 0;
}

#pragma mark  Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component{
    pickerSelectedIndex = (int)row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = headercolor;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont fontWithName:appFontRegular size:14];
    label.text = [NSString stringWithFormat:@" %@", [[[delegate.addcategoryFilterDict objectForKey:@"currency"]objectAtIndex:row]objectForKey:@"symbol"]];
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    return [[[delegate.addcategoryFilterDict objectForKey:@"currency"]objectAtIndex:row]objectForKey:@"symbol"];
}

-(void)cancel
{
    [PickerBGView setHidden:YES];
}

-(void)done
{
    if (pickerIndex==3)
    {
        [delegate.postProductArray replaceObjectAtIndex:5 withObject:[[[delegate.addcategoryFilterDict objectForKey:@"currency"]objectAtIndex:pickerSelectedIndex]objectForKey:@"symbol"]];
    }
    [PickerBGView setHidden:YES];
    [addproductTableView reloadData];
}

#pragma mark - TextFieldDelegate

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    scrollEnabled = NO;
    actifText = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    scrollEnabled = YES;

    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    scrollEnabled = YES;

    [textField resignFirstResponder];
    actifText = nil;
    //for Price text
    if(textField.tag==501){
        [delegate.postProductArray replaceObjectAtIndex:4 withObject:textField.text];
    }else if (textField.tag==502){
        [delegate.postProductArray replaceObjectAtIndex:13 withObject:textField.text];
    }else if (textField.tag==503){
        [delegate.postProductArray replaceObjectAtIndex:14 withObject:textField.text];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                   withString:string];
    if(textField.tag==501){
        {
            
            
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
                    dotLocation = (int)range.location;
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
        
    }if(textField.tag==502){
        return resultText.length <= 30;
    }if(textField.tag==503){
        return resultText.length <= 9;

    }
    else{
        return YES;
    }
    
    
}

#pragma mark - TextView Delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    scrollEnabled = YES;

    if (textView.tag==100)
    {
        if([textView.text isEqualToString:[delegate.languageDict objectForKey:@"what_are_you_selling"]]){
            textView.text = @"";
            [textView setTextColor:headercolor];
        }
    }
    else if (textView.tag==101)
    {
        if([textView.text isEqualToString:[delegate.languageDict objectForKey:@"describe_your_listing"]]){
            [textView setFont:[UIFont fontWithName:appFontRegular size:14]];
            textView.text = @"";
            [self setHTML:@""];
            [textView setTextColor:headercolor];
        }
    }
    return YES;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    scrollEnabled = YES;

    [textView resignFirstResponder];
    if (textView.tag==100)
    {
        if(textView.text.length == 0){
            [textView setText:[delegate.languageDict objectForKey:@"what_are_you_selling"]];
            [textView setTextColor:headercolor];
        }
        [delegate.postProductArray replaceObjectAtIndex:2 withObject:textView.text];
    }
    else if (textView.tag==101)
    {
        if(textView.text.length == 0){
//            [textView setText:[delegate.languageDict objectForKey:@"describe_your_listing"]];
            [textView setTextColor:Placeholdercolor];
            [self setPlaceholder:[delegate.languageDict objectForKey:@"describe_your_listing"]];
        }
        //        [delegate.postProductArray replaceObjectAtIndex:3 withObject:textView.text];
        
        [delegate.postProductArray replaceObjectAtIndex:3 withObject:[self getHTML]];
        
        
    }
    
    else
    {
        //        [delegate.postProductArray replaceObjectAtIndex:3 withObject:textView.text];
        [delegate.postProductArray replaceObjectAtIndex:3 withObject:[self getHTML]];
        
    }
}

-(void) textViewDidChange:(UITextView *)textView
{
   
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        if (textView.tag==100)
        {
            [textView setText:[delegate.languageDict objectForKey:@"what_are_you_selling"]];
            [textView setTextColor:headercolor];
        }
        else if (textView.tag==101)
        {
//            [textView setText:[delegate.languageDict objectForKey:@"describe_your_listing"]];
            [textView setTextColor:Placeholdercolor];
            [self setPlaceholder:[delegate.languageDict objectForKey:@"describe_your_listing"]];
            
                CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
                CGFloat overflow = line.origin.y + line.size.height - ( textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top );
                if ( overflow > 0 ) {
                    // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
                    // Scroll caret to visible area
                    CGPoint offset = textView.contentOffset;
                    offset.y += overflow + 7; // leave 7 pixels margin
                    // Cannot animate with setContentOffset:animated: or caret will not appear
                    [UIView animateWithDuration:.2 animations:^{
                        [textView setContentOffset:offset];
                    }];
                }


        }
        
        else
        {
            [textView setText:@""];
            [textView setTextColor:headercolor];
        }
        [textView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    
    
    
    if([textView.text length]<500){
        if(textView.tag==100)
        {
            

            if([textView.text length]>0){
                NSString *lastChar = [textView.text substringFromIndex:[textView.text length] - 1];
                if([lastChar isEqualToString:@" "]){
                    if([text isEqualToString:lastChar]){
                        return NO;
                    }
                }
            }
            
            NSString *resultText = [textView.text stringByReplacingCharactersInRange:range
                                                                          withString:text];
            
            CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
            CGFloat overflow = line.origin.y + line.size.height - ( textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top );
            if ( overflow > 0 ) {
                // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
                // Scroll caret to visible area
                CGPoint offset = textView.contentOffset;
                offset.y += overflow + 7; // leave 7 pixels margin
                // Cannot animate with setContentOffset:animated: or caret will not appear
                [UIView animateWithDuration:.2 animations:^{
                    [textView setContentOffset:offset];
                }];
            }
            if(![ACCEPTABLE_CHARACTERS containsString:text])
            {
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
                
                NSString *filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                
                return [text isEqualToString:filtered];
            }
            
            /*
             if([text isEqualToString:@"\n"]) {
             [textView resignFirstResponder];
             if(textView.text.length == 0){
             textView.textColor = [UIColor lightGrayColor];
             if (textView.tag==100)
             {
             [textView setText:[delegate.languageDict objectForKey:@"describe_your_listing"]];
             }
             else
             {
             [textView setText:@""];
             }
             }
             }*/
            return resultText.length <= 70;
        }
        else if(textView.tag==101){
            if([textView.text length]>0){
                NSString *lastChar = [textView.text substringFromIndex:[textView.text length] - 1];
                
                if([text isEqualToString:@"\n"]) {
                    [textView resignFirstResponder];
                    if(textView.text.length == 0){
                        textView.textColor = [UIColor lightGrayColor];
                        if (textView.tag==100)
                        {
                            [textView setText:[delegate.languageDict objectForKey:@"what_are_you_selling"]];
                        }
                        else
                        {
                            [textView setText:@""];
                        }
                    }
                }
                
                if([lastChar isEqualToString:@" "]){
                    if([text isEqualToString:lastChar]){
                        return NO;
                    }
                }
            }
            NSString *resultText = [textView.text stringByReplacingCharactersInRange:range
                                                                          withString:text];
            return resultText.length <= 70;
        }
        else
        {
            if([text isEqualToString:@"\n"]) {
                [textView resignFirstResponder];
                if(textView.text.length == 0){
                    textView.textColor = [UIColor lightGrayColor];
                    if (textView.tag==100)
                    {
                        [textView setText:[delegate.languageDict objectForKey:@"what_are_you_selling"]];
                        
                    }
                    else
                    {
                        [textView setText:@""];
                    }
                    [textView resignFirstResponder];
                }
                return NO;
            }
        }
    }else{
        return NO;
    }
    return YES;
}

-(void)doneWithNumberPad
{    [self.view endEditing:YES];
}

/*-(void) keyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame= CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-115);
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        frame.size.height -= keyboardBounds.size.height;
        frame.size.height = frame.size.height+64;
    }
    else
        frame.size.height -= keyboardBounds.size.width;
    
    // Apply new size of table view
    addproductTableView.frame = frame;
    
    // Scroll the table view to see the TextField just above the keyboard
    if (actifText)
    {
        CGRect textFieldRect = [addproductTableView convertRect:actifText.bounds fromView:actifText];
        [addproductTableView scrollRectToVisible:textFieldRect animated:NO];
    }
    
    [UIView commitAnimations];
    
    
}


-(void) keyboardWillHide:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = addproductTableView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Increase size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        frame.size.height += keyboardBounds.size.height;
        frame.size.height = frame.size.height-64;
    }
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Apply new size of table view
    addproductTableView.frame = frame;
    
    [UIView commitAnimations];

} */

#pragma mark - ButtonAction

#pragma mark  GestureAction edit Photos
-(void)editgestureAction:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
    delegate.editImageFlag = YES;
    [delegate.imageCapturedArray removeAllObjects];
    [self.navigationController pushViewController:self.imagePicker animated:YES];
}


#pragma mark  Toggle product condition

-(void) expandablecell:(id) sender{
    int tag =(int)[sender tag];
    NSLog(@"sender:%d",tag);
    if((int)tag==3){
        if([[delegate.postProductArray objectAtIndex:8] isEqualToString:@"Yes"])
            [delegate.postProductArray replaceObjectAtIndex:8 withObject:@"No"];
        else
            [delegate.postProductArray replaceObjectAtIndex:8 withObject:@"Yes"];
    }
    if((int)tag==4){
        if([[delegate.postProductArray objectAtIndex:9] isEqualToString:@"Yes"])
            [delegate.postProductArray replaceObjectAtIndex:9 withObject:@"No"];
        else
            [delegate.postProductArray replaceObjectAtIndex:9 withObject:@"Yes"];
    }if((int)tag==5){
        if([[delegate.postProductArray objectAtIndex:12] isEqualToString:@"Yes"])
            [delegate.postProductArray replaceObjectAtIndex:12 withObject:@"No"];
        else
            [delegate.postProductArray replaceObjectAtIndex:12 withObject:@"Yes"];
    }
    [addproductTableView reloadData];
}

#pragma  mark  Select Curency Button Tapped

-(void)currencyButtonTapped
{
    [self.view endEditing:YES];
    pickerSelectedIndex=0;
    [pickerview setFrame:CGRectMake(0,delegate.windowHeight-304,delegate.windowWidth, 260)];
    [myPickerView setFrame:CGRectMake(0, 44, delegate.windowWidth, 216)];
    pickerIndex = 3;
    [PickerBGView setHidden:NO];
    [myPickerView selectedRowInComponent:0];
    [myPickerView reloadAllComponents];
}

#pragma mark  removePhotos
-(void) removeFilter:(id) sender{
    NSMutableArray * addProductPhotos;
    addProductPhotos = [[NSMutableArray alloc]initWithCapacity:0];
    addProductPhotos =   [delegate.addProductPhotos mutableCopy];
    if (![[delegate.addProductPhotos objectAtIndex:ImageIndex]isKindOfClass:[UIImage class]])
    {
        
        [delegate.removedItemArray addObject:[delegate.addProductPhotos objectAtIndex:(int)[sender tag]]];
    }
    
    [delegate.addProductPhotos removeObjectAtIndex: (int)[sender tag]];
    [addproductTableView reloadData];
}

#pragma mark  redirect to Category
-(void) redirectToCategory
{
    [self.view endEditing:YES];
    [delegate.postProductArray replaceObjectAtIndex:6 withObject:@""];
    AddproductCategory * AddproductCategoryObj = [[AddproductCategory alloc] initWithNibName:@"AddproductCategory" bundle:nil];
    [self.navigationController pushViewController:AddproductCategoryObj animated:NO];
    [AddproductCategoryObj release];
}

#pragma mark  redirect to map
-(void) redirectTomap
{
    [self.view endEditing:YES];
    AddProductMapview * mapViewObj = [[AddProductMapview alloc] initWithNibName:@"AddProductMapview" bundle:nil];
    [self.navigationController pushViewController:mapViewObj animated:NO];
    [mapViewObj release];
}

#pragma mark  redirect to ProductCondition
-(void) redirectconditionType
{
    [self.view endEditing:YES];
    AddproductCondition * AddproductConditionObj = [[AddproductCondition alloc] initWithNibName:@"AddproductCondition" bundle:nil];
    [self.navigationController pushViewController:AddproductConditionObj animated:NO];
    [AddproductConditionObj release];
}

#pragma mark  Redirect to Home
-(void) redirecttoMain
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self.popup hideAnimated:TRUE];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark  Cancel Product edit / new
- (IBAction)LaterBtnTapped:(id)sender {
    [self redirecttoMain];
}

#pragma mark  PostProduct
- (IBAction)postBtnTapped:(id)sender {
    
    [self SaveProductBtnTapped];
}
-(void) SaveProductBtnTapped
{
    [self.view endEditing:YES];
    [delegate.postProductArray replaceObjectAtIndex:3 withObject:[self getHTML]];
    NSString * message=@"";
    if([delegate.addProductPhotos count]==0){
        message=[delegate.languageDict objectForKey:@"uploadimage"];
    }else if([[delegate.postProductArray objectAtIndex:2] isEqualToString:@""] || [[delegate.postProductArray objectAtIndex:2] isEqualToString:[delegate.languageDict objectForKey:@"what_are_you_selling"]]){
        message=[delegate.languageDict objectForKey:@"titlecannotblank"];
    }else if([[self getText] isEqualToString:@""]){
        message=[delegate.languageDict objectForKey:@"descriptioncannotblank"];
    }else if([[delegate.postProductArray objectAtIndex:4] isEqualToString:@""]){
        message=[delegate.languageDict objectForKey:@"pricecannotblank"];
    }
    else if([[delegate.postProductArray objectAtIndex:4]integerValue]==0)
    {
        //Entrez le prix valide
        message=[delegate.languageDict objectForKey:@"entervalidprice"];
    }
    else if([[delegate.postProductArray objectAtIndex:5] isEqualToString:@""]){
        message=[delegate.languageDict objectForKey:@"currencycodenotselected"];
    }else if([[delegate.postProductArray objectAtIndex:0] isEqualToString:@""]){
        message=[delegate.languageDict objectForKey:@"select_category"];
    }
    else if([[delegate.postProductArray objectAtIndex:7] isEqualToString:@""]){
        message=[delegate.languageDict objectForKey:@"locationnotselected"];
    }else if([[delegate.postProductArray objectAtIndex:12] isEqualToString:@"Yes"] && [[delegate.postProductArray objectAtIndex:13] isEqualToString:@""]){
        message = [delegate.languageDict objectForKey:@"enterpaypalID"];
    }else if([[delegate.postProductArray objectAtIndex:12] isEqualToString:@"Yes"] && ![[delegate.postProductArray objectAtIndex:13] isEqualToString:@""] && ![self validateEmail:[delegate.postProductArray objectAtIndex:13]]){
        message = [delegate.languageDict objectForKey:@"enteremail"];
    }else if([[delegate.postProductArray objectAtIndex:12] isEqualToString:@"Yes"] && [[delegate.postProductArray objectAtIndex:14] isEqualToString:@""]){
        message = [delegate.languageDict objectForKey:@"entershippingcost"];
    }
    if(![[delegate.postProductArray objectAtIndex:0] isEqualToString:@""]){
        if([[delegate.postProductArray objectAtIndex:6] isEqualToString:@""]){
            for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"category"] count];i++){
                if ([[delegate.postProductArray objectAtIndex:0] isEqualToString:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_id"]]) {
                    if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"product_condition"] != [NSNull null]){
                        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"product_condition"] isEqualToString:@"enable"]){
                            message=[delegate.languageDict objectForKey:@"Product condition not selected"];
                        }
                    }}}
        }
    }
    
    if([message isEqualToString:@""])
    {
        [postBtn setUserInteractionEnabled:NO];
        [addproductTableView setUserInteractionEnabled:NO];
        [backBtn setUserInteractionEnabled:NO];
        [Laterbtn setUserInteractionEnabled:NO];

        ImageIndex = 0;
        [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:YES];
        [self imageUplaodAndProductUploadFunction:ImageIndex];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  [delegate.languageDict objectForKey:@"alert"] message:message delegate:self
                                                 cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil];
        
        [alertView show];
        [alertView setTag:105];
    }
}
-(BOOL) validateEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    // NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    }
    else
        return YES;
}
#pragma mark - Send Request

#pragma mark load productbeforeAdd

-(void) defaultDataParsing
{
    [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:YES];
    
    
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    [proxy productbeforeadd:apiusername :apipassword:[delegate gettingLanguageCode]];
}
-(void) profileDataParsing
{
    [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:YES];
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    [proxy profile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@""];
}
#pragma mark CallingApiModal
-(void) apiCallingFunction:(NSString*)api_username api_password:(NSString*)api_password type:(NSString *)typesearch price:(NSString *)price search_key:(NSString *)search_key category_id:(NSString *)category_id subcategory_id:(NSString *)subcategory_id user_id:(NSString *)user_id item_id:(NSString *)itemid seller_id:(NSString *)seller_id sorting_id:(NSString *)sorting_id offset:(NSString *)offset limit:(NSString *)limit lat:(NSString *)lat lon:(NSString *)lon posted_within:(NSString *)posted_within distance:(NSString*)distance
{
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    
    [proxy getItems:api_username :api_password :typesearch :price :search_key :category_id :subcategory_id :user_id :itemid :seller_id :sorting_id :offset :limit :lat :lon :posted_within:distance];
}

#pragma mark submit product
-(void)addproduct:(NSString *)api_username api_password:(NSString *)api_password user_id:(NSString *)user_id item_id:(NSString *)edititem_id item_name:(NSString *)item_name item_des:(NSString *)item_des price:(NSString *)price size:(NSString *)size category:(NSString *)category subcategory:(NSString *)subcategory chat_to_buy:(NSString *)chat_to_buy exchange_to_buy:(NSString *)exchange_to_buy currency:(NSString *)currency lat:(NSString *)lat lon:(NSString *)lon address:(NSString *)address shipping_time:(NSString *)shipping_time remove_img:(NSString *)remove_img product_img:(NSString *)product_img shipping_detail:(NSString *)shipping_detail item_condition:(NSString *)item_condition make_offer:(NSString *)make_offer instant_buy:(NSString *)instant_buy paypal_id:(NSString *)paypal_id shipping_cost:(NSString *)shipping_cost country_id:(NSString *)country_id {
    
    
//    item_name = [item_name stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

//    item_des = [item_des stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    NSLog(@"api_username :%@ api_password:%@  user_id:%@   item_name:%@  item_des:%@  price:%@  size:%@  category:%@  subcategory:%@  chat_to_buy:%@  exchange_to_buy:%@  instant_buy:%@  paypal_id:%@  currency:%@  lat:%@  lon:%@  address:%@  shipping_time:%@  remove_img:%@  product_img:%@  shipping_detail:%@  item_condition:%@  make_offer:%@ shipping_cost:%@ country_id:%@",api_username ,api_password ,user_id  ,item_name ,item_des ,price ,size ,category ,subcategory ,chat_to_buy ,exchange_to_buy ,instant_buy ,paypal_id ,currency ,lat ,lon ,address ,shipping_time ,remove_img ,product_img ,shipping_detail ,item_condition ,make_offer ,shipping_cost ,country_id);
    
    
    
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        if (delegate.editFlag)
        {
            [proxy addproduct:api_username: api_password: user_id: edititem_id: item_name: item_des: price: size: category: subcategory: chat_to_buy: exchange_to_buy: currency: lat: lon: address: shipping_time: remove_img: product_img: shipping_detail: item_condition: make_offer: instant_buy: paypal_id: shipping_cost: country_id];
        }else{
            [proxy addproduct:api_username: api_password: user_id: 0: item_name: item_des: price: size: category: subcategory: chat_to_buy: exchange_to_buy: currency: lat: lon: address: shipping_time: remove_img: product_img: shipping_detail: item_condition: make_offer: instant_buy: paypal_id: shipping_cost: country_id];
        }
    }
}

- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSMutableString *outString;
    
    if (inputString)
    {
        outString = [[NSMutableString alloc] initWithString:inputString];
        
        if ([inputString length] > 0)
        {
            NSRange r;
            
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                [outString deleteCharactersInRange:r];
            }
        }
    }
    
    return outString;
}
//- (NSString *)stringByStrippingHTML {
//    NSRange r;
//    NSString *s = [[self copy] autorelease];
//    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
//        s = [s stringByReplacingCharactersInRange:r withString:@""];
//    return s;
//}

#pragma mark - upload image and Submission

-(void) imageUplaodAndProductUploadFunction:(int) productIndex
{
    [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:YES];
    //Upload Photos for product
    if (productIndex<[delegate.addProductPhotos count])
    {
        if (![[delegate.addProductPhotos objectAtIndex:ImageIndex]isKindOfClass:[UIImage class]])
        {
            [responseStr addObject:[delegate.addProductPhotos objectAtIndex:ImageIndex]];
            ImageIndex = ImageIndex+1;
            [self imageUplaodAndProductUploadFunction:ImageIndex];
        }
        else
        {
            [self uploadfunction];
        }
    }
    else
    {
        //Once upload all photos submit data
        int ExchangeBuy=0;
        int InstantBuy=0;
        NSString * FixedPrice=@"0";
        
        if([[delegate.postProductArray objectAtIndex:8] isEqualToString:@"Yes"]){
            ExchangeBuy=1;
        }
        
        for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"category"] count];i++){
            if ([[delegate.postProductArray objectAtIndex:0] isEqualToString:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_id"]]) {
                if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"make_offer"] != [NSNull null]){
                    if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"make_offer"] isEqualToString:@"enable"]){
                        if([[delegate.postProductArray objectAtIndex:9] isEqualToString:@"Yes"]){
                            FixedPrice=@"1";
                        }
                    }else{
                        FixedPrice=@"2";
                    }
                }
                if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"instant_buy"] != [NSNull null]){
                    if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"instant_buy"] isEqualToString:@"enable"]){
                        if([[delegate.postProductArray objectAtIndex:12] isEqualToString:@"Yes"]){
                            InstantBuy=1;
                        }
                    }else{
                        InstantBuy=2;
                        [delegate.postProductArray replaceObjectAtIndex:13 withObject:@""];
                        [delegate.postProductArray replaceObjectAtIndex:14 withObject:@""];
                    }
                }
                if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"product_condition"] != [NSNull null]){
                    if(![[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"product_condition"] isEqualToString:@"enable"]){
                        [delegate.postProductArray replaceObjectAtIndex:6 withObject:@"0"];
                    }
                }
                if([[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"exchange_buy"] != [NSNull null]){
                    if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"exchange_buy"] isEqualToString:@"enable"]){
                        if([[delegate.postProductArray objectAtIndex:8] isEqualToString:@"Yes"]){
                            ExchangeBuy=1;
                        }
                    }else{
                        ExchangeBuy=2;
                    }
                }
                
            }
        }
        
        
        
        NSString *itemcondition = @"0";
        
        NSLog(@"delegate.postProductArray:%@",delegate.postProductArray);
        
        if(![[delegate.postProductArray objectAtIndex:6] isEqualToString:@""]){
            itemcondition=[delegate.postProductArray objectAtIndex:6];
        }
        
        NSString * countryid=[delegate.postProductArray objectAtIndex:15];
        NSArray * currency= [[delegate.postProductArray objectAtIndex:5] componentsSeparatedByString:@"-"];
        NSString * currencyformat = [NSString stringWithFormat:@"%@-%@",[currency objectAtIndex:1],[currency objectAtIndex:0]];
        
        if (delegate.editFlag)
        {
            NSString * removedStr = @"";
            if ([delegate.removedItemArray count]!=0)
            {
                for(int i=0;i<[delegate.removedItemArray count];i++){
                    NSArray *listItems = [[[delegate.removedItemArray objectAtIndex:i] objectForKey:@"item_url_main_350"] componentsSeparatedByString:@"/"];
                    if(i==0){
                        
                        removedStr=[listItems objectAtIndex:[listItems count]-1];
                    }else{
                        removedStr=[removedStr stringByAppendingString:[NSString stringWithFormat:@",%@",[listItems objectAtIndex:[listItems count]-1]]];
                    }
                }
            }
            //            if(![[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"location"] isEqualToString:[delegate.postProductArray objectAtIndex:7]]){
            if(![[delegate.postProductArray objectAtIndex:7] isEqualToString:@""]){
                NSString * address =  [[delegate.postProductArray objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                address = [[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:7]] stringByReplacingOccurrencesOfString:@", "
                                                                                                                                   withString:@","];
                // NSArray* location = [[delegate.postProductArray objectAtIndex:7] componentsSeparatedByString: @","];
                NSArray* location = [address componentsSeparatedByString: @","];
                NSLog(@"location:%@",location);
                NSLog(@"location count:%lu",(unsigned long)[location count]);
                NSString* country =@"";
                if([location count]!=0){
                    country = [location objectAtIndex: [location count]-1];
                    NSLog(@"country:%@",country);
                }else{
                    country = [delegate.postProductArray objectAtIndex:7];
                    NSLog(@"country else:%@",country);
                }
                if([[delegate.addcategoryFilterDict objectForKey:@"country"] count]){
                    for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"country"] count];i++){
                        if([[[[[delegate.addcategoryFilterDict objectForKey:@"country"] objectAtIndex:i] objectForKey:@"country_name"] uppercaseString] isEqualToString:[country uppercaseString]]){
                            NSLog(@"country:%@",[[delegate.addcategoryFilterDict objectForKey:@"country"] objectAtIndex:i]);
                            NSLog(@"country_id:%@",[[[delegate.addcategoryFilterDict objectForKey:@"country"] objectAtIndex:i] objectForKey:@"country_id"]);
                            countryid = [[[delegate.addcategoryFilterDict objectForKey:@"country"] objectAtIndex:i] objectForKey:@"country_id"];
                        }
                    }
                }
            }
            //            }
            else{
                countryid = [delegate.postProductArray objectAtIndex:15];
            }
            
            //            [postProductArray addObject:@""];//0.categoryID
            //            [postProductArray addObject:@""];//1.subcategoryID
            //            [postProductArray addObject:@""];//2.Title
            //            [postProductArray addObject:@""];//3.Description
            //            [postProductArray addObject:@""];//4.Price
            //            [postProductArray addObject:@"USD"];//5.CurrencyCode
            //            [postProductArray addObject:@""];//6.ProductCondition
            //            [postProductArray addObject:@""];//7.Location
            //            [postProductArray addObject:@""];//8.Exchange to Buy
            //            [postProductArray addObject:@""];//9.Fixed Price
            //            [postProductArray addObject:@""];//10.Latitude
            //            [postProductArray addObject:@""];//11.longitude
            //            [postProductArray addObject:@""];//12.Instant_buy
            //            [postProductArray addObject:@""];//13.paypalID
            //            [postProductArray addObject:@""];//14.shippingCost
            //            [postProductArray addObject:@""];//15.countryID
            
            //            NSAttributedString *attributedString = [[NSAttributedString alloc]
            //                                                    initWithData: [[delegate.postProductArray objectAtIndex:3] dataUsingEncoding:NSUnicodeStringEncoding]
            //                                                    options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
            //                                                    documentAttributes: nil
            //                                                    error: nil
            //                                                    ];
            //
            //
            //
            //            NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
            //            NSData *htmlData = [attributedString dataFromRange:NSMakeRange(0, attributedString.length) documentAttributes:documentAttributes error:NULL];
            //            NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
            
            
            //            NSLog(@"%@",htmlString);
            
            //            NSString *htmlString = [delegate.postProductArray objectAtIndex:3];
            
            NSString *string = [self convertHTML:[delegate.postProductArray objectAtIndex:3]];
            
            NSRange range = NSMakeRange(0, string.length);
            
            [string enumerateSubstringsInRange:range
             
                                       options:NSStringEnumerationByParagraphs
             
                                    usingBlock:^(NSString * _Nullable paragraph, NSRange paragraphRange, NSRange enclosingRange, BOOL * _Nonnull stop) {             // ... }];
                                    }];
            
            
            //            NSString * encodedString = [[[[[string stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
            //                                           stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
            //                                          stringByReplacingOccurrencesOfString: @"'" withString: @"&#39;"]
            //                                         stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
            //                                        stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
            
            NSLog(@"%@",[delegate.postProductArray objectAtIndex:3]);
            NSString * encodedString = [self textToHtml:[delegate.postProductArray objectAtIndex:3]];
            
            
            
            NSLog(@"%@",encodedString);
            
            
            [self addproduct:apiusername api_password:apipassword user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"] item_name:[delegate.postProductArray objectAtIndex:2] item_des:encodedString price:[delegate.postProductArray objectAtIndex:4] size:[NSString stringWithFormat:@"%d",0] category:[delegate.postProductArray objectAtIndex:0] subcategory:[delegate.postProductArray objectAtIndex:1] chat_to_buy:[NSString stringWithFormat:@"%d",0] exchange_to_buy:[NSString stringWithFormat:@"%d",ExchangeBuy] currency:currencyformat lat:[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:10]] lon:[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:11]] address:[delegate.postProductArray objectAtIndex:7] shipping_time:@"" remove_img:removedStr  product_img:[responseStr componentsJoinedByString:@","] shipping_detail:@"" item_condition:itemcondition make_offer:FixedPrice instant_buy:[NSString stringWithFormat:@"%d",InstantBuy] paypal_id:[delegate.postProductArray objectAtIndex:13] shipping_cost:[delegate.postProductArray objectAtIndex:14] country_id:countryid];
            
            //            [self addproduct:apiusername api_password:apipassword user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_Id:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"id"] item_name:[delegate.postProductArray objectAtIndex:2] item_des:[delegate.postProductArray objectAtIndex:3] price:[delegate.postProductArray objectAtIndex:4] size:[NSString stringWithFormat:@"%d",0] category:[delegate.postProductArray objectAtIndex:0] subcategory:[delegate.postProductArray objectAtIndex:1] chat_to_buy:[NSString stringWithFormat:@"%d",0] exchange_to_buy:[NSString stringWithFormat:@"%d",ExchangeBuy] instant_buy:[NSString stringWithFormat:@"%d",0] paypal_id:@"" currency:[delegate.postProductArray objectAtIndex:5] lat:[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:10]] lon:[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:11]] address:[delegate.postProductArray objectAtIndex:7] shipping_time:@"" remove_img:removedStr product_img:[responseStr componentsJoinedByString:@","] shipping_detail:@"" item_condition:itemcondition make_offer:FixedPrice];
        }
        else
        {
            if(![[delegate.postProductArray objectAtIndex:7] isEqualToString:@""]){
                // NSArray* location = [[delegate.postProductArray objectAtIndex:7] componentsSeparatedByString: @","];
                NSString * address =  [[delegate.postProductArray objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                address = [[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:7]] stringByReplacingOccurrencesOfString:@", "
                                                                                                                                   withString:@""];
                NSArray* location = [address componentsSeparatedByString: @","];
                NSLog(@"location:%@",location);
                NSLog(@"location count:%lu",(unsigned long)[location count]);
                NSString* country =@"";
                if([location count]!=0){
                    country = [location objectAtIndex: [location count]-1];
                    NSLog(@"country:%@",country);
                }else{
                    country = [delegate.postProductArray objectAtIndex:7];
                    NSLog(@"country else:%@",country);
                }
                if([[delegate.addcategoryFilterDict objectForKey:@"country"] count]){
                    for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"country"] count];i++){
                        if([[[[[delegate.addcategoryFilterDict objectForKey:@"country"] objectAtIndex:i] objectForKey:@"country_name"] uppercaseString] isEqualToString:[country uppercaseString]]){
                            NSLog(@"country:%@",[[delegate.addcategoryFilterDict objectForKey:@"country"] objectAtIndex:i]);
                            NSLog(@"country_id:%@",[[[delegate.addcategoryFilterDict objectForKey:@"country"] objectAtIndex:i] objectForKey:@"country_id"]);
                            countryid = [[[delegate.addcategoryFilterDict objectForKey:@"country"] objectAtIndex:i] objectForKey:@"country_id"];
                            
                        }
                    }
                }
            }
            
            NSString * encodedString = [self textToHtml:[delegate.postProductArray objectAtIndex:3]];
            
            
            
            NSLog(@"%@",encodedString);

            
            [self addproduct:apiusername api_password:apipassword user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"0" item_name:[delegate.postProductArray objectAtIndex:2] item_des:encodedString price:[delegate.postProductArray objectAtIndex:4] size:[NSString stringWithFormat:@"%d",0] category:[delegate.postProductArray objectAtIndex:0] subcategory:[delegate.postProductArray objectAtIndex:1] chat_to_buy:[NSString stringWithFormat:@"%d",0] exchange_to_buy:[NSString stringWithFormat:@"%d",ExchangeBuy] currency:currencyformat lat:[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:10]] lon:[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:11]] address:[delegate.postProductArray objectAtIndex:7] shipping_time:@"" remove_img:@""  product_img:[responseStr componentsJoinedByString:@","] shipping_detail:@"" item_condition:itemcondition make_offer:FixedPrice instant_buy:[NSString stringWithFormat:@"%d",InstantBuy] paypal_id:[delegate.postProductArray objectAtIndex:13] shipping_cost:[delegate.postProductArray objectAtIndex:14] country_id:countryid];
            
            //            [self addproduct:apiusername api_password:apipassword user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_Id:@"0" item_name:[delegate.postProductArray objectAtIndex:2] item_des:[delegate.postProductArray objectAtIndex:3] price:[delegate.postProductArray objectAtIndex:4] size:[NSString stringWithFormat:@"%d",0] category:[delegate.postProductArray objectAtIndex:0] subcategory:[delegate.postProductArray objectAtIndex:1] chat_to_buy:[NSString stringWithFormat:@"%d",0] exchange_to_buy:[NSString stringWithFormat:@"%d",ExchangeBuy] instant_buy:[NSString stringWithFormat:@"%d",0] paypal_id:@"" currency:[delegate.postProductArray objectAtIndex:5] lat:[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:10]] lon:[NSString stringWithFormat:@"%@",[delegate.postProductArray objectAtIndex:11]] address:[delegate.postProductArray objectAtIndex:7] shipping_time:@"" remove_img:@"" product_img:[responseStr componentsJoinedByString:@","] shipping_detail:@"" item_condition:itemcondition make_offer:FixedPrice];
        }
    }
}

- (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    // trim off whitespace
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

- (NSString*)textToHtml:(NSString*)htmlString {
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"  " withString:@""];
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"strong"  withString:@"b"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"em"  withString:@"i"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;div&gt;&nbsp;&nbsp;&lt;br /&gt; &lt;/div&gt;"  withString:@"&lt;br /&gt;"];
    
    
    
    
    
    
    while ([htmlString rangeOfString:@"  "].length > 0) {
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"  " withString:@"&nbsp;"];
    }
    return htmlString;
}

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
    NSString *decodedString = [html stringByDecodingHTMLEntities];
    return decodedString;
}


#pragma mark - ImageUploadFunction

-(void)uploadfunction
{
    if ([delegate.addProductPhotos count]!=0)
    {
        [self performSelectorInBackground:@selector(encodePhotoInBackground:) withObject:[self scaleAndRotateImage:[delegate.addProductPhotos objectAtIndex:ImageIndex]]];
    }
}

#pragma mark  Upload Img Data

- (void)encodePhotoInBackground:(UIImage*)image {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*500;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    [self performSelectorOnMainThread:@selector(saveImageData:) withObject:imageData waitUntilDone:NO];
    [pool release];
}

- (void)saveImageData:(NSData*)imageData
{
    UIImage * image = [UIImage imageWithData:imageData];
    [self uploadProfileImages:image];
}

#pragma mark uploadphoto
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertView *alert;
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"error"]
                                           message:[error localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                 otherButtonTitles:nil];
        [alert  performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:Nil];
}

- (void) uploadProfileImages:(UIImage *)img
{
    NSData *imageData = UIImageJPEGRepresentation(img,1.0);
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    //http://162.243.6.9/beta/imageuploadapi.php
    [request setURL:[NSURL URLWithString:addproducturl]];//need to add url
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"images\"; filename=\"ipodfile.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

// percentage of upload
-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    //        float num = totalBytesWritten;
    //        float total = totalBytesExpectedToWrite;
    //        float percent = num/total;
    //     NSLog(@"%f",percent);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    dict = [returnString JSONValue];
    [responseStr addObject:[[dict objectForKey:@"Image"]objectForKey:@"Name"]];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    ImageIndex = ImageIndex+1;
    sleep(1);
    [self imageUplaodAndProductUploadFunction:ImageIndex];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"failed"] message:@"Image uploading failed" delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [alert release];
    UIActionSheet * addMediaAction=[[UIActionSheet alloc] initWithTitle:@" Your photo could not be uploaded at this time.\t You can save this photo and try to upload it again later" delegate:self
                                                      cancelButtonTitle:[delegate.languageDict objectForKey:@"cancel"]
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:[delegate.languageDict objectForKey:@"save"],@"Dont Save",nil];
    [addMediaAction setTag:1];
    [addMediaAction showInView:self.view];
    [addMediaAction release];
}

#pragma mark Rotate
- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 640; // Or whatever
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution)
    {
        CGFloat ratio = width/height;
        if (ratio > 1)
        {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else
        {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

#pragma mark - WSDL DelegateMethod

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
    [self showAlertconroll:[NSString stringWithFormat:@"Exeption in service %@",method] tag:0];
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
}

-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method{
    NSLog(@"Service %@ Done!",method);
    NSLog(@"data:%@",data);
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    if([method isEqualToString:@"getItems"]){
        if ([[defaultDict objectForKey:@"status"]isEqualToString:@"true"]) {
            [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj testingHomePageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
            delegate.fromAddproduct=@"YES";
            
            [self performSelectorOnMainThread:@selector(poptoitemDetailPage:) withObject:defaultDict waitUntilDone:YES];

        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if ([method isEqualToString:@"productbeforeadd"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [delegate.addcategoryFilterDict removeAllObjects];
        [delegate.addcategoryFilterDict addEntriesFromDictionary:[defaultDict objectForKey:@"result"]];
        NSMutableArray * countryListArray = [[NSMutableArray alloc]initWithCapacity:0];
        [countryListArray addObjectsFromArray:[delegate.addcategoryFilterDict objectForKey:@"country"]];
        for (int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"country"]count]; i++)
        {
            if ([[[[countryListArray objectAtIndex:i]objectForKey:@"country_name"]uppercaseString]isEqualToString:@"OTHERS"])
            {
                [countryListArray removeObjectAtIndex:i];
                [delegate.addcategoryFilterDict setObject:countryListArray forKey:@"country"];
                break;
            }
        }
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    }else if ([method isEqualToString:@"profile"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [userDetailsArray removeAllObjects];
            [userDetailsArray addObject:[defaultDict objectForKey:@"result"]];
            if([[[[userDetailsArray objectAtIndex:0]objectForKey:@"verification"] objectForKey:@"mob_no"] isEqualToString:@"true"]){
                
            }else{
                            UIAlertView *alertView = [[UIAlertView alloc]
                                                      initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                      message:[NSString stringWithFormat:@"Please Verify your mobile number"]
                                                      delegate:self
                                                      cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                                      otherButtonTitles:[delegate.languageDict objectForKey:@"cancel"], nil];
                            [alertView setTag:9210];
                            [alertView show];
            }
        }
        else if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"ERROR"])
        {
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:[[defaultDict objectForKey:@"status"]uppercaseString]
//                                      message:[NSString stringWithFormat:@"%@ Please press ok to signout",[defaultDict objectForKey:@"message"]]
//                                      delegate:self
//                                      cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
//                                      otherButtonTitles:nil, nil];
//            [alertView setTag:921];
//            [alertView show];
        }
    }
    else{
        if ([[defaultDict objectForKey:@"status"]isEqualToString:@"true"])
        {
            item_id=[[defaultDict objectForKey:@"item_id"] intValue];
            {
                NSString * message =[defaultDict objectForKey:@"message"];
                if([[[defaultDict objectForKey:@"message"]uppercaseString ] isEqualToString:@"PRODUCT POSTED SUCCESSFULLY"]){
                    message = [delegate.languageDict objectForKey:@"Product Posted Successfully"];
                }
                else if([[[defaultDict objectForKey:@"message"]uppercaseString] isEqualToString:@"PRODUCT WAITING FOR ADMIN APPROVAL"]){
                    message = [delegate.languageDict objectForKey:@"Product waiting for admin approval"];
                }
                
                else
                {
                    message = [delegate.languageDict objectForKey:[defaultDict objectForKey:@"message"]];
                }

                [self showAlertconroll:message tag:1];
            }
        }
        else
        {
            [self showAlertconroll:[defaultDict objectForKey:@"message"] tag:2];
        }
    }
}
-(void) poptoitemDetailPage:(NSMutableDictionary*)defaultDict
{
    ItemDetailPage * itemDetailPageObj = [[ItemDetailPage alloc]initWithNibName:@"ItemDetailPage" bundle:nil];
    [itemDetailPageObj detailPageArray:[[defaultDict objectForKey:@"result"]objectForKey:@"items"] selectedIndex:0];
    [self.navigationController pushViewController:itemDetailPageObj animated:YES];
    [itemDetailPageObj release];

}


-(void) showAlertconroll:(NSString*)message tag:(int)tag
{
    NSString * subject = @"";
    if (tag==1)
    {
        subject = [delegate.languageDict objectForKey:@"success"];
    }
    else
    {
        subject = @"Error!";
    }
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: subject
                                                                        message: message
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            if (tag==1)
                                                            {
                                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                            }
                                                        }];
    [controller addAction: alertAction];
    [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:) ||
        action == @selector(paste:)||
        action == @selector(cut:))
    {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if(alertView.tag==105){
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
        
        [addproductTableView reloadData];
    }
    else if(alertView.tag==106){
        if (buttonIndex == 0) {
            if(item_id==0)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:[delegate.postProductArray objectAtIndex:2] category_id:[delegate.postProductArray objectAtIndex:0] subcategory_id:[delegate.postProductArray objectAtIndex:1] user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:[NSString stringWithFormat:@"%d",item_id] seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",1] offset:@"0" limit:@"1" lat:@"" lon:@"" posted_within:@"" distance:@""];
            }
        }
    } else if(alertView.tag==9210){
        if (buttonIndex == 0) {
            EditProfile * EditProfilePageObj = [[EditProfile alloc]initWithNibName:@"EditProfile" bundle:nil];
            [self.navigationController pushViewController:EditProfilePageObj animated:NO];
            [EditProfilePageObj release];
            
        }else{
            [delegate.tabViewControllerObj.tabBarController selectTab:0];

//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag!=1){
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([[touch.view class] isSubclassOfClass:[UITableView class]])
    {
        [self.view endEditing:YES];
    }
}

#pragma mark RichTextEditor
#pragma mark - Set Up View Section
- (void)createSourceViewWithFrame:(CGRect)frame {
    
    storyTextview = [[ZSSTextView alloc] initWithFrame:CGRectMake(0, 58, delegate.windowWidth-20,1195)];
    [storyTextview setTextAlignment:NSTextAlignmentRight];
    [storyTextview setTag:101];
    storyTextview.hidden = YES;
    storyTextview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    storyTextview.autocorrectionType = UITextAutocorrectionTypeNo;
    //storyTextview.font = [UIFont fontWithName:appFontRegular size:13.0];
    [storyTextview setFont:textFont];
//    storyTextview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    storyTextview.autoresizesSubviews = YES;
    storyTextview.delegate = self;
    for (id subview in storyTextview.subviews)
        if ([[subview class] isSubclassOfClass: [UITextView class]])
            ((UITextView *)subview).delegate = self;

    [storyTextview setBackgroundColor:[UIColor redColor]];
    //    [self.view addSubview:storyTextview];
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [storyTextview setTextAlignment:NSTextAlignmentRight];
    }
    

    
}

- (void)createEditorViewWithFrame:(CGRect)frame {
    
    editorscrollView = [UIScrollView new];
    editorView = [[UIWebView alloc] initWithFrame:frame];
    editorView.opaque = NO;
//    [editorView.layer setBorderColor:[UIColor redColor].CGColor];
//    [editorView.layer setBorderWidth:1];
    editorView.scrollView.scrollEnabled = false;
    [editorView setHidden:NO];
    editorView.delegate = self;
    [editorView setBackgroundColor:[UIColor yellowColor]];
    editorView.hidesInputAccessoryView = YES;
    editorView.keyboardDisplayRequiresUserAction = NO;
    //    editorView.scalesPageToFit = YES;
//    editorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    editorView.dataDetectorTypes = UIDataDetectorTypeNone;
//    editorView.scalesPageToFit=TRUE;
    editorView.scrollView.bounces = NO;
    editorView.backgroundColor = [UIColor clearColor];
    
    for (id subview in editorView.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    
    
    
}


- (void)setUpImagePicker {
    
    self.myimagePicker = [[UIImagePickerController alloc] init];
    self.myimagePicker.delegate = self;
    self.myimagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.myimagePicker.allowsEditing = YES;
    self.selectedImageScale = kDefaultScale; //by default scale to half the size
    
}

- (void)createToolBarScroll {
    
    self.toolBarScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self isIpad] ? self.view.frame.size.width : self.view.frame.size.width - 44, 44)];
    self.toolBarScroll.backgroundColor = [UIColor clearColor];
    self.toolBarScroll.showsHorizontalScrollIndicator = NO;
    
}

- (void)createToolbar {
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.toolbar.backgroundColor = [UIColor clearColor];
    [self.toolBarScroll addSubview:self.toolbar];
    self.toolBarScroll.autoresizingMask = self.toolbar.autoresizingMask;
    
}

- (void)createParentHoldingView {
    
    //Background Toolbar
    UIToolbar *backgroundToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    backgroundToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //Parent holding view
    self.toolbarHolder = [[UIView alloc] init];
    
    if (_alwaysShowToolbar) {
        self.toolbarHolder.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    } else {
        self.toolbarHolder.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    }
    
    self.toolbarHolder.autoresizingMask = self.toolbar.autoresizingMask;
    [self.toolbarHolder addSubview:self.toolBarScroll];
    [self.toolbarHolder insertSubview:backgroundToolbar atIndex:0];
    
}

#pragma mark - Resources Section

- (void)loadResources {
    
    //Define correct bundle for loading resources
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    
    //Create a string with the contents of editor.html
    NSString *filePath = [bundle pathForResource:@"editor" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
//    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];

    //Add jQuery.js to the html file
    NSString *jquery = [bundle pathForResource:@"jQuery" ofType:@"js"];
    NSString *jqueryString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:jquery] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jQuery -->" withString:jqueryString];
    
    //Add JSBeautifier.js to the html file
    NSString *beautifier = [bundle pathForResource:@"JSBeautifier" ofType:@"js"];
    NSString *beautifierString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:beautifier] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jsbeautifier -->" withString:beautifierString];
    
    //Add ZSSRichTextEditor.js to the html file
    NSString *source = [bundle pathForResource:@"ZSSRichTextEditor" ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
    [storyTextview setTextColor:headercolor];
    [storyTextview setFont:textFont];
    
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [editorView loadHTMLString:[NSString stringWithFormat:@"<div dir='rtl'>%@<div>",htmlString] baseURL:self.baseURL];
    }else{
        [editorView loadHTMLString:[NSString stringWithFormat:@"<font face=%@ size=2 color=#464e55>%@",appFontRegular, htmlString] baseURL:self.baseURL];
    }
    //[editorView loadHTMLString:htmlString baseURL:self.baseURL];
    self.resourcesLoaded = YES;
    [self.view endEditing:YES];
    
}

#pragma mark - Toolbar Section

- (void)setEnabledToolbarItems:(NSArray *)enabledToolbarItems {
    
    _enabledToolbarItems = enabledToolbarItems;
    [self buildToolbar];
    
}


- (void)setToolbarItemTintColor:(UIColor *)toolbarItemTintColor {
    
    _toolbarItemTintColor = toolbarItemTintColor;
    
    // Update the color
    for (ZSSBarButtonItem *item in self.toolbar.items) {
        item.tintColor = [self barButtonItemDefaultColor];
    }
    self.keyboardItem.tintColor = toolbarItemTintColor;
    
}


- (void)setToolbarItemSelectedTintColor:(UIColor *)toolbarItemSelectedTintColor {
    
    _toolbarItemSelectedTintColor = toolbarItemSelectedTintColor;
    
}

- (NSArray *)itemsForToolbar {
    
    //Define correct bundle for loading resources
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    // None
    if(_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarNone])
    {
        return items;
    }
    
    BOOL customOrder = NO;
    if (_enabledToolbarItems && ![_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll]){
        customOrder = YES;
        for(int i=0; i < _enabledToolbarItems.count;i++){
            [items addObject:@""];
        }
    }
    
    // Bold
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarBold]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *bold = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSbold.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setBold)];
        bold.label = @"bold";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarBold] withObject:bold];
        } else {
            [items addObject:bold];
        }
    }
    
    // Italic
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarItalic]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *italic = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSitalic.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setItalic)];
        italic.label = @"italic";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarItalic] withObject:italic];
        } else {
            [items addObject:italic];
        }
    }
    
    // Subscript
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarSubscript]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *subscript = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSsubscript.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setSubscript)];
        subscript.label = @"subscript";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarSubscript] withObject:subscript];
        } else {
            [items addObject:subscript];
        }
    }
    
    // Superscript
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarSuperscript]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *superscript = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSsuperscript.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setSuperscript)];
        superscript.label = @"superscript";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarSuperscript] withObject:superscript];
        } else {
            [items addObject:superscript];
        }
    }
    
    /*// Strike Through
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarStrikeThrough]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *strikeThrough = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSstrikethrough.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setStrikethrough)];
     strikeThrough.label = @"strikeThrough";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarStrikeThrough] withObject:strikeThrough];
     } else {
     [items addObject:strikeThrough];
     }
     }
     
     // Underline
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarUnderline]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *underline = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSunderline.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setUnderline)];
     underline.label = @"underline";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarUnderline] withObject:underline];
     } else {
     [items addObject:underline];
     }
     }
     
     // Remove Format
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarRemoveFormat]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *removeFormat = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSclearstyle.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(removeFormat)];
     removeFormat.label = @"removeFormat";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarRemoveFormat] withObject:removeFormat];
     } else {
     [items addObject:removeFormat];
     }
     }
     
     //  Fonts
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarFonts]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     
     ZSSBarButtonItem *fonts = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSfonts.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(showFontsPicker)];
     fonts.label = @"fonts";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarFonts] withObject:fonts];
     } else {
     [items addObject:fonts];
     }
     
     }
     
     // Undo
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarUndo]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *undoButton = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSundo.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(undo:)];
     undoButton.label = @"undo";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarUndo] withObject:undoButton];
     } else {
     [items addObject:undoButton];
     }
     }
     
     // Redo
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarRedo]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *redoButton = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSredo.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(redo:)];
     redoButton.label = @"redo";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarRedo] withObject:redoButton];
     } else {
     [items addObject:redoButton];
     }
     }*/
    
    // Align Left
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarJustifyLeft]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *alignLeft = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSleftjustify.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(alignLeft)];
        alignLeft.label = @"justifyLeft";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarJustifyLeft] withObject:alignLeft];
        } else {
            [items addObject:alignLeft];
        }
    }
    
    // Align Center
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarJustifyCenter]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *alignCenter = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSScenterjustify.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(alignCenter)];
        alignCenter.label = @"justifyCenter";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarJustifyCenter] withObject:alignCenter];
        } else {
            [items addObject:alignCenter];
        }
    }
    
    // Align Right
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarJustifyRight]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *alignRight = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSrightjustify.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(alignRight)];
        alignRight.label = @"justifyRight";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarJustifyRight] withObject:alignRight];
        } else {
            [items addObject:alignRight];
        }
    }
    
    // Align Justify
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarJustifyFull]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *alignFull = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSforcejustify.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(alignFull)];
        alignFull.label = @"justifyFull";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarJustifyFull] withObject:alignFull];
        } else {
            [items addObject:alignFull];
        }
    }
    
    // Paragraph
    if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarParagraph]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
        ZSSBarButtonItem *paragraph = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSparagraph.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(paragraph)];
        paragraph.label = @"p";
        if (customOrder) {
            [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarParagraph] withObject:paragraph];
        } else {
            [items addObject:paragraph];
        }
    }
    /*
     // Header 1
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarH1]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *h1 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh1.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(heading1)];
     h1.label = @"h1";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarH1] withObject:h1];
     } else {
     [items addObject:h1];
     }
     }
     
     // Header 2
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarH2]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *h2 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh2.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(heading2)];
     h2.label = @"h2";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarH2] withObject:h2];
     } else {
     [items addObject:h2];
     }
     }
     
     // Header 3
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarH3]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *h3 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh3.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(heading3)];
     h3.label = @"h3";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarH3] withObject:h3];
     } else {
     [items addObject:h3];
     }
     }
     
     // Heading 4
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarH4]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *h4 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh4.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(heading4)];
     h4.label = @"h4";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarH4] withObject:h4];
     } else {
     [items addObject:h4];
     }
     }
     
     // Header 5
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarH5]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *h5 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh5.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(heading5)];
     h5.label = @"h5";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarH5] withObject:h5];
     } else {
     [items addObject:h5];
     }
     }
     
     // Heading 6
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarH6]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *h6 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh6.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(heading6)];
     h6.label = @"h6";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarH6] withObject:h6];
     } else {
     [items addObject:h6];
     }
     }
     
     // Text Color
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarTextColor]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *textColor = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSStextcolor.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(textColor)];
     textColor.label = @"textColor";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarTextColor] withObject:textColor];
     } else {
     [items addObject:textColor];
     }
     }
     
     // Background Color
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarBackgroundColor]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *bgColor = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSbgcolor.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(bgColor)];
     bgColor.label = @"backgroundColor";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarBackgroundColor] withObject:bgColor];
     } else {
     [items addObject:bgColor];
     }
     }
     
     // Unordered List
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarUnorderedList]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *ul = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSunorderedlist.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setUnorderedList)];
     ul.label = @"unorderedList";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarUnorderedList] withObject:ul];
     } else {
     [items addObject:ul];
     }
     }
     
     // Ordered List
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarOrderedList]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *ol = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSorderedlist.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setOrderedList)];
     ol.label = @"orderedList";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarOrderedList] withObject:ol];
     } else {
     [items addObject:ol];
     }
     }
     
     // Horizontal Rule
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarHorizontalRule]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *hr = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSShorizontalrule.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setHR)];
     hr.label = @"horizontalRule";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarHorizontalRule] withObject:hr];
     } else {
     [items addObject:hr];
     }
     }
     
     // Indent
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarIndent]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *indent = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSindent.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setIndent)];
     indent.label = @"indent";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarIndent] withObject:indent];
     } else {
     [items addObject:indent];
     }
     }
     
     // Outdent
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarOutdent]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *outdent = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSoutdent.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(setOutdent)];
     outdent.label = @"outdent";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarOutdent] withObject:outdent];
     } else {
     [items addObject:outdent];
     }
     }
     
     // Image
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarInsertImage]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *insertImage = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSimage.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(insertImage)];
     insertImage.label = @"image";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarInsertImage] withObject:insertImage];
     } else {
     [items addObject:insertImage];
     }
     }
     
     // Image From Device
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarInsertImageFromDevice]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *insertImageFromDevice = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSimageDevice.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(insertImageFromDevice)];
     insertImageFromDevice.label = @"imageFromDevice";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarInsertImageFromDevice] withObject:insertImageFromDevice];
     } else {
     [items addObject:insertImageFromDevice];
     }
     }
     
     // Insert Link
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarInsertLink]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *insertLink = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSlink.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(insertLink)];
     insertLink.label = @"link";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarInsertLink] withObject:insertLink];
     } else {
     [items addObject:insertLink];
     }
     }
     
     // Remove Link
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarRemoveLink]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *removeLink = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSunlink.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(removeLink)];
     removeLink.label = @"removeLink";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarRemoveLink] withObject:removeLink];
     } else {
     [items addObject:removeLink];
     }
     }
     
     // Quick Link
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarQuickLink]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *quickLink = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSquicklink.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(quickLink)];
     quickLink.label = @"quickLink";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarQuickLink] withObject:quickLink];
     } else {
     [items addObject:quickLink];
     }
     }
     
     // Show Source
     if ((_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarViewSource]) || (_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarAll])) {
     ZSSBarButtonItem *showSource = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSviewsource.png" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(showHTMLSource:)];
     showSource.label = @"source";
     if (customOrder) {
     [items replaceObjectAtIndex:[_enabledToolbarItems indexOfObject:ZSSRichTextEditorToolbarViewSource] withObject:showSource];
     } else {
     [items addObject:showSource];
     }
     }
     */
    return [NSArray arrayWithArray:items];
    
}


- (void)buildToolbar {
    
    // Check to see if we have any toolbar items, if not, add them all
    NSArray *items = [self itemsForToolbar];
    if (items.count == 0 && !(_enabledToolbarItems && [_enabledToolbarItems containsObject:ZSSRichTextEditorToolbarNone])) {
        _enabledToolbarItems = @[ZSSRichTextEditorToolbarAll];
        items = [self itemsForToolbar];
    }
    
    if (self.customZSSBarButtonItems != nil) {
        items = [items arrayByAddingObjectsFromArray:self.customZSSBarButtonItems];
    }
    
    // get the width before we add custom buttons
    CGFloat toolbarWidth = items.count == 0 ? 0.0f : (CGFloat)(items.count * 39) - 10;
    
    if(self.customBarButtonItems != nil)
    {
        items = [items arrayByAddingObjectsFromArray:self.customBarButtonItems];
        for(ZSSBarButtonItem *buttonItem in self.customBarButtonItems)
        {
            toolbarWidth += buttonItem.customView.frame.size.width + 11.0f;
        }
    }
    
    self.toolbar.items = items;
    for (ZSSBarButtonItem *item in items) {
        item.tintColor = [self barButtonItemDefaultColor];
    }
    
    self.toolbar.frame = CGRectMake(0, 0, toolbarWidth, 44);
    self.toolBarScroll.contentSize = CGSizeMake(self.toolbar.frame.size.width, 44);
}


#pragma mark - Editor Modification Section

- (void)setCSS:(NSString *)css {
    
    self.customCSS = css;
    
    if (self.editorLoaded) {
        [self updateCSS];
    }
    
}

- (void)updateCSS {
    
    
    
    if (self.customCSS != NULL && [self.customCSS length] != 0) {
        
        NSString *js = [NSString stringWithFormat:@"zss_editor.setCustomCSS(\"%@\");", self.customCSS];
        [editorView stringByEvaluatingJavaScriptFromString:js];
        
    }
    
}

- (void)setPlaceholderText {
    
    //Call the setPlaceholder javascript method if a placeholder has been set
    if (self.placeholder != NULL && [self.placeholder length] != 0) {
        
        NSString *js = [NSString stringWithFormat:@"zss_editor.setPlaceholder(\"%@\");", self.placeholder];
        
        [editorView stringByEvaluatingJavaScriptFromString:js];
        
    }
    
}

- (void)setFooterHeight:(float)footerHeight {
    
    //Call the setFooterHeight javascript method
    
    
    NSString *js = [NSString stringWithFormat:@"zss_editor.setFooterHeight(\"%f\");", footerHeight];
    [editorView stringByEvaluatingJavaScriptFromString:js];
    
}

- (void)setContentHeight:(float)contentHeight {
    
    
    
    //Call the contentHeight javascript method
    NSString *js = [NSString stringWithFormat:@"zss_editor.contentHeight = %f;", contentHeight];
    [editorView stringByEvaluatingJavaScriptFromString:js];
    
}

#pragma mark - Editor Interaction

- (void)focusTextEditor {
    
    editorView.keyboardDisplayRequiresUserAction = NO;
    NSString *js = [NSString stringWithFormat:@"zss_editor.focusEditor();"];
    [editorView stringByEvaluatingJavaScriptFromString:js];
}

- (void)blurTextEditor {
    
    NSString *js = [NSString stringWithFormat:@"zss_editor.blurEditor();"];
    [editorView stringByEvaluatingJavaScriptFromString:js];
}

- (void)setHTML:(NSString *)html {
    
    self.internalHTML = html;
    
    if (self.editorLoaded) {
        [self updateHTML];
    }
    
}

- (void)updateHTML {
    
    NSString *html = self.internalHTML;
    storyTextview.text = html;
    NSString *cleanedHTML = [self removeQuotesFromHTML:storyTextview.text];
//    [self.itemSummary loadHTMLString:[NSString stringWithFormat:@"<html><body p style='color:red' text=\"#FFFFFF\" face=\"Bookman Old Style, Book Antiqua, Garamond\" size=\"5\">%@</body></html>", [item objectForKey:@"description"]] baseURL: nil];
    //<html><body p style='color:red'
//    >zss_editor.setHTML(\"%@\");</body></html>
//                        NSString *trigger = [NSString stringWithFormat:@"zss_editor.setHTML(\"%@\");", cleanedHTML];
   // NSString *trigger = [NSString stringWithFormat:@"<html><body p style='color:red'>zss_editor.setHTML(\"%@\");</body></html>", cleanedHTML];
     NSString *trigger = [NSString stringWithFormat:@"zss_editor.setHTML(\"%@\");", cleanedHTML];
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    NSLog(@"%f",editorView.scrollView.contentSize.height);
    NSLog(@"%f",editorContentHeight);
    
    [editorscrollView setContentSize:CGSizeMake(0,editorContentHeight)];
    [editorView setFrame:CGRectMake(0,15, delegate.windowWidth-20,editorContentHeight)];


}

- (NSString *)getHTML {
    
    
    NSString *html = [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.getHTML();"];
    html = [self removeQuotesFromHTML:html];
    html = [self tidyHTML:html];
    return html;
    
}


- (void)insertHTML:(NSString *)html {
    
    
    NSString *cleanedHTML = [self removeQuotesFromHTML:html];
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.insertHTML(\"%@\");", cleanedHTML];
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
    
}

- (NSString *)getText {
    
    

    if(editorView.scrollView.contentSize.height!=95)
    {
    [editorscrollView setContentSize:CGSizeMake(0,editorView.scrollView.contentSize.height)];
    editorContentHeight = editorView.scrollView.contentSize.height;
    [editorView setFrame:CGRectMake(0,15, delegate.windowWidth-20,editorView.scrollView.contentSize.height)];
    }

    
    return [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.getText();"];
    
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)showHTMLSource:(ZSSBarButtonItem *)barButtonItem {
    
    
    if (storyTextview.hidden) {
        storyTextview.text = [self getHTML];
        storyTextview.hidden = NO;
        barButtonItem.tintColor = [UIColor blackColor];
        editorView.hidden = YES;
        [self enableToolbarItems:NO];
    } else {
        [self setHTML:storyTextview.text];
        barButtonItem.tintColor = [self barButtonItemDefaultColor];
        storyTextview.hidden = YES;
        editorView.hidden = NO;
        [self enableToolbarItems:YES];
    }
}

- (void)removeFormat {
    
    NSString *trigger = @"zss_editor.removeFormating();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)alignLeft {
    
    
    NSString *trigger = @"zss_editor.setJustifyLeft();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)alignCenter {
    
    
    NSString *trigger = @"zss_editor.setJustifyCenter();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)alignRight {
    
    
    NSString *trigger = @"zss_editor.setJustifyRight();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)alignFull {
    
    NSString *trigger = @"zss_editor.setJustifyFull();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setBold {
    
    
    NSString *trigger = @"zss_editor.setBold();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setItalic {
    
    
    NSString *trigger = @"zss_editor.setItalic();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setSubscript {
    
    
    NSString *trigger = @"zss_editor.setSubscript();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setUnderline {
    
    
    NSString *trigger = @"zss_editor.setUnderline();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setSuperscript {
    
    
    NSString *trigger = @"zss_editor.setSuperscript();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setStrikethrough {
    
    
    NSString *trigger = @"zss_editor.setStrikeThrough();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setUnorderedList {
    
    
    NSString *trigger = @"zss_editor.setUnorderedList();";
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setOrderedList {
    NSString *trigger = @"zss_editor.setOrderedList();";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setHR {
    NSString *trigger = @"zss_editor.setHorizontalRule();";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setIndent {
    NSString *trigger = @"zss_editor.setIndent();";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setOutdent {
    NSString *trigger = @"zss_editor.setOutdent();";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading1 {
    NSString *trigger = @"zss_editor.setHeading('h1');";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading2 {
    NSString *trigger = @"zss_editor.setHeading('h2');";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading3 {
    NSString *trigger = @"zss_editor.setHeading('h3');";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading4 {
    NSString *trigger = @"zss_editor.setHeading('h4');";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading5 {
    NSString *trigger = @"zss_editor.setHeading('h5');";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading6 {
    NSString *trigger = @"zss_editor.setHeading('h6');";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)paragraph {
    NSString *trigger = @"zss_editor.setParagraph();";
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)showFontsPicker {
    
    // Save the selection location
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    //Call picker
    ZSSFontsViewController *fontPicker = [ZSSFontsViewController cancelableFontPickerViewControllerWithFontFamily:ZSSFontFamilyDefault];
    fontPicker.delegate = self;
    [self.navigationController pushViewController:fontPicker animated:YES];
    
}

- (void)setSelectedFontFamily:(ZSSFontFamily)fontFamily {
    
    NSString *fontFamilyString;
    
    switch (fontFamily) {
        case ZSSFontFamilyDefault:
            fontFamilyString = @"Arial, Helvetica, sans-serif";
            break;
            
        case ZSSFontFamilyGeorgia:
            fontFamilyString = @"Georgia, serif";
            break;
            
        case ZSSFontFamilyPalatino:
            fontFamilyString = @"Palatino Linotype, Book Antiqua, Palatino, serif";
            break;
            
        case ZSSFontFamilyTimesNew:
            fontFamilyString = @"Times New Roman, Times, serif";
            break;
            
        case ZSSFontFamilyTrebuchet:
            fontFamilyString = @"Trebuchet MS, Helvetica, sans-serif";
            break;
            
        case ZSSFontFamilyVerdana:
            fontFamilyString = @"Verdana, Geneva, sans-serif";
            break;
            
        case ZSSFontFamilyCourierNew:
            fontFamilyString = @"Courier New, Courier, monospace";
            break;
            
        default:
            fontFamilyString = @"Arial, Helvetica, sans-serif";
            break;
    }
    
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.setFontFamily(\"%@\");", fontFamilyString];
    
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
    [storyTextview setFont:textFont];

}

- (void)textColor {
    
    // Save the selection location
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    // Call the picker
    HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:[UIColor whiteColor]];
    colorPicker.delegate = self;
    colorPicker.tag = 1;
    colorPicker.title = NSLocalizedString(@"Text Color", nil);
    [self.navigationController pushViewController:colorPicker animated:YES];
    
}

- (void)bgColor {
    
    // Save the selection location
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    // Call the picker
    HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:[UIColor whiteColor]];
    colorPicker.delegate = self;
    colorPicker.tag = 2;
    colorPicker.title = NSLocalizedString(@"BG Color", nil);
    [self.navigationController pushViewController:colorPicker animated:YES];
    
}

- (void)setSelectedColor:(UIColor*)color tag:(int)tag {
    
    NSString *hex = [NSString stringWithFormat:@"#%06x",HexColorFromUIColor(color)];
    NSString *trigger;
    if (tag == 1) {
        trigger = [NSString stringWithFormat:@"zss_editor.setTextColor(\"%@\");", hex];
    } else if (tag == 2) {
        trigger = [NSString stringWithFormat:@"zss_editor.setBackgroundColor(\"%@\");", hex];
    }
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
    
}

- (void)undo:(ZSSBarButtonItem *)barButtonItem {
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.undo();"];
}

- (void)redo:(ZSSBarButtonItem *)barButtonItem {
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.redo();"];
}

- (void)insertLink {
    
    // Save the selection location
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    // Show the dialog for inserting or editing a link
    [self showInsertLinkDialogWithLink:self.selectedLinkURL title:self.selectedLinkTitle];
    
}


- (void)showInsertLinkDialogWithLink:(NSString *)url title:(NSString *)title {
    
    // Insert Button Title
    NSString *insertButtonTitle = !self.selectedLinkURL ? NSLocalizedString(@"Insert", nil) : NSLocalizedString(@"Update", nil);
    
    // Picker Button
    UIButton *am = [UIButton buttonWithType:UIButtonTypeCustom];
    am.frame = CGRectMake(0, 0, 25, 25);
    [am setImage:[UIImage imageNamed:@"ZSSpicker.png" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [am addTarget:self action:@selector(showInsertURLAlternatePicker) forControlEvents:UIControlEventTouchUpInside];
    
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Insert Link", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"URL (required)", nil);
            if (url) {
                textField.text = url;
            }
            textField.rightView = am;
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.clearButtonMode = UITextFieldViewModeAlways;
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"Title", nil);
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.secureTextEntry = NO;
            if (title) {
                textField.text = title;
            }
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self focusTextEditor];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:insertButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UITextField *linkURL = [alertController.textFields objectAtIndex:0];
            UITextField *title = [alertController.textFields objectAtIndex:1];
            if (!self.selectedLinkURL) {
                [self insertLink:linkURL.text title:title.text];
                //NSLog(@"insert link");
            } else {
                [self updateLink:linkURL.text title:title.text];
            }
            [self focusTextEditor];
        }]];
        [self presentViewController:alertController animated:YES completion:NULL];
        
    } else {
        
        self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Insert Link", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:insertButtonTitle, nil];
        self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        self.alertView.tag = 2;
        UITextField *linkURL = [self.alertView textFieldAtIndex:0];
        linkURL.placeholder = NSLocalizedString(@"URL (required)", nil);
        if (url) {
            linkURL.text = url;
        }
        
        linkURL.rightView = am;
        linkURL.rightViewMode = UITextFieldViewModeAlways;
        
        UITextField *alt = [self.alertView textFieldAtIndex:1];
        alt.secureTextEntry = NO;
        alt.placeholder = NSLocalizedString(@"Title", nil);
        if (title) {
            alt.text = title;
        }
        
        [self.alertView show];
    }
    
}


- (void)insertLink:(NSString *)url title:(NSString *)title {
    
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.insertLink(\"%@\", \"%@\");", url, title];
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
    
}


- (void)updateLink:(NSString *)url title:(NSString *)title {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.updateLink(\"%@\", \"%@\");", url, title];
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)dismissAlertView {
    [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:YES];
}

- (void)addCustomToolbarItemWithButton:(UIButton *)button {
    
    if(self.customBarButtonItems == nil)
    {
        self.customBarButtonItems = [NSMutableArray array];
    }
    
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28.5f];
    [button setTitleColor:[self barButtonItemDefaultColor] forState:UIControlStateNormal];
    [button setTitleColor:[self barButtonItemSelectedDefaultColor] forState:UIControlStateHighlighted];
    
    ZSSBarButtonItem *barButtonItem = [[ZSSBarButtonItem alloc] initWithCustomView:button];
    
    [self.customBarButtonItems addObject:barButtonItem];
    
    [self buildToolbar];
}

- (void)addCustomToolbarItem:(ZSSBarButtonItem *)item {
    
    if(self.customZSSBarButtonItems == nil)
    {
        self.customZSSBarButtonItems = [NSMutableArray array];
    }
    [self.customZSSBarButtonItems addObject:item];
    
    [self buildToolbar];
}


- (void)removeLink {
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.unlink();"];
}

- (void)quickLink {
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.quickLink();"];
}

- (void)insertImage {
    
    // Save the selection location
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    [self showInsertImageDialogWithLink:self.selectedImageURL alt:self.selectedImageAlt];
    
}

- (void)insertImageFromDevice {
    
    // Save the selection location
    
    [editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    [self showInsertImageDialogFromDeviceWithScale:self.selectedImageScale alt:self.selectedImageAlt];
    
}

- (void)showInsertImageDialogWithLink:(NSString *)url alt:(NSString *)alt {
    
    // Insert Button Title
    NSString *insertButtonTitle = !self.selectedImageURL ? NSLocalizedString(@"Insert", nil) : NSLocalizedString(@"Update", nil);
    
    // Picker Button
    UIButton *am = [UIButton buttonWithType:UIButtonTypeCustom];
    am.frame = CGRectMake(0, 0, 25, 25);
    //    [am setImage:[UIImage imageNamed:@"ZSSpicker.png" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [am addTarget:self action:@selector(showInsertImageAlternatePicker) forControlEvents:UIControlEventTouchUpInside];
    
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Insert Image", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"URL (required)", nil);
            if (url) {
                textField.text = url;
            }
            textField.rightView = am;
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.clearButtonMode = UITextFieldViewModeAlways;
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"Alt", nil);
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.secureTextEntry = NO;
            if (alt) {
                textField.text = alt;
            }
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self focusTextEditor];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:insertButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UITextField *imageURL = [alertController.textFields objectAtIndex:0];
            UITextField *alt = [alertController.textFields objectAtIndex:1];
            if (!self.selectedImageURL) {
                [self insertImage:imageURL.text alt:alt.text];
            } else {
                [self updateImage:imageURL.text alt:alt.text];
            }
            [self focusTextEditor];
        }]];
        [self presentViewController:alertController animated:YES completion:NULL];
        
    } else {
        
        self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Insert Image", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:insertButtonTitle, nil];
        self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        self.alertView.tag = 1;
        UITextField *imageURL = [self.alertView textFieldAtIndex:0];
        imageURL.placeholder = NSLocalizedString(@"URL (required)", nil);
        if (url) {
            imageURL.text = url;
        }
        
        imageURL.rightView = am;
        imageURL.rightViewMode = UITextFieldViewModeAlways;
        imageURL.clearButtonMode = UITextFieldViewModeAlways;
        
        UITextField *alt1 = [self.alertView textFieldAtIndex:1];
        alt1.secureTextEntry = NO;
        alt1.placeholder = NSLocalizedString(@"Alt", nil);
        alt1.clearButtonMode = UITextFieldViewModeAlways;
        if (alt) {
            alt1.text = alt;
        }
        
        [self.alertView show];
    }
    
}

- (void)showInsertImageDialogFromDeviceWithScale:(CGFloat)scale alt:(NSString *)alt {
    
    // Insert button title
    NSString *insertButtonTitle = !self.selectedImageURL ? NSLocalizedString(@"Pick Image", nil) : NSLocalizedString(@"Pick New Image", nil);
    
    //If the OS version supports the new UIAlertController go for it. Otherwise use the old UIAlertView
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Insert Image From Device", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        //Add alt text field
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"Alt", nil);
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.secureTextEntry = NO;
            if (alt) {
                textField.text = alt;
            }
        }];
        
        //Add scale text field
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.secureTextEntry = NO;
            textField.placeholder = NSLocalizedString(@"Image scale, 0.5 by default", nil);
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }];
        
        //Cancel action
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self focusTextEditor];
        }]];
        
        //Insert action
        [alertController addAction:[UIAlertAction actionWithTitle:insertButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textFieldAlt = [alertController.textFields objectAtIndex:0];
            UITextField *textFieldScale = [alertController.textFields objectAtIndex:1];
            
            self.selectedImageScale = [textFieldScale.text floatValue]?:kDefaultScale;
            self.selectedImageAlt = textFieldAlt.text?:@"";
            
            [self presentViewController:self.myimagePicker animated:YES completion:nil];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:NULL];
        
    } else {
        
        self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Insert Image", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:insertButtonTitle, nil];
        self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        self.alertView.tag = 3;
        
        UITextField *textFieldAlt = [self.alertView textFieldAtIndex:0];
        textFieldAlt.secureTextEntry = NO;
        textFieldAlt.placeholder = NSLocalizedString(@"Alt", nil);
        textFieldAlt.clearButtonMode = UITextFieldViewModeAlways;
        if (alt) {
            textFieldAlt.text = alt;
        }
        
        UITextField *textFieldScale = [self.alertView textFieldAtIndex:1];
        textFieldScale.placeholder = NSLocalizedString(@"Image scale, 0.5 by default", nil);
        textFieldScale.keyboardType = UIKeyboardTypeDecimalPad;
        
        [self.alertView show];
    }
    
}

- (void)insertImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.insertImage(\"%@\", \"%@\");", url, alt];
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)updateImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.updateImage(\"%@\", \"%@\");", url, alt];
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)insertImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.insertImageBase64String(\"%@\", \"%@\");", imageBase64String, alt];
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)updateImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.updateImageBase64String(\"%@\", \"%@\");", imageBase64String, alt];
    
    [editorView stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)updateToolBarWithButtonName:(NSString *)name {
    
    // Items that are enabled
    NSArray *itemNames = [name componentsSeparatedByString:@","];
    
    // Special case for link
    NSMutableArray *itemsModified = [[NSMutableArray alloc] init];
    for (NSString *linkItem in itemNames) {
        NSString *updatedItem = linkItem;
        if ([linkItem hasPrefix:@"link:"]) {
            updatedItem = @"link";
            self.selectedLinkURL = [linkItem stringByReplacingOccurrencesOfString:@"link:" withString:@""];
        } else if ([linkItem hasPrefix:@"link-title:"]) {
            self.selectedLinkTitle = [self stringByDecodingURLFormat:[linkItem stringByReplacingOccurrencesOfString:@"link-title:" withString:@""]];
        } else if ([linkItem hasPrefix:@"image:"]) {
            updatedItem = @"image";
            self.selectedImageURL = [linkItem stringByReplacingOccurrencesOfString:@"image:" withString:@""];
        } else if ([linkItem hasPrefix:@"image-alt:"]) {
            self.selectedImageAlt = [self stringByDecodingURLFormat:[linkItem stringByReplacingOccurrencesOfString:@"image-alt:" withString:@""]];
        } else {
            self.selectedImageURL = nil;
            self.selectedImageAlt = nil;
            self.selectedLinkURL = nil;
            self.selectedLinkTitle = nil;
        }
        [itemsModified addObject:updatedItem];
    }
    itemNames = [NSArray arrayWithArray:itemsModified];
    
    self.editorItemsEnabled = itemNames;
    
    // Highlight items
    NSArray *items = self.toolbar.items;
    for (ZSSBarButtonItem *item in items) {
        if ([itemNames containsObject:item.label]) {
            item.tintColor = [self barButtonItemSelectedDefaultColor];
        } else {
            item.tintColor = [self barButtonItemDefaultColor];
        }
    }
    
}



#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSString *urlString = [[request URL] absoluteString];
    //NSLog(@"web request");
    //NSLog(@"%@", urlString);
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    } else if ([urlString rangeOfString:@"callback://0/"].location != NSNotFound) {
        
        // We recieved the callback
        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"callback://0/" withString:@""];
        [self updateToolBarWithButtonName:className];
        
    } else if ([urlString rangeOfString:@"debug://"].location != NSNotFound) {
        
        NSLog(@"Debug Found");
        
        // We recieved the callback
        NSString *debug = [urlString stringByReplacingOccurrencesOfString:@"debug://" withString:@""];
        debug = [debug stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
        NSLog(@"%@", debug);
        
    } else if ([urlString rangeOfString:@"scroll://"].location != NSNotFound) {
        
        NSInteger position = [[urlString stringByReplacingOccurrencesOfString:@"scroll://" withString:@""] integerValue];
        [self editorDidScrollWithPosition:position];
        
    }
    
    return YES;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.editorLoaded = YES;
    
    
    if (!self.internalHTML) {
        self.internalHTML = @"";
    }
    [self updateHTML];
    
    if(self.placeholder) {
        [self setPlaceholderText];
    }
    
    if (self.customCSS) {
        [self updateCSS];
    }
    
    if (self.shouldShowKeyboard) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self focusTextEditor];
        });
    }
    
    /*
     
     Callback for when text is changed, solution posted by richardortiz84 https://github.com/nnhubbard/ZSSRichTextEditor/issues/5
     
     */
    JSContext *ctx = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"contentUpdateCallback"] = ^(JSValue *msg) {
        
        if (_receiveEditorDidChangeEvents) {
            
            [self editorDidChangeWithText:[self getText] andHTML:[self getHTML]];
            
        }
        
        [self checkForMentionOrHashtagInText:[self getText]];
        
    };
    [ctx evaluateScript:@"document.getElementById('zss_editor_content').addEventListener('input', contentUpdateCallback, false);"];
    
    
}

#pragma mark - Mention & Hashtag Support Section

- (void)checkForMentionOrHashtagInText:(NSString *)text {
    
    if ([text containsString:@" "] && [text length] > 0) {
        
        NSString *lastWord = nil;
        NSString *matchedWord = nil;
        BOOL ContainsHashtag = NO;
        BOOL ContainsMention = NO;
        
        NSRange range = [text rangeOfString:@" " options:NSBackwardsSearch];
        lastWord = [text substringFromIndex:range.location];
        
        if (lastWord != nil) {
            
            //Check if last word typed starts with a #
            NSRegularExpression *hashtagRegex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:nil];
            NSArray *hashtagMatches = [hashtagRegex matchesInString:lastWord options:0 range:NSMakeRange(0, lastWord.length)];
            
            for (NSTextCheckingResult *match in hashtagMatches) {
                NSLog(@"%@",match);
                NSLog(@"%@",hashtagMatches);

                NSRange wordRange = [match rangeAtIndex:1];
                NSString *word = [lastWord substringWithRange:wordRange];
                matchedWord = word;
                ContainsHashtag = YES;
                
            }
            
            if (!ContainsHashtag) {
                
                //Check if last word typed starts with a @
                NSRegularExpression *mentionRegex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:nil];
                NSArray *mentionMatches = [mentionRegex matchesInString:lastWord options:0 range:NSMakeRange(0, lastWord.length)];
                
                for (NSTextCheckingResult *match in mentionMatches) {
                    
                    NSRange wordRange = [match rangeAtIndex:1];
                    NSString *word = [lastWord substringWithRange:wordRange];
                    matchedWord = word;
                    ContainsMention = YES;
                    
                }
                
            }
            
        }
        
        if (ContainsHashtag) {
            
            [self hashtagRecognizedWithWord:matchedWord];
            
        }
        
        if (ContainsMention) {
            
            [self mentionRecognizedWithWord:matchedWord];
            
        }
        
    }
    
}

#pragma mark - Callbacks

//Blank implementation
- (void)editorDidScrollWithPosition:(NSInteger)position {
    
    NSLog(@"%ld",(long)position);
    if (position!=0)
    {
//        [editorView.scrollView setContentOffset:CGPointMake(0,position)];
    }


}

//Blank implementation
- (void)editorDidChangeWithText:(NSString *)text andHTML:(NSString *)html  {

}

//Blank implementation
- (void)hashtagRecognizedWithWord:(NSString *)word {

}

//Blank implementation
- (void)mentionRecognizedWithWord:(NSString *)word {

}

#pragma mark - AlertView

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    
    if (alertView.tag == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        UITextField *textField2 = [alertView textFieldAtIndex:1];
        if ([textField.text length] == 0 || [textField2.text length] == 0) {
            return NO;
        }
    } else if (alertView.tag == 2) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

/*
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
 if (alertView.tag == 1) {
 if (buttonIndex == 1) {
 UITextField *imageURL = [alertView textFieldAtIndex:0];
 UITextField *alt = [alertView textFieldAtIndex:1];
 if (!self.selectedImageURL) {
 [self insertImage:imageURL.text alt:alt.text];
 } else {
 [self updateImage:imageURL.text alt:alt.text];
 }
 }
 } else if (alertView.tag == 2) {
 if (buttonIndex == 1) {
 UITextField *linkURL = [alertView textFieldAtIndex:0];
 UITextField *title = [alertView textFieldAtIndex:1];
 if (!self.selectedLinkURL) {
 [self insertLink:linkURL.text title:title.text];
 } else {
 [self updateLink:linkURL.text title:title.text];
 }
 }
 } else if (alertView.tag == 3) {
 if (buttonIndex == 1) {
 UITextField *textFieldAlt = [alertView textFieldAtIndex:0];
 UITextField *textFieldScale = [alertView textFieldAtIndex:1];
 
 self.selectedImageScale = [textFieldScale.text floatValue]?:kDefaultScale;
 self.selectedImageAlt = textFieldAlt.text?:@"";
 
 [self presentViewController:self.myimagePicker animated:YES completion:nil];
 
 }
 }
 }
 
 
 #pragma mark - Asset Picker
 
 - (void)showInsertURLAlternatePicker {
 // Blank method. User should implement this in their subclass
 }
 
 
 - (void)showInsertImageAlternatePicker {
 // Blank method. User should implement this in their subclass
 }
 
 #pragma mark - Image Picker Delegate
 
 - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
 //Dismiss the Image Picker
 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
 }
 
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info{
 
 UIImage *selectedImage = info[UIImagePickerControllerEditedImage]?:info[UIImagePickerControllerOriginalImage];
 
 //Scale the image
 CGSize targetSize = CGSizeMake(selectedImage.size.width * self.selectedImageScale, selectedImage.size.height * self.selectedImageScale);
 UIGraphicsBeginImageContext(targetSize);
 [selectedImage drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
 UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 //Compress the image, as it is going to be encoded rather than linked
 NSData *scaledImageData = UIImageJPEGRepresentation(scaledImage, kJPEGCompression);
 
 //Encode the image data as a base64 string
 NSString *imageBase64String = [scaledImageData base64EncodedStringWithOptions:0];
 
 //Decide if we have to insert or update
 if (!self.imageBase64String) {
 [self insertImageBase64String:imageBase64String alt:self.selectedImageAlt];
 } else {
 [self updateImageBase64String:imageBase64String alt:self.selectedImageAlt];
 }
 
 self.imageBase64String = imageBase64String;
 
 //Dismiss the Image Picker
 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
 }
 */


#pragma mark - Utilities

- (NSString *)removeQuotesFromHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    return html;
}


- (NSString *)tidyHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
    if (self.formatHTML) {
        
        html = [editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"style_html(\"%@\");", html]];
    }
    return html;
}


- (UIColor *)barButtonItemDefaultColor {
    
    if (self.toolbarItemTintColor) {
        return self.toolbarItemTintColor;
    }
    
    return [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}


- (UIColor *)barButtonItemSelectedDefaultColor {
    
    if (self.toolbarItemSelectedTintColor) {
        return self.toolbarItemSelectedTintColor;
    }
    
    return [UIColor blackColor];
}


- (BOOL)isIpad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}


- (NSString *)stringByDecodingURLFormat:(NSString *)string {
    NSString *result = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (void)enableToolbarItems:(BOOL)enable {
    NSArray *items = self.toolbar.items;
    for (ZSSBarButtonItem *item in items) {
        if (![item.label isEqualToString:@"source"]) {
            item.enabled = enable;
        }
    }
}

-(void) keyboardWillShow:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo];
    NSValue *keyboardBoundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [keyboardBoundsValue CGRectValue].size.height;
    UIEdgeInsets insets = [addproductTableView contentInset];
    [addproductTableView setContentInset:UIEdgeInsetsMake(insets.top, insets.left, keyboardHeight, insets.right)];
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification *)note
{
    UIEdgeInsets insets = [addproductTableView contentInset];
    [addproductTableView setContentInset:UIEdgeInsetsMake(insets.top, insets.left, 0., insets.right)];
    [UIView commitAnimations];
}


#pragma  mark - Dealloc and memory Warning

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
