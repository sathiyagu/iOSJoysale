//
//  HTSCustomTabBar.m
//
//
//  Created by Hitasoft on 19/06/2010.
//  Copyright 2010 Hitasoft IT All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "HTSCustomTabBar.h"
#import "AppDelegate.h"
#import "TabViewController.h"
#import "PKImagePickerViewController.h"
#import "welcomeScreen.h"
#import "CategoryResult.h"


@implementation HTSCustomTabBar

@synthesize buttonOne,buttonTwo,buttonThree,buttonFour ,footerBackG,lineView;
@synthesize imagePicker,labelNoti,labelProfile;

-(void)viewDidLoad
{
    //Class Initialization
    theApp=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    self.imagePicker = [[PKImagePickerViewController alloc]init];
    [imagePicker.view setFrame:CGRectMake(0,0,theApp.windowWidth,theApp.windowHeight)];
    //Appearance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //function call
    [self hideTabBar];
    [self addCustomElements];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - show /  hide tabBar
- (void)hideTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}

- (void)hideNewTabBar
{
    [self.tabBarController.tabBar setHidden:YES];
    self.lineView.hidden = 1;
    self.buttonOne.hidden = 1;
    self.buttonTwo.hidden = 1;
    self.buttonThree.hidden = 1;
    self.buttonFour.hidden = 1;
    self.footerBackG.hidden = 1;
    self.labelNoti.hidden = 1;
    self.labelProfile.hidden = 1;

}
- (void)countUpdate
{
    if (!proxy)
    {
        proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    }
    [proxy getcountdetails:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];

}

- (void)showNewTabBar
{
    [self.tabBarController.tabBar setHidden:NO];
    self.lineView.hidden = 0;
    self.buttonOne.hidden = 0;
    self.buttonTwo.hidden = 0;
    self.buttonThree.hidden = 0;
    self.buttonFour.hidden = 0;
    self.footerBackG.hidden = 0;
    self.labelNoti.hidden = 0;
    self.labelProfile.hidden = 0;

}

#pragma mark - Customize tabBar

