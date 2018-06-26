//
//  ProfilePageHeader.m
//  HSJoysale
//
//  Created by BTMani on 23/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * Profile header located on profile page. It show user information like name, username
 * Verification Mail,facebook, mobile number infomation
 * if other user means, it show follow button
 * same user means it show menu button if click on tab bar otherwise show back button only shown
 */

#import "ProfilePageHeader.h"
#import "MXParallaxHeader.h"
#import "AppDelegate.h"
#import "SideBarMenu.h"

@interface ProfilePageHeader () <MXParallaxHeader>
{
    BOOL follow;
}

@end

@implementation ProfilePageHeader

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

#pragma mark <MXParallaxHeader>

- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader {
    
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    CGFloat ratio = (parallaxHeader.contentView.frame.size.height - 64)/200.0;
    
    if (parallaxHeader.contentView.frame.size.height<=230)
    {
        [self.verifiedView setHidden:YES];
    }
    else
    {
        [self.verifiedView setHidden:NO];
    }
    if (parallaxHeader.contentView.frame.size.height==80)
    {
        [_bottomLineView setHidden:NO];
    }
    else
    {
        [_bottomLineView setHidden:YES];
    }
    [_bottomLineView setBackgroundColor:lineviewColor];
    
    int page;
    CGFloat pageWidth = 125;
    page = floor((parallaxHeader.contentView.frame.size.height - pageWidth / 2) / pageWidth)+1;
    if(page < 0 || page == pageNumber)
    {
    }
    pageNumber = page;
    header = parallaxHeader;
    
  //  [self.ratingView setHidden:YES];
    
//    self.ratingView.emptySelectedImage = [[UIImage imageNamed:@"StarEmpty"] ez_tintedImageWithColor:graycolor];
//    self.ratingView.fullSelectedImage = [[UIImage imageNamed:@"StarFull"] ez_tintedImageWithColor:AppThemeColor];
    self.ratingView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.ratingView.maxRating = 5;
    self.ratingView.minRating = 0;
    self.ratingView.editable = NO;
   // self.ratingView.halfRatings = YES;
    self.ratingView.floatRatings = YES;
    
    
    [self.ratingCountLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [self.ratingCountLabel setTextAlignment:NSTextAlignmentLeft];
    [self.ratingCountLabel setNumberOfLines:1];
    [self.ratingCountLabel setTextColor:headercolor];
    [self.ratingCountLabel setBackgroundColor:clearcolor];


    followimg = [[UIImageView alloc]init];
    [followimg setFrame:CGRectMake(8, 6, 23, 23)];
    [followimg setContentMode:UIViewContentModeScaleAspectFill];
    [followimg setUserInteractionEnabled:YES];
    //[self.FollowBtn addSubview:followimg];
    
    reviewBtn = [[UIButton alloc]init];
    reviewBtn.frame = self.headerView.frame;
    [reviewBtn addTarget:self action:@selector(reviewBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [reviewBtn setBackgroundColor:clearcolor];
    [self addSubview:reviewBtn];
    
    
    self.FollowBtn.layer.cornerRadius=2;
    //self.FollowBtn.layer.borderWidth=1;
    self.FollowBtn.layer.masksToBounds=YES;
    [self.FollowBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0]];
    [self.FollowBtn setUserInteractionEnabled:YES];
 //   {top, left, bottom, right}
    self.FollowBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5,10);

    [self.headerView setBackgroundColor:[UIColor clearColor]];
    [self.FollowBtn.titleLabel setFont:SmallButtonFont];

    self.imageTopConstraint.constant = 50;
    self.alertButtonLeadingConstrain.constant = (delegate.windowWidth-200);
    self.settingButtonLeadingConstrain.constant = (delegate.windowWidth-150);
    self.followButtonLeftConstraint.constant = (delegate.windowWidth-100);
    self.verifiedViewLeftConstraint.constant = (delegate.windowWidth-240)/2;
    self.navigationViewwidth.constant = (delegate.windowWidth);
    self.verifiedViewWidthConstraint.constant = 240;
    self.headerViewWidthConstraint.constant = 240;
    self.profileImageView.layer.masksToBounds=YES;
    
    if (parallaxHeader.contentView.frame.size.height<=180)
    {

        self.imageLeftConstraint.constant = 40;
        self.bottomConstraint.constant = ratio * 30;
        self.widthConstraint.constant = 40;
        self.imageTopConstraint.constant = 25;
        self.nameViewToptConstraint.constant = 20;
    self.profileImageView.layer.cornerRadius=self.widthConstraint.constant/2;
        [self nameViewBottomArrangeMent:parallaxHeader];
        return;
    }
    else
    {
        self.imageLeftConstraint.constant = (delegate.windowWidth-70)/2;
        self.imageTopConstraint.constant = (parallaxHeader.contentView.frame.size.height-70)/2;
        self.bottomConstraint.constant = ratio * 30 + 10;
        self.widthConstraint.constant = 70;
        self.nameViewToptConstraint.constant = (parallaxHeader.contentView.frame.size.height/2)+30;
        self.profileImageView.layer.cornerRadius=self.widthConstraint.constant/2;
        [self nameViewTopArrangeMent:parallaxHeader];
        return;
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

-(void) framesetting:(MXParallaxHeader *)parallaxHeader
{
    
}
#pragma mark - navigationView
-(void) nameViewBottomArrangeMent:(MXParallaxHeader *)parallaxHeader
{
    
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self.ratingView setHidden:YES];
    [self.ratingCountLabel setHidden:YES];
    if ([globaluserArray count]!=0)
    {
        if ([globaluserArray count]!=0)
        {
            if ([[[globaluserArray objectAtIndex:0]objectForKey:@"rating"]floatValue]==0)
            {
                [self hiderating];
            }
            else{
                [self.locationLabel setHidden:NO];
                [self.ratingView setHidden:YES];
                [self.ratingCountLabel setHidden:YES];
            }
        }
        else
        {
            [self.locationLabel setHidden:YES];
            [self.ratingView setHidden:YES];
            [self.ratingCountLabel setHidden:YES];
            
        }

    }
    [self.BackBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.settingBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.FollowBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];

    if ([globaluserArray count]>0)
    {
        NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];

        [UIView transitionWithView:self.profileImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.profileImageView setHidden:YES];
                        }
                        completion:NULL];
        self.nameViewWidthConstraint.constant = 240;
        self.nameViewHeightConstraint.constant = 35;
        @try
        {
            if([[[globaluserArray objectAtIndex:0]objectForKey:@"user_id"] isEqualToString:[defaultuser objectForKey:@"USERID"]] && delegate.tabID==4 && [profiletab isEqualToString:@"YES"]){
                self.nameViewLeftConstraint.constant = 80;
                self.imageLeftConstraint.constant = 40;
            }else if([[[globaluserArray objectAtIndex:0]objectForKey:@"user_id"] isEqualToString:[defaultuser objectForKey:@"USERID"]]){
                self.nameViewLeftConstraint.constant = 80;
                self.imageLeftConstraint.constant = 40;
            }else{
                self.nameViewLeftConstraint.constant = 80;
                self.imageLeftConstraint.constant = 40;
            }
        }
        @catch (NSException * e)
        {
            self.nameViewLeftConstraint.constant = 80;
            self.imageLeftConstraint.constant = 40;
        }
    }
    self.nameLblWidth.constant=140;
    self.namelabelTopConstraint.constant = 0;
    self.nameLabelLeftConstraint.constant = 5;
    self.locationLabelLeftConstraint.constant = 5;
    self.locationBottomWidthConstraint.constant = 5;
    
    [self.headerView setBackgroundColor:[UIColor clearColor]];
    [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.locationLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.BackBtn setImage:[UIImage imageNamed:@"profile_Backbtnheader.png"] forState:UIControlStateNormal];
    [self.settingBtn setImage:[[UIImage imageNamed:@"profile_settingheader.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.settingBtn setTintColor:filterHeadercolor];

//    [self.settingBtn setImage:[UIImage imageNamed:@"profile_settingheader.png"] forState:UIControlStateNormal];
    [self.MenuBtn setImage:[UIImage imageNamed:@"profile_Menuheader.png"] forState:UIControlStateNormal];
    [self.AlertBtn setImage:[UIImage imageNamed:@"profile_alertheader.png"] forState:UIControlStateNormal];
    
    [self.nameLabel setFont:[UIFont fontWithName:appFontBold size:15]];
    [self.locationLabel setFont:[UIFont fontWithName:appFontBold size:12]];
    
    [self.nameLabel setTextColor:headercolor];
    [self.locationLabel setTextColor:CommentDaysTextColor];
    
    [UIView transitionWithView:self.profileImageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.profileImageView setHidden:NO];
                    }
                    completion:NULL];
}

