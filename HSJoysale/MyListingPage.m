//
//  MyListingPage.m
//  HSJoysale
//
//  Created by BTMani on 23/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
/*
 * Listing shows particular users posted product, It may b own product or other user products
 * profile page> My listing Tab
 */

#import "MyListingPage.h"
#import "ItemDetailPage.h"

@interface MyListingPage ()

@end

@implementation MyListingPage

#pragma mark - View Load
- (void)viewDidLoad {
    
    //initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    refreshControl = [[UIRefreshControl alloc] init];
    
    //Appearance
    
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];

    //Local Initalization
    
    loadingErrorViewBG = [[UIView alloc]init];
    mylistingArray  = [[NSMutableArray alloc]init];
    
    //Properties
    [MainView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-165)];
    MainView.layer.masksToBounds=YES;
    
    loadingErrorViewBG.frame = CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];
    [listProductTableView addSubview:loadingErrorViewBG];
    
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [listProductTableView addSubview:refreshControl];

    [listProductTableView setFrame:CGRectMake(0, 0, delegate.windowWidth,  delegate.windowHeight-185)];
    [listProductTableView reloadData];
    [listProductTableView setBackgroundColor:BackGroundColor];
    listProductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listProductTableView.separatorColor = [UIColor clearColor];
    listProductTableView.alwaysBounceVertical = YES;
    
    //Functionality
    tempUserId = [delegate.userIDArray objectAtIndex:0];

    //Function Call
    [self noItemFindFunction];
    [self loadingIndicator];
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    [mylistingArray removeAllObjects];
    [self performSelectorOnMainThread:@selector(loadingUserAddedData) withObject:nil waitUntilDone:YES];
    [super viewDidLoad];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }
}

#pragma mark View Will Appear

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void) viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];

    //Appearance
    if([delegate.deleteProduct isEqualToString:@"YES"] || [delegate.promoteProduct isEqualToString:@"YES"]){
        delegate.deleteProduct =@"";
        delegate.promoteProduct =@"";
     //   [self loadingIndicator];
        [mylistingArray removeAllObjects];

        [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(loadingUserAddedData) withObject:nil waitUntilDone:YES];
    }
//    [delegate adminchecking];
    if ([delegate.userIDArray count]==0)
    {
        [delegate.userIDArray removeAllObjects];
        [delegate.userIDArray addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];
    }
    pulltoRefresh = YES;
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];
    [listProductTableView reloadData];
    [super viewWillAppear:animated];
    [self loadingUserData];
}

#pragma mark - If no data in parsing it show alert

-(void) noItemFindFunction
{
    UIImageView *loadingErrorImageView = [[UIImageView alloc]init];
    loadingErrorImageView.frame = CGRectMake(delegate.windowWidth/2-100, 50, 200, 150);
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
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"nolistingfound"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    [listProductTableView addSubview:loadingErrorViewBG];
}

#pragma mark - show and hide noitemfound

-(void)checkIfhavsData
{
    if ([mylistingArray count]==0)
    {
        [loadingErrorViewBG setHidden:NO];
        [listProductTableView setBackgroundColor:[UIColor clearColor]];
        [self.view bringSubviewToFront:listProductTableView];
    }
    else
    {
        [loadingErrorViewBG setHidden:YES];
    }
}

#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 4.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_multiColorLoader setFrame:CGRectMake((delegate.windowWidth-15)/2, 50, 30, 30)];
    [_multiColorLoader startAnimation];
   // [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view addSubview:_multiColorLoader];
    [self.view bringSubviewToFront:_multiColorLoader];

}

-(void) startLoadig
{
    [listProductTableView setUserInteractionEnabled:NO];
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
}

-(void) stopLoading
{
    [listProductTableView setUserInteractionEnabled:YES];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [refreshControl endRefreshing];
    [listProductTableView finishInfiniteScroll];
}

#pragma mark - PullDown Refresh
- (void)bottomrefreshTable:(void(^)(void))completion
{
    if([mylistingArray count]%10==0 && [mylistingArray count]>=10)
    {
    [self apiCallingFunction:apiusername api_password:apipassword type:@"moreitems" price:@"" search_key:@"" category_id:@"" subcategory_id:@"" user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:tempUserId sorting_id:@"1" offset:[NSString stringWithFormat:@"%d",(int)[mylistingArray count]] limit:@"10" lat:@"0" lon:@"0" posted_within:@"0"distance:@""];
    if(completion)
    {
        completion();
    }
    }else{
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    }
}