-(void)addCustomElements
{
    footerBackG = [[UIImageView alloc] init];
    [footerBackG setBackgroundColor:clearcolor];
    [footerBackG setFrame:CGRectMake(0,theApp.window.frame.size.height-55,theApp.window.frame.size.height, 55)];
    footerBackG.layer.borderColor=lineviewColor.CGColor;
    footerBackG.layer.borderWidth=0.3;
    [footerBackG setImage:[UIImage imageNamed:@"tabbarBg.png"]];
    [self.view addSubview:footerBackG];
    
    //Setup the button
    self.lineView = [[UIView alloc] init];
    self.buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonThree = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonFour = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonOne setImage:[UIImage imageNamed:@"tab_home.png"] forState:UIControlStateNormal];
    [buttonTwo setImage:[UIImage imageNamed:@"tab_category.png"] forState:UIControlStateNormal];
    [buttonThree setImage:[UIImage imageNamed:@"tab_camera.png"] forState:UIControlStateNormal];
    [buttonFour setImage:[UIImage imageNamed:@"tab_profile.png.png"] forState:UIControlStateNormal];
    
    [buttonOne.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [buttonTwo.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [buttonThree.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [buttonFour.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [buttonOne setSelected:true];
    [buttonOne setBackgroundColor:[UIColor clearColor]];
    [buttonTwo setBackgroundColor:[UIColor clearColor]];
    [buttonThree setBackgroundColor:[UIColor clearColor]];
    [buttonFour setBackgroundColor:[UIColor clearColor]];
    
    // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
    
    // Now we repeat the process for the other buttons
    
    [buttonOne setTag:0];
    [buttonTwo setTag:1];
    [buttonThree setTag:2];
    [buttonFour setTag:3];
    
    float yval = theApp.window.frame.size.height;
    float btnwidth=theApp.window.frame.size.width/4;
    buttonOne.frame = CGRectMake(0,yval-55, btnwidth, 55);
    buttonTwo.frame = CGRectMake(btnwidth, yval-55, btnwidth, 55);
    buttonThree.frame = CGRectMake(btnwidth*2, yval-55, btnwidth, 55);
    buttonFour.frame = CGRectMake(btnwidth*3, yval-55,btnwidth, 55);
    lineView.frame = CGRectMake(0, yval-55, theApp.window.frame.size.width, 0.5);
    
    buttonOne.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
    buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
    buttonThree.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
    buttonFour.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
    
    labelNoti = [[UILabel alloc] initWithFrame:CGRectMake(btnwidth*3.5, yval-53,20, 20)];
    labelNoti.backgroundColor = NameColor;
    labelNoti.layer.cornerRadius = 10;
    labelNoti.clipsToBounds = YES;
    labelNoti.textAlignment = NSTextAlignmentCenter;
    labelNoti.font = [UIFont fontWithName:@"Helvetica" size:12];
    labelNoti.textColor = [UIColor whiteColor];
    
    labelProfile = [[UILabel alloc] initWithFrame:CGRectMake(btnwidth*3.5, yval-53,20, 20)];
    labelProfile.backgroundColor = AppThemeColor;
    labelProfile.layer.cornerRadius = 10;
    labelProfile.clipsToBounds = YES;
    labelProfile.textAlignment = NSTextAlignmentCenter;
    labelProfile.font = [UIFont fontWithName:@"Helvetica" size:12];
    labelProfile.textColor = [UIColor whiteColor];
    lineView.backgroundColor = lineviewColor;

    [labelNoti setBackgroundColor:[UIColor clearColor]];
    [labelProfile  setBackgroundColor:[UIColor clearColor]];
    
//    NSLog(@"%@",theApp.)
    
    NSLog(@"CCCC:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]==NULL)
    {
//        labelNoti.text = @"!";
//        [labelNoti setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:18]];
        
        // theApp.ResultBool = NO;
    }
    else
    {
//        labelNoti.text = @"10";
//        labelProfile.text = @"9";

        [proxy getcountdetails:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];
        
        // theApp.ResultBool = YES;
    }


    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
    [buttonOne addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonThree addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonFour addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

//    self.tabBarController.tabBar.layer.borderWidth = 2;
//    self.tabBarController.tabBar.layer.borderColor = [UIColor blueColor].CGColor;
    
    // Add my new buttons to the view
    [self.view addSubview:buttonOne];
    [self.view addSubview:buttonTwo];
    [self.view addSubview:buttonThree];
    [self.view addSubview:buttonFour];
//    [self.view addSubview:labelNoti];
    [self.view addSubview:labelProfile];
    [self.view addSubview:lineView];
    [self selectTab:0];

    //Call App agreement if first time install it show otherwise skip
    [theApp addingWebSubView];
}



#pragma mark   WSDL DelegateMethod

//proxy finished, (id)data is the object of the relevant method service
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method
{
    
    NSLog(@"Exeption in service %@",method);
    @try
    {
        
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
    }
    
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    
    NSLog(@"Service %@ Done!",method);
    
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    
    [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    
    [theApp.countDetailDict removeAllObjects];
    [theApp.countDetailDict addEntriesFromDictionary:defaultDict];
    
    
    NSLog(@"Message Page Array :%@",defaultDict);
    
    
    NSString *strError = [NSString stringWithFormat:@"%@",[defaultDict objectForKey:@"status"]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]==NULL)
    {
        //labelNoti.hidden = NO;
        labelNoti.text = @"";
        [labelNoti setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:18]];
    }
    else
    {
        
        if([strError isEqualToString:@"true"])
        {
            NSString *chatCount = [NSString stringWithFormat:@"%@",[[defaultDict objectForKey:@"result"]objectForKey:@"chatCount"]];
            NSString *notificationCount = [NSString stringWithFormat:@"%@",[[defaultDict objectForKey:@"result"]objectForKey:@"notificationCount"]];

            
            if ([chatCount isEqualToString:@"0"])
            {
                labelNoti.backgroundColor = [UIColor clearColor];
                labelNoti.text =@"";
            }
            else
            {
                // labelNoti.hidden = NO;
                
                labelNoti.backgroundColor = NameColor;

                labelNoti.text = chatCount;

                
                [labelNoti setFont:[UIFont fontWithName:appFontBold size:12]];
                
                
            }
            
            if ([notificationCount isEqualToString:@"0"])
            {
                labelProfile.backgroundColor = [UIColor clearColor];
                labelProfile.text =@"";
            }
            else
            {
                // labelNoti.hidden = NO;
                
                labelProfile.backgroundColor = AppThemeColor;
                
                labelProfile.text = notificationCount;
                
                [labelProfile setFont:[UIFont fontWithName:appFontBold size:12]];
                
                
                
                
            }

            

            
            
        }
    }
    //    else if ([strError isEqualToString:@"false"])
    //    {
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!"
    //                                                        message:@"Something went wrong!"
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"OK"
    //                                              otherButtonTitles:nil];
    //
    //        [self.view endEditing:YES];
    //        
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //        [alert show];
    //        
    //    }
    
}


#pragma mark tabbar action

- (void)buttonClicked:(id)sender
{
    
    theApp.notificationredirectionFlag = NO;
    [theApp.imageCapturedArray removeAllObjects];
    [theApp.tabViewControllerObj.tabBarController showNewTabBar];
    
    [proxy getcountdetails:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];


    if ([theApp connectedToNetwork])
    {
        int tagNum = (int)[sender tag];
        if (tagNum!=2 && tagNum!=3 && tagNum!=4)
        {
            theApp.tabID = tagNum;
            [self selectTab:tagNum];
        }
        else
        {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]==NULL)
            {
                UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
                [self goToWelcomePage];
            }
            else if(tagNum==2)
            {
                theApp.editFlag = NO;
                theApp.editImageFlag=NO;
                [theApp.addProductPhotos removeAllObjects];
                UINavigationController * vc = [theApp.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:theApp.tabID];
                [vc pushViewController:self.imagePicker animated:NO];
            }
            else
            {
                theApp.tabID = tagNum;
                [self selectTab:tagNum];
            }
        }
    }
    else
    {
        [theApp networkError];
    }
}

- (void)selectTab:(int)tabID
{
    [buttonOne setImage:[UIImage imageNamed:@"tab_home.png"] forState:UIControlStateNormal];
    [buttonTwo setImage:[UIImage imageNamed:@"tab_category.png"] forState:UIControlStateNormal];
    [buttonThree setImage:[UIImage imageNamed:@"tab_camera.png"] forState:UIControlStateNormal];
    [buttonFour setImage:[UIImage imageNamed:@"tab_profile.png.png"] forState:UIControlStateNormal];
    
    switch(tabID)
    {
        case 0:
        {
            
            [theApp.tabViewControllerObj poptoHomeNavi];
            [buttonOne setImage:[UIImage imageNamed:@"tab_home_sel.png"] forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            [buttonTwo setImage:[UIImage imageNamed:@"tab_category_sel.png"] forState:UIControlStateNormal];
//            if([theApp.CategoryTabbed isEqualToString:@"Category"])
//            {
//                [theApp.tabViewControllerObj poptoCategoryNavi];
//            }else{
//                [self goToCatResultPage];
//            }
            [theApp.tabViewControllerObj poptoCategoryNavi];

            break;
        }
        case 2:
        {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]==NULL)
            {
                UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
                [self goToWelcomePage];
            }
            else
            {
                [buttonThree setImage:[UIImage imageNamed:@"tab_camera_sel.png"] forState:UIControlStateNormal];
            }
            break;
        }
        case 3:
        {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]==NULL)
            {
                UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                    statusBar.backgroundColor = AppThemeColor;
                }
                [self goToWelcomePage];
            }
            else
            {
                
                [theApp.tabViewControllerObj poptoProfileNavi];
                [buttonFour setImage:[UIImage imageNamed:@"tab_profile_sel.png"] forState:UIControlStateNormal];
            }
            break;
        }
        
    }
    self.selectedIndex = tabID;
}


