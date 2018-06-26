//
//  AdvanceSearchPage.m
//  HSJoysale
//
//  Created by BTMANI on 17/12/14.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * Home page filter
 */

#import "AdvanceSearchPage.h"
#import "AppDelegate.h"
#import "NYSliderPopover.h"
#import "FilterSubcategory.h"
#import "advancesearchMapView.h"

@interface AdvanceSearchPage ()


@property (nonatomic, strong) IBOutlet NYSliderPopover *slider;
- (IBAction)sliderValueChanged:(id)sender;

@end

@implementation AdvanceSearchPage
@synthesize slider;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialization
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //appearance
    
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];

    //UI frame
    homeimg = [[UIImageView alloc] init];
    designimg = [[UIImageView alloc] init];
    mileimg = [[UIImageView alloc] init];
    milelable = [[UILabel alloc] init];
    FilterView = [[UIView alloc] initWithFrame:CGRectMake(0, delegate.windowHeight-125,delegate.windowWidth, 60)];

    //functionality
    
    //Copy Main data to temp array
    [delegate.HomeSearchtempArray replaceObjectAtIndex:0 withObject:[delegate.HomeSearchArray objectAtIndex:0]];//latitude
    [delegate.HomeSearchtempArray replaceObjectAtIndex:1 withObject:[delegate.HomeSearchArray objectAtIndex:1]];//longitude
    [delegate.HomeSearchtempArray replaceObjectAtIndex:2 withObject:[delegate.HomeSearchArray objectAtIndex:2]];//address
    [delegate.HomeSearchtempArray replaceObjectAtIndex:3 withObject:[delegate.HomeSearchArray objectAtIndex:3]];//distance
    [delegate.HomeSearchtempArray replaceObjectAtIndex:4 withObject:[delegate.HomeSearchArray objectAtIndex:4]];//postwithin
    [delegate.HomeSearchtempArray replaceObjectAtIndex:5 withObject:[delegate.HomeSearchArray objectAtIndex:5]];//sortby
    [delegate.HomeDictForCatIDtemp removeAllObjects];
    delegate.HomeDictForCatIDtemp = [delegate.HomeDictForCatID mutableCopy];
    
    //properties
    
    
    [advanceSearchPageTabel setBackgroundColor:BackGroundColor];
    [advanceSearchPageTabel setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight-120)];
    [advanceSearchPageTabel setTag:101];
    
    postwithinArray = [[NSMutableArray alloc] init];
    [postwithinArray addObject:[delegate.languageDict objectForKey:@"last24h"]];
    [postwithinArray addObject:[delegate.languageDict objectForKey:@"last7d"]];
    [postwithinArray addObject:[delegate.languageDict objectForKey:@"last30d"]];
    [postwithinArray addObject:[delegate.languageDict objectForKey:@"allproducts"]];
    
    shortbyArray = [[NSMutableArray alloc] init];
    [shortbyArray addObject:[delegate.languageDict objectForKey:@"popular"]];
    
    
    [shortbyArray addObject:[delegate.languageDict objectForKey:@"hightolow"]];
    [shortbyArray addObject:[delegate.languageDict objectForKey:@"lowtohigh"]];
    
    [SaveFilter setFrame:CGRectMake(5, 10, (delegate.windowWidth)-10, 40)];
    SaveFilter.layer.cornerRadius=4;
    SaveFilter.layer.masksToBounds=YES;
    [SaveFilter setTitle:[delegate.languageDict objectForKey:@"save"] forState:UIControlStateNormal];
    [SaveFilter.titleLabel setAdjustsFontSizeToFitWidth:YES];

    [SaveFilter setBackgroundColor:AppThemeColor];
    [FilterView setBackgroundColor:whitecolor];
    [SaveFilter.titleLabel setFont:ButtonFont];
    [FilterView.layer setBorderWidth:1];
    [FilterView.layer setBorderColor:BackGroundColor.CGColor];
    FilterView.layer.masksToBounds = NO;
    [FilterView addSubview:SaveFilter];
    [self.view addSubview:FilterView];
    
    //Function call
    [self barButtonFunction];
    [self categoryDataParing];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma  mark viewwillappear

