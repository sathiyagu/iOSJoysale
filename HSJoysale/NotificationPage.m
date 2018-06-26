//
//  NotificationPage.m
//  HSJoysale
//
//  Created by BTMANI on 16/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import "NotificationPage.h"
#import "AppDelegate.h"
#import "UIImage+FontAwesome.h"
#import "ItemDetailPage.h"
#import "NSDate+DateMath.h"
@interface NotificationPage ()

@property  NSArray* dataList;

@end

@implementation NotificationPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    //initialization

    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    refreshControl = [[UIRefreshControl alloc]init];
    loadingErrorViewBG = [[UIView alloc]init];
    itemDetailArray = [NSMutableArray new];
    notificationArray = [[NSMutableArray alloc]initWithCapacity:0];

    //Appearance
    
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];

    //Properties
    

    CustomInfiniteIndicator *indicator = [[[CustomInfiniteIndicator alloc] initWithFrame:CGRectMake(0, 0, 24, 24)] autorelease];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [notificationTable addSubview:refreshControl];
    notificationTable.alwaysBounceVertical = YES;
    [notificationTable setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-115)];
    notificationTable.infiniteScrollIndicatorView = indicator;
    notificationTable.infiniteScrollIndicatorMargin = 40;
    
    //Function call
    [self noItemFindFunction];
    [self barButtonFunction];
    [self loadingIndicator];
    [self loadnotification];
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    [super viewDidLoad];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    //appearance
    [self setNeedsStatusBarAppearanceUpdate];
    [delegate.tabViewControllerObj.tabBarController performSelectorOnMainThread:@selector(countUpdate) withObject:nil waitUntilDone:YES];


    activeSelect=YES;
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
}



#pragma mark - If no data in parsing it show alert

-(void) noItemFindFunction
{
    loadingErrorViewBG.frame = CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];
    
    UIImageView *loadingErrorImageView = [[UIImageView alloc]init];
    loadingErrorImageView.frame = CGRectMake(delegate.windowWidth/2-100, delegate.windowHeight/2-150, 200, 150);
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
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"nonotificationfound"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    
    [notificationTable addSubview:loadingErrorViewBG];
}

#pragma mark  show and hide noitemfound

-(void)checkIfhavsData
{
    if ([notificationArray count]==0)
    {
        [loadingErrorViewBG setHidden:NO];
    }
    else
    {
        [loadingErrorViewBG setHidden:YES];
    }
}
#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    _multiColorLoader=[[BLMultiColorLoader alloc]init];
    _multiColorLoader.lineWidth = 4.0;
    _multiColorLoader.colorArray = [NSArray arrayWithObjects:AppThemeColor, nil];
    [_multiColorLoader setFrame:CGRectMake((delegate.windowWidth/2)-15, (delegate.windowHeight-150)/2, 30, 30)];
    [_multiColorLoader startAnimation];
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
    [self.view addSubview:_multiColorLoader];
}

-(void) startLoadig
{
    [_multiColorLoader setHidden:NO];
    [_multiColorLoader startAnimation];
}

-(void) stopLoading
{
    [_multiColorLoader setHidden:YES];
    [_multiColorLoader stopAnimation];
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
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setTag:1000];
    [backBtn setFrame:CGRectMake(0+[HSUtility adjustablePadding],2,45,40)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:backBtn];
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"notifications"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [leftNaviNaviButtonView addSubview:titleLabel];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark back Button action