#pragma mark - Profile middle view

-(void) nameViewTopArrangeMent:(MXParallaxHeader *)parallaxHeader
{
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [UIView transitionWithView:self.profileImageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.profileImageView setHidden:YES];
                    }
                    completion:NULL];
    
    {
        if ([globaluserArray count]!=0)
        {
            if ([[[globaluserArray objectAtIndex:0]objectForKey:@"rating"]floatValue]==0)
            {
                [self hiderating];
            }
            else{
                [self.locationLabel setHidden:NO];
                [self.ratingView setHidden:YES];
                [self.ratingCountLabel setHidden:YES];
            }
        }
        else
        {
            [self.locationLabel setHidden:YES];
            [self.ratingView setHidden:YES];
            [self.ratingCountLabel setHidden:YES];
            
        }
        
    }

    self.nameLblWidth.constant=230;
    self.nameViewWidthConstraint.constant = 240;
    self.nameViewHeightConstraint.constant = 55;
    self.nameViewLeftConstraint.constant = (delegate.windowWidth-240)/2;
    [self.headerView setBackgroundColor:[UIColor clearColor]];
    self.namelabelTopConstraint.constant = 5;
    self.nameLabelLeftConstraint.constant = 5;
    self.locationLabelLeftConstraint.constant = 5;
    self.locationBottomWidthConstraint.constant =12;
    [self.BackBtn setImage:[UIImage imageNamed:@"profile_Backbtn.png"] forState:UIControlStateNormal];
    [self.settingBtn setImage:[UIImage imageNamed:@"profile_setting.png"] forState:UIControlStateNormal];
    [self.MenuBtn setImage:[UIImage imageNamed:@"profile_Menu.png"] forState:UIControlStateNormal];
    [self.AlertBtn setImage:[UIImage imageNamed:@"profile_alert.png"] forState:UIControlStateNormal];
    
    [self.nameLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [self.locationLabel setFont:[UIFont fontWithName:appFontBold size:14]];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.locationLabel setTextAlignment:NSTextAlignmentCenter];
    [self.nameLabel setTextColor:headercolor];
    [self.locationLabel setTextColor:CommentDaysTextColor];
    
    [UIView transitionWithView:self.profileImageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.profileImageView setHidden:NO];
                    }
                    completion:NULL];
}

