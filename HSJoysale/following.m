//
//  following.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 27/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * It shows particular user following user information we can follow,unfollow here too.
 */

#import "following.h"
#import "DefensiveClass.h"
#import "welcomeScreen.h"
@interface following ()

@end

@implementation following

#pragma mark - View Load
- (void)viewDidLoad
{
    //initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    followingArray = [[NSMutableArray alloc]initWithCapacity:0];
    refreshControl = [[UIRefreshControl alloc] init];

    //Appearance
    
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];
    
    
    //Properties
    
    [mainView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-165)];
    mainView.layer.masksToBounds=YES;
    
    followingTableView.alwaysBounceVertical = YES;
    [followingTableView reloadData];
    [followingTableView setBackgroundColor:BackGroundColor];
    followingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    followingTableView.separatorColor = [UIColor clearColor];
    [followingTableView setFrame:CGRectMake(0,5, delegate.windowWidth,  delegate.windowHeight-190)];

    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [followingTableView addSubview:refreshControl];
    
    
    
    loadingErrorViewBG = [[UIView alloc]init];
    loadingErrorViewBG.frame = CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];
    [followingTableView addSubview:loadingErrorViewBG];

    localUserId = [delegate.userIDArray objectAtIndex:0];

    //FunctionCall
    [self noItemFindFunction];
    [self loadFollowingDatas];
    [self loadingIndicator];
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    [super viewDidLoad];
    
}
#pragma mark View Will Appear

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void) viewWillAppear:(BOOL)animated
{
    //Appearance
    [self setNeedsStatusBarAppearanceUpdate];

    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];
    [followingTableView reloadData];
    pulltoRefresh = YES;
    [super viewWillAppear:animated];
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
    [followingTableView setUserInteractionEnabled:NO];
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
}

-(void) stopLoading
{
    [followingTableView setUserInteractionEnabled:YES];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
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
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"noFollowing"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    
}


#pragma mark - show and hide noitemfound

-(void)checkIfhavsData
{
    if ([followingArray count]==0)
    {
        [loadingErrorViewBG setHidden:NO];
    }
    else
    {
        [loadingErrorViewBG setHidden:YES];
    }
}

