
//
//  HomePage.m
//  HSJoysale
//
//  Created by BTMANI on 01/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import "HomePage.h"

#import "AppDelegate.h"
#import "DefensiveClass.h"
#import "Reachability.h"

#import "ItemDetailPage.h"
#import "AdvanceSearchPage.h"
#import "CommentPage.h"
#import "SearchResult.h"
#import "FilterMapView.h"
#import "welcomeScreen.h"

#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"
#import "SBJson.h"

#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "NSDate+DateMath.h"
#import "CategoryResult.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface HomePage ()

//for CollectionViewCell
@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (nonatomic) CGRect originalFrame;

/**
 To identify the reachability of the network
 */
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation HomePage

//CollectionView to Show Datas
@synthesize collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    [super viewDidLoad];
    
    homeCategorySearchEnable = NO;

    //obj Intialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    filterArray = [[NSMutableArray alloc] init];
    homePageArray = [[NSMutableArray alloc]initWithCapacity:0];
    refreshControl = [[UIRefreshControl alloc]init];
    
    taptouch = YES;
    delegate.langchangeFlag = NO;
    //Component Initalization
    
    homePageHeaderTable = [[UITableView alloc]init];
    homeTableview = [[UITableView alloc]init];
    filterScroll=[[UIScrollView alloc] init];
    loadingErrorViewBG = [[UIView alloc]init];
    NSLog(@"location:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]);
    NSLog(@"maplocation:%@",delegate.mapLocationArray);
    //appearance and subviews
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view setBackgroundColor:BackGroundColor];
    //    [self.view addSubview:homeTableview];
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:homePageHeaderTable];
    //    [self.view sendSubviewToBack:homeTableview];
    [self.view sendSubviewToBack:self.collectionView];
    [self.view addSubview:homePageHeaderTable];
    //[self.view setBackgroundColor:[UIColor greenColor]];
    
    //Properties
    
    [homePageHeaderTable setScrollEnabled:NO];
    [homePageHeaderTable setDelegate:self];
    [homePageHeaderTable setDataSource:self];
    [homePageHeaderTable setBackgroundColor:clearcolor];
    [homePageHeaderTable setFrame:CGRectMake((delegate.windowWidth/2)-103,11,206,44)];
    [homePageHeaderTable setSeparatorColor:[UIColor clearColor]];
    homePageHeaderTable.translatesAutoresizingMaskIntoConstraints = NO;
    [homePageHeaderTable setTag:100];
    
    [homeTableview setDelegate:self];
    [homeTableview setDataSource:self];
    [homeTableview setBackgroundColor:BackGroundColor];
    [homeTableview setFrame:CGRectMake(0,0,delegate.windowWidth,285)];
    [homeTableview setSeparatorColor:[UIColor clearColor]];
    homeTableview.translatesAutoresizingMaskIntoConstraints = NO;
    [homeTableview setTag:101];
    
    
    //    loadingErrorViewBG.frame = CGRectMake(0, 100, delegate.windowWidth, delegate.windowHeight-200);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];
    
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    
    //Functionalities
    
    /*[delegate.HomeSearchArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:0]];//latitude 0
     [delegate.HomeSearchArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:1]];//longitude 1
     [delegate.HomeSearchArray replaceObjectAtIndex:2 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:2]];//longitude 1
     
     [delegate.selectedLocationArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:0]];
     [delegate.selectedLocationArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:1]];
     
     if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:2] isEqualToString:@"WorldWide"] && [[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:1] isEqualToString:@"0"])
     {
     }else{
     [self performSelectorOnMainThread:@selector(getLocationName) withObject:nil waitUntilDone:YES];
     }*/
    
    if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6] isEqualToString:@"WorldWide"]){
        [delegate.HomeSearchArray replaceObjectAtIndex:0 withObject:@""];//latitude 0
        [delegate.HomeSearchArray replaceObjectAtIndex:1 withObject:@""];//longitude 1
        [delegate.HomeSearchArray replaceObjectAtIndex:2 withObject:@"WorldWide"];//longitude 1
        [delegate.selectedLocationArray replaceObjectAtIndex:0 withObject:@""];
        [delegate.selectedLocationArray replaceObjectAtIndex:1 withObject:@""];
    }else if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6] isEqualToString:@"setLocation"]){
        [delegate.HomeSearchArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:0]];//latitude 0
        [delegate.HomeSearchArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:1]];//longitude 1
        [delegate.HomeSearchArray replaceObjectAtIndex:2 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:2]];//longitude 1
        
        //        [delegate.selectedLocationArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:0]];
        //        [delegate.selectedLocationArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:1]];
    }
    // [self performSelectorOnMainThread:@selector(defaultDataParsing) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(reloadHeaderTabel) withObject:nil waitUntilDone:YES];
    
    //Bools and initializeValue
    
    delegate.advancesearchFlag = NO;
    
    //Change the host name here to change the server you want to monitor.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.apple.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [self.collectionView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.collectionView.alwaysBounceVertical = YES;
    
    [collectionView addInfiniteScrollWithHandler:^(UICollectionView *collectionView) {
        [self bottomrefreshTable:^{
        }];
    }];
    
    //Functions
    // [self categorysetting];
    [self getLocationnonvoid];
    [self barButtonItems];
    [self loadingIndicator];
    [self noItemFindFunction];
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    if (delegate.currentlatitude!=0)
    {
        [self performSelector:@selector(loadDataAfterFewSecond) withObject:nil afterDelay:0.5];
    }
    else
    {
        [self loadingHomePageData];
    }
    
    isBannerEnable = YES;
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:homePageHeaderTable];
    [self.view sendSubviewToBack:self.collectionView];
    //                [collectionView setHidden:NO];
    [self.collectionView reloadData];
    [collectionView reloadData];
    [homeTableview reloadData];
    [self defaultDataParsing];
    
    
    //    if (delegate.bannerEnable)
    //    {
    //        [self bannerSettings];
    //    }
    
}

#pragma mark - image slider with automatic scroll

-(void)configureImageSlider{
    imageSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0,0,delegate.windowWidth, 200) andSlides: delegate.bannerDetailsArray];
    [imageSlider setBackgroundColor:BackGroundColor];
    imageSlider.delegate = self;
    if([delegate.bannerDetailsArray count]>1)
    {
        [imageSlider setAutoSlide: YES];
    }
    else
    {
        [imageSlider setAutoSlide:NO];
    }

    [imageSlider setPlaceholderImage:@"placeholder.png"];
    [imageSlider setContentMode: UIViewContentModeScaleAspectFill];
}


- (void)imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    NSLog(@"Selected slide at index: %lu", (unsigned long)index);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[delegate.bannerDetailsArray objectAtIndex:index]objectForKey:@"bannerURL"]]];
    
}

-(void) bannerSettings
{
    
    bannerScrollView = [UIScrollView new];
    [bannerScrollView setBackgroundColor:BackGroundColor];
    [bannerScrollView setFrame:CGRectMake(0,0,delegate.windowWidth, 200)];

    [bannerScrollView setPagingEnabled:YES];
    [bannerScrollView setContentSize:CGSizeMake([delegate.bannerDetailsArray count]*delegate.windowWidth, 0)];
    
    NSLog(@"%@",delegate.bannerDetailsArray);
    
    for(int i=0;i<[delegate.bannerDetailsArray count];i++)
    {
        UIImageView * imageView = [UIImageView new];
        [imageView setFrame:CGRectMake(i*delegate.windowWidth,0,delegate.windowWidth,200)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[delegate.bannerDetailsArray objectAtIndex:i]objectForKey:@"bannerImage"]]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView.layer setMasksToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        [imageView setTag:i];
        [bannerScrollView addSubview:imageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerGestureTapped:)];
        [imageView addGestureRecognizer:singleTap];
        
    }
}
-(void)bannerGestureTapped:(UIGestureRecognizer*) sender
{
    
    int tag =(int)(UIGestureRecognizer*)[sender.view tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[delegate.bannerDetailsArray objectAtIndex:tag]objectForKey:@"bannerURL"]]];
}

