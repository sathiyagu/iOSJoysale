//
//  SideBarMenu.m
//  HSJoysale
//
//  Created by BTMani on 28/11/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "SideBarMenu.h"
#import "EditProfile.h"
#import "NotificationPage.h"
#import "HelpPage.h"
#import "welcomeScreen.h"
#import "NewProfilePage.h"
#import "UIImage+EZAdditions.h"
#import "TPFloatRatingView.h"
@interface SideBarMenu ()

@end

@implementation SideBarMenu
@synthesize popup;

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate  = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view setBackgroundColor:BackGroundColor];
    
    if (!proxy)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    sideMenuArray = [[NSMutableArray alloc]initWithCapacity:0];
    userDetailArray = [[NSMutableArray alloc]initWithCapacity:0];

    
    //
    
    
    //Properties
    
    [sideMenuTable setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight-120)];
    [sideMenuTable setBackgroundColor:BackGroundColor];

    
    [self inviteBtnPopup];
    
    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{

    [self setNeedsStatusBarAppearanceUpdate];

    //appearance
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self performSelectorOnMainThread:@selector(checkadmindatasapi) withObject:nil waitUntilDone:YES];
    [self allocData];

    
    
    [sideMenuTable reloadData];

    
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
    [self barButtonFunction];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void) allocData{
    
    [sideMenuArray removeAllObjects];
    [userDetailArray removeAllObjects];
    [sideMenuArray addObject:@""];
    
    [sideMenuArray addObject:[delegate.languageDict objectForKey:@"notifications"]];//
    [sideMenuArray addObject:[delegate.languageDict objectForKey:@"help"]];
    [sideMenuArray addObject:[delegate.languageDict objectForKey:@"Invite friends"]];
    [sideMenuArray addObject:[delegate.languageDict objectForKey:@"logout"]];
    
    
    
    
    NSLog(@"%@",delegate.UserDetailArray);
    
    //    [userDetailArray addObjectsFromArray:delegate.UserDetailArray];
    
    //    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=NULL)
    //    {
    [userDetailArray removeAllObjects];
    @try {
        [userDetailArray addObject:[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"user_id"]];
        [userDetailArray addObject:[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"full_name"]];
        [userDetailArray addObject:[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"user_img"]];
        [userDetailArray addObject:[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"rating"]];
    } @catch (NSException *exception) {
        [self getProfileInfo];
        
        NSLog(@"Exception in UserDetails");
    } @finally {
        NSLog(@"It's from view will appear");
    }
    [sideMenuTable reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)checkadmindatasapi
{
    [proxy admindatas:apiusername :apipassword :[delegate gettingLanguageCode]];
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
    [titleLabel setText:[delegate.languageDict objectForKey:@"myprofile"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [leftNaviNaviButtonView addSubview:titleLabel];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 80;
    }
    else if (indexPath.row==[sideMenuArray count]-1)
    {
        return 72;
    }
    else
    {
        return 55;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([userDetailArray count]!=0)
    {
        return [sideMenuArray count];

    }
    return 0;
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
    
    
    UIView * contentview = [[[UIView alloc]init]autorelease];
    [contentview setBackgroundColor:whitecolor];
    
    UIImageView * arrowImage = [[[UIImageView alloc]init]autorelease];
    [arrowImage setImage:[UIImage imageNamed:@"InArrowImg.png"]];
    [arrowImage setContentMode:UIViewContentModeScaleAspectFit];
    [contentview addSubview:arrowImage];
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        
        [arrowImage setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
    }

    

    
    if (indexPath.row==0)
    {
        
        [contentview setFrame:CGRectMake(0,5,delegate.windowWidth,70)];
        UIImageView * userImageview = [[[UIImageView alloc]init]autorelease];
        [userImageview setFrame:CGRectMake(10,8,50,50)];
        [userImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDetailArray objectAtIndex:2]]]placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
        [userImageview setContentMode:UIViewContentModeScaleAspectFill];
        userImageview.layer.cornerRadius = 25;
        userImageview.layer.masksToBounds=YES;
        [userImageview setBackgroundColor:AppThemeColor];
        [contentview addSubview:userImageview];
        [arrowImage setFrame:CGRectMake(delegate.windowWidth-30,25,20,20)];

        UILabel * usernameLable = [[[UILabel alloc]init]autorelease];
        [usernameLable setText:[userDetailArray objectAtIndex:1]];
        [usernameLable setFont:[UIFont fontWithName:appFontBold size:20]];
        [usernameLable setTextAlignment:NSTextAlignmentLeft];
        [usernameLable setNumberOfLines:1];
        [usernameLable setTextColor:headercolor];
        [usernameLable setFrame:CGRectMake(70,7,delegate.windowWidth-110,30)];
        [usernameLable setBackgroundColor:clearcolor];
        [contentview addSubview:usernameLable];

        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [userImageview setFrame:CGRectMake(delegate.windowWidth-60,10,50,50)];
            [usernameLable setFrame:CGRectMake(10,10,delegate.windowWidth-80,30)];
            [usernameLable setTextAlignment:NSTextAlignmentRight];
            [arrowImage setFrame:CGRectMake(10,25,20,20)];
            
        }
        

            UILabel * heloTextLabel = [[[UILabel alloc]init]autorelease];
            [heloTextLabel setText:[delegate.languageDict objectForKey:@"View and Edit Profile"]];
            [heloTextLabel setFont:[UIFont fontWithName:appFontRegular size:14]];
            [heloTextLabel setTextAlignment:NSTextAlignmentLeft];
            [heloTextLabel setNumberOfLines:1];
            [heloTextLabel setTextColor:headercolor];
            [heloTextLabel setFrame:CGRectMake(70,40,delegate.windowWidth-110,20)];
            [heloTextLabel setBackgroundColor:clearcolor];
            [contentview addSubview:heloTextLabel];
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [heloTextLabel setFrame:CGRectMake(10,40,delegate.windowWidth-110,20)];
                [heloTextLabel setTextAlignment:NSTextAlignmentRight];
                
            }

        

        
        //  need to check buynow flag



    }
    else
    {

        UILabel * textLabel = [[[UILabel alloc]init]autorelease];
        [textLabel setText:[sideMenuArray objectAtIndex:indexPath.row]];
        [textLabel setFont:[UIFont fontWithName:appFontRegular size:17]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setNumberOfLines:1];
        [textLabel setTextColor:headercolor];
        [textLabel setFrame:CGRectMake(10,10,delegate.windowWidth-50,30)];
        [textLabel setBackgroundColor:clearcolor];
        [contentview addSubview:textLabel];
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [textLabel setFrame:CGRectMake(40,10,delegate.windowWidth-50,30)];
            [textLabel setTextAlignment:NSTextAlignmentRight];
        }
        if (indexPath.row==[sideMenuArray count]-1)
        {
            [contentview setFrame:CGRectMake(0,20,delegate.windowWidth,50)];
            [arrowImage setFrame:CGRectMake(delegate.windowWidth-30,15,20,20)];
            [arrowImage setImage:[UIImage imageNamed:@"logout.png"]];
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [arrowImage setFrame:CGRectMake(10,15,20,20)];
            }
            //

        }
        else
        {
            [contentview setFrame:CGRectMake(0,0,delegate.windowWidth,50)];
            [arrowImage setFrame:CGRectMake(delegate.windowWidth-30,15,20,20)];
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [arrowImage setFrame:CGRectMake(10,15,20,20)];
            }
            if (indexPath.row==1)
            {
                //countDetailDict
                NSString *notificationCount = [NSString stringWithFormat:@"%@",[[delegate.countDetailDict objectForKey:@"result"]objectForKey:@"notificationCount"]];
                if ([notificationCount isEqualToString:@"0"])
                {
//                    labelProfile.backgroundColor = [UIColor clearColor];
//                    labelProfile.text =@"";
                }
                else
                {
                    UILabel * countLabel = [UILabel new];
                    [countLabel setText:@""];
                    [countLabel setFrame:CGRectMake(delegate.windowWidth-80,10,50,30)];
                    [countLabel.layer setCornerRadius:15];
                    [countLabel.layer setMasksToBounds:YES];

                    [countLabel setTextAlignment:NSTextAlignmentCenter];
                    [countLabel setTextColor:whitecolor];
                    countLabel.backgroundColor = AppThemeColor;
                    countLabel.text = notificationCount;
                    [countLabel setFont:[UIFont fontWithName:appFontBold size:12]];
                    [contentview addSubview:countLabel];
                    if([delegate.languageSelected isEqualToString:@"Arabic"]){
                        [arrowImage setFrame:CGRectMake(10,15,20,20)];
                        [countLabel setFrame:CGRectMake(40,10,50,30)];
                        [arrowImage setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
                        
                    }
                }

            }

        }

    }
    [cell.contentView addSubview:contentview];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark  TableViewDelegate

