//
//  ProfilePageHeader.h
//  HSJoysale
//
//  Created by BTMani on 23/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"

@protocol ProfilePageHeaderProtocols<NSObject>

-(void) alertButtonTapped;
-(void) settingButtonTapped;
-(void) menuButtonTapped;
-(void) backButtonTapped;
-(void)reviewBtnTapped;
-(void) headerReloadingFrame;
-(void) followBtnAction;

@end

@interface ProfilePageHeader : UIView
{
    MXParallaxHeader * header;
    
    //Provide User information to UI
    NSMutableArray * globaluserArray;
    
    UIButton *reviewBtn;
    
    //To check own profile or other profile
    NSString * profiletab;
    BOOL headerFlag;
    int pageNumber;
    UIImageView *followimg;
}



@property (nonatomic,strong)id<ProfilePageHeaderProtocols> delegate;

//Program mark Constraint for adding animation
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *imageLeftConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *nameViewToptConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *nameViewHeightConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *nameViewWidthConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *nameViewLeftConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *namelabelTopConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *locationLabelLeftConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *locationBottomWidthConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *verifiedViewLeftConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *verifiedViewWidthConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *headerViewWidthConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *alertButtonLeadingConstrain;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *settingButtonLeadingConstrain;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *navHeaderHeightConstraint;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *followButtonLeftConstraint;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *navigationViewwidth;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *nameLblWidth;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *locationLblWidth;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *ratingViewWidth;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *backbtnTopConstrain;

@property (retain, nonatomic) IBOutlet UIButton *BackBtn;
@property (retain, nonatomic) IBOutlet UIButton *settingBtn;
@property (retain, nonatomic) IBOutlet UIButton *AlertBtn;
@property (retain, nonatomic) IBOutlet UIButton *MenuBtn;
@property (retain, nonatomic) IBOutlet UIButton *FollowBtn;

@property (nonatomic,strong) IBOutlet UILabel * nameLabel;
@property (nonatomic,strong) IBOutlet UILabel * locationLabel;
@property (nonatomic,strong) IBOutlet TPFloatRatingView * ratingView;
@property (nonatomic,strong) IBOutlet UILabel * ratingCountLabel;

@property (retain, nonatomic) IBOutlet UIImageView *mobileVerifiedImageView;
@property (retain, nonatomic) IBOutlet UIImageView *faceBookVerifiedImageView;
@property (retain, nonatomic) IBOutlet UIImageView *mailVerfiedImageView;
@property (nonatomic,strong) IBOutlet UIImageView * profileImageView;

@property (retain, nonatomic) IBOutlet UIView *NavigationView;
@property (retain, nonatomic) IBOutlet UIView *bottomLineView;
@property (nonatomic,strong) IBOutlet UIView * MoreViewPopup;
@property (nonatomic,strong) IBOutlet UIView * headerView;
@property (nonatomic,strong) IBOutlet UIView * verifiedView;

- (IBAction)BackBtnTapped:(id)sender;
- (IBAction)settingBtnTapped:(id)sender;
- (IBAction)reviewBtnTapped:(id)sender;
- (IBAction)AlertBtnTapped:(id)sender;
- (IBAction)MenuBtnTapped:(id)sender;

+ (instancetype)instantiateFromNib;

-(void)loadProfileHeaderValues:(NSMutableArray*)userDetailarray tab:(NSString *) profileTab height:(float)headerH;
-(void)animatingHeaderView;
-(void) sethiddenButtons;
-(void) updateFollowBtn:(BOOL)followerFlag;
-(void) hiderating;


@end
