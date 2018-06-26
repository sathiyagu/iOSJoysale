//
//  CategoryAdvSearch.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 20/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * Category page filter
 */

#import "CategoryAdvSearch.h"
#import "AppDelegate.h"
#import "NYSliderPopover.h"
#import "SubCategoryTab.h"
#import "advancesearchMapView.h"

@interface CategoryAdvSearch ()

@property (nonatomic, strong) IBOutlet NYSliderPopover *slider;
- (IBAction)sliderValueChanged:(id)sender;

@end

@implementation CategoryAdvSearch
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
    FilterView = [[UIView alloc] initWithFrame:CGRectMake(-1, delegate.windowHeight-125,delegate.windowWidth+2, 61)];

    //functionality
    //Copy Main data to temp array
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:0 withObject:[delegate.advanceCategorySearchArray objectAtIndex:0]];//latitude
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:1 withObject:[delegate.advanceCategorySearchArray objectAtIndex:1]];//longitude
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:2 withObject:[delegate.advanceCategorySearchArray objectAtIndex:2]];//address
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:3 withObject:[delegate.advanceCategorySearchArray objectAtIndex:3]];//distance
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:4 withObject:[delegate.advanceCategorySearchArray objectAtIndex:4]];//postwithin
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:5 withObject:[delegate.advanceCategorySearchArray objectAtIndex:5]];//sortby
    [delegate.CategoryDictForCatIDtemp removeAllObjects];
    delegate.CategoryDictForCatIDtemp = [delegate.CategoryDictForCatID mutableCopy];
    
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

    [FilterView setBackgroundColor:whitecolor];
    [FilterView.layer setBorderWidth:1];
    [FilterView.layer setBorderColor:BackGroundColor.CGColor];
    FilterView.layer.masksToBounds = NO;
    [FilterView addSubview:SaveFilter];
    [self.view addSubview:FilterView];
    [self.view bringSubviewToFront:FilterView];

    [SaveFilter setBackgroundColor:AppThemeColor];

    //Functions call
    
    [self barButtonFunction];
    
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma  mark viewwillappear

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self setNeedsStatusBarAppearanceUpdate];

    
    [self viewAppearance];
    [advanceSearchPageTabel reloadData];
    [super viewWillAppear:YES];
}