-(void) categorysetting{
    
}
-(void) categorysetting1
{
    
    categoryScrollView = [UIScrollView new];
    [categoryScrollView setBackgroundColor:BackGroundColor];
    // delegate.bannerEnable = NO;
    if (delegate.bannerEnable) {
        [categoryScrollView setFrame:CGRectMake(0,155,delegate.windowWidth, 85)];
        //imageSlider.frame.origin.y+imageSlider.frame.size.height
    }
    else{
        
        [categoryScrollView setFrame:CGRectMake(0,0,delegate.windowWidth, 85)];
    }
    
    //[categoryScrollView setPagingEnabled:YES];
    [categoryScrollView setContentSize:CGSizeMake([[delegate.getcategoryDict objectForKey:@"category"]count]*101, 0)];
    categoryScrollView.userInteractionEnabled = YES;
    
    [categoryScrollView setScrollEnabled:YES];
    [categoryScrollView setShowsVerticalScrollIndicator:NO];
    categoryScrollView.showsHorizontalScrollIndicator=NO;
    
    for(int i=0;i<[[delegate.getcategoryDict objectForKey:@"category"]count];i++)
    {
        UIImageView * imageView = [UIImageView new];
        [imageView setFrame:CGRectMake((i*100)+25,10,50,50)];
        NSString *cat_imgstr = [NSString stringWithFormat:@"%@",[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_img"]];
        cat_imgstr = [cat_imgstr stringByReplacingOccurrencesOfString:@"resized/40" withString:@"resized/200"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:cat_imgstr]placeholderImage:[UIImage imageNamed:@"applogo.png"]];
        
        //  [imageView sd_setImageWithURL:[NSURL URLWithString:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_img"]]];
        imageView.layer.cornerRadius = 25;
        imageView.layer.masksToBounds=YES;
        //        [imageView setBackgroundColor:[UIColor greenColor]];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        // [imageView.layer setMasksToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        [imageView setTag:i];
        [categoryScrollView addSubview:imageView];
        
        UILabel * contentLable = [[[UILabel alloc]init]autorelease];
        [contentLable setFrame:CGRectMake((i*100)+10,imageView.frame.origin.y+imageView.frame.size.height,80,30)];
        [contentLable setBackgroundColor:[UIColor clearColor]];
        [contentLable setFont:[UIFont fontWithName:appFontRegular size:15]];
        [contentLable setText:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_name"]];
        [contentLable setTextColor:headercolor];
        [contentLable setTextAlignment:NSTextAlignmentCenter];
        [categoryScrollView addSubview:contentLable];
        [contentLable setNumberOfLines:2];
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotocategorypage:)];
        [imageView addGestureRecognizer:imageTap];
        
    }
    
}
-(void)gotocategorypage:(UIGestureRecognizer*) sender
{
    homeCategorySearchEnable = YES;

    int tag =(int)(UIGestureRecognizer*)[sender.view tag];
    
    if (![[delegate.HomeDictForCatID allKeys] containsObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:tag] objectForKey:@"category_id"]]) {
        // contains key
        [delegate.HomeDictForCatID setValue:@"0" forKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:tag] objectForKey:@"category_id"]];
    }else{
        [delegate.HomeDictForCatID removeObjectForKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:tag] objectForKey:@"category_id"]];
    }
    //    delegate.CategoryTabbed = @"CategoryResult"; //Tab to categoryresult
    //    CategoryResult * pageObj = [[CategoryResult alloc]initWithNibName:@"CategoryResult" bundle:nil];
    //    [self.navigationController pushViewController:pageObj animated:YES];
    //    [pageObj release];
    [self filterscroll];
    [self searchDatasparsing];
    
}

#pragma mark - viewWillAppear

