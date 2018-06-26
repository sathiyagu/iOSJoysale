//
//  CategoryPage.m
//  HSJoysale
//
//  Created by BTMANI on 01/09/15.
//  Copyright (c) 2015 BTMANI. All rights reserved.
//
/*
 * Main navigation second tab view. it show all parent category depend on location we can filter selected category result. after that we can remove selected category.
 */


#import "CategoryTab.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "CategoryResult.h"

@interface CategoryTab ()

@end

@implementation CategoryTab

- (void)viewDidLoad {
    
    //initialization
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    categorPageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //Appearance
    
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];
    [self setNeedsStatusBarAppearanceUpdate];


    
    //Properties
    
    [categoryTable setBackgroundColor:BackGroundColor];
    [categoryTable reloadData];
    [categoryTable setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight-115)];
    
    //Functionalities
    
   /* [delegate.advanceCategorySearchArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:0]];//latitude
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:1]];//longitude
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:2 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:2]];//address
    */
    if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6] isEqualToString:@"WorldWide"]){
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:0 withObject:@""];//latitude 0
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:1 withObject:@""];//longitude 1
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:2 withObject:@"WorldWide"];//longitude 1
    }else if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6] isEqualToString:@"setLocation"]){
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:0]];//latitude 0
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:1]];//longitude 1
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:2 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:2]];//longitude 1
    }
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:3 withObject:@""];//distance
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:4 withObject:@""];//PostWithin
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:5 withObject:@""];//sortBy
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:6 withObject:@""];//Category
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:7 withObject:@""];//SubCategory


    //FunctionCall
    
    [self noItemFindFunction];
    [self barButtonFunction];
    [super viewDidLoad];
    
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

    [self setNeedsStatusBarAppearanceUpdate];

    //Appearance
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
    [self barButtonFunction];
    if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6] isEqualToString:@"WorldWide"]){
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:0 withObject:@""];//latitude 0
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:1 withObject:@""];//longitude 1
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:2 withObject:@"WorldWide"];//longitude 1
    }else if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:6] isEqualToString:@"setLocation"]){
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:0 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:0]];//latitude 0
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:1 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:1]];//longitude 1
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:2 withObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]objectAtIndex:2]];//longitude 1
    }
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:3 withObject:@""];//distance
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:4 withObject:@""];//PostWithin
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:5 withObject:@""];//sortBy
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:6 withObject:@""];//Category
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:7 withObject:@""];//SubCategory
    [delegate.CategoryDictForCatID removeAllObjects];
    
    //Again call api because recently any category added means it will updated
    [self defaultDataParsing];
   // [categoryTable reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - If no data in parsing it show alert

-(void) noItemFindFunction
{
    loadingErrorViewBG = [[UIView alloc]init];
    loadingErrorViewBG.frame = CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];
    [categoryTable addSubview:loadingErrorViewBG];
    
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
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"noCategoryfound"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark - show and hide noitemfound

-(void)checkIfhavsData
{
    if ([delegate.getcategoryDict count]==0)
    {
        [loadingErrorViewBG setHidden:NO];
    }
    else
    {
        [loadingErrorViewBG setHidden:YES];
    }
}


#pragma mark - barButtonFunctions

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
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"categories"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}



