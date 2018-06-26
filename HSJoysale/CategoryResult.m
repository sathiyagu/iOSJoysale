//
//  CategoryResult.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 16/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * In tab two > we select any one category is show related data depend on that category.
 * we can customize this category page using filter, map.
 */

#import "CategoryResult.h"
#import "ItemDetailPage.h"
#import "CategoryAdvSearch.h"
#import "FilterMapView.h"

#import "NSDate+DateMath.h"

#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"


@interface CategoryResult ()

//Collection view cell size
@property (nonatomic, strong) NSMutableArray *cellSizes;

@end

@implementation CategoryResult
@synthesize collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialization
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    homePageHeaderTable = [[UITableView alloc]init];
    homePageArray = [[NSMutableArray alloc]initWithCapacity:0];
    loadingErrorViewBG = [[UIView alloc]init];
    filterArray = [[NSMutableArray alloc] init];
    filterScroll=[[UIScrollView alloc] init];
    
    //Appearance
    
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:BackGroundColor];
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:homePageHeaderTable];
    [self.view sendSubviewToBack:self.collectionView];
    [self.view addSubview:homePageHeaderTable];
    
    //Properties
    
    [homePageHeaderTable setDelegate:self];
    [homePageHeaderTable setDataSource:self];
    [homePageHeaderTable setScrollEnabled:NO];
    [homePageHeaderTable setBackgroundColor:clearcolor];
    [homePageHeaderTable setFrame:CGRectMake((delegate.windowWidth/2)-103,11,206,44)];
    [homePageHeaderTable setSeparatorColor:clearcolor];
    homePageHeaderTable.layer.masksToBounds=YES;
    [homePageHeaderTable reloadData];
    
    loadingErrorViewBG.frame = CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight);
    [loadingErrorViewBG setBackgroundColor:BackGroundClearColor];
    [loadingErrorViewBG setHidden:YES];
    [collectionView addSubview:loadingErrorViewBG];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [self.collectionView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.collectionView.alwaysBounceVertical = YES;
    
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    
    //Functionalities
    
    /*if (delegate.currentlatitude!=0&&![[delegate.advanceCategorySearchArray objectAtIndex:2]isEqualToString:@"WorldWide"])
     {
     [delegate.selectedLocationArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",delegate.currentlatitude]];
     [delegate.selectedLocationArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",delegate.currentlongitude]];
     [delegate.advanceCategorySearchArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",delegate.currentlatitude]];
     [delegate.advanceCategorySearchArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",delegate.currentlongitude]];
     }
     else
     {
     [delegate.selectedLocationArray replaceObjectAtIndex:0 withObject:@""];
     [delegate.selectedLocationArray replaceObjectAtIndex:1 withObject:@""];
     [delegate.selectedLocationArray replaceObjectAtIndex:2 withObject:@"WorldWide"];
     [self performSelectorOnMainThread:@selector(reloadHeaderTabel) withObject:nil waitUntilDone:YES];
     }*/
    
    
    //Functionality
    delegate.filterBtnTapped=NO;
    
    //Fuctions
    [self noItemFindFunction];
    [self loadingIndicator];
    [self barButtonFunction];
    [self filterscroll];
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(loadingHomePageData) withObject:nil waitUntilDone:YES];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void) viewWillAppear:(BOOL)animated
{
    //Appearance
  
    
[self.navigationController.navigationBar setBottomBorderColor:AppThemeColor height:0.7];
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
    [self barButtonFunction];
    //    [delegate adminchecking];
    
    //Functionality
    count=0;
    if (delegate.filterBtnTapped || [delegate.deleteProduct isEqualToString:@"YES"] || [delegate.promoteProduct isEqualToString:@"YES"])
    {
        delegate.deleteProduct=@"";
        delegate.promoteProduct =@"";
        [self filterscroll];
        delegate.filterBtnTapped = NO;
        [homePageArray removeAllObjects];
        [collectionView reloadData];
        [homePageHeaderTable reloadData];
        [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(loadingHomePageData) withObject:nil waitUntilDone:YES];
    }
    [self performSelectorOnMainThread:@selector(reloadHeaderTabel) withObject:nil waitUntilDone:YES];
    [super viewWillAppear:animated];
}


#pragma mark - NavigationItems

