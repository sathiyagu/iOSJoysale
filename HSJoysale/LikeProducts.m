//
//  LikeProducts.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 27/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * Like shows particular users Liked product, It may b own product or other user products
 * profile page> My listing Tab
 */

#import "LikeProducts.h"
#import "ItemDetailPage.h"

@interface LikeProducts ()

@end

@implementation LikeProducts

#pragma mark - View Load
- (void)viewDidLoad {
    
    //initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    likeProductsArray = [[NSMutableArray alloc] init];
    
    if (!proxy)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }

    //Appearance
    
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];
    
    //Properties
    [MainView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-165)];
    MainView.layer.masksToBounds=YES;

    loadingErrorViewBG = [[UIView alloc]init];
    loadingErrorViewBG.frame = CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];
    
    [likedProductTableView reloadData];
    [likedProductTableView setBackgroundColor:BackGroundColor];
    likedProductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    likedProductTableView.separatorColor = [UIColor clearColor];
    [likedProductTableView setFrame:CGRectMake(0, 0, delegate.windowWidth,  delegate.windowHeight-185)];
    likedProductTableView.alwaysBounceVertical = YES;

    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [likedProductTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    tempUserId = [delegate.userIDArray objectAtIndex:0];

    //FunctionCall
    [self noItemFindFunction];
    [self performSelectorOnMainThread:@selector(loadingIndicator) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(loadingLikedData) withObject:nil waitUntilDone:NO];
    [super viewDidLoad];
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
//    [delegate adminchecking];
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];
    [likedProductTableView reloadData];
    pulltoRefresh = YES;
    [super viewWillAppear:animated];
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
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"noItemfound"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    [likedProductTableView addSubview:loadingErrorViewBG];

}


#pragma mark - show and hide noitemfound

-(void)checkIfhavsData
{
    if ([likeProductsArray count]==0)
    {
        [loadingErrorViewBG setHidden:NO];
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
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view addSubview:_multiColorLoader];
}

-(void) startLoadig
{
    [likedProductTableView setUserInteractionEnabled:NO];
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
}

-(void) stopLoading
{
    [likedProductTableView setUserInteractionEnabled:YES];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
}


#pragma mark - WSDL DelegateMethod
//proxy finished, (id)data is the object of the relevant method service
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
    @try {
        pulltoRefresh = YES;
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];

    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    [self refreshTable];
    
}
//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    NSLog(@"data %@ Done!",data);

    
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj testingHomePageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
    
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];

    if ([[defaultDict objectForKey:@"status"] isEqualToString:@"true"]) {
        [likeProductsArray addObjectsFromArray:[[defaultDict objectForKey:@"result"] objectForKey:@"items"]];
    }else
    {
    }
    
    if([likeProductsArray count]%20==0 && [likeProductsArray count]>=20){
            // Add infinite scroll handler
            typeof(self) weakSelf = self;
            [likedProductTableView addInfiniteScrollWithHandler:^(UICollectionView *collectionView) {
                [weakSelf bottomrefreshTable:^{
                    // Finish infinite scroll animations
                }];
            }];
            
        }

    
    pulltoRefresh = YES;
    [likedProductTableView reloadData];
    [self checkIfhavsData];
    [refreshControl endRefreshing];
    [likedProductTableView finishInfiniteScroll];

    
}
#pragma mark - CallingApiModal
-(void) loadingLikedData
{
        [likeProductsArray removeAllObjects];
        [self apiCallingFunction:apiusername api_password:apipassword type:@"liked" price:@"" search_key:@"" category_id:@"" subcategory_id:@"" user_id:tempUserId item_id:@"" seller_id:@"" sorting_id:@"" offset:@"0" limit:@"20" lat:@"" lon:@"" posted_within:@"" distance:@""];
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
#pragma mark - PullDown Refresh
- (void)bottomrefreshTable:(void(^)(void))completion
{
    if([likeProductsArray count]%20==0 && [likeProductsArray count]>=20){

    [self apiCallingFunction:apiusername api_password:apipassword type:@"liked" price:@"" search_key:@"" category_id:@"" subcategory_id:@"" user_id:tempUserId item_id:@"" seller_id:@"" sorting_id:@"" offset:[NSString stringWithFormat:@"%d",(int)[likeProductsArray count]] limit:@"20" lat:@"" lon:@"" posted_within:@"" distance:@""];
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
    [likeProductsArray removeAllObjects];
    [likedProductTableView reloadData];
    [self apiCallingFunction:apiusername api_password:apipassword type:@"liked" price:@"" search_key:@"" category_id:@"" subcategory_id:@"" user_id:tempUserId item_id:@"" seller_id:@"" sorting_id:@"" offset:@"0" limit:@"20" lat:@"" lon:@"" posted_within:@"" distance:@""];
}

#pragma mark - CallingApiModal

-(void) apiCallingFunction:(NSString*)api_username api_password:(NSString*)api_password type:(NSString *)type price:(NSString *)price search_key:(NSString *)search_key category_id:(NSString *)category_id subcategory_id:(NSString *)subcategory_id user_id:(NSString *)user_id item_id:(NSString *)item_id seller_id:(NSString *)seller_id sorting_id:(NSString *)sorting_id offset:(NSString *)offset limit:(NSString *)limit lat:(NSString *)lat lon:(NSString *)lon posted_within:(NSString *)posted_within distance:(NSString *)distance
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=nil)
    {
    [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :user_id :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within :distance];
    }else{
        [proxy getItems:api_username :api_password :type :price :search_key :category_id :subcategory_id :@"" :item_id :seller_id :sorting_id :offset :limit :lat :lon :posted_within :distance];
    }
}