#pragma mark - WSDL DelegateMethod
//proxy finished, (id)data is the object of the relevant method service

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method
{
    NSLog(@"Exeption in service %@",method);
    pulltoRefresh = YES;
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    [refreshControl endRefreshing];
    [followingTableView finishInfiniteScroll];
    [followingTableView reloadData];
    [self refreshTable];
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"service %@ done",method);
    NSLog(@"data: %@ ",data);

    if ([method isEqualToString:@"Followuser"]||[method isEqualToString:@"Unfollowuser"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
        if([[defaultDict objectForKey:@"status"] isEqualToString:@"false"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                            message:[defaultDict objectForKey:@"message"]
                                                           delegate:self
                                                  cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
        if ([[defaultDict objectForKey:@"status"] isEqualToString:@"true"]) {
            if([[defaultDict objectForKey:@"result"] isEqual:[NSNull null]]){
                
            }else{
                [followingArray addObjectsFromArray:[delegate.defensiveClassObj followPageData:[defaultDict objectForKey:@"result"]]];
            }
        }else{
        }
    }
    
    if([followingArray count]%20==0 && [followingArray count]>=20){
    // Add infinite scroll handler
    typeof(self) weakSelf = self;
    [followingTableView addInfiniteScrollWithHandler:^(UICollectionView *collectionView)
     {
         [weakSelf bottomrefreshTable:^{
             // Finish infinite scroll animations
         }];
     }];
    }
    pulltoRefresh = YES;
    [self checkIfhavsData];
    [refreshControl endRefreshing];
    [followingTableView finishInfiniteScroll];
    [followingTableView reloadData];
}

#pragma mark - Data Parsing

-(void) loadFollowingDatas
{
    [followingArray removeAllObjects];
    [followingTableView reloadData];
    [proxy Followingdetails:apiusername :apipassword :localUserId :@"20":@"0"];
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

- (void)refreshTable
{
    pulltoRefresh = NO;
    [followingArray removeAllObjects];
    [followingTableView reloadData];
    [proxy Followingdetails:apiusername :apipassword :localUserId :@"20":@"0"];
}
- (void)bottomrefreshTable:(void(^)(void))completion
{
    if([followingArray count]%20==0 && [followingArray count]>=20){
        [proxy Followingdetails:apiusername :apipassword :localUserId :@"20":[NSString stringWithFormat:@"%d",(int)[followingArray count]]];
    }else{
        [refreshControl endRefreshing];
        [followingTableView finishInfiniteScroll];
        [followingTableView reloadData];
    }
    if(completion)
    {
        completion();
    }
}


#pragma mark TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [followingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        static NSString *cellIdentifier = @"cellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:cellIdentifier] autorelease];
        }
        [[cell.contentView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.selectionStyle=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        UIView * ContentView=[[[UIView alloc]init]autorelease];
        [ContentView setFrame:CGRectMake(0, 0, delegate.windowWidth, 70)];
        [ContentView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *userimage=[[[UIImageView alloc]init] autorelease];
        [userimage setFrame:CGRectMake(10,7.5,55,55)];
        [userimage sd_setImageWithURL:[NSURL URLWithString:[[followingArray objectAtIndex:indexPath.row]objectForKey:@"user_image"]]placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
        [userimage setContentMode:UIViewContentModeScaleAspectFill];
        [userimage.layer setMasksToBounds:YES];
        [userimage.layer setCornerRadius:27.5];
        
        UILabel *namelable=[[[UILabel alloc]init]autorelease];
        [namelable setFrame:CGRectMake(80,17,delegate.windowWidth-130, 20)];
        if (![[[followingArray objectAtIndex:indexPath.row]objectForKey:@"full_name"]isEqual:[NSNull null]])
        {
            [namelable setText:[[followingArray objectAtIndex:indexPath.row]objectForKey:@"full_name"]];
        }
        [namelable setTextColor:headercolor];
        [namelable setFont:[UIFont fontWithName:appFontRegular size:17]];
        namelable.backgroundColor=[UIColor clearColor];
        
        UILabel *userNameLabel=[[[UILabel alloc]init]autorelease];
        [userNameLabel setFrame:CGRectMake(80,37,delegate.windowWidth-90, 20)];
        [userNameLabel setFont:[UIFont fontWithName:appFontRegular size:14]];
        [userNameLabel setTextColor:filterHeadercolor];
        [userNameLabel setText:[[followingArray objectAtIndex:indexPath.row]objectForKey:@"user_name"]];
        userNameLabel.backgroundColor=[UIColor clearColor];
        
        UIButton *followbutton=[[UIButton alloc]initWithFrame:CGRectMake(delegate.windowWidth-45, 20,35 ,30  )];
        followbutton.imageEdgeInsets = UIEdgeInsetsMake(5, 6, 5, 6);

        if([delegate.followerIdArray containsObject:[[followingArray objectAtIndex:indexPath.row]objectForKey:@"user_id"]]){
            [followbutton setImage:[UIImage imageNamed:@"Follow.png"] forState:UIControlStateNormal];
            [followbutton setBackgroundColor:AppThemeColor];
            [followbutton addTarget:self action:@selector(unfollowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [followbutton setImage:[UIImage imageNamed:@"unFollow.png"] forState:UIControlStateNormal];
            [followbutton setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0]];
            [followbutton addTarget:self action:@selector(followBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
        if (![[[followingArray objectAtIndex:indexPath.row] objectForKey:@"user_id"]isEqual:[NSNull null]])
        {
            if ([[defaultuser objectForKey:@"USERID"] isEqualToString:[[followingArray objectAtIndex:indexPath.row] valueForKey:@"user_id"]])
                {
                    [followbutton setHidden:YES];
                }
                else
                {
                    [followbutton setHidden:NO];
                }
        }
        
        
        followbutton.layer.cornerRadius = 3;
        [followbutton addTarget:self action:@selector(followbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
        followbutton.tag=indexPath.row;
        UIButton *proBtn = [[[UIButton alloc]init]autorelease];
        proBtn.frame = userimage.frame;
        [proBtn addTarget:self action:@selector(usergesterAction:) forControlEvents:UIControlEventTouchUpInside];
        [proBtn setBackgroundColor:[UIColor clearColor]];
      
        [proBtn setTag:[[[followingArray objectAtIndex:indexPath.row]objectForKey:@"user_id"]intValue]];

        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [userNameLabel setTextAlignment:NSTextAlignmentRight];
            [namelable setTextAlignment:NSTextAlignmentRight];
            [userimage setFrame:CGRectMake(delegate.windowWidth-65,7.5,55,55)];
            [namelable setFrame:CGRectMake(55,17,delegate.windowWidth-130, 20)];
            proBtn.frame = userimage.frame;
            [userNameLabel setFrame:CGRectMake(55,37,delegate.windowWidth-130, 20)];
            [followbutton setFrame:CGRectMake(10, 20,35 ,30  )];
        }
        [ContentView addSubview:followbutton];
        [ContentView addSubview:namelable];
        [ContentView addSubview:userNameLabel];
        [ContentView addSubview:userimage];
        [ContentView addSubview:proBtn];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:ContentView];
        [cell.contentView setBackgroundColor:BackGroundColor];
        
        [userimage setBackgroundColor:clearcolor];
        
        return cell;
    }
    @catch(NSException *e)
    {
        
    }
}
#pragma mark  TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark - redirect to other User profile

-(void)usergesterAction:(id) sender
{
    if([[NSString stringWithFormat:@"%ld",(long)[sender tag]]intValue]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"user_not_registered_yet"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [delegate.userIDArray removeAllObjects];
        [delegate.userIDArray addObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
        NewProfilePage * newprofilePageObj = [[NewProfilePage alloc]init];
        [newprofilePageObj loadingOtherUserData:[NSString stringWithFormat:@"%ld",(long)(UIGestureRecognizer*)[sender tag]]:@"NO"];
        [self.navigationController pushViewController:newprofilePageObj animated:YES];
    }
}

#pragma mark - follow user buttonTapped

-(void)followBtnTapped:(id) sender
{
    @try {
        if ([delegate connectedToNetwork] == NO)
        {
            [delegate networkError];
        }
        else{
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=NULL)
            {
        [delegate.followerIdArray addObject:[[followingArray objectAtIndex:[sender tag]] valueForKey:@"user_id"]];
        [proxy Followuser:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[[followingArray objectAtIndex:[sender tag]] valueForKey:@"user_id"]];
        [followingTableView reloadData];
            }
            else
            {
                welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
                [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
                
                [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
                //                [self.navigationController pushViewController:pageObj animated:YES];
                //                [pageObj release];
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark - unfollow user buttonTapped

-(void)unfollowBtnTapped:(id) sender
{
    @try {
        if ([delegate connectedToNetwork] == NO)
        {
            [delegate networkError];
        }
        else{
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=NULL)
            {
                [delegate.followerIdArray removeObject:[[followingArray objectAtIndex:[sender tag]] valueForKey:@"user_id"]];
                
                [proxy Unfollowuser:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[[followingArray objectAtIndex:[sender tag]] valueForKey:@"user_id"]];
                [followingTableView reloadData];
            }else
            {
                welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
                [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
                
                [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//                [self.navigationController pushViewController:pageObj animated:YES];
//                [pageObj release];
            }

        
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark Follow and unFollow User
-(IBAction)followbuttonaction:(id) sender
{
    [followingTableView reloadData];
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [mainView release];
    [followingTableView release];
    [super dealloc];
}

@end
