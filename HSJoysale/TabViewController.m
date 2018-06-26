//
//  TabViewController.m
//  JwellShop
//
//  Created by ixmmac5 on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabViewController.h"
#import "AppDelegate.h"
#import "HomePage.h"
#import "CategoryTab.h"
#import "AddProductDetails.h"
#import "NotificationPage.h"
#import "NewProfilePage.h"
#import "SideBarMenu.h"
#import "NotificationPage.h"

@implementation TabViewController
@synthesize tabBarController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Appearance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];
    
    //Class Declaration
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomePage *homePageObj = [[HomePage alloc]init];
    NotificationPage *notificationPageObj = [[NotificationPage alloc]initWithNibName:@"NotificationPage" bundle:nil];
//    NewProfilePage *profilePageObj = [[NewProfilePage alloc]initWithNibName:@"NewProfilePage" bundle:nil];
    
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
   
    
    SideBarMenu * sideBarMenuObj = [[SideBarMenu alloc]initWithNibName:@"SideBarMenu" bundle:nil];
    
    CategoryTab *CategoryTabObj = [[CategoryTab alloc]initWithNibName:@"CategoryTab" bundle:nil];
    AddProductDetails *addproductpage = [[AddProductDetails alloc]initWithNibName:@"AddProductDetails" bundle:nil];

    homeNavi = [[AHKNavigationController alloc] initWithRootViewController:homePageObj];
    notificationNavi = [[AHKNavigationController alloc] initWithRootViewController:notificationPageObj];
    addProductNavi = [[AHKNavigationController alloc] initWithRootViewController:addproductpage];
    profileNavi = [[AHKNavigationController alloc] initWithRootViewController:sideBarMenuObj];
    CategoryNavi = [[AHKNavigationController alloc] initWithRootViewController:CategoryTabObj];
    
    [homeNavi.navigationBar setBarTintColor:AppThemeColor];
    [homeNavi.navigationBar setTranslucent:NO];
    [notificationNavi.navigationBar setBarTintColor:AppThemeColor];
    [notificationNavi.navigationBar setTranslucent:NO];
    
    [addProductNavi.navigationBar setBarTintColor:AppThemeColor];
    [addProductNavi.navigationBar setTranslucent:NO];
    [profileNavi.navigationBar setBarTintColor:AppThemeColor];
    [profileNavi.navigationBar setTranslucent:NO];
    
    [CategoryNavi.navigationBar setBarTintColor:AppThemeColor];
    [CategoryNavi.navigationBar setTranslucent:NO];
    
    NSArray *temp = [[NSArray alloc] initWithObjects:homeNavi,CategoryNavi,addProductNavi,profileNavi, nil];
    [tabBarController setViewControllers:temp animated:YES];
    [tabBarController setDelegate:self];
    [tabBarController.view setFrame:CGRectMake(0,0, delegate.windowWidth, delegate.windowHeight)];
    [self.view addSubview:tabBarController.view];
    
    self.tabBarController.tabBar.layer.borderWidth = 2;
    self.tabBarController.tabBar.layer.borderColor = [UIColor blueColor].CGColor;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - Redirection

#pragma mark homePage
-(void) poptoHomeNavi
{
    [homeNavi popToRootViewControllerAnimated:NO];
}

#pragma mark CategoryPage
-(void) poptoCategoryNavi
{
    [CategoryNavi popToRootViewControllerAnimated:NO];
}

#pragma mark messagePage
-(void) poptoMessageNavi
{
    [notificationNavi popToRootViewControllerAnimated:NO];
}

#pragma mark profilePage
-(void) poptoProfileNavi
{
    [profileNavi popToRootViewControllerAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}
@end