- (void)refreshTable
{
//    [delegate adminchecking];
    pulltoRefresh = NO;
    [mylistingArray removeAllObjects];
    [listProductTableView reloadData];
    [self apiCallingFunction:apiusername api_password:apipassword type:@"moreitems" price:@"" search_key:@"" category_id:@"" subcategory_id:@"" user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:tempUserId sorting_id:@"1" offset:@"0" limit:@"10" lat:@"0" lon:@"0" posted_within:@"0"distance:@""];
}


#pragma mark - WSDL DelegateMethod

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method
{
    NSLog(@"Exeption in service %@",method);
    @try
    {
        pulltoRefresh = YES;

        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    [self refreshTable];
}

-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj testingHomePageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
    
   // [self stopLoading];

    if ([[defaultDict objectForKey:@"status"] isEqualToString:@"true"])
    {
        [mylistingArray addObjectsFromArray:[[defaultDict objectForKey:@"result"] objectForKey:@"items"]];
    }
    if([mylistingArray count]%10==0 && [mylistingArray count]>=10){
    typeof(self) weakSelf = self;
    [listProductTableView addInfiniteScrollWithHandler:^(UICollectionView *collectionView) {
        [weakSelf bottomrefreshTable:^{
        }];
    }];
    }
    pulltoRefresh = YES;

    [listProductTableView reloadData];
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    [self checkIfhavsData];
    [refreshControl endRefreshing];
    [listProductTableView finishInfiniteScroll];
    


}

-(void) loadingUserData
{
    if (!proxy)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=nil)
    {
        [[NSUserDefaults standardUserDefaults]synchronize];
        userIDValue =[[NSMutableArray alloc]initWithCapacity:0];
        [userIDValue addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];
    }
}

#pragma mark - CallingApiModal

-(void) apiCallingFunction:(NSString*)api_username api_password:(NSString*)api_password type:(NSString *)type price:(NSString *)price search_key:(NSString *)search_key category_id:(NSString *)category_id subcategory_id:(NSString *)subcategory_id user_id:(NSString *)user_id item_id:(NSString *)item_id seller_id:(NSString *)seller_id sorting_id:(NSString *)sorting_id offset:(NSString *)offset limit:(NSString *)limit lat:(NSString *)lat lon:(NSString *)lon posted_within:(NSString *)posted_within distance:(NSString*)distance
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=nil)
    {
        [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :user_id :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within:distance];
    }else{
        [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :@"" :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within:distance];
    }
}


-(void) loadingUserAddedData
{
    @try
    {
        [mylistingArray removeAllObjects];
        [listProductTableView reloadData];
        [self apiCallingFunction:apiusername api_password:apipassword type:@"moreitems" price:@"" search_key:@"" category_id:@"" subcategory_id:@"" user_id:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] item_id:@"" seller_id:tempUserId sorting_id:@"1" offset:@"0" limit:@"10" lat:@"" lon:@"" posted_within:@"0"distance:@""];
    } @catch (NSException *exception) {
    } @finally {
    }
}


#pragma mark - UITable datasource and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=([mylistingArray count]/2)+([mylistingArray count]%2)){
        return 150;
    }else{
        return 160;
    }
    return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return ([mylistingArray count]/2)+([mylistingArray count]%2);
}

