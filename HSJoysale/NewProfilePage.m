//
//  NewProfilePage.m
//  HSJoysale
//
//  Created by BTMani on 23/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * Profile page for login user or showing other user Profile
 */
#import "NewProfilePage.h"
#import "EditProfile.h"
#import "NotificationPage.h"
#import "HelpPage.h"
#import "welcomeScreen.h"

@interface NewProfilePage ()
//For more option button background transparency
#define opwhitecolor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9]

@end

@implementation NewProfilePage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Appearance
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    
    //Initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    userDetailsArray = [[NSMutableArray alloc]initWithCapacity:0];
    if (!proxy)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    myListingPageObj = [[MyListingPage alloc]initWithNibName:@"MyListingPage" bundle:nil];
    
    myLikesPageObj = [[LikeProducts alloc]initWithNibName:@"LikeProducts" bundle:nil];
    followerPageObj = [[Followers alloc]initWithNibName:@"Followers" bundle:nil];
    followingPageObj = [[following alloc]initWithNibName:@"following" bundle:nil];
    profileHeader = [ProfilePageHeader instantiateFromNib];
    [profileHeader hiderating];
    sectionHeaderArray = [[NSMutableArray alloc]initWithCapacity:0];

    //functionality
    headerheight = 270;
    if([delegate.userIDArray count]==0)
    {
        [delegate.userIDArray removeAllObjects];
        [delegate.userIDArray addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];
    }
    

    //properties
    [profileHeader sethiddenButtons];
    [profileHeader setDelegate:self];

    //Function call
//    [self MoreBtnPopup];

    
    // Parallax Header
    
  //  self.segmentedPager.segmentedControl.s
    
    self.segmentedPager.parallaxHeader.view = profileHeader;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.segmentedPager.parallaxHeader.height = 270;
    self.segmentedPager.parallaxHeader.minimumHeight = 80;
    self.segmentedPager.bounces = YES;
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:appFontRegular size:15],
                               NSForegroundColorAttributeName : filterHeadercolor
                               };
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes=attrDict;
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : AppThemeColor};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor clearColor] ;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    
//    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    // Appearance
    

    [self setNeedsStatusBarAppearanceUpdate];

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:YES];

    delegate.window.userInteractionEnabled = NO;
    self.segmentedPager.bounces = YES;

    //If userid have no value means it show login user Detail
    if ([userIDValue count]!=0)
    {
        [delegate.userIDArray removeAllObjects];
        [delegate.userIDArray addObjectsFromArray:userIDValue];
    }
    
    //if other profile or came from other page profiletab should be "NO", Own profile means it should be "YES"
    if(![profileTab isEqualToString:@"NO"]){
        [self performSelectorOnMainThread:@selector(loadingUserData) withObject:nil waitUntilDone:YES];
        profileTab=@"YES";
    }
    else
    {
        delegate.window.userInteractionEnabled = YES;
    }
    //Reload Profile page header
    [profileHeader loadProfileHeaderValues:userDetailsArray tab:profileTab height:headerheight];
    
    //If own profile > it change "my listing" otherwise "listing"
    //If change language from edit profile, language should change when view appear
    [sectionHeaderArray removeAllObjects];
    if([[profileTab uppercaseString] isEqualToString:@"YES"] || [[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] isEqual:[delegate.userIDArray objectAtIndex:0]])
    {
        [sectionHeaderArray addObject:[NSString stringWithFormat:@"%@",[delegate.languageDict objectForKey:@"my_listing"]]];
    }
    else
    {
        [sectionHeaderArray addObject:[NSString stringWithFormat:@"%@",[delegate.languageDict objectForKey:@"listing"]]];
    }
   
    [sectionHeaderArray addObject:[NSString stringWithFormat:@"\t%@",[delegate.languageDict objectForKey:@"liked"]]];
    [sectionHeaderArray addObject:[NSString stringWithFormat:@"\t%@",[delegate.languageDict objectForKey:@"followers"]]];
    [sectionHeaderArray addObject:[NSString stringWithFormat:@"\t%@",[delegate.languageDict objectForKey:@"followings"]]];
    
    self.segmentedPager.segmentedControl.selectedSegmentIndex = 3;

    [self.segmentedPager reloadData];
}