-(void)backBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString * username=@"";
        NSString * content=@"";
        NSString * message=@"";
        NSString *temp=@"";
        if ([[notificationArray objectAtIndex:indexPath.row] objectForKey:@"user_name"]!=NULL)
        {
            username=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"user_name"];
        }
        if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"admin"]){
            username=AppName;
            content=[delegate.languageDict objectForKey:@"a_post"];
            message=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"adminpayment"]){
            username=AppName;
            message=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"like"]){
            content=[delegate.languageDict objectForKey:@"liked_your_product"];
            
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            
            message=tittleattributedString.string;
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"add"]){
            if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"]  isEqualToString:@"added a product"]){
                content=[delegate.languageDict objectForKey:@"addedProduct"];
            }
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];
            
            
            message=tittleattributedString.string;

        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"follow"]){
            content=[delegate.languageDict objectForKey:@"start_following_you"];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"myoffer"]){
            if([[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] uppercaseString] isEqualToString:@"CONTACTED YOU ON YOUR PRODUCT"]){
                content = [delegate.languageDict objectForKey:@"contacted_you_on_your_product"];
            }else {
                NSString *amount = [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"sent offer request " withString:@""];
                amount = [amount stringByReplacingOccurrencesOfString:@"on your product" withString:@""];
                
                content = [NSString stringWithFormat:@"%@ %@ %@",[delegate.languageDict objectForKey:@"sent_offer_request"],amount,[delegate.languageDict objectForKey:@"on_your_product"]];
            }
            //  content=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            
            message=[NSString stringWithFormat:@"%@ %@ %@",tittleattributedString.string,[delegate.languageDict objectForKey:@"for Request Price"],[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"request_price"]];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"promotion_active"]){
            username=@"";
            content=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
            message=[NSString stringWithFormat:@"%@ for %@",[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"paid_amount"],[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"promotion_days"]];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"promotion_expired"]){
            username=@"";
            content=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            message=[NSString stringWithFormat:@"%@ on %@",tittleattributedString.string,[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"expire_date"]];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"exchange"]){
            if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"declined your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"declined_your_exchange_request_on"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"successed your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"successed_your_exchange_request_on"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"accepted your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"accepted_your_exchange_request_on"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"canceled your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"canceled_your_exchange_request_on"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"sent exchange request to your product"]){
                content=[delegate.languageDict objectForKey:@"sent_exchange_request_to_your_product"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"failed your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"failed_your_exchange_request_on"];
            }
            
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            message=[NSString stringWithFormat:@"%@",tittleattributedString.string];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"comment"]){
            content=[delegate.languageDict objectForKey:@"comment_on_your_product"];
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            message=[NSString stringWithFormat:@"%@",tittleattributedString.string];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"order"]){
            NSString * orderid = @"";
            if ([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"added tracking details for your order. Order Id :"].location != NSNotFound) {
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"added tracking details for your order. Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"added tracking details for your order. Order Id : "],orderid];
            }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"your order has been cancelled Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"your order has been cancelled Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"your order has been cancelled Order Id :"],orderid];
            }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"has marked your order as delivered. Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"has marked your order as delivered. Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"has marked your order as delivered. Order Id :"],orderid];
                //
            }
            else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"your order has been marked as delivered Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"your order has been marked as delivered Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"your order has been marked as delivered Order Id :"],orderid];
            }
            else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"your order has been marked as shipped Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"your order has been marked as shipped Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"your order has been marked as shipped Order Id :"],orderid];
            }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"your order has been marked as processing Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"your order has been marked as processing Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"your order has been marked as processing Order Id :"],orderid];
            }
            else {
                content=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
            }
            
            
            if(![[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] isEqualToString:@"Json Error"]){
                content=[content stringByAppendingString:@" "];
                content=[content stringByAppendingString:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
            }
        }
        //    content = [delegate.languageDict objectForKey:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"]];
        
        temp=[temp stringByAppendingString:username];
        temp=[temp stringByAppendingString:@" "];
        temp=[temp stringByAppendingString:content];
        temp=[temp stringByAppendingString:@" "];
        temp=[temp stringByAppendingString:message];
        
        
        NSString * labelTxt=temp;
        
        CGRect textRect = [labelTxt boundingRectWithSize: CGSizeMake(delegate.windowWidth-120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:appFontRegular size:16]} context:nil];
        
        if(textRect.size.height>20){
            if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"admin"] || [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"adminpayment"] || [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"order"]){
                return textRect.size.height+50;
            }
        }
        return 85;

        

    } @catch (NSException *exception) {
        return 85;

    } @finally {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notificationArray count];
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
    cell.selectionStyle = NO;
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    UIView * contentview = [[[UIView alloc]init]autorelease];
    [contentview setBackgroundColor:whitecolor];
    [contentview setFrame:CGRectMake(0,0,delegate.windowWidth,80)];
    
    
    UIImageView *userImageView = [[[UIImageView alloc] init] autorelease];
    [userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"user_image"]]] placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
    [userImageView setTag:[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"user_id"]intValue]];
    
    if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"admin"]){
        
    }else{
        UITapGestureRecognizer *usergesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usergesterAction:)];
        [usergesture setNumberOfTapsRequired:1];
        [userImageView addGestureRecognizer:usergesture];
        [userImageView setUserInteractionEnabled:YES];
        
    }
    
    NSString * username=@"";
    NSString * content=@"";
    NSString * message=@"";
    NSString *temp=@"";
    
    @try {
        if ([[notificationArray objectAtIndex:indexPath.row] objectForKey:@"user_name"]!=NULL)
        {
            username=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"user_name"];
        }
        if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"admin"]){
            username=AppName;
            content=[delegate.languageDict objectForKey:@"a_post"];
            message=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"adminpayment"]){
            username=AppName;
            message=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"like"]){
            content=[delegate.languageDict objectForKey:@"liked_your_product"];
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            message=tittleattributedString.string;
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"add"]){
            if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"]  isEqualToString:@"added a product"]){
                content=[delegate.languageDict objectForKey:@"addedProduct"];
            }
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            message=tittleattributedString.string;
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"follow"]){
            content=[delegate.languageDict objectForKey:@"start_following_you"];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"myoffer"]){
            if([[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] uppercaseString] isEqualToString:@"CONTACTED YOU ON YOUR PRODUCT"]){
                content = [delegate.languageDict objectForKey:@"contacted_you_on_your_product"];
            }else {
                NSString *amount = [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"sent offer request " withString:@""];
                amount = [amount stringByReplacingOccurrencesOfString:@"on your product" withString:@""];
                
                content = [NSString stringWithFormat:@"%@ %@ %@",[delegate.languageDict objectForKey:@"sent_offer_request"],amount,[delegate.languageDict objectForKey:@"on_your_product"]];
            }
            //  content=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            message=[NSString stringWithFormat:@"%@ %@ %@",tittleattributedString.string,[delegate.languageDict objectForKey:@"for Request Price"],[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"request_price"]];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"promotion_active"]){
            username=@"";
            content=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
            message=[NSString stringWithFormat:@"%@ for %@",[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"paid_amount"],[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"promotion_days"]];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"promotion_expired"]){
            username=@"";
            content=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            message=[NSString stringWithFormat:@"%@ on %@",tittleattributedString.string,[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"expire_date"]];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"exchange"]){
            if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"declined your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"declined_your_exchange_request_on"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"successed your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"successed_your_exchange_request_on"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"accepted your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"accepted_your_exchange_request_on"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"canceled your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"canceled_your_exchange_request_on"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"sent exchange request to your product"]){
                content=[delegate.languageDict objectForKey:@"sent_exchange_request_to_your_product"];
            }else  if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] isEqualToString:@"failed your exchange request on"]){
                content=[delegate.languageDict objectForKey:@"failed_your_exchange_request_on"];
            }
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];


            message=[NSString stringWithFormat:@"%@",tittleattributedString.string];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"comment"]){
            content=[delegate.languageDict objectForKey:@"comment_on_your_product"];
            NSAttributedString *tittleattributedString = [[NSAttributedString alloc]
                                                          initWithData: [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                          documentAttributes: nil
                                                          error: nil
                                                          ];

            message=[NSString stringWithFormat:@"%@",tittleattributedString.string];
        }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"order"]){
            NSString * orderid = @"";
            if ([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"added tracking details for your order. Order Id :"].location != NSNotFound) {
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"added tracking details for your order. Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"added tracking details for your order. Order Id : "],orderid];
            }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"your order has been cancelled Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"your order has been cancelled Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"your order has been cancelled Order Id :"],orderid];
            }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"has marked your order as delivered. Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"has marked your order as delivered. Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"has marked your order as delivered. Order Id :"],orderid];
                //
            }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"your order has been marked as delivered Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"your order has been marked as delivered Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"your order has been marked as delivered Order Id :"],orderid];
            }
            else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"your order has been marked as shipped Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"your order has been marked as shipped Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"your order has been marked as shipped Order Id :"],orderid];
            }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] rangeOfString:@"your order has been marked as processing Order Id :"].location != NSNotFound){
                orderid =[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"your order has been marked as processing Order Id :" withString:@""];
                content = [NSString stringWithFormat:@"%@ %@",[delegate.languageDict objectForKey:@"your order has been marked as processing Order Id :"],orderid];
            }
            else {
                content=[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"];
            }
            
            
            if(![[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"] isEqualToString:@"Json Error"]){
                content=[content stringByAppendingString:@" "];
                content=[content stringByAppendingString:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_title"]];
            }
        }
//        content = [delegate.languageDict objectForKey:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"message"]];
        
        temp=[temp stringByAppendingString:username];
        temp=[temp stringByAppendingString:@" "];
        temp=[temp stringByAppendingString:content];
        temp=[temp stringByAppendingString:@" "];
        temp=[temp stringByAppendingString:message];
        
        
        NSString * labelTxt=temp;
        
        [userImageView setContentMode:UIViewContentModeScaleAspectFill];
        [userImageView setFrame:CGRectMake(10, 10, 55, 55)];
        userImageView.layer.cornerRadius=27.5;
        userImageView.layer.masksToBounds=YES;
        [userImageView setBackgroundColor:AppThemeColor];
        [contentview addSubview:userImageView];
        
        
        UILabel * contentLabel = [[[UILabel alloc] init] autorelease];
        [contentLabel setTextColor:filterHeadercolor];
        [contentLabel setNumberOfLines:2];
        [contentLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
        [contentview addSubview:contentLabel];
        
        CGRect textRect = [labelTxt boundingRectWithSize: CGSizeMake(delegate.windowWidth-120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:appFontRegular size:16]} context:nil];
        
        if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"admin"] || [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"adminpayment"] || [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"order"]){
            textRect = [labelTxt boundingRectWithSize: CGSizeMake(delegate.windowWidth-120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:appFontRegular size:16]} context:nil];

        }
        NSString * myString =labelTxt;
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:myString];
        NSRange range = [myString rangeOfString:username];
        NSRange rangeg = [myString rangeOfString:content];
        NSRange rangeb = [myString rangeOfString:message];
        [string addAttribute:NSForegroundColorAttributeName value:NameColor range:range];
        [string addAttribute:NSForegroundColorAttributeName value:filterHeadercolor range:rangeg];
        [string addAttribute:NSForegroundColorAttributeName value:headercolor range:rangeb];
        contentLabel.attributedText = string;
        [contentLabel sizeToFit];
        
        if(textRect.size.height>20){
            if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"admin"] || [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"adminpayment"] ||[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"order"]){
                [contentLabel setNumberOfLines:0];

        [contentLabel setFrame:CGRectMake(75, 10, delegate.windowWidth-120, textRect.size.height)];
            }else{
        [contentLabel setFrame:CGRectMake(75, 10, delegate.windowWidth-120,40)];
            }
        }else{
            [contentLabel setFrame:CGRectMake(75, 10, delegate.windowWidth-120, 20)];
        }
        
        UILabel * dateLabel = [[[UILabel alloc] init] autorelease];
        [dateLabel setFrame:CGRectMake(75, contentLabel.frame.origin.y+5+contentLabel.frame.size.height, delegate.windowWidth-90, 20)];
        [dateLabel setTextColor:filterHeadercolor];
        [dateLabel setNumberOfLines:2];
        [dateLabel setFont:[UIFont fontWithName:appFontRegular size:15]];
        

        [dateLabel setText:[self Changemonth:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"event_time"]]];

        
       // [dateLabel setText:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"event_time"]]];
        [contentview addSubview:dateLabel];
        if(textRect.size.height>20){
            if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"admin"] || [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"adminpayment"] || [[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"order"]){
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth,contentLabel.frame.origin.y+5+contentLabel.frame.size.height+30)];
            }
        }
        UIImageView *arrowImg = [[[UIImageView alloc] init] autorelease];
        [arrowImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
        [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
        [arrowImg setFrame:CGRectMake(delegate.windowWidth-35, 25, 20, 20)];
        if (![[[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"]uppercaseString] isEqualToString:@"ADMIN"] && ![[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"adminpayment"] && ![[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"order"])
        {
            [contentview addSubview:arrowImg];
        }
        
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [contentLabel setTextAlignment:NSTextAlignmentRight];
            [dateLabel setTextAlignment:NSTextAlignmentRight];
            [userImageView setFrame:CGRectMake(delegate.windowWidth-65, 10, 55, 55)];
            [contentLabel setFrame:CGRectMake(50, 10, delegate.windowWidth-120, contentLabel.frame.size.height)];
             [dateLabel setFrame:CGRectMake(50, contentLabel.frame.origin.y+5+contentLabel.frame.size.height, delegate.windowWidth-120, 20)];
            [arrowImg setFrame:CGRectMake(10, 25, 20, 20)];
            [arrowImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];

        }
        [cell.contentView addSubview:contentview];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return cell;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(activeSelect){
        activeSelect=NO;
    if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"admin"])
    {
        activeSelect=YES;
    }
    else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"adminpayment"])
    {
            activeSelect=YES;
    }
    else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"add"])
    {
        [self productDetaiPageNavigation:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_id"]];
    }

    else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"like"])
    {
        [self productDetaiPageNavigation:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_id"]];
    }
    else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"follow"])
    {
        [self userDetailPageNavigation:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"user_id"]];
    }
    else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"myoffer"])
    {
        [self messagePageRedirection];
    }
    else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"promotion"])
    {
        [self productDetaiPageNavigation:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_id"]];
    }
    else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"promotion"])
    {
        [self productDetaiPageNavigation:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_id"]];
    }
   
    else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"comment"])
    {
        [self productDetaiPageNavigation:[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"item_id"]];
    }else if([[[notificationArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"order"]){
    }
    }
}