#pragma mark - Hide verification view when scroll header

-(void) hidenVerification:(NSString*)headerH
{
    if ([headerH floatValue]==70)
    {
        [self.verifiedView setHidden:YES];
        self.imageLeftConstraint.constant = 40;
    }
    else
    {
        [self.verifiedView setHidden:NO];
    }
}

#pragma mark - Loading HeaderDetails

-(void) hiderating
{
    [self.ratingView setHidden:YES];
    [self.ratingCountLabel setHidden:YES];

}

-(void)loadProfileHeaderValues:(NSMutableArray*)userDetailarray tab:(NSString *) profileTab height:(float)headerH
{
    globaluserArray = [[NSMutableArray alloc] init];
    [globaluserArray addObjectsFromArray:userDetailarray];
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    profiletab=profileTab;
    [self.ratingView setHidden:YES];
    [self.ratingCountLabel setHidden:YES];

    if (follow)
    {
        //self.FollowBtn.layer.borderColor=AppThemeColor.CGColor;
        //[self.FollowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //[followimg setImage:[UIImage imageNamed:@"unFollow.png"]];
        [self.FollowBtn setImage:[UIImage imageNamed:@"following_red.png"] forState:UIControlStateNormal];
       // [self.FollowBtn setTitle:[delegate.languageDict objectForKey:@"unfollow"] forState:UIControlStateNormal];
        
    }
    else
    {
       
        //[self.FollowBtn setBackgroundColor:whitecolor];
       
        [self.FollowBtn setImage:[UIImage imageNamed:@"unFollow.png"] forState:UIControlStateNormal];
       
    }

    [_verifiedView setHidden:NO];
    if([globaluserArray count]!=0){
        [delegate.editProfileArray replaceObjectAtIndex:0 withObject:[[globaluserArray objectAtIndex:0]objectForKey:@"user_id"]];
        [delegate.editProfileArray replaceObjectAtIndex:1 withObject:[[globaluserArray objectAtIndex:0]objectForKey:@"full_name"]];
        [delegate.editProfileArray replaceObjectAtIndex:2 withObject:[[globaluserArray objectAtIndex:0]objectForKey:@"user_img"]];
        [delegate.editProfileArray replaceObjectAtIndex:3 withObject:[[globaluserArray objectAtIndex:0]objectForKey:@"facebook_id"]];
        [delegate.editProfileArray replaceObjectAtIndex:4 withObject:[[globaluserArray objectAtIndex:0]objectForKey:@"mobile_no"]];
        [self.nameLabel setText:[[globaluserArray objectAtIndex:0]objectForKey:@"full_name"]];
        [self.locationLabel setText:[[globaluserArray objectAtIndex:0]objectForKey:@"user_name"]];
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[globaluserArray objectAtIndex:0]objectForKey:@"user_img"]]]placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
        
        

    self.ratingView.emptySelectedImage = [[UIImage imageNamed:@"StarEmpty"] ez_tintedImageWithColor:graycolor];
        self.ratingView.fullSelectedImage = [[UIImage imageNamed:@"StarFull"] ez_tintedImageWithColor:Starcolor];

        self.ratingView.rating = [[[globaluserArray objectAtIndex:0]objectForKey:@"rating"]floatValue];
        [self.ratingCountLabel setText:[NSString stringWithFormat:@"(%@)",[[globaluserArray objectAtIndex:0]objectForKey:@"rating"]]];
        
        if ([[[globaluserArray objectAtIndex:0]objectForKey:@"rating"]floatValue]==0)
        {
            [self hiderating];
        }

        NSUserDefaults * defaultuser = [NSUserDefaults standardUserDefaults];
        @try
        {
            //userown profile tab id 4
            if([[[globaluserArray objectAtIndex:0]objectForKey:@"user_id"] isEqualToString:[defaultuser objectForKey:@"USERID"]] && delegate.tabID==4&& [profileTab isEqualToString:@"YES"]){
                [self.FollowBtn setHidden:YES];
//                [self.BackBtn setHidden:NO];
                [self.AlertBtn setHidden:YES];
                [self.settingBtn setHidden:NO];
                [self.MenuBtn setHidden:YES];
            }// for back button visible and follow button
            else if([[[globaluserArray objectAtIndex:0]objectForKey:@"user_id"] isEqualToString:[defaultuser objectForKey:@"USERID"]]){
                [self.FollowBtn setHidden:YES];
//                [self.BackBtn setHidden:NO];
                [self.AlertBtn setHidden:YES];
                [self.settingBtn setHidden:NO];
                [self.MenuBtn setHidden:YES];
            }//Other user profile
            else
            {
                [self.FollowBtn setHidden:NO];
                [self.FollowBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
                self.FollowBtn.tintColor=AppThemeColor;
//                [self.BackBtn setHidden:NO];
                [self.AlertBtn setHidden:YES];
                [self.settingBtn setHidden:YES];
                [self.MenuBtn setHidden:YES];
            }
        }
        @catch (NSException * e)
        {
            NSLog(@"Exception: %@", e);
            self.nameViewLeftConstraint.constant = 80;
            self.imageLeftConstraint.constant = 40;
        }
        if ([[[[[globaluserArray objectAtIndex:0]objectForKey:@"verification"]objectForKey:@"email"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [self.mailVerfiedImageView setImage:[UIImage imageNamed:@"mail-veri.png"]];
        }
        else
        {
            [self.mailVerfiedImageView setImage:[UIImage imageNamed:@"mail-unveri.png"]];
        }
        if ([[[[[globaluserArray objectAtIndex:0]objectForKey:@"verification"]objectForKey:@"facebook"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [self.faceBookVerifiedImageView setImage:[UIImage imageNamed:@"fac-veri.png"]];

        }
        else
        {
            [self.faceBookVerifiedImageView setImage:[UIImage imageNamed:@"fac-unveri.png"]];

        }
        if ([[[[[globaluserArray objectAtIndex:0]objectForKey:@"verification"]objectForKey:@"mob_no"]uppercaseString]isEqualToString:@"TRUE"])
        {
            [self.mobileVerifiedImageView setImage:[UIImage imageNamed:@"mob-veri.png"]];
        }
        else
        {
            [self.mobileVerifiedImageView setImage:[UIImage imageNamed:@"mob-unveri.png"]];
        }
        
        [self.ratingView setHidden:YES];
        [self.ratingCountLabel setHidden:YES];

    }
    else
    {
        if ([profileTab isEqualToString:@"YES"])
        {
            [self.FollowBtn setHidden:YES];
//            [self.BackBtn setHidden:NO];
            [self.AlertBtn setHidden:YES];
            [self.settingBtn setHidden:NO];
            [self.MenuBtn setHidden:YES];
            [self.mailVerfiedImageView setImage:[UIImage imageNamed:@"mail-unveri.png"]];
            [self.faceBookVerifiedImageView setImage:[UIImage imageNamed:@"fac-unveri.png"]];
            [self.mobileVerifiedImageView setImage:[UIImage imageNamed:@"mob-unveri.png"]];
        }
        else
        {
            [self.FollowBtn setHidden:YES];
//            [self.BackBtn setHidden:NO];
            [self.AlertBtn setHidden:YES];
            [self.settingBtn setHidden:YES];
            [self.MenuBtn setHidden:YES];
            [self.mailVerfiedImageView setImage:[UIImage imageNamed:@"mail-unveri.png"]];
            [self.faceBookVerifiedImageView setImage:[UIImage imageNamed:@"fac-unveri.png"]];
            [self.mobileVerifiedImageView setImage:[UIImage imageNamed:@"mob-unveri.png"]];
        }
    }
    [self performSelectorOnMainThread:@selector(hidenVerification:) withObject:[NSString stringWithFormat:@"%f",headerH] waitUntilDone:YES];
}

#pragma mark - follow and unfollow Button Tapped

-(void) updateFollowBtn:(BOOL)followerFlag
{
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    if (followerFlag)
    {
        follow = YES;
        //self.FollowBtn.layer.borderColor=AppThemeColor.CGColor;
       // [self.FollowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[self.FollowBtn setBackgroundColor:whitecolor];
        //[followimg setImage:[UIImage imageNamed:@"unFollow.png"]];
        [self.FollowBtn setImage:[UIImage imageNamed:@"following_red.png"] forState:UIControlStateNormal];


        //[self.FollowBtn setTitle:[delegate.languageDict objectForKey:@"unfollow"] forState:UIControlStateNormal];
    }
    else
    {
        follow = NO;
        //self.FollowBtn.layer.borderColor=AppThemeColor.CGColor;
      //  [self.FollowBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
       // [self.FollowBtn setBackgroundColor:whitecolor];
        [self.FollowBtn setImage:[UIImage imageNamed:@"unFollow.png"] forState:UIControlStateNormal];

       // [followimg setImage:[UIImage imageNamed:@"following.png"]];

       // [self.FollowBtn setTitle:[delegate.languageDict objectForKey:@"follow"] forState:UIControlStateNormal];
    }
}

- (IBAction)followBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(followBtnAction)])
    {
        [self.delegate followBtnAction];
    }
}

#pragma mark - show / hide in new profile page

-(void) sethiddenButtons
{
    [self.FollowBtn setHidden:YES];
//    [self.BackBtn setHidden:NO];
    [self.AlertBtn setHidden:YES];
    [self.settingBtn setHidden:YES];
    [self.MenuBtn setHidden:YES];
}

#pragma mark - ButtonAction

- (IBAction)BackBtnTapped:(id)sender
{
    AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    if (appdelegate.PromotionSuccessFlag) {
        
        UINavigationController * vc = [appdelegate.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:appdelegate.tabID];
           [vc popToRootViewControllerAnimated:NO];
        SideBarMenu * sideBarMenuObj = [[SideBarMenu alloc]initWithNibName:@"SideBarMenu" bundle:nil];
        [vc pushViewController:sideBarMenuObj animated:YES];
        appdelegate.PromotionSuccessFlag = NO;
        [sideBarMenuObj release];
        
    }
    else{
    if ([self.delegate respondsToSelector:@selector(backButtonTapped)]) {
        [self.delegate backButtonTapped];
    }
        
    }
}

-(void) reloadingHeaderFrame:(BOOL) loadingFull
{
    if ([self.delegate respondsToSelector:@selector(headerReloadingFrame)]) {
        [self.delegate headerReloadingFrame];
    }
}
- (IBAction)settingBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(settingButtonTapped)]) {
        [self.delegate settingButtonTapped];
    }
}


-(void)reviewBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(reviewBtnTapped)]) {
        [self.delegate reviewBtnTapped];
    }
}
- (IBAction)AlertBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(alertButtonTapped)]) {
        [self.delegate alertButtonTapped];
    }
}

- (IBAction)MenuBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(menuButtonTapped)]) {
        [self.delegate menuButtonTapped];
    }
}



-(void)animatingHeaderView
{
    pageNumber = -1;
}

- (void)dealloc {
    [_BackBtn release];
    [_settingBtn release];
    [_AlertBtn release];
    [_MenuBtn release];
    [_NavigationView release];
    [_navigationViewwidth release];
    [_FollowBtn release];
    [_mobileVerifiedImageView release];
    [_faceBookVerifiedImageView release];
    [_mailVerfiedImageView release];
    [super dealloc];
}

@end