#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma  mark - followerId's

-(void) getFollowedUserID
{
    [proxy Getfollowerid:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];
}


#pragma mark - ProfileHeaderProtocol

-(void) alertButtonTapped
{
    [self RedirectToNotification];
}

-(void) settingButtonTapped
{
    [self RedirectToEditProfile];
}

-(void)reviewBtnTapped
{
    self.segmentedPager.segmentedControl.selectedSegmentIndex = 4;
    [self.segmentedPager.pager showPageAtIndex:4 animated:YES];
    
}

-(void) menuButtonTapped
{
    [self MoreBtnPopup];
}

-(void) backButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - Follow or unfollow Tapped

-(void) followBtnAction
{
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=NULL)
    {
    if ([delegate.followerIdArray containsObject:[delegate.userIDArray objectAtIndex:0]])
    {
        [delegate.followerIdArray removeObject:[delegate.userIDArray objectAtIndex:0]];
        [profileHeader updateFollowBtn:NO];
        [proxy Unfollowuser:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[delegate.userIDArray objectAtIndex:0]];
    }
    else
    {
        [delegate.followerIdArray addObject:[delegate.userIDArray objectAtIndex:0]];
        [profileHeader updateFollowBtn:YES];
        [proxy Followuser:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[delegate.userIDArray objectAtIndex:0]];
    }
    }else
    {
        welcomeScreen * pageObj = [[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
        [pageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self.view.window.rootViewController presentViewController:pageObj animated:YES completion:nil];
//        [self.navigationController pushViewController:pageObj animated:YES];
//        [pageObj release];
    }
}

-(void)headerReloadingFrame
{
}

#pragma  mark - More button Frame

-(void) MoreBtnPopup
{
    MoreViewPopup = [[[UIView alloc] init] autorelease];
    [MoreViewPopup setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [MoreViewPopup setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2f]];
    
    UIButton * closepopupBtn = [[[UIButton alloc] init] autorelease];
    [closepopupBtn setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [closepopupBtn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [MoreViewPopup addSubview:closepopupBtn];
    
    
    UIButton * helpBtn = [[[UIButton alloc] init] autorelease];
    [helpBtn setFrame:CGRectMake(10, delegate.windowHeight-150, delegate.windowWidth-20, 60)];
    [helpBtn addTarget:self action:@selector(RedirectTohelppage) forControlEvents:UIControlEventTouchUpInside];
    [helpBtn setTitle:[delegate.languageDict objectForKey:@"help"] forState:UIControlStateNormal];
    [helpBtn setTitleColor:headercolor forState:UIControlStateNormal];
    [helpBtn setBackgroundColor:opwhitecolor];
    [helpBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [helpBtn.layer setCornerRadius:2];
    [helpBtn.layer setMasksToBounds:YES];
    [MoreViewPopup addSubview:helpBtn];
    
    UIButton * cancelBtn = [[[UIButton alloc] init] autorelease];
    [cancelBtn setFrame:CGRectMake(10, delegate.windowHeight-80, delegate.windowWidth-20, 60)];
    [cancelBtn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:AppThemeColor];
    [cancelBtn setTitle:[delegate.languageDict objectForKey:@"cancel"] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [cancelBtn.layer setCornerRadius:2];
    [cancelBtn.layer setMasksToBounds:YES];
    [MoreViewPopup addSubview:cancelBtn];
    
    
    self.popup = [KOPopupView popupView];
    [self.popup.handleView addSubview:MoreViewPopup];
    MoreViewPopup.center = CGPointMake(self.popup.handleView.frame.size.width/2.0,
                                       self.popup.handleView.frame.size.height/2.0);
    [self.popup show];

}

-(void)closePopup
{
    [self.popup hideAnimated:TRUE];
}

-(void) ShowMorePopup{
    [self.popup show];
    
}







#pragma mark - Redirect To EditProfile

-(void)RedirectToEditProfile
{
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        EditProfile * EditProfilePageObj = [[EditProfile alloc]initWithNibName:@"EditProfile" bundle:nil];
        [self.navigationController pushViewController:EditProfilePageObj animated:NO];
        [EditProfilePageObj release];
    }
}


#pragma mark - Redirect To Notification

-(void)RedirectToNotification
{
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        NotificationPage * NotificationPageObj = [[NotificationPage alloc]initWithNibName:@"NotificationPage" bundle:nil];
        [self.navigationController pushViewController:NotificationPageObj animated:YES];
        [NotificationPageObj release];
    }
    
}

#pragma mark - Redirect To helppage

-(void)RedirectTohelppage
{
    [self.popup hideAnimated:TRUE];
    
    NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
    if ([defaultuser objectForKey:@"USERID"]!=NULL)
    {
        HelpPage * HelpPageObj = [[HelpPage alloc]initWithNibName:@"HelpPage" bundle:nil];
        [self.navigationController pushViewController:HelpPageObj animated:YES];
        [HelpPageObj release];
    }
    
}

#pragma mark - Parsing function

-(void) loadingUserData
{
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        @try
        {
            userIDValue =[[NSMutableArray alloc]initWithCapacity:0];
            [userIDValue addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];
            [delegate.userIDArray removeAllObjects];
            [delegate.userIDArray addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];
            [proxy profile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@""];
//            [delegate adminchecking];
            delegate.window.userInteractionEnabled = YES;
        }
        @catch (NSException * e)
        {
        }
    }
}

-(void) loadingOtherUserData:(NSString *) userId :(NSString *) ProfileTab
{
    if (!proxy)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    profileTab=ProfileTab;
    userIDValue =[[NSMutableArray alloc]initWithCapacity:0];
    [userIDValue addObject:[NSString stringWithFormat:@"%@",userId]];
    [delegate.userIDArray removeAllObjects];
    [delegate.userIDArray addObject:[userIDValue objectAtIndex:0]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [proxy profile:apiusername :apipassword :[userIDValue objectAtIndex:0] :@""];
}

#pragma mark - <MXSegmentedPagerControllerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager
{
    return [sectionHeaderArray count];
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index
{
        return @[myListingPageObj,myLikesPageObj,followerPageObj,followingPageObj][index];
}

-(NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index
{
    if ([sectionHeaderArray count]!=0)
    {
        return [sectionHeaderArray objectAtIndex:index];

    }
    return 0;
}
-(BOOL)segmentedPagerShouldScrollToTop:(MXSegmentedPager *)segmentedPager
{
    return YES;
}

-(void)segmentedPager:(MXSegmentedPager *)segmentedPager didEndDraggingWithParallaxHeader:(MXParallaxHeader *)parallaxHeader
{
    
    NSLog(@"%f",parallaxHeader.contentView.frame.size.height);
    
    
    if (parallaxHeader.height==270)
    {
        if (parallaxHeader.contentView.frame.size.height>=180)
        {
            parallaxHeader.height=270;
            [self performSelector:@selector(showAnimating:) withObject:parallaxHeader afterDelay:0.1];
        


        }
        else
        {
            parallaxHeader.height=80;
            [self performSelector:@selector(showAnimating:) withObject:parallaxHeader afterDelay:0.1];
          

        }
    }
    else
    {
        if (parallaxHeader.contentView.frame.size.height>=30)
        {
            parallaxHeader.height=270;
            [self performSelector:@selector(showAnimatings:) withObject:parallaxHeader afterDelay:0.1];
        

        }
        else
        {
            parallaxHeader.height=80;
            [self performSelector:@selector(showAnimating:) withObject:parallaxHeader afterDelay:0.1];

            
           

        }
    }
    
    if (parallaxHeader.contentView.frame.size.height>=270)
    {
        self.segmentedPager.bounces = NO;
    }
    else
    {
        self.segmentedPager.bounces = YES;
    }

    headerheight =parallaxHeader.height;
    return;
    
}
-(void) showAnimating:(MXParallaxHeader*)parallaxHeader
{
    [self.segmentedPager scrollToTopAnimated:YES];
    [profileHeader animatingHeaderView];

}
-(void) showAnimatings:(MXParallaxHeader*)parallaxHeader
{
    [self.segmentedPager scrollToTopAnimated:NO];
    [profileHeader animatingHeaderView];
    
}

#pragma mark - WSDL DelegateMethod

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
}

-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    
    NSLog(@"%@",data);
    
    self.segmentedPager.bounces = NO;
    if ([method isEqualToString:@"Getfollowerid"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
        [delegate.followerIdArray removeAllObjects];
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [delegate.followerIdArray addObjectsFromArray:[defaultDict objectForKey:@"result"]];
        }
        if ([delegate.followerIdArray containsObject:[delegate.userIDArray objectAtIndex:0]])
        {
            [profileHeader updateFollowBtn:YES];
            
        }
        [profileHeader loadProfileHeaderValues:userDetailsArray tab:profileTab height:headerheight];

    }
    else if ([method isEqualToString:@"pushsignout"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
    }
    else if ([method isEqualToString:@"profile"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [userDetailsArray removeAllObjects];
            [userDetailsArray addObject:[defaultDict objectForKey:@"result"]];
            if(![profileTab isEqualToString:@"NO"]){
                profileTab=@"YES";
            }
            [[NSUserDefaults standardUserDefaults]setObject:[[userDetailsArray objectAtIndex:0]objectForKey:@"full_name"] forKey:@"full_name"];
            [[NSUserDefaults standardUserDefaults]setObject:[[userDetailsArray objectAtIndex:0]objectForKey:@"user_img"] forKey:@"photo"];

            [profileHeader loadProfileHeaderValues:userDetailsArray tab:profileTab height:headerheight];
            [self performSelectorOnMainThread:@selector(getFollowedUserID) withObject:nil waitUntilDone:YES];
            errorFlag = NO;
        }
        else if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"ERROR"])
        {
            errorFlag = YES;
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:[[defaultDict objectForKey:@"status"]uppercaseString]
                                      message:[NSString stringWithFormat:@"%@ Please press ok to signout",[defaultDict objectForKey:@"message"]]
                                      delegate:self
                                      cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                      otherButtonTitles:nil, nil];
            [alertView setTag:921];
            [alertView show];
        }
    }
    else if ([method isEqualToString:@"Unfollowuser"])
    {
    }
    else if ([method isEqualToString:@"Followuser"])
    {
    }
}

#pragma mark - alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==921)
    {
        if (buttonIndex==0)
        {
            NSUserDefaults*defaultuser=[NSUserDefaults standardUserDefaults];
            [defaultuser removeObjectForKey:@"USERID"];
            [defaultuser removeObjectForKey:@"user_name"];
            [defaultuser removeObjectForKey:@"photo"];
            [defaultuser removeObjectForKey:@"full_name"];
            [defaultuser synchronize ];
            [self deleteDeviceForDeviceToken];
            delegate.tabID = 0;
            delegate.tabViewControllerObj = [[TabViewController alloc]initWithNibName:@"TabViewController" bundle:nil];
            delegate.navi = [[AHKNavigationController alloc]initWithRootViewController:delegate.tabViewControllerObj];
            [delegate.navi setNavigationBarHidden:YES];
            delegate.window.rootViewController = delegate.navi;
            [delegate.userIDArray removeAllObjects];
        }
    }
}

#pragma mark - Signout proxy
-(void) deleteDeviceForDeviceToken
{
    if ([delegate.devicetokenArray count]!=0)
    {
        if ([delegate.devicetokenArray count]!=0)
        {
            [proxy pushsignout:apiusername :apipassword :[delegate.devicetokenArray objectAtIndex:0]];
        }
    }
}

#pragma  mark - Dealloc and memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