#pragma mark - send Request Proxy

#pragma mark load notification data
-(void) loadnotification{
    [notificationArray removeAllObjects];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        [notificationArray removeAllObjects];
        [proxy notification:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@"0" :@"20"];
    }
}
#pragma mark  pulltoRefresh and loadmore ParsingFunction

- (void)refreshTable
{
    [notificationArray removeAllObjects];
    [notificationTable reloadData];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        [proxy notification:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@"0" :@"20"];
    }
}

- (void)bottomrefreshTable:(void(^)(void))completion
{
    if([notificationArray count]%20 == 0 && [notificationArray count]>=20)
    {
        if ([delegate connectedToNetwork] == NO)
        {
            [delegate networkError];
        }else{
            [proxy notification:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[NSString stringWithFormat:@"%d",(int)[notificationArray count]] :@"20"];
        }
    }
    if(completion) {
        completion();
    }
    
}
#pragma mark load particular product data
-(void)productDetaiPageNavigation:(NSString*)itemId
{
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        [proxy searchbyitem:apiusername :apipassword :itemId :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]];
    }
}

#pragma mark - Redirection

#pragma mark  Redirect to itemDetail
-(void) pageRedirection
{
    int tag =0;
    int viewCount =[[[itemDetailArray objectAtIndex:tag]objectForKey:@"views_count"]intValue];
    viewCount = viewCount+1;
    
    if ([NSString stringWithFormat:@"%d",viewCount] != (NSString*)[NSNull null])
    {
        if ([[itemDetailArray objectAtIndex:tag]isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict addEntriesFromDictionary:[itemDetailArray objectAtIndex:tag]];
            [dict setObject:[NSString stringWithFormat:@"%d",viewCount] forKey:@"views_count"];
            [itemDetailArray replaceObjectAtIndex:tag withObject:dict];
            [dict release];

        }
    }
    ItemDetailPage * itemDetailPageObj = [[ItemDetailPage alloc]initWithNibName:@"ItemDetailPage" bundle:nil];
    [itemDetailPageObj detailPageArray:itemDetailArray selectedIndex:tag];
    [self.navigationController pushViewController:itemDetailPageObj animated:YES];
    [itemDetailPageObj release];
}