-(void)viewWillAppear:(BOOL)animated{

    [self setNeedsStatusBarAppearanceUpdate];

    [self viewAppearance];
    [self defaultDataParsing];

    [advanceSearchPageTabel reloadData];
    [super viewWillAppear:YES];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark  appearance

- (void) viewAppearance
{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [delegate tabbarFrameHide];
    [self.view setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight+100)];
}

#pragma  mark - Navigation bar button function

-(void) barButtonFunction
{
    UIView * leftNaviNaviButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,delegate.windowWidth, 44)];
    [leftNaviNaviButtonView setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem * negativeSpacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]autorelease];
    if (isAboveiOSVersion7)
    {
        negativeSpacer.width = -20;
    }
    else
    {
        negativeSpacer.width = -10;
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setTag:1000];
    [closeBtn setFrame:CGRectMake(10+[HSUtility adjustablePadding],2,60,40)];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [closeBtn setTitle:[delegate.languageDict objectForKey:@"cancel"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font=[UIFont fontWithName:appFontRegular size:16];
    [closeBtn addTarget:self action:@selector(addcloseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:closeBtn];
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"filter"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontBold size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setBackgroundColor:[UIColor clearColor]];
    [doneButton setTag:1000];
    [doneButton setFrame:CGRectMake(delegate.windowWidth-70+[HSUtility adjustablePadding],2,60,40)];
    doneButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [doneButton setTitle:[delegate.languageDict objectForKey:@"reset"] forState:UIControlStateNormal];
    [doneButton.titleLabel setAdjustsFontSizeToFitWidth:YES];

    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font=[UIFont fontWithName:appFontRegular size:16];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneButton addTarget:self action:@selector(adddoneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:doneButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}


#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //101 for main table view
    if(tableView.tag==101){
        return 5;
    }
    else{ // AutoSuggesstion Tableview
        return 1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section==0){
        return 60; //Change LocationHeight
    }
    if(indexPath.section==1){
        return 100; //Change Slider for Distance
    }
    if(indexPath.section==2){
        if([[delegate.getcategoryDict objectForKey:@"category"] count]-1==indexPath.row){
            return 60; //category Height with bottom Space
        }else{
            return 51; //category Height
        }
    }
    if(indexPath.section==3){
        if([postwithinArray count]-1==indexPath.row){
            return 60; //postwithin Height with bottom Space
        }else{
            return 51; //postwithin Height
        }
    }
    if(indexPath.section==4){
        if([shortbyArray count]-1==indexPath.row){
            return 60; //shortby Height with bottom Space
        }else{
            return 51; //shortby Height
        }
    }
    else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }
    if(section==1){
        return 1;
    }
    if(section==2){
        return [[delegate.getcategoryDict objectForKey:@"category"] count];
    }
    if(section==3){
        return [postwithinArray count];
    }
    if(section==4){
        return [shortbyArray count];
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
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    {
        UIView * contentview = [[[UIView alloc]init]autorelease];
        [contentview setBackgroundColor:whitecolor];
        [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,50)];
        UIView * lineviewbottom = [[[UIView alloc]init]autorelease];
        [lineviewbottom setBackgroundColor:BackGroundColor];
        if(indexPath.section==0){
            if (indexPath.row==0)
            {
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,60)];
                UILabel * changelocationLbl = [[[UILabel alloc]init]autorelease];
                if ([[delegate.HomeSearchtempArray objectAtIndex:2]isEqualToString:@""])
                {
                    [changelocationLbl setText:[delegate.languageDict objectForKey:@"change_location"]];
                }
                else
                {
                    [changelocationLbl setText:[delegate.HomeSearchtempArray objectAtIndex:2]];
                }
                [changelocationLbl setFrame:CGRectMake(10,0,delegate.windowWidth-50,50)];
                [changelocationLbl setTextColor:headercolor];
                [changelocationLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
                [contentview addSubview:changelocationLbl];
                [lineviewbottom setFrame:CGRectMake(0,50,delegate.windowWidth,10)];
                [contentview addSubview:lineviewbottom];
                UIImageView *arrowImg = [[[UIImageView alloc] init] autorelease];
                [arrowImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
                [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
                [arrowImg setFrame:CGRectMake(delegate.windowWidth-30, 15, 20, 20)];
                [contentview addSubview:arrowImg];
                if([delegate.languageSelected isEqualToString:@"Arabic"]){
                    //[milelable setFrame:CGRectMake(25, 10, 60, 20)];
                    [changelocationLbl setFrame:CGRectMake(50,0,delegate.windowWidth-60,50)];
                    [changelocationLbl setTextAlignment:NSTextAlignmentRight];
                    [arrowImg setFrame:CGRectMake(10, 15, 20, 20)];
                    [arrowImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
                }
            }
        }
        else if(indexPath.section==1){
            if(indexPath.row==0){
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,100)];
                
                mileimg.layer.cornerRadius=12.5;
                mileimg.layer.masksToBounds=YES;
                [mileimg setFrame:CGRectMake(50,20, 50, 25)];
                [contentview addSubview:mileimg];
                
                milelable.layer.cornerRadius=10;
                milelable.layer.masksToBounds=YES;
                [milelable setFrame:CGRectMake(25, 10, 50, 20)];
                [milelable setTextAlignment:NSTextAlignmentCenter];
                [milelable setBackgroundColor:headercolor];
                [milelable setTextColor:whitecolor];
                [milelable setFont:[UIFont fontWithName:appFontRegular size:12]];
                [contentview addSubview:milelable];
                
                [homeimg setFrame:CGRectMake(10, 40, 30, 30)];
                [contentview addSubview:homeimg];
                
                slider.minimumValue = 0.0;
                slider.maximumValue = 100.0;
                slider.continuous = YES;
                slider.value=[[self distanceFunc:[delegate.HomeSearchtempArray objectAtIndex:3]] floatValue];
                [slider setFrame:CGRectMake(50, 30, delegate.windowWidth-100, 50)];
                [slider setMinimumTrackTintColor:AppThemeColor];
                [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                [contentview addSubview:slider];
                
                if([[delegate.HomeSearchArray objectAtIndex:2] isEqualToString:@"WorldWide"]){
                    [slider setEnabled:false];
                }else{
                    [slider setEnabled:true];
                    
                }
                
                [designimg setFrame:CGRectMake(delegate.windowWidth-40, 40, 30, 30)];
                [contentview addSubview:designimg];
                
                if(slider.value<1){
                    [mileimg setImage:[UIImage imageNamed:@"mileimgDisable.png"]];
                    [milelable setText:[NSString stringWithFormat:@"%@",[delegate.languageDict objectForKey:@"Not set"]]];
                    [milelable setBackgroundColor:graycolor];
                    [milelable setAdjustsFontSizeToFitWidth:YES];

                    [homeimg setImage:[UIImage imageNamed:@"filterHomeDisable.png"]];
                    [designimg setImage:[UIImage imageNamed:@"filterdesignationDisable.png"]];
                }
                else{
                    [mileimg setImage:[UIImage imageNamed:@"mileimg.png"]];
                    [milelable setBackgroundColor:headercolor];
                    [milelable setText:[NSString stringWithFormat:@"%.0f %@",slider.value,delegate.distancestring]];
                    
                    [homeimg setImage:[UIImage imageNamed:@"filterHome.png"]];
                    [designimg setImage:[UIImage imageNamed:@"filterdesignation.png"]];
                }
                
                [self updatePopoverFrame:slider.value];

                [lineviewbottom setFrame:CGRectMake(0,90,delegate.windowWidth,10)];
                [contentview addSubview:lineviewbottom];
            }
        }
        else if(indexPath.section==2){
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UILabel * categoryLbl = [[[UILabel alloc]init]autorelease];
            [categoryLbl setFrame:CGRectMake(10,0,delegate.windowWidth-20,50)];
            [categoryLbl setText:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"category_name"]];
            [categoryLbl setTextColor:headercolor];
            [categoryLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
            [contentview addSubview:categoryLbl];
            
            UIImageView *checkiconimg = [[[UIImageView alloc] init] autorelease];
            [checkiconimg setFrame:CGRectMake(delegate.windowWidth-30, 15, 20, 20)];
            
            if ([[delegate.HomeDictForCatIDtemp allKeys] containsObject:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"category_id"]]) {
                [categoryLbl setTextColor:AppThemeColor];
                [checkiconimg setImage:[UIImage imageNamed:@"checkicon.png"]];
                [contentview addSubview:checkiconimg];
            }
            else{
                if([[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"subcategory"] count]!=0){
                    [checkiconimg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
                    [checkiconimg setContentMode:UIViewContentModeScaleAspectFit];
                    [checkiconimg setFrame:CGRectMake(delegate.windowWidth-30, 15, 20, 20)];
                    [contentview addSubview:checkiconimg];
                }
            }
            
            if([[delegate.getcategoryDict objectForKey:@"category"] count]-1==indexPath.row){
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,60)];
                [lineviewbottom setFrame:CGRectMake(0,50,delegate.windowWidth,10)];
                [contentview addSubview:lineviewbottom];
            }else{
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,51)];
                [lineviewbottom setFrame:CGRectMake(10,50,delegate.windowWidth-20,1)];
                [contentview addSubview:lineviewbottom];
            }
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [categoryLbl setFrame:CGRectMake(50,0,delegate.windowWidth-60,50)];
                [categoryLbl setTextAlignment:NSTextAlignmentRight];
                [checkiconimg setFrame:CGRectMake(10, 15, 20, 20)];
                if([[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"subcategory"] count]!=0){
                    [checkiconimg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
                    [checkiconimg setContentMode:UIViewContentModeScaleAspectFit];
                }
            }
        }
        else if(indexPath.section==3){
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UILabel * postwithinLbl = [[[UILabel alloc]init]autorelease];
            [postwithinLbl setFrame:CGRectMake(10,0,delegate.windowWidth-20,50)];
            [postwithinLbl setText:[postwithinArray objectAtIndex:indexPath.row]];
            [postwithinLbl setTextColor:headercolor];
            [postwithinLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
            [contentview addSubview:postwithinLbl];
            
            UIImageView *checkiconimg = [[[UIImageView alloc] init] autorelease];
            [checkiconimg setFrame:CGRectMake(delegate.windowWidth-30, 15, 20, 20)];
            
            if([[delegate.HomeSearchtempArray objectAtIndex:4] isEqualToString:[postwithinArray objectAtIndex:indexPath.row]]){
                [postwithinLbl setTextColor:AppThemeColor];
                [checkiconimg setImage:[UIImage imageNamed:@"checkicon.png"]];
                [contentview addSubview:checkiconimg];
            }
            if([postwithinArray count]-1==indexPath.row){
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,60)];
                [lineviewbottom setFrame:CGRectMake(0,50,delegate.windowWidth,10)];
                [contentview addSubview:lineviewbottom];
            }else{
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,51)];
                [lineviewbottom setFrame:CGRectMake(10,50,delegate.windowWidth-20,1)];
                [contentview addSubview:lineviewbottom];
            }
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [postwithinLbl setFrame:CGRectMake(50,0,delegate.windowWidth-60,50)];
                [postwithinLbl setTextAlignment:NSTextAlignmentRight];
                [checkiconimg setFrame:CGRectMake(10, 15, 20, 20)];
            }

        }
        else if(indexPath.section==4){
            UILabel * postwithinLbl = [[[UILabel alloc]init]autorelease];
            [postwithinLbl setFrame:CGRectMake(10,0,delegate.windowWidth-20,50)];
            [postwithinLbl setText:[shortbyArray objectAtIndex:indexPath.row]];
            [postwithinLbl setTextColor:headercolor];
            [postwithinLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
            [contentview addSubview:postwithinLbl];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UIImageView *checkiconimg = [[[UIImageView alloc] init] autorelease];
            [checkiconimg setFrame:CGRectMake(delegate.windowWidth-30, 15, 20, 20)];
            
            if([[delegate.HomeSearchtempArray objectAtIndex:5] isEqualToString:[shortbyArray objectAtIndex:indexPath.row]]){
                [postwithinLbl setTextColor:AppThemeColor];
                [checkiconimg setImage:[UIImage imageNamed:@"checkicon.png"]];
                [contentview addSubview:checkiconimg];
            }
            if([shortbyArray count]-1==indexPath.row){
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,60)];
                [lineviewbottom setFrame:CGRectMake(0,50,delegate.windowWidth,10)];
                [contentview addSubview:lineviewbottom];
            }else{
                [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,51)];
                [lineviewbottom setFrame:CGRectMake(10,50,delegate.windowWidth-20,1)];
                [contentview addSubview:lineviewbottom];
            }
            if([delegate.languageSelected isEqualToString:@"Arabic"]){
                [postwithinLbl setFrame:CGRectMake(50,0,delegate.windowWidth-60,50)];
                [postwithinLbl setTextAlignment:NSTextAlignmentRight];
                [checkiconimg setFrame:CGRectMake(10, 15, 20, 20)];
            }

        }
        
        [cell.contentView addSubview:contentview];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    return cell;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        advancesearchMapView * pageObj = [[advancesearchMapView alloc]initWithNibName:@"advancesearchMapView" bundle:nil];
        [self.navigationController pushViewController:pageObj animated:YES];
        [pageObj release];
        
    }else if(indexPath.section==1){
    }else if(indexPath.section==2){
        [delegate.filterCategoryArray replaceObjectAtIndex:0 withObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]];
        [delegate.filterCategoryArray replaceObjectAtIndex:1 withObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_name"]];
        
        NSLog(@"%@",[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"subcategory"]);
        if([[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"subcategory"] count]!=0){
            if (![[delegate.HomeDictForCatIDtemp allKeys] containsObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]]) {
            }
            [delegate.filterSubcategoryDic addEntriesFromDictionary:[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] ];
            FilterSubcategory * pageObj = [[FilterSubcategory alloc]initWithNibName:@"FilterSubcategory" bundle:nil];
            [self.navigationController pushViewController:pageObj animated:YES];
            [pageObj release];
        }
        else{
            if (![[delegate.HomeDictForCatIDtemp allKeys] containsObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]]) {
                [delegate.HomeDictForCatIDtemp setValue:@"0" forKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]];
            }else{
                [delegate.HomeDictForCatIDtemp removeObjectForKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]];
            }
            [advanceSearchPageTabel reloadData];
        }
        
    }else if(indexPath.section==3){
        [delegate.HomeSearchtempArray replaceObjectAtIndex:4
                                                withObject:[postwithinArray objectAtIndex:indexPath.row]];
        [advanceSearchPageTabel reloadData];
    }else if(indexPath.section==4){
        [delegate.HomeSearchtempArray replaceObjectAtIndex:5
                                                withObject:[shortbyArray objectAtIndex:indexPath.row]];
        [advanceSearchPageTabel reloadData];
    }
    if (indexPath.row==1)
    {
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[[UIView alloc]init]autorelease];
    [view setFrame:CGRectMake(0,0,320,0)];
    
    [view setBackgroundColor:whitecolor];
    if(tableView.tag==101){
        [view setFrame:CGRectMake(0,0,delegate.windowWidth,40)];
        UILabel * headerLabel = [[[UILabel alloc]init]autorelease];
        headerLabel.backgroundColor = whitecolor;
        [headerLabel setFont:[UIFont fontWithName:appFontBold size:17]];
        [headerLabel setFrame:CGRectMake(10,0,delegate.windowWidth-20,40)];
        [headerLabel setTextColor:filterHeadercolor];
        UIView * lineview = [[[UIView alloc]init]autorelease];
        [lineview setFrame:CGRectMake(10,39,delegate.windowWidth-20,0.7)];
        [lineview setBackgroundColor:lineviewColor];
        if(section==0){
            [headerLabel setText:[[delegate.languageDict objectForKey:@"location"] uppercaseString]];
        }if(section==1){
            [headerLabel setText:[delegate.languageDict objectForKey:@"Distance"]];
        }if(section==2){
            [headerLabel setText:[delegate.languageDict objectForKey:@"Categories"]];
        }if(section==3){
            [headerLabel setText:[delegate.languageDict objectForKey:@"Posted_within"]];
        }if(section==4){
            [headerLabel setText:[delegate.languageDict objectForKey:@"Sort_by"]];
        }
        [view addSubview:headerLabel];
        [view addSubview:lineview];
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [headerLabel setTextAlignment:NSTextAlignmentRight];
        }
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