-(void) viewWillAppear:(BOOL)animated
{
    
    NSLog(@"viewWillAppear home");
    [self setNeedsStatusBarAppearanceUpdate];
    
    taptouch = YES;
    [delegate.tabViewControllerObj.tabBarController.view setFrame:CGRectMake(0,0, delegate.windowWidth, delegate.windowHeight)];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    //Appearance
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
    // [self.navigationController.navigationBar setBottomBorderColor:lineviewColor height:0.7];
    
    //    [delegate adminchecking];
    [collectionView reloadData];
    
    //functionality
    [searchbarBtn setEnabled:YES];
    count=0;
    
    CGPoint offset = collectionView.contentOffset;
    
    @try
    {
        if (delegate.favHomeFlag)
        {
            if ([homePageArray count]==[delegate.detailPageArray count])
            {
                delegate.favHomeFlag = NO;
                [homePageArray removeAllObjects];
                [collectionView reloadData];
                [homePageArray addObjectsFromArray:delegate.detailPageArray];
            }
        }
        if([homePageArray count]!=0)
        {
            [collectionView reloadData];
            [collectionView layoutIfNeeded];// Force layout so things are updated before resetting the contentOffset.
            [collectionView setContentOffset:offset];
        }
        if(delegate.advancesearchFlag || [delegate.deleteProduct isEqualToString:@"YES"] || [delegate.promoteProduct isEqualToString:@"YES"])
        {
            delegate.advancesearchFlag = NO;
            delegate.deleteProduct=@"";
            delegate.promoteProduct =@"";
            [self filterscroll];
            [self searchDatasparsing];
        }
        if (delegate.langchangeFlag == YES) {
            [self loadingHomePageData];
        }
        
        [self performSelectorOnMainThread:@selector(reloadHeaderTabel) withObject:nil waitUntilDone:YES];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    NSLog(@"location:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]);
    NSLog(@"maplocation:%@",delegate.mapLocationArray);
    [self noItemFindFunction];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"viewDidAppear home");
    
    [super viewDidAppear:animated];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    NSLog(@"viewDidDisappear home");
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    NSLog(@"viewWillDisappear home");
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation bar button items function

-(void) barButtonItems
{
    
    [self.navigationController.navigationBar setBarTintColor:AppThemeColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    
    
    
    UIView * leftNaviNaviButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,delegate.windowWidth, 44)];
    [leftNaviNaviButtonView setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem * negativeSpacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]autorelease];
    negativeSpacer.width = -18;
    
    searchbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchbarBtn setBackgroundColor:[UIColor clearColor]];
    [searchbarBtn setTag:1000];
    [searchbarBtn setFrame:CGRectMake(0+[HSUtility adjustablePadding],0,50,44)];
    [searchbarBtn setImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
    [searchbarBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [searchbarBtn addTarget:self action:@selector(searchPageTapped) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:searchbarBtn];
    
        UILabel * Label = [[[UILabel alloc]init]autorelease];
        [Label setFrame:CGRectMake(50+[HSUtility adjustablePadding],0,delegate.windowWidth-100,44)];
        [Label setBackgroundColor:[UIColor clearColor]];
        [Label setText:@"Joysale"];
        [Label setFont:[UIFont fontWithName:appFontBold size:30]];
        [Label setTextAlignment:NSTextAlignmentCenter];
        [Label setTextColor:whitecolor];
        [leftNaviNaviButtonView addSubview:Label];
    
//    UIImageView * logoImageView = [UIImageView new];
//    [logoImageView setFrame:CGRectMake(((delegate.windowWidth-150)/2)+[HSUtility adjustablePadding],7,150,30)];
//    [logoImageView setBackgroundColor:[UIColor clearColor]];
//    [logoImageView setImage:[UIImage imageNamed:@"app_headerlogo.png"]];
//    [logoImageView setContentMode:UIViewContentModeScaleAspectFit];
//    [leftNaviNaviButtonView addSubview:logoImageView];
    
    UIButton *advanceSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [advanceSearch setBackgroundColor:[UIColor clearColor]];
    [advanceSearch setTag:1000];
    [advanceSearch setFrame:CGRectMake(delegate.windowWidth-50+[HSUtility adjustablePadding],0,50,44)];
    [advanceSearch setImage:[UIImage imageNamed:@"search_adv.png"] forState:UIControlStateNormal];
    [advanceSearch addTarget:self action:@selector(advanceSearchTapped) forControlEvents:UIControlEventTouchUpInside];
    [advanceSearch.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [leftNaviNaviButtonView addSubview:advanceSearch];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
    
}

#pragma mark  redirect to Searchpage

-(void) searchPageTapped
{
    
    [searchbarBtn setEnabled:NO];
    SearchResult* pageObj = [[SearchResult alloc]initWithNibName:@"SearchResult" bundle:nil];
    [self.navigationController pushViewController:pageObj animated:YES];
    [pageObj release];
}

#pragma mark  redirect to AdvanceSearchPage

-(void)advanceSearchTapped
{
    
    delegate.advancesearchFlag = YES;
    AdvanceSearchPage * advanceSearchPageObj = [[AdvanceSearchPage alloc]initWithNibName:@"AdvanceSearchPage" bundle:nil];
    [self.navigationController pushViewController:advanceSearchPageObj animated:YES];
    [advanceSearchPageObj release];
}

#pragma mark - LocationManager

-(void) getLocationnonvoid
{
    
    locationManager=[[CLLocationManager alloc] init];
    if(IS_OS_8_OR_LATER)
    {
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        else
        {
            [locationManager requestAlwaysAuthorization];
        }
    }
    [locationManager setDelegate:self];
    locationManager.distanceFilter = 100.0; //whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    CLLocationCoordinate2D location=newLocation.coordinate;
    if ([[delegate.selectedLocationArray objectAtIndex:1]floatValue]==0)
    {
        [delegate.selectedLocationArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",location.latitude]];
        [delegate.selectedLocationArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",location.longitude]];
        
        [delegate.HomeSearchArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",location.latitude]];
        [delegate.HomeSearchArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",location.longitude]];
        [self performSelectorOnMainThread:@selector(getLocationName) withObject:nil waitUntilDone:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (locations == nil)
        return;
    CLLocation *location = [manager location];
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    if ([[delegate.selectedLocationArray objectAtIndex:1]floatValue]==0)
    {
        [delegate.selectedLocationArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",coordinate.latitude]];
        [delegate.selectedLocationArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",coordinate.longitude]];
        [delegate.HomeSearchArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",coordinate.latitude]];
        [delegate.HomeSearchArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",coordinate.longitude]];
        
        [self performSelectorOnMainThread:@selector(getLocationName) withObject:nil waitUntilDone:YES];
    }
}

-(void) getLocationName
{
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[delegate.selectedLocationArray objectAtIndex:0]floatValue] longitude:[[delegate.selectedLocationArray objectAtIndex:1]floatValue]];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  //String to hold address
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
                  //Print the location to console
                  if (locatedAt!=NULL)
                  {
                      //                      [delegate.selectedLocationArray replaceObjectAtIndex:2 withObject:locatedAt];
                      //                      [delegate.HomeSearchArray replaceObjectAtIndex:2 withObject:locatedAt];
                      [delegate.selectedLocationArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",locatedAt]];
                      [delegate.HomeSearchArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",locatedAt]];
                      
                  }
                  if ([[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]!=NULL)
                  {
                      [delegate.HomeSearchArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:0]];//latitude 0
                      [delegate.HomeSearchArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:1]];//longitude 1
                      [delegate.HomeSearchArray replaceObjectAtIndex:2 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:2]];//Current Placemark 2
                  }
                  [self performSelectorOnMainThread:@selector(reloadHeaderTabel) withObject:nil waitUntilDone:YES];
              }
     ];
}

#pragma mark - Sort value

-(int) sortFunc:(NSString *)sort
{
    
    //selectedIndexValue = 1 for mostRecent , 2 for most popular, 3 for high to low, 4 for low to high
    if([sort isEqualToString:@"Popular"]){
        return 2;
    }else if([sort isEqualToString:@"High to Low"]){
        return 3;
    }else if([sort isEqualToString:@"Low to High"]){
        return 4;
    }else if([sort isEqualToString:@"Urgent"]){
        return 5;
    }else{
        return 1;
    }
}

-(NSString *)distanceFunc:(NSString *)distance
{
    NSString* noSpaces;
    noSpaces = distance;
    noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@" "withString:@""];
    noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"within"withString:@""];
    noSpaces = [noSpaces stringByReplacingOccurrencesOfString:delegate.distancestring withString:@""];
    
    
    return noSpaces;
}
-(NSString *) postWithinFunc:(NSString *)sort
{
    
    //selectedIndexValue = 1 for mostRecent , 2 for most popular, 3 for high to low, 4 for low to high
    if([sort isEqualToString:@"The last 24 h"]){
        return @"last24h";
    }else if([sort isEqualToString:@"The last 7days ago"]){
        return @"last7d";
    }else if([sort isEqualToString:@"The last 30days ago"]){
        return @"last30d";
    }else{
        return @"";
    }
}


#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 4.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_multiColorLoader setFrame:CGRectMake((delegate.windowWidth/2)-15, (delegate.windowHeight-150)/2, 30, 30)];
    [_multiColorLoader startAnimation];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view addSubview:_multiColorLoader];
}
-(void) startLoadig
{
    
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
    [loadingErrorViewBG setHidden:YES];
}
-(void) stopLoading
{
    
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    
    headerview.hidden = NO;
    [bottomrefreshControl endRefreshing];
    [refreshControl endRefreshing];
    [collectionView finishInfiniteScroll];
}
#pragma mark - Reachablity
/**
 To check the network reachablity of the device we are using this function
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == self.hostReachability)
    {
    }
    if (reachability == self.internetReachability)
    {
        [self configureTextField:@"" imageView:@"" reachability:reachability];
    }
    if (reachability == self.wifiReachability)
    {
        [self configureTextField:@"" imageView:@"" reachability:reachability];
    }
}

- (void)configureTextField:(NSString *)textField imageView:(NSString *)imageView reachability:(Reachability *)reachability
{
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    
    switch (netStatus)
    {
        case NotReachable:        {
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
    }
    if (connectionRequired)
    {
    }
}


#pragma  mark - filterscroll


-(void) filterscroll
{
    
    [filterScroll setFrame:CGRectMake(0, 0, delegate.windowWidth, 45)];
    [filterScroll setShowsVerticalScrollIndicator:YES];
    [filterScroll setScrollEnabled:YES];
    [filterScroll setBackgroundColor:clearcolor];
    for (UIView *subview in filterScroll.subviews) {
        [subview removeFromSuperview];
    }
    [self.view addSubview:filterScroll];
    
    
    count=0;
    float width=5;
    NSString *categoryID=@"";
    NSString *subcategoryID=@"";
    [filterArray removeAllObjects];
    
    for(int j=0;j<[[delegate.getcategoryDict objectForKey:@"category"] count];j++){
        for (id key in delegate.HomeDictForCatID) {
            if([[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_id"]==key){
                count+=1;
                [filterArray addObject:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_name"]];
                NSString *c = [[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_id"];
                
                if([[delegate.HomeDictForCatID objectForKey:key]isEqualToString:@"0"
                    ]){
                    if([categoryID isEqualToString:@""]){
                        categoryID=[categoryID stringByAppendingString:c];
                    }else{
                        categoryID=[categoryID stringByAppendingString:[NSString stringWithFormat:@",%@",c]];
                    }
                }
                else{
                    NSString *s = [delegate.HomeDictForCatID objectForKey:key];
                    
                    if([subcategoryID isEqualToString:@""]){
                        subcategoryID=[subcategoryID stringByAppendingString:s];
                    }else{
                        subcategoryID=[subcategoryID stringByAppendingString:[NSString stringWithFormat:@",%@",s]];
                    }
                }
            }
        }
    }
    [delegate.HomeSearchArray replaceObjectAtIndex:6 withObject:categoryID];
    [delegate.HomeSearchArray replaceObjectAtIndex:7 withObject:subcategoryID];
    
    if(![[delegate.HomeSearchArray objectAtIndex:4] isEqualToString:@""]){
        [filterArray addObject:[delegate.HomeSearchArray objectAtIndex:4]];
        count+=1;
    }
    if(![[delegate.HomeSearchArray objectAtIndex:5] isEqualToString:@""]){
        [filterArray addObject:[delegate.HomeSearchArray objectAtIndex:5]];
        count+=1;
    }
    if(![[delegate.HomeSearchArray objectAtIndex:3] isEqualToString:@""]){
        [filterArray addObject:[delegate.HomeSearchArray objectAtIndex:3]];
        count+=1;
    }
    if(![[delegate.HomeSearchArray objectAtIndex:8]isEqualToString:@""])
    {
        [filterArray addObject:[delegate.HomeSearchArray objectAtIndex:8]];
        count+=1;
    }
    
    if(count==0){
        collectionView.frame = CGRectMake(0, 0, delegate.windowWidth-0, delegate.windowHeight-120);
        [filterScroll setBackgroundColor:clearcolor];
        //        collectionView.frame = CGRectMake(5,130, delegate.windowWidth-10, delegate.windowHeight-250);
        [filterScroll setBackgroundColor:clearcolor];
        [homePageHeaderTable setFrame:CGRectMake((delegate.windowWidth/2)-103,11,206,44)];
    }else{
        [filterScroll setBackgroundColor:AppThemeColor];
        collectionView.frame = CGRectMake(0,45, delegate.windowWidth, delegate.windowHeight-160);
        [homePageHeaderTable setFrame:CGRectMake((delegate.windowWidth/2)-103,51,206,44)];
        [filterScroll setBackgroundColor:AppThemeColor];
        if(delegate.bannerEnable && [delegate.bannerDetailsArray count]!=0)
        {
            loadingErrorViewBG.frame = CGRectMake(0, 285, delegate.windowWidth, 300);
        }
        else
        {
            loadingErrorViewBG.frame = CGRectMake(0, 140, delegate.windowWidth, 300);
        }
    }
    [self.view bringSubviewToFront:homePageHeaderTable];
    [self.view sendSubviewToBack:self.collectionView];
    for(int i=0;i<count;i++){
        
        UIView *Filterview =[[UIView alloc] init];
        [Filterview setBackgroundColor:whitecolor];
        Filterview.layer.cornerRadius=14.5;
        Filterview.layer.masksToBounds=YES;
        
        UILabel * filterlable = [[UILabel alloc] init];
        [filterlable setText:[filterArray objectAtIndex:i]];
        [filterlable setFont:[UIFont fontWithName:appFontRegular size:12]];
        [Filterview addSubview:filterlable];
        
        UIButton * filtercloseBtn = [[UIButton alloc] init];
        [filtercloseBtn setBackgroundImage:[UIImage imageNamed:@"crossImg.png"] forState:UIControlStateNormal];
        [filtercloseBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [filtercloseBtn setTag:i];
        [filtercloseBtn addTarget:self action:@selector(removeFilter:) forControlEvents:UIControlEventTouchUpInside];
        [Filterview addSubview:filtercloseBtn];
        
        [filterScroll addSubview:Filterview];
        
        [Filterview setFrame:CGRectMake(width, 6, filterlable.intrinsicContentSize.width+42, 29)];
        [filterlable setFrame:CGRectMake(10, 0, filterlable.intrinsicContentSize.width, 29)];
        [filtercloseBtn setFrame:CGRectMake(filterlable.frame.size.width+filterlable.frame.origin.x+5, 5, 20, 20)];
        
        width=Filterview.frame.size.width+Filterview.frame.origin.x+5;
        
    }
    [filterScroll setContentSize:CGSizeMake(width, 45)];
}

-(void) removeFilter:(id) sender
{
    
    int count_id=0;
    NSMutableDictionary * HomeDictForCatIDtemp;
    HomeDictForCatIDtemp = [[[NSMutableDictionary alloc]initWithCapacity:0] autorelease];
    [HomeDictForCatIDtemp addEntriesFromDictionary:delegate.HomeDictForCatID];
    
    for(int j=0;j<[[delegate.getcategoryDict objectForKey:@"category"] count];j++){
        for (id key in HomeDictForCatIDtemp) {
            if([[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_id"]==key){
                if(count_id==(int)[sender tag]){
                    [delegate.HomeDictForCatID removeObjectForKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:j] objectForKey:@"category_id"]];
                }
                count_id+=1;
            }
        }
    }
    
    if([[delegate.HomeSearchArray objectAtIndex:4] isEqualToString:[filterArray objectAtIndex:(long)[sender tag]]]){
        [delegate.HomeSearchArray replaceObjectAtIndex:4 withObject:@""];
    }
    if([[delegate.HomeSearchArray objectAtIndex:3] isEqualToString:[filterArray objectAtIndex:(long)[sender tag]]]){
        [delegate.HomeSearchArray replaceObjectAtIndex:3 withObject:@""];
    }
    if ([[delegate.HomeSearchArray objectAtIndex:8]isEqualToString:[filterArray objectAtIndex:(long)[sender tag]]])
    {
        [delegate.HomeSearchArray replaceObjectAtIndex:8 withObject:@""];
    }
    if([[delegate.HomeSearchArray objectAtIndex:5] isEqualToString:[filterArray objectAtIndex:(long)[sender tag]]]){
        [delegate.HomeSearchArray replaceObjectAtIndex:5 withObject:@""];
    }
    [self filterscroll];
    [self searchDatasparsing];
}



#pragma mark - If no data in parsing it show alert

-(void) noItemFindFunction
{
    
    [[loadingErrorViewBG subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *loadingErrorImageView = [[UIImageView alloc]init];
    loadingErrorImageView.frame = CGRectMake(delegate.windowWidth/2-100, 30, 200, 150);
    [loadingErrorImageView setBackgroundColor:[UIColor clearColor]];
    [loadingErrorImageView setContentMode:UIViewContentModeScaleAspectFit];
    [loadingErrorImageView setImage:[UIImage imageNamed:@"noItemImg.png"]];
    [loadingErrorViewBG addSubview:loadingErrorImageView];
    
    UILabel * sorryTextLabel = [[[UILabel alloc]init]autorelease];
    [sorryTextLabel setText:[delegate.languageDict objectForKey:@"sorry"]];
    [sorryTextLabel setTextColor:NoItemFindColor];
    [sorryTextLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:sorryTextLabel];
    sorryTextLabel.frame = CGRectMake(delegate.windowWidth/2-100,loadingErrorImageView.frame.size.height+loadingErrorImageView.frame.origin.y, 200,30);
    [sorryTextLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel * noItemFindLabel = [[[UILabel alloc]init]autorelease];
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"noItemfound"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    //    [self.view addSubview:loadingErrorViewBG];
}


#pragma mark  show and hide noitemfound

-(void)checkIfhavsData
{
    
    if ([homePageArray count] == 0)
    {
        [loadingErrorViewBG setHidden:NO];
        //        [collectionView setHidden:YES];
        [collectionView setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [loadingErrorViewBG setHidden:YES];
        //        [collectionView setHidden:NO];
    }
}

#pragma mark - Data parsing


#pragma mark  CallingApiModal
-(void) apiCallingFunction:(NSString*)api_username api_password:(NSString*)api_password type:(NSString *)type price:(NSString *)price search_key:(NSString *)search_key category_id:(NSString *)category_id subcategory_id:(NSString *)subcategory_id user_id:(NSString *)user_id item_id:(NSString *)item_id seller_id:(NSString *)seller_id sorting_id:(NSString *)sorting_id offset:(NSString *)offset limit:(NSString *)limit lat:(NSString *)lat lon:(NSString *)lon posted_within:(NSString *)posted_within distance:(NSString *)distance
{
    
    NSLog(@"api_username :%@ api_password :%@  type :%@  price :%@  search_key :%@  category_id :%@  subcategory_id :%@  user_id :%@  item_id :%@  seller_id :%@  sorting_id :%@  offset :%@  limit :%@  lat :%@  lon :%@  posted_within :%@  distance:%@  ",api_username ,api_password ,type ,price ,search_key ,category_id ,subcategory_id ,user_id ,item_id ,seller_id ,sorting_id ,offset ,limit ,lat ,lon ,posted_within ,distance);
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        if( [[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:2] isEqualToString:@"WorldWide"]){
            lat = @"";
            lon = @"";
            [delegate.selectedLocationArray replaceObjectAtIndex:0 withObject:@""];
            [delegate.selectedLocationArray replaceObjectAtIndex:1 withObject:@""];
        }
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=NULL)
        {
            [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :user_id :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within :distance];
        }else{
            [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :@"" :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within :distance];
        }
    }
}

#pragma mark - Data parsing
-(void) defaultDataParsing
{
    ApiControllerServiceProxy *adminproxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        [adminproxy admindatas:apiusername :apipassword :[delegate gettingLanguageCode] ];
    }
}
#pragma mark  load Data after few second

//Load Home Page Data because of GettingCurrent location need Some Time

-(void) loadDataAfterFewSecond
{
    
    [self loadingHomePageData];
}

#pragma mark  Home page ParsingFunction

-(void) loadingHomePageData
{
    
    latituted = [[delegate.HomeSearchArray objectAtIndex:0] floatValue];
    delegate.langchangeFlag = NO;
    // selectedIndexValue = 1 for mostRecent , 2 for most popular, 3 for high to low, 4 for low to high
    
    int selectedIndexValue = [self sortFunc:[delegate.HomeSearchArray objectAtIndex:5]];
    NSString * postwithin = [self postWithinFunc:[delegate.HomeSearchArray objectAtIndex:4]];
    NSString *distanceStr = [self distanceFunc:[delegate.HomeSearchArray objectAtIndex:3]];
    
    
    
    [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:[delegate.HomeSearchArray objectAtIndex:8] category_id:[delegate.HomeSearchArray objectAtIndex:6] subcategory_id:[delegate.HomeSearchArray objectAtIndex:7] user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",selectedIndexValue] offset:@"0" limit:@"10" lat:[delegate.HomeSearchArray objectAtIndex:0] lon:[delegate.HomeSearchArray objectAtIndex:1] posted_within:postwithin distance:distanceStr];
}


#pragma mark  search result page ParsingFunction

/**
 Loading search datas under this funtion
 */

-(void) searchDatasparsing
{
    
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    
    //selectedIndexValue = 1 for mostRecent , 2 for most popular, 3 for high to low, 4 for low to high
    
    int selectedIndexValue = [self sortFunc:[delegate.HomeSearchArray objectAtIndex:5]];
    NSString * postwithin = [self postWithinFunc:[delegate.HomeSearchArray objectAtIndex:4]];
    NSString *distanceStr = [self distanceFunc:[delegate.HomeSearchArray objectAtIndex:3]];
    
    
    //    For Reference
    //    -(void)getItems:(NSString *)api_username :(NSString *)api_password :(NSString *)type :(NSString *)price :(NSString *)search_key :(NSString *)category_id :(NSString *)user_id :(NSString *)item_id :(NSString *)seller_id :(NSString *)sorting_id :(NSString *)offset :(NSString *)limit :(NSString *)lat :(NSString *)lon :(NSString *)distance {
    
    [homePageArray removeAllObjects];
    
    
    [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:[delegate.HomeSearchArray objectAtIndex:8] category_id:[delegate.HomeSearchArray objectAtIndex:6] subcategory_id:[delegate.HomeSearchArray objectAtIndex:7] user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",selectedIndexValue] offset:@"0" limit:@"10" lat:[delegate.HomeSearchArray objectAtIndex:0] lon:[delegate.HomeSearchArray objectAtIndex:1] posted_within:postwithin distance:distanceStr];
}

#pragma mark  pulltoRefresh and loadmore ParsingFunction

/**
 Reload functions
 */

- (void)refreshTable
{
    
    //    [delegate adminchecking];
    [homePageArray removeAllObjects];
    [collectionView reloadData];
    headerview.hidden = YES;
    //selectedIndexValue = 1 for mostRecent , 2 for most popular, 3 for high to low, 4 for low to high
    
    int selectedIndexValue = [self sortFunc:[delegate.HomeSearchArray objectAtIndex:5]];
    NSString * postwithin = [self postWithinFunc:[delegate.HomeSearchArray objectAtIndex:4]];
    NSString *distanceStr = [self distanceFunc:[delegate.HomeSearchArray objectAtIndex:3]];
    
    
    [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:[delegate.HomeSearchArray objectAtIndex:8] category_id:[delegate.HomeSearchArray objectAtIndex:6] subcategory_id:[delegate.HomeSearchArray objectAtIndex:7] user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",selectedIndexValue] offset:0 limit:@"10" lat:[delegate.HomeSearchArray objectAtIndex:0] lon:[delegate.HomeSearchArray objectAtIndex:1] posted_within:postwithin distance:distanceStr];
    
    //    [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:@"" category_id:[delegate.HomeSearchArray objectAtIndex:6] subcategory_id:[delegate.HomeSearchArray objectAtIndex:7] user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",selectedIndexValue] offset:@"0" limit:@"10" lat:[delegate.HomeSearchArray objectAtIndex:0] lon:[delegate.HomeSearchArray objectAtIndex:1] posted_within:postwithin distance:[delegate.HomeSearchArray objectAtIndex:3]];
    
    
}


/**
 Load more functions
 */

- (void)bottomrefreshTable:(void(^)(void))completion
{
    
    //selectedIndexValue = 1 for mostRecent , 2 for most popular, 3 for high to low, 4 for low to high, 5 for urgent
    
    //-(void)getItems:(NSString *)api_username :(NSString *)api_password :(NSString *)type :(NSString *)price :(NSString *)search_key :(NSString *)category_id :(NSString *)user_id :(NSString *)item_id :(NSString *)seller_id :(NSString *)sorting_id :(NSString *)offset :(NSString *)limit :(NSString *)lat :(NSString *)lon :(NSString *)distance {
    
    
    int selectedIndexValue = [self sortFunc:[delegate.HomeSearchArray objectAtIndex:5]];
    NSString * postwithin = [self postWithinFunc:[delegate.HomeSearchArray objectAtIndex:4]];
    NSString *distanceStr = [self distanceFunc:[delegate.HomeSearchArray objectAtIndex:3]];
    
    
    
    if([homePageArray count]%10==0 && [homePageArray count]>=10)
    {
        [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:[delegate.HomeSearchArray objectAtIndex:8] category_id:[delegate.HomeSearchArray objectAtIndex:6] subcategory_id:[delegate.HomeSearchArray objectAtIndex:7] user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",selectedIndexValue] offset:[NSString stringWithFormat:@"%d",(int)[homePageArray count]] limit:@"10" lat:[delegate.HomeSearchArray objectAtIndex:0] lon:[delegate.HomeSearchArray objectAtIndex:1] posted_within:postwithin distance:distanceStr];
    }
    else
    {
        [self performSelectorInBackground:@selector(stopLoading) withObject:nil];
    }
    if(completion) {
        completion();
    }
}

#pragma mark  - WSDL DelegateMethod
//proxy finished, (id)data is the object of the relevant method service

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
    
    @try {
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
        
        if ([method isEqualToString:@"getItems"])
        {
            if (homeCategorySearchEnable) {
                homeCategorySearchEnable = NO;
            }
        }
    }
    @catch (NSException * e) {
    }
    [self checkIfhavsData];
    [bottomrefreshControl endRefreshing];
    [refreshControl endRefreshing];
    [collectionView finishInfiniteScroll];
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    
    NSLog(@"method %@",method);
    //    NSLog(@"data %@",data);
    
    
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    
    if ([method isEqualToString:@"getItems"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj testingHomePageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
        if (homeCategorySearchEnable) {
            [homePageArray removeAllObjects];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                homeCategorySearchEnable = NO;
            });
        }
        if([[defaultDict objectForKey:@"status"] isEqualToString:@"true"]){
            [homePageArray addObjectsFromArray:[[defaultDict objectForKey:@"result"]objectForKey:@"items"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate.bannerEnable  && [delegate.bannerDetailsArray count]!=0)
            {
                loadingErrorViewBG.frame = CGRectMake(0, 285, delegate.windowWidth, 300);
                layout.headerHeight = 200+80;
                if (isBannerEnable)
                {
                    [self performSelectorOnMainThread:@selector(configureImageSlider) withObject:nil waitUntilDone:YES];
                    isBannerEnable = NO;
                }
            }
            else
            {
                loadingErrorViewBG.frame = CGRectMake(0, 140, delegate.windowWidth, 300);
                layout.headerHeight = 200-80;
            }
            [self.collectionView reloadData];
            [collectionView reloadData];
            [homeTableview reloadData];
            [self checkIfhavsData];
            [bottomrefreshControl endRefreshing];
        });
    }
    else if ([method isEqualToString:@"admindatas"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
        [delegate.getcategoryDict removeAllObjects];
        [delegate.getcategoryDict addEntriesFromDictionary:[defaultDict objectForKey:@"result"]];
        delegate.distancestring = [[defaultDict objectForKey:@"result"] objectForKey:@"distance_type"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
            {
                
                NSLog(@"result:%@",[defaultDict objectForKey:@"result"]);
                NSLog(@"promotion:%@",[[defaultDict objectForKey:@"result"] objectForKey:@"promotion"]);
              
                
                if([[[defaultDict objectForKey:@"result"] objectForKey:@"banner"] isEqualToString:@"disable"]){
                    delegate.bannerEnable = NO;
                    [homeTableview setFrame:CGRectMake(0,0,delegate.windowWidth,85)];
                    
                }else{
                    
                    delegate.bannerEnable = YES;
                    [homeTableview setFrame:CGRectMake(0,0,delegate.windowWidth,285)];
                    
                    @try {
                        [delegate.bannerDetailsArray removeAllObjects];
                        [delegate.bannerDetailsArray addObjectsFromArray:[[defaultDict objectForKey:@"result"] objectForKey:@"bannerData"]];
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        if([delegate.bannerDetailsArray count]==0){
                            [homeTableview setFrame:CGRectMake(0,0,delegate.windowWidth,85)];
                        }
                    }
                    
                }
                
              
                
            }
            [self categorysetting];
            [collectionView reloadData];
            [homeTableview reloadData];
        });
        
        
        
    }
}

#pragma mark - TableViewDelagate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag==100)
        return 1;
    else
        return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==100)
        return 44;
    else{
        if(indexPath.section==0){
            return 200;
        }
        if(indexPath.section==1){
            return 90;
        }
        return 200;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==100)
        return 1;
    else{
        if(section==0){
            if(delegate.bannerEnable && [delegate.bannerDetailsArray count]!=0)
                return 1;
            else
                return 0;
        }
        if(section==1){
            return 1;
        }
        return 1;
        return 1;
    }
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
    //To show current Location
    @try {
        
        if(tableView.tag==100){
            headerview = [[[UIView alloc] init] autorelease];
            // delegate.bannerEnable = NO;
            [headerview setFrame:CGRectMake(3,5,200,34)];
            [headerview setBackgroundColor:whitecolor];
            headerview.layer.cornerRadius=17;
            headerview.layer.masksToBounds=YES;
            headerview.layer.shadowColor = appblackcolor.CGColor;
            headerview.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            headerview.layer.shadowRadius = 2.0;
            headerview.layer.shadowOpacity = 0.5;
            headerview.alpha = 0.9;
            headerview.layer.masksToBounds = NO;
            headerview.userInteractionEnabled = YES;
            [cell.contentView addSubview:headerview];
            [headerview setBackgroundColor:[UIColor whiteColor]];
            
            
            UIImageView * Locationimg = [[[UIImageView alloc]init]autorelease];
            [Locationimg setImage:[UIImage imageNamed:@"locationGreens.png"]];
            [Locationimg setContentMode:UIViewContentModeScaleAspectFit];
            [headerview addSubview:Locationimg];
            //    Locationimg.image = [Locationimg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            //    [Locationimg setTintColor:AppThemeColor];
            
            UILabel * headerTextLbl = [[[UILabel alloc]init]autorelease];
            [headerTextLbl setTextColor:headercolor];
            [headerTextLbl setBackgroundColor:clearcolor];
            [headerTextLbl setTextAlignment:NSTextAlignmentLeft];
            [headerTextLbl setFont:[UIFont fontWithName:appFontRegular size:12]];
            [headerTextLbl setBackgroundColor:[UIColor whiteColor]];
            [headerTextLbl setFrame:CGRectMake(32,2,140,32)];
            [Locationimg setFrame:CGRectMake(10,5,15,24)];
            
            NSLog(@"delegate.HomeSearchArray1 %@",delegate.HomeSearchArray);
            [headerTextLbl setText:[NSString stringWithFormat:@"%@",[delegate.HomeSearchArray objectAtIndex:2]]];
            
            headerTextLbl.layer.cornerRadius=17;
            headerTextLbl.layer.masksToBounds=YES;
            
            [headerview addSubview:headerTextLbl];
            
            UIImageView * DropDownLbl = [[[UIImageView alloc]init]autorelease];
            [DropDownLbl setImage:[UIImage imageNamed:@"dropDownImg.png"]];
            [DropDownLbl setContentMode:UIViewContentModeScaleAspectFit];
            [DropDownLbl setFrame:CGRectMake(177,8,15,20)];
            [headerview addSubview:DropDownLbl];
            
            if ([[delegate.HomeSearchArray objectAtIndex:2]isEqualToString:@"WorldWide"])
            {
                [headerTextLbl setText:[NSString stringWithFormat:@"%@",[delegate.languageDict objectForKey:[delegate.HomeSearchArray objectAtIndex:2]]]];
                [headerview setFrame:CGRectMake(34,5,140,34)];
                [headerTextLbl setFrame:CGRectMake(32,2,81,32)];
                [Locationimg setFrame:CGRectMake(10,5,15,24)];
                [DropDownLbl setFrame:CGRectMake(115,5,15,24)];
            }
            
            UIButton * filtermapBtn = [[UIButton alloc] init];
            filtermapBtn.layer.cornerRadius=17;
            filtermapBtn.layer.masksToBounds=YES;
            [filtermapBtn addTarget:self action:@selector(mapviewredirect) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:filtermapBtn];
            
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [Locationimg setFrame:CGRectMake(175,5,15,24)];
                [DropDownLbl setFrame:CGRectMake(10,5,15,24)];
                [headerTextLbl setTextAlignment:NSTextAlignmentRight];
                if ([[delegate.HomeSearchArray objectAtIndex:2]isEqualToString:@"WorldWide"])
                {
                    [Locationimg setFrame:CGRectMake(120,5,15,24)];
                }
            }else{
                // [Locationimg setFrame:CGRectMake(10,5,15,24)];
                // [DropDownLbl setFrame:CGRectMake(170,8,15,20)];
            }
            [filtermapBtn setFrame:CGRectMake(0,5,200,34)];
        }
        else{
            if(indexPath.section==0){
                imageSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0,0,delegate.windowWidth, 200) andSlides: delegate.bannerDetailsArray];
                [imageSlider setBackgroundColor:BackGroundColor];
                imageSlider.delegate = self;
                [imageSlider setAutoSlide: YES];
                [imageSlider setPlaceholderImage:@"placeholder.png"];
                [imageSlider setContentMode: UIViewContentModeScaleAspectFill];
                [cell.contentView addSubview:imageSlider];
            }else if(indexPath.section==1){
                categoryScrollView = [UIScrollView new];
                [categoryScrollView setBackgroundColor:BackGroundColor];
                [categoryScrollView setContentSize:CGSizeMake([[delegate.getcategoryDict objectForKey:@"category"]count]*101, 0)];
                categoryScrollView.userInteractionEnabled = YES;
                [categoryScrollView setScrollEnabled:YES];
                [categoryScrollView setShowsVerticalScrollIndicator:NO];
                categoryScrollView.showsHorizontalScrollIndicator=NO;
                [cell.contentView addSubview:categoryScrollView];
                [categoryScrollView setFrame:CGRectMake(0,0,delegate.windowWidth, 85)];
                
                for(int i=0;i<[[delegate.getcategoryDict objectForKey:@"category"]count];i++)
                {
                    UIImageView * imageView = [UIImageView new];
                    [imageView setFrame:CGRectMake((i*100)+25,10,50,50)];
                    NSString *cat_imgstr = [NSString stringWithFormat:@"%@",[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_img"]];
                    cat_imgstr = [cat_imgstr stringByReplacingOccurrencesOfString:@"resized/40" withString:@"resized/200"];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:cat_imgstr]placeholderImage:[UIImage imageNamed:@"applogo.png"]];
                    imageView.layer.cornerRadius = 25;
                    imageView.layer.masksToBounds=YES;
                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
                    [imageView setUserInteractionEnabled:YES];
                    [imageView setTag:i];
                    [categoryScrollView addSubview:imageView];
                    
                    UILabel * contentLable = [[[UILabel alloc]init]autorelease];
                    [contentLable setFrame:CGRectMake((i*100)+10,imageView.frame.origin.y+imageView.frame.size.height,80,30)];
                    [contentLable setBackgroundColor:[UIColor clearColor]];
                    [contentLable setFont:[UIFont fontWithName:appFontRegular size:15]];
                    [contentLable setText:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_name"]];
                    [contentLable setTextColor:headercolor];
                    [contentLable setTextAlignment:NSTextAlignmentCenter];
                    [categoryScrollView addSubview:contentLable];
                    [contentLable setNumberOfLines:2];
                    
                    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotocategorypage:)];
                    [imageView addGestureRecognizer:imageTap];
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception in cell%@",exception);
    } @finally {
        
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}


#pragma mark TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void) reloadHeaderTabel
{
    
    [homePageHeaderTable reloadData];
}
#pragma mark  Redirect to filtermapview

-(void) mapviewredirect{
    
    delegate.advancesearchFlag = YES;
    delegate.FilterFromFlag=@"Home";
    FilterMapView * filterMapViewObj =[[FilterMapView alloc]initWithNibName:@"FilterMapView" bundle:nil];
    [self.navigationController pushViewController:filterMapViewObj animated:NO];
    [filterMapViewObj release];
}


- (CGFloat)imageWithImage:(CGFloat)width maxHeight:(CGFloat)height {
    
    CGFloat oldWidth = 1200;
    CGFloat oldHeight = 500;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    //    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    
    return newHeight;
}


#pragma mark - UICollectionViewDefinition

- (UICollectionView *)collectionView {
    /** Definition for CollectionView  **/
    
    
    if (!collectionView) {
        layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(15,10, 10,10);
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        // delegate.bannerEnable = NO;
        
        if(delegate.bannerEnable && [delegate.bannerDetailsArray count]!=0)
        {
            loadingErrorViewBG.frame = CGRectMake(0, 285, delegate.windowWidth, 300);
            layout.headerHeight = 285;
        }
        else
        {
            loadingErrorViewBG.frame = CGRectMake(0, 85, delegate.windowWidth, 300);
            layout.headerHeight = 85;
        }
        [self noItemFindFunction];
        
        collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [collectionView addSubview:loadingErrorViewBG];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.frame = CGRectMake(0, 0, delegate.windowWidth-0, delegate.windowHeight-120);
        
        //        collectionView.frame = CGRectMake(5,130, delegate.windowWidth-10, delegate.windowHeight-250);
        
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[CHTCollectionViewWaterfallCell class]
           forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
           forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                  withReuseIdentifier:HEADER_IDENTIFIER];
    }
    return collectionView;
}


- (NSArray *)cellSizes {
    
    /** Here we mentioned the code for size of collection view cells  **/
    _cellSizes = [NSMutableArray array];
    
    if ([homePageArray count] != 0 )
    {
        _cellSizes = [NSMutableArray array];
        [_cellSizes removeAllObjects];
        
        for (NSInteger i = 0; i < [homePageArray count]; i++)
        {
            CGSize size;
            UIImageView *sampleImage = [[[UIImageView alloc]init]autorelease];
            [sampleImage setFrame:CGRectMake(0,0,(delegate.windowWidth-30)/2,150)];
            CGSize size1 = [self aspectScaledImageSizeForImageView:sampleImage width:150 height:150];
            size=CGSizeMake(size1.width, size1.height+85);
            _cellSizes[i] =[NSValue valueWithCGSize:size];
        }
    }
    return _cellSizes;
}


- (CGSize) aspectScaledImageSizeForImageView:(UIImageView *)iv width:(float)wid height:(float)hgth
{
    
    float x,y;
    float a,b;
    x = iv.frame.size.width;
    y = iv.frame.size.height;
    a = wid;
    b = hgth;
    
    if ( x == a && y == b ) {           // image fits exactly, no scaling required
        // return iv.frame.size;
    }
    else if ( x > a && y > b ) {         // image fits completely within the imageview frame
        if ( x-a > y-b ) {              // image height is limiting factor, scale by height
            a = y/b * a;
            b = y;
        } else {
            b = x/a * b;                // image width is limiting factor, scale by width
            a = x;
        }
    }
    else if ( x < a && y < b ) {        // image is wider and taller than image view
        if ( a - x > b - y ) {          // height is limiting factor, scale by height
            a = y/b * a;
            b = y;
        } else {                        // width is limiting factor, scale by width
            b = x/a * b;
            a = x;
        }
    }
    else if ( x < a && y > b ) {        // image is wider than view, scale by width
        b = x/a * b;
        a = x;
    }
    else if ( x > a && y < b ) {        // image is taller than view, scale by height
        a = y/b * a;
        b = y;
    }
    else if ( x == a ) {
        a = y/b * a;
        b = y;
    } else if ( y == b ) {
        b = x/a * b;
        a = x;
    }
    
    
    return CGSizeMake(a,b);
    
}

#pragma mark  Life Cycle



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [homePageArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)loccollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[loccollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                   forIndexPath:indexPath];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemgestureAction:)];
    [cell addGestureRecognizer:singleTap];
    
    
    cell.tag=indexPath.row+10000;
    @try {
        
        
        if([homePageArray count]!=0){
            if ([[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"photos"]count]!=0)
            {
                [cell.ItemImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"photos"]objectAtIndex:0] objectForKey:@"item_url_main_350"]]]];
            }else{
                [cell.ItemImage setImage:[UIImage imageNamed:@"applogo.png"]];
                
            }
            double unixTimeStamp =[[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"posted_time"] doubleValue];
            NSTimeInterval timeInterval=unixTimeStamp;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSString *dateString=[dateFormatter stringFromDate:date];
            [cell.PostedTime setText:[NSDate dateDiff:dateString]];
            
            // [cell.PostedTime setText:[NSString stringWithFormat:@"%@",[[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"posted_time"] uppercaseString]]];
            if([[NSString stringWithFormat:@"%@",[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
                if(![[NSString stringWithFormat:@"%@",[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                    [cell.productType setText:[NSString stringWithFormat:@"\n%@",[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"promotion_type"]]];
                    if([[NSString stringWithFormat:@"\n%@",[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                        [cell.productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];
                        
                        [cell.productType setBackgroundColor:redcolor];
                    }else if([[NSString stringWithFormat:@"\n%@",[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
                        [cell.productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"ad"]]];
                        
                        [cell.productType setBackgroundColor:AdColor];
                    }
                }else{
                    [cell.productType setText:@""];
                    [cell.productType setBackgroundColor:clearcolor];
                }
            }else{
                [cell.productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"sold"]]];
                [cell.productType setBackgroundColor:soldOutColor];
            }
            NSArray * currency =[[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"currency_code"] componentsSeparatedByString:@"-"];
            NSString * currencyformat = [NSString stringWithFormat:@"%@ ",[currency objectAtIndex:0]];
            
            [cell.priceLbl setText:[NSString stringWithFormat:@"%@%@",currencyformat,[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"price"]]];
            
            
            
            
            [cell.productTitleLbl setText:[delegate attributestringtostring:[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"item_title"]]];
            [cell.productLocation setText:[[homePageArray objectAtIndex:indexPath.row]objectForKey:@"location"]];
            
            [cell.ItemImage setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-78)];
            [cell.PlaceholderImage setFrame:CGRectMake(0, cell.frame.size.height-128, cell.frame.size.width,50 )];
            [cell.PostedTime setFrame:CGRectMake(0, cell.frame.size.height-113,  cell.frame.size.width-5,30)];
            [cell.priceLbl setFrame:CGRectMake(10, cell.frame.size.height-78, cell.frame.size.width-15, 30)];
            [cell.productTitleLbl setFrame:CGRectMake(10, cell.frame.size.height-60, cell.frame.size.width-15,30 )];
            [cell.productType setFrame:CGRectMake(cell.frame.size.width-cell.productType.intrinsicContentSize.width-15, -4, cell.productType.intrinsicContentSize.width+10, 34)];
            [cell.productLocation setFrame:CGRectMake(10, cell.frame.size.height-30, cell.frame.size.width-15,30 )];
            [cell.lineView setFrame:CGRectMake(0, cell.frame.size.height-30, cell.frame.size.width, 1)];
            
            [cell.lineView setBackgroundColor:BackGroundColor];
            
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [cell.priceLbl setTextAlignment:NSTextAlignmentRight];
                [cell.productTitleLbl setTextAlignment:NSTextAlignmentRight];
                [cell.productLocation setTextAlignment:NSTextAlignmentRight];
                [cell.productType setFrame:CGRectMake(15, -4, cell.productType.intrinsicContentSize.width+10, 34)];
            }else{
                [cell.priceLbl setTextAlignment:NSTextAlignmentLeft];
                [cell.productTitleLbl setTextAlignment:NSTextAlignmentLeft];
                [cell.productLocation setTextAlignment:NSTextAlignmentLeft];
            }
            
        }
        return cell;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)loccollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    [reusableView setBackgroundColor:BackGroundColor];
    //    reusableView.backgroundColor = [UIColor blackColor];
    reusableView = [loccollectionView dequeueReusableSupplementaryViewOfKind:kind
                                                         withReuseIdentifier:HEADER_IDENTIFIER
                                                                forIndexPath:indexPath];
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [loccollectionView dequeueReusableSupplementaryViewOfKind:kind
                                                             withReuseIdentifier:HEADER_IDENTIFIER
                                                                    forIndexPath:indexPath];
        [reusableView addSubview:homeTableview];
        if(delegate.bannerEnable && [delegate.bannerDetailsArray count]!=0){
            [reusableView setFrame:CGRectMake(0, 0, delegate.windowWidth, 285)];
        }else{
            [reusableView setFrame:CGRectMake(0, 45, delegate.windowWidth, 85)];
        }
        //        [reusableView addSubview:categoryScrollView];
        
    }
    //    else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
    //        reusableView = [loccollectionView dequeueReusableSupplementaryViewOfKind:kind
    //                                                             withReuseIdentifier:FOOTER_IDENTIFIER
    //                                                                    forIndexPath:indexPath];
    //    }
    //
    
    return reusableView;
}

#pragma mark  CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([homePageArray count]!=0)
        return [self.cellSizes[indexPath.item] CGSizeValue];
    else
        return CGSizeMake(0, 0);
}
//#pragma mark  GestureAction

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{

//    if ([touch.view isKindOfClass:[UITableView class]]) {
//        return NO;
//    }
//    return YES;
//}

-(void)itemgestureAction:(UITapGestureRecognizer *) sender
{
    
    delegate.favHomeFlag = YES;
    int tag =(int)(UIGestureRecognizer*)[sender.view tag]-10000;
    int viewCount =[[[homePageArray objectAtIndex:tag]objectForKey:@"views_count"]intValue];
    viewCount = viewCount+1;
    
    if ([NSString stringWithFormat:@"%d",viewCount] != (NSString*)[NSNull null])
    {
        [[homePageArray objectAtIndex:tag]setObject:[NSString stringWithFormat:@"%d",viewCount] forKey:@"views_count"];
    }
    if (taptouch) {
        taptouch = NO;
        ItemDetailPage * itemDetailPageObj = [[ItemDetailPage alloc]initWithNibName:@"ItemDetailPage" bundle:nil];
        [itemDetailPageObj detailPageArray:homePageArray selectedIndex:tag];
        [self.navigationController pushViewController:itemDetailPageObj animated:YES];
        [itemDetailPageObj release];
    }
}

#pragma  mark - scrollviewdelegatemethod

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    CGFloat hei = self.collectionView.frame.origin.y;
    //
    //    CGRect headerFrame = homePageHeaderTable.frame;
    //    headerFrame.origin.y = MIN(homePageHeaderTable.frame.origin.y, categoryScrollView.contentOffset.y);
    //    homePageHeaderTable.frame = headerFrame;
    
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//
//    return NO;
//}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    collectionView.delegate = nil;
    collectionView.dataSource = nil;
    [super dealloc];
}


@end

