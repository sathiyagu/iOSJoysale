//
//  NewProfilePage.h
//  HSJoysale
//
//  Created by BTMani on 23/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSegmentedPagerController.h"
#import "KOPopupView.h"
#import "ProfilePageHeader.h"
#import "MyListingPage.h"
#import "LikeProducts.h"
#import "Followers.h"
#import "following.h"
@class AppDelegate;

@interface NewProfilePage : MXSegmentedPagerController<ProfilePageHeaderProtocols,Wsdl2CodeProxyDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    //Class Declaration
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;
    MXParallaxHeader * header;
    ProfilePageHeader * profilepageHeaderView;
    ProfilePageHeader * profileHeader;
    MyListingPage * myListingPageObj;
    LikeProducts * myLikesPageObj;
    Followers * followerPageObj;
    following * followingPageObj;
    
    //Variable Declaration
    NSMutableArray * sectionHeaderArray;
    NSMutableArray * userIDValue;
    NSMutableArray * userDetailsArray;
    NSString * profileTab;
    float headerheight;
    BOOL errorFlag;
    
    //UI Declaration
    UIView * MoreViewPopup;
}

@property (nonatomic, strong) KOPopupView *popup;
-(void) loadingOtherUserData:(NSString *) userId :(NSString *) ProfileTab;
@end