#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 151;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Single row have two view, so calculate number of rows in section
    return ([[delegate.getcategoryDict objectForKey:@"category"]count]/2)+([[delegate.getcategoryDict objectForKey:@"category"]count]%2);
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

    int indexrow = (int) indexPath.row * 2;
    
    UIView * contentview = [[[UIView alloc]init]autorelease];
    [contentview setBackgroundColor:whitecolor];
    [contentview setFrame:CGRectMake(5,0,delegate.windowWidth-10,150)];
    
    UIImageView * categoryImageview = [[[UIImageView alloc]init]autorelease];
    [categoryImageview setFrame:CGRectMake(5,10,((contentview.frame.size.width/2))-13,100)];
    [categoryImageview setBackgroundColor:[UIColor clearColor]];
    categoryImageview.layer.borderWidth = 0;
    categoryImageview.layer.borderColor = AdvanceSearchPageColor.CGColor;
    [categoryImageview setUserInteractionEnabled:YES];
    [categoryImageview setContentMode:UIViewContentModeScaleAspectFit];
    categoryImageview.layer.masksToBounds=YES;
    NSString *cat_imgstr = [NSString stringWithFormat:@"%@",[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexrow]objectForKey:@"category_img"]];
    cat_imgstr = [cat_imgstr stringByReplacingOccurrencesOfString:@"resized/40"
                                                       withString:@"resized/200"];
    [categoryImageview sd_setImageWithURL:[NSURL URLWithString:cat_imgstr]placeholderImage:[UIImage imageNamed:@"applogo.png"]];
    
    [contentview addSubview:categoryImageview];
    
    UILabel * contentLable = [[[UILabel alloc]init]autorelease];
    [contentLable setFrame:CGRectMake(5,110,((contentview.frame.size.width/2))-13,40)];
    [contentLable setBackgroundColor:[UIColor clearColor]];
    [contentLable setFont:[UIFont fontWithName:appFontRegular size:15]];
    [contentLable setText:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexrow]objectForKey:@"category_name"]];
    [contentLable setTextColor:headercolor];
    [contentLable setTextAlignment:NSTextAlignmentCenter];
    [contentview addSubview:contentLable];
    [contentLable setNumberOfLines:2];
    
    UIImageView * categoryImageviewOne = [[[UIImageView alloc]init]autorelease];
    [categoryImageviewOne setFrame:CGRectMake(((contentview.frame.size.width/2))+7,10,((contentview.frame.size.width/2))-13,100)];
    [categoryImageviewOne setBackgroundColor:[UIColor clearColor]];
    categoryImageviewOne.layer.borderWidth = 0;
    categoryImageviewOne.layer.borderColor = AdvanceSearchPageColor.CGColor;
    [categoryImageviewOne setUserInteractionEnabled:YES];
    [categoryImageviewOne setContentMode:UIViewContentModeScaleAspectFit];
    categoryImageviewOne.layer.masksToBounds=YES;
    
    UILabel * contentLableOne = [[[UILabel alloc]init]autorelease];
    [contentLableOne setBackgroundColor:[UIColor clearColor]];
    [contentLableOne setFont:[UIFont fontWithName:appFontRegular size:15]];
    [contentLableOne setTextColor:headercolor];
    [contentLableOne setFrame:CGRectMake(((contentview.frame.size.width/2))+7,110,((contentview.frame.size.width/2))-13,40)];
    [contentLableOne setTextAlignment:NSTextAlignmentCenter];
    [contentLableOne setNumberOfLines:2];
    
    UIView * lineview = [[[UIView alloc]init]autorelease];
    [lineview setBackgroundColor:lineviewColor];
    [lineview setFrame:CGRectMake(0,150,contentview.frame.size.width,0.7)];
    [contentview addSubview:lineview];
    
    UIView * lineviewVertical = [[[UIView alloc]init]autorelease];
    [lineviewVertical setBackgroundColor:lineviewColor];
    [lineviewVertical setFrame:CGRectMake(contentview.frame.size.width/2,0,1,contentview.frame.size.height)];
    
    UIButton * CategoryBtnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [CategoryBtnOne setFrame:CGRectMake(0,0,contentview.frame.size.width/2,150)];
    [contentview addSubview:CategoryBtnOne];
    [CategoryBtnOne addTarget:self action:@selector(selectedCategory:) forControlEvents:UIControlEventTouchUpInside];
    [CategoryBtnOne setTag:indexrow];
    
    UIButton * CategoryBtntwo = [[UIButton alloc] init];
    [CategoryBtntwo setFrame:CGRectMake((contentview.frame.size.width/2),0,contentview.frame.size.width/2,150)];
    
    if(([[delegate.getcategoryDict objectForKey:@"category"]count]/2)+([[delegate.getcategoryDict objectForKey:@"category"]count]%2)-1==indexPath.row){
        if([[delegate.getcategoryDict objectForKey:@"category"]count]%2==0){
            NSString *cat_imgstr = [NSString stringWithFormat:@"%@",[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexrow+1]objectForKey:@"category_img"]];
            cat_imgstr = [cat_imgstr stringByReplacingOccurrencesOfString:@"resized/40"
                                                               withString:@"resized/200"];
            [categoryImageviewOne sd_setImageWithURL:[NSURL URLWithString:cat_imgstr]placeholderImage:[UIImage imageNamed:@"applogo.png"]];
            [contentLableOne setFrame:CGRectMake(((contentview.frame.size.width/2))+7,110,((contentview.frame.size.width/2))-13,40)];
            [contentLableOne setText:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexrow+1]objectForKey:@"category_name"]];
            [CategoryBtntwo setTag:indexrow+1];
            [CategoryBtntwo addTarget:self action:@selector(selectedCategory:) forControlEvents:UIControlEventTouchUpInside];
            
            [contentview addSubview:contentLableOne];
            [contentview addSubview:categoryImageviewOne];
            [contentview addSubview:lineviewVertical];
            [contentview addSubview:CategoryBtntwo];
        }else{
            [CategoryBtnOne setFrame:CGRectMake(0,0,contentview.frame.size.width,150)];
            [categoryImageview setFrame:CGRectMake(((contentview.frame.size.width/2)-(((contentview.frame.size.width/2))-13)/2),10,((contentview.frame.size.width/2))-13,100)];
            [contentLable setFrame:CGRectMake(5,110,((contentview.frame.size.width))-15,40)];
        }
    }else{
        NSString *cat_imgstr = [NSString stringWithFormat:@"%@",[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexrow+1]objectForKey:@"category_img"]];
        cat_imgstr = [cat_imgstr stringByReplacingOccurrencesOfString:@"resized/40"
                                                           withString:@"resized/200"];
        
        [categoryImageviewOne sd_setImageWithURL:[NSURL URLWithString:cat_imgstr]placeholderImage:[UIImage imageNamed:@"applogo.png"]];        [contentLableOne setText:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexrow+1]objectForKey:@"category_name"]];
        [CategoryBtntwo setTag:indexrow+1];
        [CategoryBtntwo addTarget:self action:@selector(selectedCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        [contentview addSubview:contentLableOne];
        [contentview addSubview:categoryImageviewOne];
        [contentview addSubview:lineviewVertical];
        [contentview addSubview:CategoryBtntwo];
        
    }
    
    [cell.contentView addSubview:contentview];
    [cell.contentView setBackgroundColor:whitecolor];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}