-(void) barButtonFunction
{
    UIView * leftNaviNaviButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,delegate.windowWidth, 44)];
    [leftNaviNaviButtonView setBackgroundColor:AppThemeColor];
    UIBarButtonItem * negativeSpacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]autorelease];
    if (isAboveiOSVersion7)
    {
        negativeSpacer.width = -20;
    }
    else
    {
        negativeSpacer.width = -16;
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setTag:1000];
    [backBtn setFrame:CGRectMake(0+[HSUtility adjustablePadding],2,45,40)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:backBtn];
    
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    
    [titleLabel setText:[delegate.languageDict objectForKey:@"category"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *advanceSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [advanceSearch setBackgroundColor:[UIColor clearColor]];
    [advanceSearch setTag:1000];
    [advanceSearch setFrame:CGRectMake(delegate.windowWidth-50+[HSUtility adjustablePadding],0,50,44)];
    [advanceSearch setImage:[UIImage imageNamed:@"search_adv.png"] forState:UIControlStateNormal];
    [advanceSearch setImage:[UIImage imageNamed:@"search_adv.png"] forState:UIControlStateHighlighted];
    [advanceSearch addTarget:self action:@selector(advanceSearchTapped) forControlEvents:UIControlEventTouchUpInside];
    [advanceSearch.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [leftNaviNaviButtonView addSubview:advanceSearch];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark - advancecategorySearch

-(void)advanceSearchTapped
{
    delegate.filterBtnTapped=YES;
    CategoryAdvSearch * CategoryAdvSearchObj = [[CategoryAdvSearch alloc]initWithNibName:@"CategoryAdvSearch" bundle:nil];
    [self.navigationController pushViewController:CategoryAdvSearchObj animated:YES];
    [CategoryAdvSearchObj release];
}


#pragma mark - AppearData when PageLoad

-(void) loadingHomePageData
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    latituted = [[delegate.advanceCategorySearchArray objectAtIndex:0] floatValue];
    int selectedIndexValue = [self sortFunc:[delegate.advanceCategorySearchArray objectAtIndex:5]];
    NSString * postwithin = [self postWithinFunc:[delegate.advanceCategorySearchArray objectAtIndex:4]];
    NSString *distanceStr = [self distanceFunc:[delegate.advanceCategorySearchArray objectAtIndex:3]];

    
    //For Reference Data Passing
    //-(void)getItems:(NSString *)api_username :(NSString *)api_password :(NSString *)type :(NSString *)price :(NSString *)search_key :(NSString *)category_id :(NSString *)user_id :(NSString *)item_id :(NSString *)seller_id :(NSString *)sorting_id :(NSString *)offset :(NSString *)limit :(NSString *)lat :(NSString *)lon :(NSString *)distance {
    
    [homePageArray removeAllObjects];
    
    [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:@"" category_id:[delegate.advanceCategorySearchArray objectAtIndex:6] subcategory_id:[delegate.advanceCategorySearchArray objectAtIndex:7] user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",selectedIndexValue] offset:@"0" limit:@"20" lat:[delegate.advanceCategorySearchArray objectAtIndex:0] lon:[delegate.advanceCategorySearchArray objectAtIndex:1] posted_within:postwithin distance:distanceStr];
    
}

#pragma mark - pulltoRefresh and loadmore ParsingFunction

/**
 Reload functions
 */

- (void)refreshTable
{
    //    [delegate adminchecking];
    [homePageArray removeAllObjects];
    [collectionView reloadData];
    headerview.hidden = YES;
    if([homePageArray count]!=0)
    {
        [collectionView reloadData];
    }
    
    
    //selectedIndexValue = 1 for mostRecent , 2 for most popular, 3 for high to low, 4 for low to high
    
    int selectedIndexValue = [self sortFunc:[delegate.advanceCategorySearchArray objectAtIndex:5]];
    NSString * postwithin = [self postWithinFunc:[delegate.advanceCategorySearchArray objectAtIndex:4]];
    NSString *distanceStr = [self distanceFunc:[delegate.advanceCategorySearchArray objectAtIndex:3]];

    
    [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:@"" category_id:[delegate.advanceCategorySearchArray objectAtIndex:6] subcategory_id:[delegate.advanceCategorySearchArray objectAtIndex:7] user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",selectedIndexValue] offset:@"0" limit:@"20" lat:[delegate.advanceCategorySearchArray objectAtIndex:0] lon:[delegate.advanceCategorySearchArray objectAtIndex:1] posted_within:postwithin distance:distanceStr];
    
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
/**
 Load more functions
 */

- (void)bottomrefreshTable:(void(^)(void))completion
{
    //selectedIndexValue = 1 for mostRecent , 2 for most popular, 3 for high to low, 4 for low to high
    
    //-(void)getItems:(NSString *)api_username :(NSString *)api_password :(NSString *)type :(NSString *)price :(NSString *)search_key :(NSString *)category_id :(NSString *)user_id :(NSString *)item_id :(NSString *)seller_id :(NSString *)sorting_id :(NSString *)offset :(NSString *)limit :(NSString *)lat :(NSString *)lon :(NSString *)distance {
    
    
    
    int selectedIndexValue = [self sortFunc:[delegate.advanceCategorySearchArray objectAtIndex:5]];
    NSString * postwithin = [self postWithinFunc:[delegate.advanceCategorySearchArray objectAtIndex:4]];
    NSString *distanceStr = [self distanceFunc:[delegate.advanceCategorySearchArray objectAtIndex:3]];

    
    if([homePageArray count]%20==0 && [homePageArray count]>=20)
    {
        [self apiCallingFunction:apiusername api_password:apipassword type:@"search" price:@"" search_key:@"" category_id:[delegate.advanceCategorySearchArray objectAtIndex:6] subcategory_id:[delegate.advanceCategorySearchArray objectAtIndex:7] user_id:@"" item_id:@"" seller_id:@"" sorting_id:[NSString stringWithFormat:@"%d",selectedIndexValue] offset:[NSString stringWithFormat:@"%d",(int)[homePageArray count]] limit:@"20" lat:[delegate.advanceCategorySearchArray objectAtIndex:0] lon:[delegate.advanceCategorySearchArray objectAtIndex:1] posted_within:postwithin distance:distanceStr];
        
    }else{
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
        
    }
    if(completion) {
        completion();
    }
    
}


#pragma mark - Proxy Results


-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exception in service %@",method);
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    [self checkIfhavsData];
    
}

-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj testingHomePageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
    [homePageArray addObjectsFromArray:[[defaultDict objectForKey:@"result"]objectForKey:@"items"]];
    
    
    if([homePageArray count]%20==0 && [homePageArray count]>=20){
        
        // Add infinite scroll handler
        [collectionView addInfiniteScrollWithHandler:^(UICollectionView *collectionView) {
            [self bottomrefreshTable:^{
                // Finish infinite scroll animations
            }];
        }];
        
    }
    
    if([homePageArray count]>1)
    {
        [self filterscroll];
        
        
    }
    
    [collectionView reloadData];
    
    [self checkIfhavsData];
    
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

#pragma mark - Start and stop Loader

-(void) startLoadig
{
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
}

-(void) stopLoading
{
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    headerview.hidden = NO;
    [refreshControl endRefreshing];
    [collectionView finishInfiniteScroll];
}

#pragma mark - If no data in parsing it show alert

-(void) noItemFindFunction
{
    UIImageView *loadingErrorImageView = [[UIImageView alloc]init];
    loadingErrorImageView.frame = CGRectMake(delegate.windowWidth/2-100, delegate.windowHeight/2-150, 200, 150);
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
    [noItemFindLabel setText:@"No Category to be Displayed"];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    
    
    [collectionView addSubview:loadingErrorViewBG];
    
    
    
}

#pragma mark - show and hide noitemfound

-(void)checkIfhavsData
{
    if ([homePageArray count]==0)
    {
        [loadingErrorViewBG setHidden:NO];
    }
    else
    {
        [loadingErrorViewBG setHidden:YES];
    }
}

#pragma mark - Reloadtable

-(void) reloadHeaderTabel
{
    [homePageHeaderTable reloadData];
}

#pragma  mark - filterscroll

-(void) filterscroll {
    
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
    
    [filterArray removeAllObjects];
    NSString *categoryID=@"";
    NSString *subcategoryID=@"";
    for(int j=0;j<[[delegate.getcategoryDict objectForKey:@"category"] count];j++){
        for (id key in delegate.CategoryDictForCatID) {
            if([[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_id"]==key){
                count+=1;
                [filterArray addObject:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_name"]];
                NSString *c = [[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_id"];
                
                if([[delegate.CategoryDictForCatID objectForKey:key]isEqualToString:@"0"
                    ]){
                    if([categoryID isEqualToString:@""]){
                        categoryID=[categoryID stringByAppendingString:c];
                    }else{
                        categoryID=[categoryID stringByAppendingString:[NSString stringWithFormat:@",%@",c]];
                    }
                }
                else{
                    NSString *s = [delegate.CategoryDictForCatID objectForKey:key];
                    
                    if([subcategoryID isEqualToString:@""]){
                        subcategoryID=[subcategoryID stringByAppendingString:s];
                    }else{
                        subcategoryID=[subcategoryID stringByAppendingString:[NSString stringWithFormat:@",%@",s]];
                    }
                }
            }
        }
    }
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:6 withObject:categoryID];
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:7 withObject:subcategoryID];
    if(![[delegate.advanceCategorySearchArray objectAtIndex:4] isEqualToString:@""]){
        [filterArray addObject:[delegate.advanceCategorySearchArray objectAtIndex:4]];
        count+=1;
    }
    if(![[delegate.advanceCategorySearchArray objectAtIndex:3] isEqualToString:@""]){
        [filterArray addObject:[delegate.advanceCategorySearchArray objectAtIndex:3]];
        count+=1;

    }
    if(![[delegate.advanceCategorySearchArray objectAtIndex:5] isEqualToString:@""]){
        [filterArray addObject:[delegate.advanceCategorySearchArray objectAtIndex:5]];
        count+=1;
    }
    
    if(count==0){
        collectionView.frame = CGRectMake(5, -5, delegate.windowWidth-10, delegate.windowHeight-120);
        [homePageHeaderTable setFrame:CGRectMake((delegate.windowWidth/2)-103,11,206,44)];
        [filterScroll setBackgroundColor:clearcolor];

        
    }else{
        collectionView.frame = CGRectMake(5,40, delegate.windowWidth-10, delegate.windowHeight-160);
        [homePageHeaderTable setFrame:CGRectMake((delegate.windowWidth/2)-103,51,206,44)];
        [filterScroll setBackgroundColor:AppThemeColor];

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
        
        [Filterview setFrame:CGRectMake(width, 6, filterlable.intrinsicContentSize.width+38, 29)];
        [filterlable setFrame:CGRectMake(10, 0, filterlable.intrinsicContentSize.width, 29)];
        [filtercloseBtn setFrame:CGRectMake(filterlable.frame.size.width+filterlable.frame.origin.x+5, 5, 20, 20)];
        
        width=Filterview.frame.size.width+Filterview.frame.origin.x+5;
        
    }
    [filterScroll setContentSize:CGSizeMake(width, 45)];
}

-(void) removeFilter:(id) sender{
    int count_id=0;
    NSMutableDictionary * CategoryDictForCatIDtemp;
    CategoryDictForCatIDtemp = [[[NSMutableDictionary alloc]initWithCapacity:0] autorelease];
    [CategoryDictForCatIDtemp addEntriesFromDictionary:delegate.CategoryDictForCatID];
    
    for(int j=0;j<[[delegate.getcategoryDict objectForKey:@"category"] count];j++){
        for (id key in CategoryDictForCatIDtemp) {
            
            if([[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_id"]==key){
                
                if(count_id==(int)[sender tag]){
                    [delegate.CategoryDictForCatID removeObjectForKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:j] objectForKey:@"category_id"]];
                    
                }
                count_id+=1;
                //                [filterArray addObject:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:j]objectForKey:@"category_name"]];
                
            }
        }
    }
    
    
    if([[delegate.advanceCategorySearchArray objectAtIndex:4] isEqualToString:[filterArray objectAtIndex:(long)[sender tag]]]){
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:4 withObject:@""];
    }
    if([[delegate.advanceCategorySearchArray objectAtIndex:5] isEqualToString:[filterArray objectAtIndex:(long)[sender tag]]]){
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:5 withObject:@""];
    }
    if([[delegate.advanceCategorySearchArray objectAtIndex:3] isEqualToString:[filterArray objectAtIndex:(long)[sender tag]]]){
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:3 withObject:@""];
    }
    [self filterscroll];
    [self performSelectorOnMainThread:@selector(loadingHomePageData) withObject:nil waitUntilDone:YES];
    
    
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

#pragma mark - TableViewDelagate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    headerview = [[[UIView alloc] init] autorelease];
    [headerview setFrame:CGRectMake(3,5,200,34)];
    [headerview setBackgroundColor:whitecolor];
    headerview.layer.cornerRadius=17;
    headerview.layer.masksToBounds=YES;
    headerview.layer.shadowColor = appblackcolor.CGColor;
    headerview.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    headerview.layer.shadowRadius = 2.0;
    headerview.layer.shadowOpacity = 0.5;
    headerview.layer.masksToBounds = NO;
    [cell.contentView addSubview:headerview];
    
    UIImageView * Locationimg = [[[UIImageView alloc]init]autorelease];
    [Locationimg setImage:[UIImage imageNamed:@"locationGreens.png"]];
    //[Locationimg setFrame:CGRectMake(10,5,15,24)];

    [Locationimg setContentMode:UIViewContentModeScaleAspectFit];
    [headerview addSubview:Locationimg];
    
    UILabel * headerTextLbl = [[[UILabel alloc]init]autorelease];
    [headerTextLbl setTextColor:headercolor];
    [headerTextLbl setText:[delegate.advanceCategorySearchArray objectAtIndex:2]];
   /* if ([[delegate.advanceCategorySearchArray objectAtIndex:2]isEqualToString:@"WorldWide"])
    {
        [headerTextLbl setText:[NSString stringWithFormat:@"%@",[delegate.languageDict objectForKey:[delegate.advanceCategorySearchArray objectAtIndex:2]]]];
        
    }*/
    [Locationimg setFrame:CGRectMake(10,5,15,24)];
    [headerTextLbl setFrame:CGRectMake(32,2,140,32)];
    
    //[headerTextLbl setFrame:CGRectMake(28,2,145,32)];
    [headerTextLbl setBackgroundColor:whitecolor];
    [headerTextLbl setTextAlignment:NSTextAlignmentLeft];
    headerTextLbl.layer.cornerRadius=17;
    headerTextLbl.layer.masksToBounds=YES;
    [headerTextLbl setFont:[UIFont fontWithName:appFontRegular size:12]];
    [headerview addSubview:headerTextLbl];
    
    UIImageView * DropDownLbl = [[[UIImageView alloc]init]autorelease];
    [DropDownLbl setImage:[UIImage imageNamed:@"dropDownImg.png"]];
//    [DropDownLbl setFrame:CGRectMake(175,5,15,24)];
    [DropDownLbl setFrame:CGRectMake(177,8,15,20)];
    [DropDownLbl setContentMode:UIViewContentModeScaleAspectFit];
    [headerTextLbl setFont:[UIFont fontWithName:appFontRegular size:12]];
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
    [filtermapBtn setFrame:CGRectMake(0,5,200,34)];
    filtermapBtn.layer.cornerRadius=17;
    filtermapBtn.layer.masksToBounds=YES;
    [filtermapBtn addTarget:self action:@selector(mapviewredirect) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:filtermapBtn];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark TableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Redirect to filtermapview

-(void) mapviewredirect{
    delegate.filterBtnTapped = YES;
    delegate.FilterFromFlag=@"Category";
    FilterMapView * filterMapViewObj =[[FilterMapView alloc]initWithNibName:@"FilterMapView" bundle:nil];
    [self.navigationController pushViewController:filterMapViewObj animated:NO];
    [filterMapViewObj release];
    
}

#pragma mark - UICollectionViewDefinition


- (UICollectionView *)collectionView {
    /** Definition for CollectionView  **/
    
    if (!collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[[CHTCollectionViewWaterfallLayout alloc] init]autorelease];
        
        layout.sectionInset = UIEdgeInsetsMake(15, 5, 10, 5);
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        //        collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [collectionView addSubview:loadingErrorViewBG];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.frame = CGRectMake(5,40, delegate.windowWidth-10, delegate.windowHeight-160);
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[CHTCollectionViewWaterfallCell class]
           forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
           forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                  withReuseIdentifier:HEADER_IDENTIFIER];
        [collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
           forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                  withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return collectionView;
}

#pragma mark  UICollectionViewCellSize

- (NSArray *)cellSizes {
    
    /** Here we mentioned the code for size of collection view cells  **/
    
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

#pragma mark calculate UICollectionViewCellSize depend on image height and size

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

#pragma mark Life Cycle



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
        [cell.priceLbl setFrame:CGRectMake(5, cell.frame.size.height-78, cell.frame.size.width-10, 30)];
        [cell.productTitleLbl setFrame:CGRectMake(10, cell.frame.size.height-60, cell.frame.size.width-15,30 )];
        [cell.productType setFrame:CGRectMake(cell.frame.size.width-cell.productType.intrinsicContentSize.width-15, -4, cell.productType.intrinsicContentSize.width+10, 30+4)];
        [cell.productLocation setFrame:CGRectMake(10, cell.frame.size.height-30, cell.frame.size.width-15,30 )];
        [cell.lineView setFrame:CGRectMake(0, cell.frame.size.height-30, cell.frame.size.width, 1)];
            [cell.priceLbl setTextColor:AppTextColor];
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [cell.priceLbl setTextAlignment:NSTextAlignmentRight];
            [cell.productTitleLbl setTextAlignment:NSTextAlignmentRight];
            [cell.productLocation setTextAlignment:NSTextAlignmentRight];
            [cell.productType setFrame:CGRectMake(15, -4, cell.productType.intrinsicContentSize.width+10, 30+4)];
        }else{
            [cell.priceLbl setTextAlignment:NSTextAlignmentLeft];
            [cell.productTitleLbl setTextAlignment:NSTextAlignmentLeft];
            [cell.productLocation setTextAlignment:NSTextAlignmentLeft];
        }
        
    }
    return cell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)loccollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [loccollectionView dequeueReusableSupplementaryViewOfKind:kind
                                                             withReuseIdentifier:HEADER_IDENTIFIER
                                                                    forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [loccollectionView dequeueReusableSupplementaryViewOfKind:kind
                                                             withReuseIdentifier:FOOTER_IDENTIFIER
                                                                    forIndexPath:indexPath];
    }
    return reusableView;
}

#pragma mark  CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item] CGSizeValue];
}

#pragma mark - SelectingProduct

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
    
    //Pass data to ItemDetail page and display
    
    ItemDetailPage * itemDetailPageObj = [[ItemDetailPage alloc]initWithNibName:@"ItemDetailPage" bundle:nil];
    [itemDetailPageObj detailPageArray:homePageArray selectedIndex:tag];
    [self.navigationController pushViewController:itemDetailPageObj animated:YES];
    [itemDetailPageObj release];
}