#pragma mark Redirect to Welcome Page
-(void) goToWelcomePage
{
//    UINavigationController * vc = [theApp.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:theApp.tabID];
//    [vc popToRootViewControllerAnimated:NO];
   
    welcomeScreen*firstpageObj=[[welcomeScreen alloc]initWithNibName:@"welcomeScreen" bundle:nil];
    [firstpageObj setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
       // [self presentModalViewController:firstpageObj animated:YES];
  [self.view.window.rootViewController presentViewController:firstpageObj animated:YES completion:nil];
    
    
  // [vc pushViewController:firstpageObj animated:NO];
    //[firstpageObj release];
    

}
#pragma mark Redirect to categoryResult Page
-(void) goToCatResultPage
{
    UINavigationController * vc = [theApp.tabViewControllerObj.tabBarController.viewControllers objectAtIndex:theApp.tabID];
    [vc popToRootViewControllerAnimated:NO];
    CategoryResult*firstpageObj=[[CategoryResult alloc]initWithNibName:@"CategoryResult" bundle:nil];
    [vc pushViewController:firstpageObj animated:NO];
    [firstpageObj release];
}

#pragma mark - Dealloc


- (void)dealloc {
    [buttonOne release];
    [buttonTwo release];
    [buttonThree release];
    [buttonFour release];
    [footerBackG release];
    [labelNoti release];
    [labelProfile release];

    [super dealloc];
}



@end