#pragma mark - ButtonAction
/**** To close the advance search page ****/
-(void)addcloseBtnClicked
{
    delegate.advancesearchFlag = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

/**** Add close to close the navigation  ****/

-(void)adddoneBtnClicked
{
    [delegate.HomeSearchtempArray replaceObjectAtIndex:0 withObject:[delegate.HomeSearchArray objectAtIndex:0]];//latitude
    [delegate.HomeSearchtempArray replaceObjectAtIndex:1 withObject:[delegate.HomeSearchArray objectAtIndex:1]];//longitude
    [delegate.HomeSearchtempArray replaceObjectAtIndex:2 withObject:[delegate.HomeSearchArray objectAtIndex:2]];//address
    [delegate.HomeSearchtempArray replaceObjectAtIndex:3 withObject:@"0"];//distance
    [delegate.HomeSearchtempArray replaceObjectAtIndex:4 withObject:@""];//postwithin
    [delegate.HomeSearchtempArray replaceObjectAtIndex:5 withObject:@""];//sortby
    [delegate.HomeDictForCatIDtemp removeAllObjects];
    [advanceSearchPageTabel reloadData];
}
//Save button Tapped
- (IBAction)saveBtnTapped:(id)sender
{
    [self.view endEditing:YES];
    NSLog(@"%@",[delegate.HomeSearchArray objectAtIndex:4]);
    [delegate.HomeSearchArray replaceObjectAtIndex:0 withObject:[delegate.HomeSearchtempArray objectAtIndex:0]];
    [delegate.HomeSearchArray replaceObjectAtIndex:1 withObject:[delegate.HomeSearchtempArray objectAtIndex:1]];
    [delegate.HomeSearchArray replaceObjectAtIndex:2 withObject:[delegate.HomeSearchtempArray objectAtIndex:2]];
    if (![[delegate.HomeSearchtempArray objectAtIndex:3]isEqualToString:@""]) {
        NSString *distanceStr = [NSString stringWithFormat:@"within %.0f %@",slider.value,delegate.distancestring] ;
        
        [delegate.HomeSearchArray replaceObjectAtIndex:3 withObject:distanceStr];
    }
    else
    {
        [delegate.HomeSearchArray replaceObjectAtIndex:3 withObject:[delegate.HomeSearchtempArray objectAtIndex:3]];

    }
   
    
   // [delegate.HomeSearchArray replaceObjectAtIndex:3 withObject:[delegate.HomeSearchtempArray objectAtIndex:3]];
    [delegate.HomeSearchArray replaceObjectAtIndex:4 withObject:[delegate.HomeSearchtempArray objectAtIndex:4]];
    [delegate.HomeSearchArray replaceObjectAtIndex:5 withObject:[delegate.HomeSearchtempArray objectAtIndex:5]];
    [delegate.HomeDictForCatID removeAllObjects];
    delegate.HomeDictForCatID = [delegate.HomeDictForCatIDtemp mutableCopy];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)distanceFunc:(NSString *)distance
{
    NSString* noSpaces;
    noSpaces = distance;
    noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@" "withString:@""];
    noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"within"withString:@""];
    noSpaces = [noSpaces stringByReplacingOccurrencesOfString:delegate.distancestring withString:@""];
    
    
    return noSpaces;
}