#pragma mark- barButtonFunctions

-(void)backBtnTapped
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    delegate.CategoryTabbed=@"Category";
    [delegate.CategoryDictForCatID removeAllObjects];
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:0 withObject:[delegate.selectedLocationArray objectAtIndex:0]];//latitude
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:1 withObject:[delegate.selectedLocationArray objectAtIndex:1]];//longitude
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:2 withObject:[delegate.selectedLocationArray objectAtIndex:2]];//address
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:3 withObject:@""];//latitude
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:4 withObject:@""];//longitude
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:5 withObject:@""];//address
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark CallingApiModal
-(void) apiCallingFunction:(NSString*)api_username api_password:(NSString*)api_password type:(NSString *)type price:(NSString *)price search_key:(NSString *)search_key category_id:(NSString *)category_id subcategory_id:(NSString *)subcategory_id user_id:(NSString *)user_id item_id:(NSString *)item_id seller_id:(NSString *)seller_id sorting_id:(NSString *)sorting_id offset:(NSString *)offset limit:(NSString *)limit lat:(NSString *)lat lon:(NSString *)lon posted_within:(NSString *)posted_within distance:(NSString*)distance
{
    NSLog(@"api_username :%@ api_password :%@  type :%@  price :%@  search_key :%@  category_id :%@  subcategory_id :%@  user_id :%@  item_id :%@  seller_id :%@  sorting_id :%@  offset :%@  limit :%@  lat :%@  lon :%@  posted_within :%@  distance:%@  ",api_username ,api_password ,type ,price ,search_key ,category_id ,subcategory_id ,user_id ,item_id ,seller_id ,sorting_id ,offset ,limit ,lat ,lon ,posted_within ,distance);
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        if( [[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:2] isEqualToString:@"WorldWide"]){
            lat = @"";
            lon = @"";
        }
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=NULL)
        {
            [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :user_id :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within:distance];
        }else{
            [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :@"" :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within:distance];
        }
    }
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