#pragma mark  Redirect to Profile
-(void)userDetailPageNavigation:(NSString*)itemId
{

    if([itemId intValue]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"user_not_registered_yet"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
        activeSelect=YES;

    }else{
    NewProfilePage * newprofilePageObj = [[NewProfilePage alloc]init];
    [newprofilePageObj loadingOtherUserData:itemId:@"NO"];
    [self.navigationController pushViewController:newprofilePageObj animated:YES];
    }
}
-(void)messagePageRedirection
{
    [delegate.tabViewControllerObj.tabBarController selectTab:3];
}


-(void)usergesterAction:(UITapGestureRecognizer *) sender
{
    [self userDetailPageNavigation:[NSString stringWithFormat:@"%ld",(long)(UIGestureRecognizer*)[sender.view tag]]];
    
}

#pragma mark  - WSDL DelegateMethod
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
    @try {
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    activeSelect=YES;
    [refreshControl endRefreshing];
    [notificationTable finishInfiniteScroll];
    [self checkIfhavsData];
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method{
    NSLog(@"Service %@ Done!",method);
    NSLog(@"data: %@ ",data);
    
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    if ([method isEqualToString:@"notification"])
    {
        [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj notificationPageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
        [notificationArray addObjectsFromArray:[[defaultDict objectForKey:@"result"] objectForKey:@"notification"]];
        [notificationTable reloadData];
    }
    else
    {
        [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj testingHomePageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
        [itemDetailArray removeAllObjects];
        [itemDetailArray addObjectsFromArray:[[defaultDict objectForKey:@"result"]objectForKey:@"items"]];
        [self performSelectorOnMainThread:@selector(pageRedirection) withObject:nil waitUntilDone:YES];
    }
    
    if([notificationArray count]%20 == 0 && [notificationArray count]>=20)
    {
    [notificationTable addInfiniteScrollWithHandler:^(UICollectionView *collectionView) {
        [self bottomrefreshTable:^{
        }];
    }];
    }
    activeSelect=YES;
    [refreshControl endRefreshing];
    [notificationTable finishInfiniteScroll];
    [self checkIfhavsData];
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];

}

-(NSString *)Changemonth : (NSString*)Timestamp{
    NSString * replacemnth =@"";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];;
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"MMM dd, YYYY"];
    NSTimeInterval epoch = [Timestamp doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:epoch];
    NSString * date_locale=[dateFormatter stringFromDate:date];
    replacemnth=[date_locale stringByReplacingOccurrencesOfString:[date_locale substringToIndex:3] withString:[delegate.languageDict objectForKey:[date_locale substringToIndex:3]]];
    
    return replacemnth;
}



#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