//Redirect to message Detail page

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
        if ([defaultuser objectForKey:@"USERID"]!=NULL)
        {
        NewProfilePage * newProfilePageObj = [[NewProfilePage alloc]initWithNibName:@"NewProfilePage" bundle:nil];
        [self.navigationController pushViewController:newProfilePageObj animated:YES];
        [newProfilePageObj release];
        }
    }
    else if(indexPath.row==[sideMenuArray count]-1)//Logout
    {
        [self SignOutDesigns];
    }
    else if ([[sideMenuArray objectAtIndex:indexPath.row]isEqualToString:[delegate.languageDict objectForKey:@"notifications"]])
    {
        NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
        if ([defaultuser objectForKey:@"USERID"]!=NULL)
        {
            NotificationPage * NotificationPageObj = [[NotificationPage alloc]initWithNibName:@"NotificationPage" bundle:nil];
            [self.navigationController pushViewController:NotificationPageObj animated:YES];
            [NotificationPageObj release];
        }
    }
    else if ([[sideMenuArray objectAtIndex:indexPath.row]isEqualToString:[delegate.languageDict objectForKey:@"Invite friends"]])
    {
        NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
        if ([defaultuser objectForKey:@"USERID"]!=NULL)
        {
            [self ShowMorePopup];
        }

    }
    else if ([[sideMenuArray objectAtIndex:indexPath.row]isEqualToString:[delegate.languageDict objectForKey:@"addressbook"]])
    {
        NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
        if ([defaultuser objectForKey:@"USERID"]!=NULL)
        {
        }
        
    }

    
    else if ([[sideMenuArray objectAtIndex:indexPath.row]isEqualToString:[delegate.languageDict objectForKey:@"help"]])
    {
        NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
        if ([defaultuser objectForKey:@"USERID"]!=NULL)
        {
            HelpPage * HelpPageObj = [[HelpPage alloc]initWithNibName:@"HelpPage" bundle:nil];
            [self.navigationController pushViewController:HelpPageObj animated:YES];
            [HelpPageObj release];
        }

    }

    
}
#pragma mark signout
-(void)SignOutDesigns
{
    [self.view endEditing:YES];
    UIAlertView * signOutAlert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[delegate.languageDict objectForKey:@"reallySignOut"]
                                                           delegate:self
                                                  cancelButtonTitle:[delegate.languageDict objectForKey:@"cancel"]
                                                  otherButtonTitles:[delegate.languageDict objectForKey:@"ok"],nil];
    [signOutAlert setTag:921];
    [signOutAlert show];
}


