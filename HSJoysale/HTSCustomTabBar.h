//
//  HTSCustomTabBar.h
//  
//
//  Created by Hitasoft on 19/06/2010.
//  Copyright 2010 Hitasoft IT All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class PKImagePickerViewController;

@interface HTSCustomTabBar : UITabBarController<UINavigationControllerDelegate, UIAlertViewDelegate,UIImagePickerControllerDelegate,
UINavigationBarDelegate,Wsdl2CodeProxyDelegate> {
    
    //Class Declaration
    AppDelegate *theApp;
    
    //UI Declaration
    UIButton *buttonOne;
	UIButton *buttonTwo;
	UIButton *buttonThree;
	UIButton *buttonFour;
    UIImageView *footerBackG;
    UIView * lineView;
    ApiControllerServiceProxy *proxy;

}
@property (nonatomic, strong) PKImagePickerViewController *imagePicker;
@property (nonatomic, retain) UIButton *buttonOne;
@property (nonatomic, retain) UIButton *buttonTwo;
@property (nonatomic, retain) UIButton *buttonThree;
@property (nonatomic, retain) UIButton *buttonFour;
@property (nonatomic, retain) UIImageView *footerBackG;
@property (nonatomic, retain) UILabel * labelNoti;
@property (nonatomic, retain) UILabel * labelProfile;
@property (nonatomic, retain) UIView * lineView;

- (void)hideTabBar;
- (void)addCustomElements;
- (void)selectTab:(int)tabID;
- (void)hideNewTabBar;
- (void)showNewTabBar;
- (void)countUpdate;
@end
