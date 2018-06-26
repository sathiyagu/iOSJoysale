//
//  FilterSubcategory.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 13/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "FilterSubcategory.h"

@interface FilterSubcategory ()

@end

@implementation FilterSubcategory

- (void)viewDidLoad {
    
    //Initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    //Appearance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];

    //Properties
    [categoryTable setFrame:CGRectMake(0,60,delegate.windowWidth,delegate.windowHeight-115)];
    [categoryTable setBackgroundColor:BackGroundColor];
    [categoryTable reloadData];
    
    UILabel * categoryName = [[[UILabel alloc]init]autorelease];
    [categoryName setText:[delegate.filterCategoryArray objectAtIndex:1]];
    [categoryName setTextColor:headercolor];
    [categoryName setFont:[UIFont fontWithName:appFontRegular size:20]];
    [categoryName setFrame:CGRectMake(10,10,delegate.windowWidth-20,50)];
    [categoryName setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:categoryName];
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [categoryName setTextAlignment:NSTextAlignmentRight];
    }
    //Function Call
    [self barButtonFunction];
    [super viewDidLoad];
    
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void) viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];

    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
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
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:backBtn];
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"Categories"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [leftNaviNaviButtonView addSubview:titleLabel];

    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark Back Button tapped

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
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[delegate.filterSubcategoryDic objectForKey:@"subcategory"] count]+1;
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    int indexrow = (int) indexPath.row ;
    
    UIView * contentview = [[[UIView alloc]init]autorelease];
    [contentview setBackgroundColor:whitecolor];
    [contentview setFrame:CGRectMake(0,0,delegate.windowWidth,50)];
    
    UIImageView *Checkicon = [[[UIImageView alloc] init] autorelease];
    //[Checkicon setImage:[UIImage imageNamed:@"uncheckicon.png"]];
    [Checkicon setContentMode:UIViewContentModeScaleAspectFit];
    [Checkicon setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
    [contentview addSubview:Checkicon];
    
    UILabel * contentLable = [[[UILabel alloc]init]autorelease];
    [contentLable setFrame:CGRectMake(10,0,((contentview.frame.size.width))-13,50)];
    [contentLable setBackgroundColor:[UIColor clearColor]];
    [contentLable setFont:[UIFont fontWithName:appFontRegular size:15]];
    if(indexrow==0){
        [contentLable setText:[delegate.languageDict objectForKey:@"allproducts"]];

    }else{
    [contentLable setText:[[[delegate.filterSubcategoryDic objectForKey:@"subcategory"]objectAtIndex:indexrow-1]objectForKey:@"sub_name"]];
    }
    [contentLable setTextColor:headercolor];
    [contentLable setTextAlignment:NSTextAlignmentLeft];
    [contentview addSubview:contentLable];
    
    if(indexPath.row==0){
        if([[delegate.HomeDictForCatIDtemp objectForKey:[delegate.filterSubcategoryDic objectForKey:@"category_id"]] isEqual:@"0"]){
            
            [Checkicon setImage:[UIImage imageNamed:@"checkicon.png"]];
            [contentLable setTextColor:AppThemeColor];
        }else{
            //[Checkicon setImage:[UIImage imageNamed:@"uncheckicon.png"]];
            [contentLable setTextColor:headercolor];
        }
    }
    else{
        if([[delegate.HomeDictForCatIDtemp objectForKey:[delegate.filterSubcategoryDic objectForKey:@"category_id"]] intValue]==[[[[delegate.filterSubcategoryDic objectForKey:@"subcategory"]objectAtIndex:indexPath.row-1]objectForKey:@"sub_id"] intValue]){
            [Checkicon setImage:[UIImage imageNamed:@"checkicon.png"]];
            [contentLable setTextColor:AppThemeColor];
        }else{
            //[Checkicon setImage:[UIImage imageNamed:@"uncheckicon.png"]];
            [contentLable setTextColor:headercolor];
        }
    }
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [Checkicon setFrame:CGRectMake(10, 15, 20, 20)];
        [contentLable setFrame:CGRectMake(50,0,((contentview.frame.size.width))-63,50)];
        [contentLable setTextAlignment:NSTextAlignmentRight];
    }
    UIView * lineview = [[[UIView alloc]init]autorelease];
    [lineview setBackgroundColor:lineviewColor];
    [lineview setFrame:CGRectMake(0,50,contentview.frame.size.width,0.7)];
    [contentview addSubview:lineview];
    
    [cell.contentView addSubview:contentview];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}


#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        if([[delegate.HomeDictForCatIDtemp objectForKey:[delegate.filterSubcategoryDic objectForKey:@"category_id"]] isEqual:@"0"]){
            [delegate.HomeDictForCatIDtemp removeObjectForKey:[delegate.filterSubcategoryDic objectForKey:@"category_id"]];
        }
        else{
            [delegate.HomeDictForCatIDtemp setValue:@"0" forKey:[delegate.filterSubcategoryDic objectForKey:@"category_id"]];
        }
    }else{
        if([[delegate.HomeDictForCatIDtemp objectForKey:[delegate.filterSubcategoryDic objectForKey:@"category_id"]] intValue]==[[[[delegate.filterSubcategoryDic objectForKey:@"subcategory"]objectAtIndex:indexPath.row-1]objectForKey:@"sub_id"] intValue]){
            [delegate.HomeDictForCatIDtemp removeObjectForKey:[delegate.filterSubcategoryDic objectForKey:@"category_id"]];
        }else{
            [delegate.HomeDictForCatIDtemp setValue:[[[delegate.filterSubcategoryDic objectForKey:@"subcategory"] objectAtIndex:indexPath.row-1]objectForKey:@"sub_id"] forKey:[delegate.filterSubcategoryDic objectForKey:@"category_id"]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