#pragma mark - slider distance trigger to display values

- (IBAction)sliderValueChanged:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]!=NULL)
    {
        if ([[[[[NSUserDefaults standardUserDefaults]objectForKey:@"choosedDataArray"]objectAtIndex:2]uppercaseString]isEqualToString:@"WORLDWIDE"])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[delegate.languageDict objectForKey:@"error"] message:@"Please Select Location" delegate:self cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"] otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [slider setValue:0];
            return;
        }
    }
    [self updateSliderPopoverText];
    if(slider.value<1){
        [mileimg setImage:[UIImage imageNamed:@"mileimgDisable.png"]];
        [milelable setBackgroundColor:graycolor];
        [milelable setText:[NSString stringWithFormat:@"%@",[delegate.languageDict objectForKey:@"Not set"]]];
        [homeimg setImage:[UIImage imageNamed:@"filterHomeDisable.png"]];
        [designimg setImage:[UIImage imageNamed:@"filterdesignationDisable.png"]];
    }
    else{
        [mileimg setImage:[UIImage imageNamed:@"mileimg.png"]];
        [milelable setBackgroundColor:headercolor];
        [milelable setText:[NSString stringWithFormat:@"%.0f %@",slider.value,delegate.distancestring]];
        [homeimg setImage:[UIImage imageNamed:@"filterHome.png"]];
        [designimg setImage:[UIImage imageNamed:@"filterdesignation.png"]];
    }
    [self updatePopoverFrame:slider.value];
}

