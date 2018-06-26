//
//  SideBarMenu.h
//  HSJoysale
//
//  Created by BTMani on 28/11/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KOPopupView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "TPFloatRatingView.h"
@interface SideBarMenu : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,Wsdl2CodeProxyDelegate,MFMailComposeViewControllerDelegate,FBSDKAppInviteDialogDelegate,TPFloatRatingViewDelegate>
{
    IBOutlet UITableView * sideMenuTable;
    AppDelegate * delegate;
    NSMutableArray * sideMenuArray,*userDetailArray;
    ApiControllerServiceProxy *proxy;
    UIView * moreViewPopup;
    

}
@property (nonatomic, strong) KOPopupView *popup;
@end
