 //
//  AddproductCategory.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 04/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * Add / edit product select category (subcategory)
 */
#import "AddproductCategory.h"

@interface AddproductCategory ()

@end

@implementation AddproductCategory

- (void)viewDidLoad {
    //Initalization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }

    //Appearance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    //Properties
    [MainView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [CategoryTableview setFrame:CGRectMake(0, 0, 120, delegate.windowHeight-65)];
    [subCategoryTableView setFrame:CGRectMake(120, 0, delegate.windowWidth-120, delegate.windowHeight-65)];
    [CategoryTableview setTag:100];
    [subCategoryTableView setTag:101];
    [CategoryTableview setShowsVerticalScrollIndicator:NO];

    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [CategoryTableview setFrame:CGRectMake(delegate.windowWidth-120, 0, 120, delegate.windowHeight-65)];
        [subCategoryTableView setFrame:CGRectMake(0, 0, delegate.windowWidth-120, delegate.windowHeight-65)];
    }
    //Functionality
    subcategoryArray =  [[NSMutableArray alloc]initWithCapacity:0];
    if([[delegate.postProductArray objectAtIndex:0] isEqualToString:@""]){
        [delegate.postProductArray replaceObjectAtIndex:0 withObject:[[[delegate.addcategoryFilterDict objectForKey:@"category"] objectAtIndex:0] objectForKey:@"category_id"]];
        [delegate.postProductArray replaceObjectAtIndex:1 withObject:@""];

        [subcategoryArray removeAllObjects];
        [subcategoryArray addObject:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:0]objectForKey:@"subcategory"]];
    }
    
    //Function call
    [self barButtonFunction];
    
    [subCategoryTableView reloadData];
    [CategoryTableview reloadData];
    [super viewDidLoad];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark Back button Tapped

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
    if(tableView.tag==100){
    return 110;
    }
    else if (tableView.tag==101){
        return 51;
    }
    return 51;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==100){
        return [[delegate.addcategoryFilterDict objectForKey:@"category"] count];
    }
    else if (tableView.tag==101){
        for(int i=0;i<[[delegate.addcategoryFilterDict objectForKey:@"category"] count];i++){
            
            if([[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"category_id"] isEqualToString:[delegate.postProductArray objectAtIndex:0]]){
                [subcategoryArray removeAllObjects];
                [subcategoryArray addObject:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:i]objectForKey:@"subcategory"]];
            }
        }
        return [[subcategoryArray objectAtIndex:0] count];
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //    UITableViewCellAccessoryDisclosureIndicator
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    if(tableView.tag==100){
        cell.accessoryType = UITableViewCellAccessoryNone;

        UIView * contentview = [[[UIView alloc]init]autorelease];
        [contentview setBackgroundColor:whitecolor];
        [contentview setFrame:CGRectMake(0,0,120,110)];
        
        UIView * Lineview = [[[UIView alloc]init]autorelease];
        [Lineview setBackgroundColor:AppThemeColor];
        [Lineview setFrame:CGRectMake(0,0,3,110)];
        
        UIImageView * arrowImageview = [[[UIImageView alloc]init]autorelease];
        [arrowImageview setFrame:CGRectMake(110,45,10,20)];
        [arrowImageview setBackgroundColor:whitecolor];
        [arrowImageview setContentMode:UIViewContentModeScaleAspectFit];
        arrowImageview.layer.masksToBounds=YES;
        [arrowImageview setImage:[UIImage imageNamed:@"trianglemark.png"]];
        
        if([[delegate.postProductArray objectAtIndex:0] isEqualToString:@""]) {
            if(indexPath.row==0){
                [contentview addSubview:Lineview];
                [contentview addSubview:arrowImageview];
            }
        }
        else if([[delegate.postProductArray objectAtIndex:0] isEqualToString:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"category_id"]]){
            [contentview addSubview:Lineview];
            [contentview addSubview:arrowImageview];
        }
        
        UIImageView * categoryImageview = [[[UIImageView alloc]init]autorelease];
        [categoryImageview setFrame:CGRectMake(20,10,70,60)];
        [categoryImageview setBackgroundColor:whitecolor];
        categoryImageview.layer.borderWidth = 0;
        categoryImageview.layer.borderColor = AdvanceSearchPageColor.CGColor;
        [categoryImageview setUserInteractionEnabled:YES];
        [categoryImageview setContentMode:UIViewContentModeScaleAspectFit];
        categoryImageview.layer.masksToBounds=YES;
        NSString *cat_imgstr = [NSString stringWithFormat:@"%@",[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"category_img"]];
        cat_imgstr = [cat_imgstr stringByReplacingOccurrencesOfString:@"resized/40"
                                                           withString:@"resized/200"];

        [categoryImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",cat_imgstr]]placeholderImage:[UIImage imageNamed:@"applogo.png"]];
        [contentview addSubview:categoryImageview];
        
        UILabel * categoryLbl = [[[UILabel alloc]init]autorelease];
        [categoryLbl setFrame:CGRectMake(10,80,100,20)];
        [categoryLbl setText:[[[delegate.addcategoryFilterDict objectForKey:@"category"]objectAtIndex:indexPath.row]objectForKey:@"category_name"]];
        [categoryLbl setTextColor:headercolor];
        [categoryLbl setTextAlignment:NSTextAlignmentCenter];
        [categoryLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
        [contentview addSubview:categoryLbl];
        
        UIView * lineviewbottom = [[[UIView alloc]init]autorelease];
        [lineviewbottom setBackgroundColor:lineviewColor];
        [lineviewbottom setFrame:CGRectMake(0,109,120,1)];
        [contentview addSubview:lineviewbottom];
        
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [Lineview setFrame:CGRectMake(117,0,3,110)];
            [arrowImageview setFrame:CGRectMake(0,45,10,20)];
            [arrowImageview setImage:[UIImage imageNamed:@"trianglemarkreverse.png"]];
        }
        
        [cell.contentView addSubview:contentview];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(tableView.tag==101){
        
        UIView * contentview = [[[UIView alloc]init]autorelease];
        [contentview setBackgroundColor:BackGroundColor];
        
        UIView * lineviewbottom = [[[UIView alloc]init]autorelease];
        [lineviewbottom setBackgroundColor:BackGroundColor];
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UILabel * subcategoryLbl = [[[UILabel alloc]init]autorelease];
        [subcategoryLbl setFrame:CGRectMake(20,0,delegate.windowWidth-40,50)];
        [subcategoryLbl setText:[[[subcategoryArray objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"sub_name"]];
        [subcategoryLbl setTextColor:headercolor];
        [subcategoryLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
        [contentview addSubview:subcategoryLbl];
        
        UIImageView *checkiconimg = [[[UIImageView alloc] init] autorelease];
        [checkiconimg setFrame:CGRectMake(delegate.windowWidth-160, 15, 20, 20)];
        if ([[delegate.postProductArray objectAtIndex:1] isEqualToString:[[[subcategoryArray objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"sub_id"]]) {
            [subcategoryLbl setTextColor:AppThemeColor];
            [checkiconimg setImage:[UIImage imageNamed:@"checkicon.png"]];
            [contentview addSubview:checkiconimg];
        }
        
        if([[subcategoryArray objectAtIndex:0] count]-1==indexPath.row){
            [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-120,51)];
            [lineviewbottom setFrame:CGRectMake(10,50,delegate.windowWidth-140,1)];
            [contentview addSubview:lineviewbottom];
        }else{
            [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-120,51)];
            [lineviewbottom setFrame:CGRectMake(20,50,delegate.windowWidth-140,1)];
            [contentview addSubview:lineviewbottom];
        }
        
        UIView * lineview = [[[UIView alloc]init]autorelease];
        [lineview setBackgroundColor:ThirdryTextColor];
        [lineview setFrame:CGRectMake(20,50,contentview.frame.size.width-20,1)];
        [contentview addSubview:lineview];
        if([delegate.languageSelected isEqualToString:@"Arabic"]){
            [checkiconimg setFrame:CGRectMake(10, 15, 20, 20)];
            [subcategoryLbl setFrame:CGRectMake(50,0,contentview.frame.size.width-60,50)];
            [subcategoryLbl setTextAlignment:NSTextAlignmentRight];
            [lineview setFrame:CGRectMake(0,50,contentview.frame.size.width-20,1)];
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
    if(tableView.tag==100){
        [delegate.postProductArray replaceObjectAtIndex:0 withObject:[[[delegate.addcategoryFilterDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"category_id"]];
        [delegate.postProductArray replaceObjectAtIndex:1 withObject:@""];
        if([[[[delegate.addcategoryFilterDict objectForKey:@"category"] objectAtIndex:indexPath.row] objectForKey:@"subcategory"] count]==0){
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if( tableView.tag==101){
        [delegate.postProductArray replaceObjectAtIndex:1 withObject:[[[subcategoryArray objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"sub_id"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [CategoryTableview reloadData];
    [subCategoryTableView reloadData];
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [subCategoryTableView release];
    [CategoryTableview release];
    [MainView release];
    [super dealloc];
}
@end
