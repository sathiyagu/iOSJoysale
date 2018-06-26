//
//  SearchResult.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 15/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "SearchResult.h"
#import "ItemDetailPage.h"
#import "AdvanceSearchPage.h"

#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#import "NSDate+DateMath.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface SearchResult ()

@property (nonatomic, strong) NSMutableArray *cellSizes;

@end

@implementation SearchResult

#pragma mark -View Did load

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialization
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    homePageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //Appearance
    
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:ResignSearchBarTextBtn];
    
    //Properties
    
    
    
    
    advanceSearchArray = [[NSMutableArray alloc]initWithCapacity:0];
    [advanceSearchArray addObject:@""];
    
    loadingErrorViewBG = [[UIView alloc]init];
    loadingErrorViewBG.frame = CGRectMake(0, 0, 320, 508);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];
    
    [searchLable setText:[advanceSearchArray objectAtIndex:0]];
    
    SearchBar.barTintColor = whitecolor;
    //SearchBar.backgroundColor=whitecolor;
    SearchBar.layer.borderWidth = 1;
    SearchBar.layer.borderColor = [whitecolor CGColor];
    UITextField *textField = [SearchBar valueForKey:@"_searchField"];
    [SearchBar setPlaceholder:[delegate.languageDict objectForKey:@"search"]];
    [SearchBar setText:[advanceSearchArray objectAtIndex:0]];
    [SearchBar setBackgroundColor:[UIColor whiteColor]];
    [SearchBar setFrame:CGRectMake(35,23,delegate.windowWidth-55,35)];
    SearchBar.layer.masksToBounds=YES;
    SearchBar.layer.cornerRadius=5;
    textField.textAlignment = NSTextAlignmentLeft;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:appFontRegular size:15]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:whitecolor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:headercolor];
    UITextField *searchField;
    if([[SearchBar.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
        searchField = [SearchBar.subviews objectAtIndex:0];
        if(!(searchField == nil))
            searchField.textColor = [UIColor whiteColor];
        [searchField setBackgroundColor:whitecolor];
        [searchField setBorderStyle:UITextBorderStyleNone];
    }
    [SearchBar setImage:[UIImage imageNamed:@"search_blackbtn.png"]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
    
    [SearchBar setImage:[UIImage imageNamed:@"search_blackbtn.png"]
       forSearchBarIcon:UISearchBarIconClear
                  state:UIControlStateNormal];
    
    
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:headercolor]; // Cursor color
    [CancelBtn setBackgroundColor:[UIColor clearColor]];
    [CancelBtn setFrame:CGRectMake(5,17,29,44)];
    CancelBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0,12, 0);
    [CancelBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [CancelBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
    [CancelBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //[CancelBtn setEnabled:NO];
    [ResignSearchBarTextBtn setImage:[UIImage imageNamed:@"search_blackbtn.png"] forState:UIControlStateNormal];
    [ResignSearchBarTextBtn setHidden:YES];
    ResignSearchBarTextBtn.layer.masksToBounds=YES;
    
    //    UIButton *advanceSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [advanceSearch setBackgroundColor:[UIColor clearColor]];
    //    [advanceSearch setTag:1000];
    //    [advanceSearch setFrame:CGRectMake(delegate.windowWidth-50,17,50,44)];
    //    [advanceSearch setImage:[UIImage imageNamed:@"search_adv.png"] forState:UIControlStateNormal];
    //    [advanceSearch addTarget:self action:@selector(advanceSearchTapped) forControlEvents:UIControlEventTouchUpInside];
    //    [advanceSearch.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //    [navigationView addSubview:advanceSearch];
    
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    //setframes
    
    [navigationView setFrame:CGRectMake(-1, -1, delegate.windowWidth+2, 64)];
    navigationView.layer.borderWidth=0.7;
    navigationView.layer.borderColor=AppThemeColor.CGColor;
    [ResignSearchBarTextBtn setFrame:CGRectMake(0, 63, delegate.windowWidth, delegate.windowHeight-50)];
    
    
    searchHistoryTable = [UITableView new];
    [searchHistoryTable setFrame:CGRectMake(0, navigationView.frame.size.height+navigationView.frame.origin.y, delegate.windowWidth, delegate.windowHeight-112)];
    [searchHistoryTable setDataSource:self];
    [searchHistoryTable setDelegate:self];
    [searchHistoryTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:searchHistoryTable];
    
    [navigationView setBackgroundColor:AppThemeColor];
    
    //Functionality
    
    
    //Function call
    [self noItemFindFunction];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated{
    //    [delegate adminchecking];
    [searchHistoryTable reloadData];
    if( [delegate.deleteProduct isEqualToString:@"YES"] || [delegate.promoteProduct isEqualToString:@"YES"])
    {
        delegate.deleteProduct =@"";
        delegate.promoteProduct =@"";
        [self loadingHomePageData];
        [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    }
    [self setNeedsStatusBarAppearanceUpdate];

    //Appearance
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBottomBorderColor:AppThemeColor height:0.7];
}


#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return [delegate.searchHistoryArray count];
    }else{
        if([delegate.searchHistoryArray count]!=0){
            return 1;
        }else{
            return 0;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [[cell.contentView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    UIView *contentView = [UIView new];
    [contentView setFrame:CGRectMake(0, 0, delegate.windowWidth, 45)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [UIView new];
    [lineView setFrame:CGRectMake(50, 44.5, delegate.windowWidth-65, 0.5)];
    [lineView setBackgroundColor:lineviewColor];
    [contentView addSubview:lineView];
    
    
    UIImageView *searchTypeImg = [UIImageView new];
    [searchTypeImg setFrame:CGRectMake(17.5, 17.5, 15, 15)];
    [contentView addSubview:searchTypeImg];
    
    UILabel *searchStrLbl = [UILabel new];
    [searchStrLbl setTextColor:LightTextColor];
    [searchStrLbl setFont:SmallButtonFont];
    [searchStrLbl setFrame:CGRectMake(50, 17.5, delegate.windowWidth-70, 15)];
    [contentView addSubview:searchStrLbl];
    if(indexPath.section==0)
    {
        [searchTypeImg setImage:[UIImage imageNamed:@"clock.png"]];
        [searchStrLbl setText:[delegate.searchHistoryArray objectAtIndex:indexPath.row]];
    }
    else{
        [searchTypeImg setImage:[UIImage imageNamed:@"close-gray.png"]];
        [searchStrLbl setText:@"Clear History"];
    }
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [searchTypeImg setFrame:CGRectMake(delegate.windowWidth-35, 15, 20, 20)];
        [searchStrLbl setFrame:CGRectMake(10, 15, delegate.windowWidth-55, 15)];
        [searchStrLbl setTextAlignment:NSTextAlignmentRight];
    }
    [cell.contentView addSubview:contentView];
    
    
    return cell;
}




#pragma mark Tableview Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    delegate.advancesearchFlag = YES;
    
    if (indexPath.section==0)
    {
        [delegate.HomeSearchArray replaceObjectAtIndex:8 withObject:[delegate.searchHistoryArray objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [delegate.searchHistoryArray removeAllObjects];
        [searchHistoryTable reloadData];
        [delegate.HomeSearchArray replaceObjectAtIndex:8 withObject:@""];
    }
    
    
}












#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 4.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_multiColorLoader setFrame:CGRectMake((delegate.windowWidth-15)/2, (delegate.windowHeight-50)/2, 30, 30)];
    [_multiColorLoader startAnimation];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view addSubview:_multiColorLoader];
}

#pragma mark  Start and stop Loader

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
    [refreshControl endRefreshing];
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
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"noItemfound"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:loadingErrorViewBG];
}



#pragma mark - Reset and Cancel Button Clicked

- (IBAction)ResetBtnTapped:(id)sender {
    [advanceSearchArray replaceObjectAtIndex:0 withObject:@""];
    [SearchBar setPlaceholder:[delegate.languageDict objectForKey:@"search"]];
    [SearchBar setText:[advanceSearchArray objectAtIndex:0]];
    [self loadingHomePageData];
}

- (IBAction)CancelBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ResignSearchBarTextBtnTapped:(id)sender {
    [SearchBar resignFirstResponder];
}


-(void)advanceSearchTapped
{
    
    delegate.advancesearchFlag = YES;
    AdvanceSearchPage * advanceSearchPageObj = [[AdvanceSearchPage alloc]initWithNibName:@"AdvanceSearchPage" bundle:nil];
    [self.navigationController pushViewController:advanceSearchPageObj animated:YES];
    [advanceSearchPageObj release];
}

#pragma mark - UICollectionViewDefinition




#pragma mark - SearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [ResignSearchBarTextBtn setHidden:NO];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [ResignSearchBarTextBtn setHidden:YES];
    [advanceSearchArray replaceObjectAtIndex:0 withObject:searchBar.text];
    delegate.advancesearchFlag = YES;
    [delegate.HomeSearchArray replaceObjectAtIndex:8 withObject:searchBar.text];
    if (![searchBar.text isEqualToString:@""])
    {
        [delegate.searchHistoryArray addObject:searchBar.text];
        [searchHistoryTable reloadData];
    }
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [ResignSearchBarTextBtn setHidden:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [navigationView release];
    [searchLable release];
    [ResetBtn release];
    [CancelBtn release];
    [ResignSearchBarTextBtn release];
    [super dealloc];
}

@end