- (void)updatePopoverFrame:(float) values
{
    //Inspired in Collin Ruffenach's ELCSlider https://github.com/elc/ELCSlider/blob/master/ELCSlider/ELCSlider.m#L53
    
    CGFloat minimum =  0;
    CGFloat maximum = 100;
    CGFloat value = values;
    
    if (minimum < 0.0) {
        
        value = values - minimum;
        maximum = maximum - minimum;
        minimum = 0.0;
    }
    
    CGFloat x = slider.frame.origin.x;
    CGFloat maxMin = (maximum + minimum) / 2.0;
    
    x += (((value - minimum) / (maximum - minimum)) * slider.frame.size.width) - (mileimg.frame.size.width / 2.0);
    
    if (value > maxMin) {
        
        value = (value - maxMin) + (minimum * 1.0);
        value = value / maxMin;
        value = value * 15.0;
        
        
        x = x - value;
        
    } else {
        
        value = (maxMin - value) + (minimum * 1.0);
        value = value / maxMin;
        value = value * 15.0;

        x = x + value;
    }
    
    CGRect popoverRect = mileimg.frame;
    popoverRect.origin.x = x;
    popoverRect.origin.y = slider.frame.origin.y -20;
    
    mileimg.frame = popoverRect;
    [milelable setFrame:CGRectMake(popoverRect.origin.x,popoverRect.origin.y,50,20)];
}