//UITableViewCell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    //[self stopLoading];

    @try {
        int indexrow = (int) indexPath.row * 2;
        
        UIView * contentview = [[[UIView alloc]init]autorelease];
        [contentview setBackgroundColor:BackGroundColor];
        [contentview setFrame:CGRectMake(0,0,delegate.windowWidth,150)];
        contentview.layer.masksToBounds=YES;
        
        UIImageView * LikedProductImgView = [[[UIImageView alloc]init]autorelease];
        [LikedProductImgView setFrame:CGRectMake(10,10,((contentview.frame.size.width/2))-15,135)];
        [LikedProductImgView setBackgroundColor:[UIColor clearColor]];
        LikedProductImgView.layer.borderWidth = 0;
        LikedProductImgView.layer.borderColor = AdvanceSearchPageColor.CGColor;
        [LikedProductImgView setUserInteractionEnabled:YES];
        [LikedProductImgView setContentMode:UIViewContentModeScaleAspectFill];
        LikedProductImgView.layer.masksToBounds=YES;
        if([[[mylistingArray objectAtIndex:indexrow]objectForKey:@"photos"] count]>0){
            [LikedProductImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[mylistingArray objectAtIndex:indexrow]objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"item_url_main_350"]]] placeholderImage:[UIImage imageNamed:@"applogo.png"]];
        }else{
            [LikedProductImgView setImage:[UIImage imageNamed:@"applogo.png"]];
        }
        [contentview addSubview:LikedProductImgView];
        
        UIButton * LikedProductBtnOne = [UIButton buttonWithType:UIButtonTypeCustom];
        [LikedProductBtnOne setFrame:CGRectMake(0,0,contentview.frame.size.width/2,150)];
        [LikedProductBtnOne addTarget:self action:@selector(selectedproduct:) forControlEvents:UIControlEventTouchUpInside];
        [LikedProductBtnOne setTag:(int)indexrow];
        [contentview addSubview:LikedProductBtnOne];
        
        UILabel * productType = [[UILabel alloc] init];
        [productType setFont:[UIFont fontWithName:appFontRegular size:12]];
        [productType setTextColor:whitecolor];
        [productType setBackgroundColor:clearcolor];
        [productType setTextAlignment:NSTextAlignmentCenter];
        productType.layer.cornerRadius=2;
        productType.layer.masksToBounds=YES;
        productType.numberOfLines=2;
        if([[NSString stringWithFormat:@"%@",[[mylistingArray objectAtIndex:indexrow]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
            if(![[NSString stringWithFormat:@"%@",[[mylistingArray objectAtIndex:indexrow] objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                [productType setText:[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow]objectForKey:@"promotion_type"]]];
                if([[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                    [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];
                    [productType setBackgroundColor:redcolor];
                }else if([[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
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
        LikedProductImgView.clipsToBounds = YES;
        [productType setFrame:CGRectMake(LikedProductImgView.frame.size.width-productType.intrinsicContentSize.width-15, 10, productType.intrinsicContentSize.width+10, 30+2)];
        [contentview addSubview:productType];
        
        UIImageView * LikedProductImgViewOne = [[[UIImageView alloc]init]autorelease];
        [LikedProductImgViewOne setFrame:CGRectMake(((contentview.frame.size.width/2))+5,10,((contentview.frame.size.width/2))-15,135)];
        [LikedProductImgViewOne setBackgroundColor:[UIColor clearColor]];
        LikedProductImgViewOne.layer.borderWidth = 0;
        LikedProductImgViewOne.layer.borderColor = AdvanceSearchPageColor.CGColor;
        [LikedProductImgViewOne setUserInteractionEnabled:YES];
        [LikedProductImgViewOne setContentMode:UIViewContentModeScaleAspectFill];
        LikedProductImgViewOne.layer.masksToBounds=YES;
        
        UIButton * LikedProductBtntwo = [[UIButton alloc] init];
        [LikedProductBtntwo setFrame:CGRectMake((contentview.frame.size.width/2),0,contentview.frame.size.width/2,150)];
        if(([mylistingArray count]/2)+([mylistingArray count]%2)-1==indexPath.row){
            if([mylistingArray count]%2==0){
                if([[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"photos"] count]>0){
                    [LikedProductImgViewOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"item_url_main_350"]]] placeholderImage:[UIImage imageNamed:@"applogo.png"]];
                    
                }else{
                    [LikedProductImgViewOne setImage:[UIImage imageNamed:@"applogo.png"]];
                }
                [LikedProductBtntwo setTag:indexrow+1];
                [LikedProductBtntwo addTarget:self action:@selector(selectedproduct:) forControlEvents:UIControlEventTouchUpInside];
                
                [contentview addSubview:LikedProductImgViewOne];
                [contentview addSubview:LikedProductBtntwo];
                
                UILabel * productType = [[UILabel alloc] init];
                [productType setFont:[UIFont fontWithName:appFontRegular size:12]];
                [productType setTextColor:whitecolor];
                [productType setBackgroundColor:clearcolor];
                [productType setTextAlignment:NSTextAlignmentCenter];
                productType.layer.cornerRadius=2;
                productType.layer.masksToBounds=YES;
                productType.numberOfLines=2;
                if([[NSString stringWithFormat:@"%@",[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
                    if(![[NSString stringWithFormat:@"%@",[[mylistingArray objectAtIndex:indexrow+1] objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                        [productType setText:[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]]];
                        if([[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                            [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];
                            [productType setBackgroundColor:redcolor];
                        }else if([[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
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
                [productType setFrame:CGRectMake(LikedProductImgViewOne.frame.origin.x+LikedProductImgViewOne.frame.size.width-productType.intrinsicContentSize.width-15, 10, productType.intrinsicContentSize.width+10, 30+2)];
                LikedProductImgViewOne.clipsToBounds = YES;
                [contentview addSubview:productType];
            }
        }else{
            if([[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"photos"] count]>0){
                [LikedProductImgViewOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"item_url_main_350"]]] placeholderImage:[UIImage imageNamed:@"applogo.png"]];
            }else{
                [LikedProductImgViewOne setImage:[UIImage imageNamed:@"applogo.png"]];
            }
            [LikedProductBtntwo setTag:indexrow+1];
            [LikedProductBtntwo addTarget:self action:@selector(selectedproduct:) forControlEvents:UIControlEventTouchUpInside];
            [contentview addSubview:LikedProductImgViewOne];
            [contentview addSubview:LikedProductBtntwo];
            
            UILabel * productType = [[UILabel alloc] init];
            [productType setFont:[UIFont fontWithName:appFontRegular size:12]];
            [productType setTextColor:whitecolor];
            [productType setBackgroundColor:clearcolor];
            [productType setTextAlignment:NSTextAlignmentCenter];
            productType.layer.cornerRadius=2;
            productType.layer.masksToBounds=YES;
            productType.numberOfLines=2;
            if([[NSString stringWithFormat:@"%@",[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
                if(![[NSString stringWithFormat:@"%@",[[mylistingArray objectAtIndex:indexrow+1] objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                    [productType setText:[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]]];
                    if([[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                        [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];
                        [productType setBackgroundColor:redcolor];
                    }else if([[NSString stringWithFormat:@"\n%@",[[mylistingArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
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
            [productType setFrame:CGRectMake(LikedProductImgViewOne.frame.origin.x+LikedProductImgViewOne.frame.size.width-productType.intrinsicContentSize.width-15, 10, productType.intrinsicContentSize.width+10, 30+2)];
            [contentview addSubview:productType];
        }
        [cell.contentView addSubview:contentview];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [_multiColorLoader stopAnimation];
        //[loadingErrorViewBG stopan];
        
    }
    @catch (NSException *exception) {
    } @finally {
    }
   // [self stopLoading];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60 && ![refreshControl isRefreshing]) {
        [refreshControl beginRefreshing];
        if(pulltoRefresh){
        [self refreshTable];
        }
    }
}
#pragma  mark - select Product

-(void) selectedproduct:(id) sender
{
    int tag =0;
    int viewCount =[[[mylistingArray objectAtIndex:tag]objectForKey:@"views_count"]intValue];
    viewCount = viewCount+1;
    if ([NSString stringWithFormat:@"%d",viewCount] != (NSString*)[NSNull null])
    {
        if ([[mylistingArray objectAtIndex:tag]isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict addEntriesFromDictionary:[mylistingArray objectAtIndex:tag]];
            [dict setObject:[NSString stringWithFormat:@"%d",viewCount] forKey:@"views_count"];
            [mylistingArray replaceObjectAtIndex:tag withObject:dict];
            [dict release];
        }
    }
    ItemDetailPage * itemDetailPageObj = [[ItemDetailPage alloc]initWithNibName:@"ItemDetailPage" bundle:nil];
    [itemDetailPageObj detailPageArray:mylistingArray selectedIndex:(int)[sender tag]];
    
    [self.navigationController pushViewController:itemDetailPageObj animated:YES];
    [itemDetailPageObj release];
    
    
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [MainView release];
    [listProductTableView release];
    [super dealloc];
}

@end