#pragma mark - UITable datasource and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=([likeProductsArray count]/2)+([likeProductsArray count]%2)){
        return 150;
    }else{
        return 160;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([likeProductsArray count]/2)+([likeProductsArray count]%2);
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

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
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
        if([[[likeProductsArray objectAtIndex:indexrow]objectForKey:@"photos"] count]>0){
            [LikedProductImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[likeProductsArray objectAtIndex:indexrow]objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"item_url_main_350"]]] placeholderImage:[UIImage imageNamed:@"applogo.png"]];
            
        }else{
            [LikedProductImgView setImage:[UIImage imageNamed:@"applogo.png"]];
        }
        [contentview addSubview:LikedProductImgView];
        
        UIButton * LikedProductBtnOne = [UIButton buttonWithType:UIButtonTypeCustom];
        [LikedProductBtnOne setFrame:CGRectMake(0,0,contentview.frame.size.width/2,150)];
        [LikedProductBtnOne addTarget:self action:@selector(selectedExchange:) forControlEvents:UIControlEventTouchUpInside];
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
        if([[NSString stringWithFormat:@"%@",[[likeProductsArray objectAtIndex:indexrow]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
            if(![[NSString stringWithFormat:@"%@",[[likeProductsArray objectAtIndex:indexrow] objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                [productType setText:[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow]objectForKey:@"promotion_type"]]];
                if([[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                    [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];
                    [productType setBackgroundColor:redcolor];
                }else if([[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
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
        if(([likeProductsArray count]/2)+([likeProductsArray count]%2)-1==indexPath.row){
            if([likeProductsArray count]%2==0){
                if([[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"photos"] count]>0){
                    [LikedProductImgViewOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"item_url_main_350"]]] placeholderImage:[UIImage imageNamed:@"applogo.png"]];
                    
                }else{
                    [LikedProductImgViewOne setImage:[UIImage imageNamed:@"applogo.png"]];
                }
                [LikedProductBtntwo setTag:indexrow+1];
                [LikedProductBtntwo addTarget:self action:@selector(selectedExchange:) forControlEvents:UIControlEventTouchUpInside];
                
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
                if([[NSString stringWithFormat:@"%@",[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
                    if(![[NSString stringWithFormat:@"%@",[[likeProductsArray objectAtIndex:indexrow+1] objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                        [productType setText:[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]]];
                        if([[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                            [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];
                            [productType setBackgroundColor:redcolor];
                        }else if([[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
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
                
            }else{
            }
        }else{
            if([[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"photos"] count]>0){
                [LikedProductImgViewOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"item_url_main_350"]]] placeholderImage:[UIImage imageNamed:@"applogo.png"]];
                
            }else{
                [LikedProductImgViewOne setImage:[UIImage imageNamed:@"applogo.png"]];
            }
            [LikedProductBtntwo setTag:indexrow+1];
            [LikedProductBtntwo addTarget:self action:@selector(selectedExchange:) forControlEvents:UIControlEventTouchUpInside];
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
            if([[NSString stringWithFormat:@"%@",[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"item_status"]] isEqualToString:@"onsale"]){
                if(![[NSString stringWithFormat:@"%@",[[likeProductsArray objectAtIndex:indexrow+1] objectForKey:@"promotion_type"]] isEqualToString:@"Normal"]&&delegate.promotionModuleFlag){
                    [productType setText:[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]]];
                    if([[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]] isEqualToString:@"\nUrgent"]){
                        [productType setText:[NSString stringWithFormat:@"\n%@",[delegate.languageDict objectForKey:@"urgent"]]];
                        [productType setBackgroundColor:redcolor];
                    }else if([[NSString stringWithFormat:@"\n%@",[[likeProductsArray objectAtIndex:indexrow+1]objectForKey:@"promotion_type"]] isEqualToString:@"\nAd"]){
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
        
    }
    
    @catch (NSException *exception) {
    } @finally {
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  mark - select Product

-(void) selectedExchange:(id) sender
{
    int tag =0;
    int viewCount =[[[likeProductsArray objectAtIndex:tag]objectForKey:@"views_count"]intValue];
    viewCount = viewCount+1;
    if ([NSString stringWithFormat:@"%d",viewCount] != (NSString*)[NSNull null])
    {
        if ([[likeProductsArray objectAtIndex:tag]isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict addEntriesFromDictionary:[likeProductsArray objectAtIndex:tag]];
            [dict setObject:[NSString stringWithFormat:@"%d",viewCount] forKey:@"views_count"];
            [likeProductsArray replaceObjectAtIndex:tag withObject:dict];
            [dict release];
        }
    }
    UINavigationController * vc = [delegate.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:delegate.tabID];
    ItemDetailPage * itemDetailPageObj = [[ItemDetailPage alloc]initWithNibName:@"ItemDetailPage" bundle:nil];
    [itemDetailPageObj detailPageArray:likeProductsArray selectedIndex:(int)[sender tag]];
    [vc pushViewController:itemDetailPageObj animated:YES];
    [itemDetailPageObj release];
}




#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [MainView release];
    [likedProductTableView release];
    [super dealloc];
}

@end