- (void)updateSliderPopoverText
{
    self.slider.popover.textLabel.text = [NSString stringWithFormat:@"  %.0f KM %@", self.slider.value,@"  "];
    [self.view bringSubviewToFront:self.slider.popover.textLabel];
    [delegate.HomeSearchtempArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%.0f", self.slider.value]];
}

-(void) defaultDataParsing
{
    ApiControllerServiceProxy *adminproxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        [adminproxy admindatas:apiusername :apipassword :[delegate gettingLanguageCode] ];
    }
}

-(void) categoryDataParing
{
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
        [proxy getcategory:apiusername :apipassword :[delegate gettingLanguageCode]];
    }
}

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
    
    @try {
      //  [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    }
    @catch (NSException * e) {
    }
   }

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    
    NSLog(@"method %@",method);
    NSLog(@"data %@",data);
    
    
  //  [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    
   if ([method isEqualToString:@"admindatas"])
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        NSLog(@"%@",defaultDict);
       // [delegate.getcategoryDict removeAllObjects];
       // [delegate.getcategoryDict addEntriesFromDictionary:[defaultDict objectForKey:@"result"]];
        delegate.distancestring = [[defaultDict objectForKey:@"result"] objectForKey:@"distance_type"];
        
        [advanceSearchPageTabel reloadData];

        
    }
    else
    {
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        [delegate.getcategoryDict removeAllObjects];
        [delegate.getcategoryDict addEntriesFromDictionary:[defaultDict objectForKey:@"result"]];
        [advanceSearchPageTabel reloadData];
        NSMutableArray * countryListArray = [[NSMutableArray alloc]initWithCapacity:0];
        [countryListArray addObjectsFromArray:[delegate.getcategoryDict objectForKey:@"country"]];
        for (int i=0;i<[[delegate.getcategoryDict objectForKey:@"country"]count]; i++)
        {
            if ([[[[countryListArray objectAtIndex:i]objectForKey:@"country_name"]uppercaseString]isEqualToString:@"OTHERS"])
            {
                [countryListArray removeObjectAtIndex:i];
                [delegate.getcategoryDict setObject:countryListArray forKey:@"country"];
                break;
            }
        }
    }
}


#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
    [FilterView release];
    [SaveFilter release];
    [super dealloc];
}

@end