#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - category selected
-(void) selectedCategory:(id) sender
{
    if (![[delegate.CategoryDictForCatID allKeys] containsObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:(int)[sender tag]] objectForKey:@"category_id"]]) {
        // contains key
        [delegate.CategoryDictForCatID setValue:@"0" forKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:(int)[sender tag]] objectForKey:@"category_id"]];
    }else{
        [delegate.CategoryDictForCatID removeObjectForKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:(int)[sender tag]] objectForKey:@"category_id"]];
    }
    delegate.CategoryTabbed = @"CategoryResult"; //Tab to categoryresult
    CategoryResult * pageObj = [[CategoryResult alloc]initWithNibName:@"CategoryResult" bundle:nil];
    [self.navigationController pushViewController:pageObj animated:YES];
    [pageObj release];
}

#pragma mark - Data parsing
-(void) defaultDataParsing
{
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        [proxy getcategory:apiusername :apipassword :[delegate gettingLanguageCode]];
    }
}

#pragma mark  - WSDL DelegateMethod

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
  }

-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    [delegate.getcategoryDict removeAllObjects];
    [delegate.getcategoryDict addEntriesFromDictionary:[defaultDict objectForKey:@"result"]];
    NSMutableArray * countryListArray = [[NSMutableArray alloc]initWithCapacity:0];
    [countryListArray addObjectsFromArray:[delegate.getcategoryDict objectForKey:@"country"]];
    for (int i=0;i<[[delegate.getcategoryDict objectForKey:@"country"]count]; i++)
    {
        if ([[[[countryListArray objectAtIndex:i]objectForKey:@"country_name"]uppercaseString]isEqualToString:@"OTHERS"])
        {
            [countryListArray removeObjectAtIndex:i];
            [delegate.getcategoryDict setObject:countryListArray forKey:@"country"];
            break;
        }
    }
    [categoryTable reloadData];
    [self checkIfhavsData];
}



#pragma  mark - Dealloc and memory Warning


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