#pragma mark - alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==921)
    {
        if (buttonIndex==1)
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
            
            UINavigationController * vc = [delegate.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:delegate.tabID];
            [delegate.userIDArray removeAllObjects];
            
            welcomeScreen *firstpageObj=[[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
            [firstpageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
            
            [self.view.window.rootViewController presentViewController:firstpageObj animated:YES completion:nil];
//            [vc pushViewController:firstpageObj animated:YES];
//            [firstpageObj release];

        }
    }
}

//

-(void) getProfileInfo
{
    //[self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:YES];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]!=NULL)
    {
        ApiControllerServiceProxy *Profileproxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
        [Profileproxy profile:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@""];
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
#pragma mark - WSDL DelegateMethod

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
}

-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    
    NSLog(@"%@",data);
    
    if ([method isEqualToString:@"pushsignout"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
    }else if ([method isEqualToString:@"profile"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [delegate.UserDetailArray removeAllObjects];
            [delegate.UserDetailArray addObjectsFromArray:[delegate.defensiveClassObj profileParsing:[defaultDict objectForKey:@"result"]]];
            
            [[NSUserDefaults standardUserDefaults]setObject:[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"full_name"] forKey:@"full_name"];
            [[NSUserDefaults standardUserDefaults]setObject:[[delegate.UserDetailArray objectAtIndex:0]objectForKey:@"user_img"] forKey:@"photo"];
            [self allocData];
            [sideMenuTable reloadData];
        }
    }else if ([method isEqualToString:@"admindatas"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
        if ([[[defaultDict objectForKey:@"status"]uppercaseString]isEqualToString:@"TRUE"])
        {
            if([[[defaultDict objectForKey:@"result"] objectForKey:@"banner"] isEqualToString:@"disable"]){
                delegate.bannerEnable = NO;
            }else{
                delegate.bannerEnable = YES;
                @try {
                    [delegate.bannerDetailsArray addObjectsFromArray:[[defaultDict objectForKey:@"result"] objectForKey:@"bannerData"]];
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
            }
        }
    }
}

#pragma mark - invite popup

-(void) inviteBtnPopup{

    moreViewPopup = [[[UIView alloc] init] autorelease];
    [moreViewPopup setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [moreViewPopup setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2f]];
    
    self.popup = [KOPopupView popupView];
    [self.popup.handleView addSubview:moreViewPopup];
    moreViewPopup.center = CGPointMake(self.popup.handleView.frame.size.width/2.0,
                                       self.popup.handleView.frame.size.height/2.0);
    
    UIButton * closepopupBtn = [UIButton new];
    [closepopupBtn setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [closepopupBtn addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [moreViewPopup addSubview:closepopupBtn];
    
    UIView * inviteview = [[[UIView alloc] init] autorelease];
    [inviteview setBackgroundColor:whitecolor];
    inviteview.layer.cornerRadius=15.0f;
    [moreViewPopup addSubview:inviteview];
    
    UIImageView *inviteImageview = [[[UIImageView alloc] init] autorelease];
    [inviteImageview setBackgroundColor:TransparentBlack];
    [inviteImageview setImage:[UIImage imageNamed:@"applogo.png"]];
    [inviteImageview setContentMode:UIViewContentModeScaleAspectFit];
    inviteImageview.layer.cornerRadius=40.0f;
    [inviteImageview.layer setMasksToBounds:YES];
    [moreViewPopup addSubview:inviteImageview];
    
    UILabel * titlelable = [[[UILabel alloc]init]autorelease];
    
    [titlelable setText:[delegate.languageDict objectForKey:@"Invite friends"]];
//    [titlelable setText:@"Invite Friends"];

    
    [titlelable setTextColor:headercolor];
    [titlelable setFont:[UIFont fontWithName:appFontBold size:25]];
    [titlelable setTextAlignment:NSTextAlignmentCenter];
    [inviteview addSubview:titlelable];
    
    UILabel * messageLable = [[UILabel alloc] init];
    
    [messageLable setText:[delegate.languageDict objectForKey:@"Invite Message"]];
    [messageLable setAdjustsFontSizeToFitWidth:YES];
//    [messageLable setText:@"Invite your friends to use Joysale app. Via Whats app,Facebook and Email."];

    
    [messageLable setTextColor:CommentDaysTextColor];
    [messageLable setFont:[UIFont fontWithName:appFontRegular size:16]];
    [messageLable setTextAlignment:NSTextAlignmentCenter];
    [messageLable setNumberOfLines:5];
    [inviteview addSubview:messageLable];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL =
    [NSURL URLWithString:InviteURL];
    
    FBSDKSendButton * messengerBtn = [[FBSDKSendButton alloc] init];
    
//    UIButton * messengerBtn = [UIButton new];

    [messengerBtn setTitleColor:headercolor forState:UIControlStateNormal];
    
//    [messengerBtn setTitle:[delegate.languageDict objectForKey:@"inviteviamessenger"] forState:UIControlStateNormal];
    
    [messengerBtn setTitle:[delegate.languageDict objectForKey:@"Invite via Messanger"] forState:UIControlStateNormal];

    messengerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [messengerBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [messengerBtn.titleLabel setFont:[UIFont fontWithName:appFontBold size:14]];
    [messengerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [messengerBtn.layer setCornerRadius:2];
    [messengerBtn.layer setCornerRadius:10];
    [messengerBtn.layer setMasksToBounds:YES];
    [messengerBtn setBackgroundColor:[UIColor clearColor]];
    [messengerBtn setBackgroundColor:[UIColor colorWithRed:59/255.0 green:89/255.0 blue:153/255.0 alpha:1]];
    messengerBtn.shareContent = content;
    [inviteview addSubview:messengerBtn];
    
    
    UIButton * invitewhatsappBtn = [UIButton new];
    [invitewhatsappBtn addTarget:self action:@selector(redirectWhatsapp) forControlEvents:UIControlEventTouchUpInside];
    [invitewhatsappBtn setTitleColor:headercolor forState:UIControlStateNormal];
    
    [invitewhatsappBtn setTitle:[delegate.languageDict objectForKey:@"Invite via Whatsapp"] forState:UIControlStateNormal];
    
    
    [invitewhatsappBtn.titleLabel setFont:[UIFont fontWithName:appFontBold size:14]];
//    [invitewhatsappBtn.titleLabel setBackgroundColor:graycolor];
    [invitewhatsappBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [invitewhatsappBtn.layer setCornerRadius:2];
    [invitewhatsappBtn.layer setCornerRadius:10];
    [invitewhatsappBtn.layer setMasksToBounds:YES];
    [invitewhatsappBtn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:213/255.0 blue:65/255.0 alpha:1]];
    UIImageView *whatsappImagview = [[[UIImageView alloc] init] autorelease];
    [whatsappImagview setFrame:CGRectMake(12,12, 20,20)];
    
    [whatsappImagview setImage:[UIImage imageNamed:@"invite_whatsapp.png"]];
    [whatsappImagview setContentMode:UIViewContentModeScaleAspectFill];
    [invitewhatsappBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [invitewhatsappBtn addSubview:whatsappImagview];
    [inviteview addSubview:invitewhatsappBtn];
    
    UIButton * inviteemailbtn = [[[UIButton alloc] init] autorelease];
    [inviteemailbtn addTarget:self action:@selector(redirectemail) forControlEvents:UIControlEventTouchUpInside];
    [inviteemailbtn setBackgroundColor:AppThemeColor];
    
    [inviteemailbtn setTitle:[delegate.languageDict objectForKey:@"Invite via Email"] forState:UIControlStateNormal];
    
//    [inviteemailbtn setTitle:@"Invite via Email" forState:UIControlStateNormal];

    [inviteemailbtn.titleLabel setFont:[UIFont fontWithName:appFontBold size:14]];
    [inviteemailbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inviteemailbtn.layer setCornerRadius:10];
    [inviteemailbtn.layer setMasksToBounds:YES];
    [inviteemailbtn setBackgroundColor:[UIColor redColor]];//[UIColor colorWithRed:134/255.0 green:126/255.0 blue:129/255.0 alpha:1]];
    UIImageView *mailImageView = [[[UIImageView alloc] init] autorelease];
    [mailImageView setFrame:CGRectMake(12, 12, 20, 20)];
    
    [mailImageView setImage:[UIImage imageNamed:@"invite_mail.png"]];
    [mailImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    
    [inviteemailbtn addSubview:mailImageView];

    
    
    [inviteview addSubview:inviteemailbtn];
    [inviteview setFrame:CGRectMake(40, (delegate.windowHeight/2)-170, delegate.windowWidth-80,320)];
    CGFloat invitewidth= inviteview.frame.size.width;
    [inviteImageview setFrame:CGRectMake((delegate.windowWidth/2)-40, (delegate.windowHeight/2)-210, 80, 80)];
    titlelable.frame = CGRectMake(20,50, inviteview.frame.size.width-40,25);
    messageLable.frame = CGRectMake(10,titlelable.frame.size.height+titlelable.frame.origin.y+5, inviteview.frame.size.width-20,70);
    [messengerBtn setFrame:CGRectMake(15,messageLable.frame.size.height+messageLable.frame.origin.y+5, invitewidth-30, 45)];
    [invitewhatsappBtn setFrame:CGRectMake(15,messengerBtn.frame.size.height+messengerBtn.frame.origin.y+5, invitewidth-30, 45)];
    [inviteemailbtn setFrame:CGRectMake(15,invitewhatsappBtn.frame.size.height+invitewhatsappBtn.frame.origin.y+5, invitewidth-30, 45)];

    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [mailImageView setFrame:CGRectMake(inviteemailbtn.frame.size.width-32, 12, 20, 20)];
        [whatsappImagview setFrame:CGRectMake(invitewhatsappBtn.frame.size.width-32,12, 20,20)];
        NSLog(@"Messengar Btn Imageview before frame : %f",messengerBtn.imageView.frame.origin.x
              );
        messengerBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        messengerBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        messengerBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        //[messengerBtn.imageView setFrame:CGRectMake(messengerBtn.frame.size.width-52,12, 20,20)];
        NSLog(@"Messengar Btn Imageview  after frame : %f",messengerBtn.imageView.frame.origin.x
              );
    }
//    [self.popup show];
    
}
-(void) redirectWhatsapp
{
    NSString * shareURL = InviteURL;

    NSString * msg = [NSString stringWithFormat:@"%@",shareURL];
    
    msg = [msg stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    msg = [msg stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    msg = [msg stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    msg = [msg stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    msg = [msg stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    msg = [msg stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
    NSURL * whatsappURL = [NSURL URLWithString:urlWhats];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"WhatsApp not installed"] message:[delegate.languageDict objectForKey:@"WhatsappError"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
        [alert show];
    }
}
-(void) redirectemail
{
    NSString * shareURL = InviteURL;
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *message = [NSString stringWithFormat:@"<h4>%@ %@: <a href='%@'>%@</a> </h4>",[delegate.languageDict objectForKey:@"InviteAlert"],AppName,shareURL,shareURL];
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:[NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"Invite from"],AppName]];
        [mail setMessageBody: message isHTML: YES];
        NSString *toStr = @"";
        [mail setToRecipients:@[toStr]];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"failed"] message:[delegate.languageDict objectForKey:@"InviteAlert"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
        [alert show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [[[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"Message Cancelled"] message:nil delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil]show];
            break;
        case MFMailComposeResultSent:
            [[[UIAlertView alloc]initWithTitle:@"Success!!" message:[delegate.languageDict objectForKey:@"App Invite send successfully"] delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles: nil]show];                 break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)closePopup
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = AppThemeColor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self.popup hideAnimated:TRUE];
}

-(void) ShowMorePopup{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = clearcolor;
        //[statusBar setTintColor:[UIColor blackColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self.popup show];
}

@end