#pragma mark - appearance

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
    [leftNaviNaviButtonView setBackgroundColor:AppThemeColor];
    
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
    [closeBtn setTitleColor:whitecolor forState:UIControlStateNormal];
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

    [doneButton setTitleColor:whitecolor forState:UIControlStateNormal];
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
    return 5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0){
        //Change LocationHeight
        return 60;
    }
    if(indexPath.section==1){
        //Change Slider for Distance
        return 100;
    }
    if(indexPath.section==2){
        if([[delegate.getcategoryDict objectForKey:@"category"] count]-1==indexPath.row){
            //category Height with bottom Space
            return 60;
        }else{
            //category Height
            return 51;
        }
    }
    if(indexPath.section==3){
        if([postwithinArray count]-1==indexPath.row){
            //postwithin Height with bottom Space
            return 60;
        }else{
            //postwithin Height
            return 51;
        }
    }
    if(indexPath.section==4){
        if([shortbyArray count]-1==indexPath.row){
            //shortby Height with bottom Space
            return 60;
        }else{
            //shortby Height
            return 51;
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
    
       /**** Advance search page Data ****/
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
                [changelocationLbl setFrame:CGRectMake(10,0,delegate.windowWidth-50,50)];
                if (![[delegate.advanceCategorySearchtempArray objectAtIndex:2]isEqualToString:@""])
                {
                    [changelocationLbl setText:[delegate.advanceCategorySearchtempArray objectAtIndex:2]];
                }
                else
                {
                    [changelocationLbl setText:[delegate.languageDict objectForKey:@"change_location"]];
                }
                    
                [changelocationLbl setTextColor:headercolor];
                [changelocationLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
                [contentview addSubview:changelocationLbl];
                [lineviewbottom setFrame:CGRectMake(0,50,delegate.windowWidth,10)];
                [contentview addSubview:lineviewbottom];
                UIImageView *arrowImg = [[[UIImageView alloc] init] autorelease];
                [arrowImg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
                [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
                [arrowImg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
                [contentview addSubview:arrowImg];
                if([delegate.languageSelected isEqualToString:@"Arabic"]){
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
                [mileimg setFrame:CGRectMake(25,20, 50, 25)];
                [contentview addSubview:mileimg];
                
                milelable.layer.cornerRadius=10;
                milelable.layer.masksToBounds=YES;
                [milelable setFrame:CGRectMake(25, 10, 50, 20)];
                [milelable setTextAlignment:NSTextAlignmentCenter];
                [milelable setBackgroundColor:headercolor];
                [milelable setTextColor:whitecolor];
                [milelable setFont:[UIFont fontWithName:appFontRegular size:10]];
                [contentview addSubview:milelable];
                
                [homeimg setFrame:CGRectMake(10, 40, 30, 30)];
                [contentview addSubview:homeimg];
                
                slider.minimumValue = 0.0;
                slider.maximumValue = 100.0;
                slider.continuous = YES;
                slider.value=[[delegate.advanceCategorySearchtempArray objectAtIndex:3] floatValue];
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
                    [milelable setText:@"Not set"];
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
            [checkiconimg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
            
            if ([[delegate.CategoryDictForCatIDtemp allKeys] containsObject:[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"category_id"]]) {
                // contains key
                [categoryLbl setTextColor:AppThemeColor];
                [checkiconimg setImage:[UIImage imageNamed:@"checkicon.png"]];
                [contentview addSubview:checkiconimg];
            }
            else{
                if([[[[delegate.getcategoryDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"subcategory"] count]!=0){
                    [checkiconimg setImage:[UIImage imageNamed:@"InArrowImg.png"]];
                    [checkiconimg setContentMode:UIViewContentModeScaleAspectFit];
                    [checkiconimg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
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
                [checkiconimg setFrame:CGRectMake(10, 15, checkiconimg.frame.size.width, checkiconimg.frame.size.height)];
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
            [checkiconimg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
            
            if([[delegate.advanceCategorySearchtempArray objectAtIndex:4] isEqualToString:[postwithinArray objectAtIndex:indexPath.row]]){
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
                [checkiconimg setFrame:CGRectMake(10, 15, checkiconimg.frame.size.width, checkiconimg.frame.size.height)];
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
            [checkiconimg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
            
            if([[delegate.advanceCategorySearchtempArray objectAtIndex:5] isEqualToString:[shortbyArray objectAtIndex:indexPath.row]]){
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
                [checkiconimg setFrame:CGRectMake(10, 15, checkiconimg.frame.size.width, checkiconimg.frame.size.height)];
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
    
    {
        if(indexPath.section==0){
            advancesearchMapView * pageObj = [[advancesearchMapView alloc]initWithNibName:@"advancesearchMapView" bundle:nil];
            [self.navigationController pushViewController:pageObj animated:YES];
            [pageObj release];
            
        }else if(indexPath.section==1){
        }else if(indexPath.section==2){
            [delegate.filterCategoryArray replaceObjectAtIndex:0 withObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]];
            [delegate.filterCategoryArray replaceObjectAtIndex:1 withObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_name"]];
            
            if([[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"subcategory"] count]!=0){
                if (![[delegate.CategoryDictForCatIDtemp allKeys] containsObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]]) {
                    // contains key
//                    [delegate.CategoryDictForCatIDtemp setValue:@"0" forKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]];
                }
                [delegate.filterSubcategoryDic addEntriesFromDictionary:[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] ];
                SubCategoryTab * pageObj = [[SubCategoryTab alloc]initWithNibName:@"SubCategoryTab" bundle:nil];
                [self.navigationController pushViewController:pageObj animated:YES];
                [pageObj release];
            }
            else{
                if (![[delegate.CategoryDictForCatIDtemp allKeys] containsObject:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]]) {
                    // contains key
                    [delegate.CategoryDictForCatIDtemp setValue:@"0" forKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]];
                }else{
                    [delegate.CategoryDictForCatIDtemp removeObjectForKey:[[[delegate.getcategoryDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]];
                }
                [advanceSearchPageTabel reloadData];
            }
            
        }else if(indexPath.section==3){
            [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:4
                                                      withObject:[postwithinArray objectAtIndex:indexPath.row]];
            [advanceSearchPageTabel reloadData];
        }else if(indexPath.section==4){
            [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:5
                                                   withObject:[shortbyArray objectAtIndex:indexPath.row]];
            [advanceSearchPageTabel reloadData];
        }
        if (indexPath.row==1)
        {
    }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[[UIView alloc]init]autorelease];
    [view setFrame:CGRectMake(0,0,320,0)];
    
    [view setBackgroundColor:whitecolor];
    if(tableView.tag==101){
        [view setFrame:CGRectMake(0,0,delegate.windowWidth,30)];
        UILabel * headerLabel = [[[UILabel alloc]init]autorelease];
        headerLabel.backgroundColor = whitecolor;
        [headerLabel setFont:[UIFont fontWithName:appFontBold size:17]];
        [headerLabel setFrame:CGRectMake(10,0,delegate.windowWidth-20,40)];
        [headerLabel setTextColor:filterHeadercolor];
        UIView * lineview = [[[UIView alloc]init]autorelease];
        [lineview setFrame:CGRectMake(10,39,delegate.windowWidth-20,0)];
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
    delegate.filterBtnTapped = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

/**** Add close to close the navigation  ****/

-(void)adddoneBtnClicked
{
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:0 withObject:[delegate.advanceCategorySearchArray objectAtIndex:0]];//latitude
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:1 withObject:[delegate.advanceCategorySearchArray objectAtIndex:1]];//longitude
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:2 withObject:[delegate.advanceCategorySearchArray objectAtIndex:2]];//address
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:3 withObject:@"0"];//distance
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:4 withObject:@""];//postwithin
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:5 withObject:@""];//sortby
    [delegate.CategoryDictForCatIDtemp removeAllObjects];
    [advanceSearchPageTabel reloadData];
}

//Save button Tapped

- (IBAction)saveBtnTapped:(id)sender
{
    [self.view endEditing:YES];
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:0 withObject:[delegate.advanceCategorySearchtempArray objectAtIndex:0]];
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:1 withObject:[delegate.advanceCategorySearchtempArray objectAtIndex:1]];
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:2 withObject:[delegate.advanceCategorySearchtempArray objectAtIndex:2]];
    if (![[delegate.advanceCategorySearchtempArray objectAtIndex:3]isEqualToString:@""])
    {
        NSString *distanceStr = [NSString stringWithFormat:@"within %@ %@",[delegate.advanceCategorySearchtempArray objectAtIndex:3],delegate.distancestring] ;
    }
    else
    {
        [delegate.advanceCategorySearchArray replaceObjectAtIndex:3 withObject:[delegate.advanceCategorySearchtempArray objectAtIndex:3]];
    }
    
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:4 withObject:[delegate.advanceCategorySearchtempArray objectAtIndex:4]];
    [delegate.advanceCategorySearchArray replaceObjectAtIndex:5 withObject:[delegate.advanceCategorySearchtempArray objectAtIndex:5]];
    [delegate.CategoryDictForCatID removeAllObjects];
    delegate.CategoryDictForCatID = [delegate.CategoryDictForCatIDtemp mutableCopy];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - slider distance trigger to display values

- (IBAction)sliderValueChanged:(id)sender
{
    [self updateSliderPopoverText];
    if(slider.value<1){
        
        [mileimg setImage:[UIImage imageNamed:@"mileimgDisable.png"]];
        
        [milelable setBackgroundColor:graycolor];
        [milelable setText:[NSString stringWithFormat:@"Not set"]];
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

- (void)updateSliderPopoverText
{
    self.slider.popover.textLabel.text = [NSString stringWithFormat:@"  %.0f KM %@", self.slider.value,@"  "];
    [self.view bringSubviewToFront:self.slider.popover.textLabel];
    [delegate.advanceCategorySearchtempArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%.0f", self.slider.value]];
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
    
    //    [mileimg setFrame:CGRectMake((slider.value*(slider.frame.size.width/100))+20, 10, 50, 25)];
    [milelable setFrame:CGRectMake(popoverRect.origin.x,popoverRect.origin.y,50,20)];
}




#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [FilterView release];
    [SaveFilter release];
    [super dealloc];
}

@end
