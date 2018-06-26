//
//  AddproductCondition.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 05/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//
/*
 * For selecting product condition depend on category from add or edit product
 */
#import "AddproductCondition.h"

@interface AddproductCondition ()

@end

@implementation AddproductCondition

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
    [ProductconditionTableview setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-65)];

    //Functionality
    ConditionTypeArray =  [[NSMutableArray alloc]initWithCapacity:0];
    [ConditionTypeArray addObject:@"New"];
    [ConditionTypeArray addObject:@"Used"];
    [ConditionTypeArray addObject:@"Light Used"];
    [ConditionTypeArray addObject:@"Damaged"];
    //Function call
    [self barButtonFunction];
    
    [ProductconditionTableview reloadData];
    
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
    [titleLabel setText:[delegate.languageDict objectForKey:@"itemcondition"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark Back Button action

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
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[delegate.addcategoryFilterDict objectForKey:@"product_condition"] count];
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
    
    UIView * contentview = [[[UIView alloc]init]autorelease];
    [contentview setBackgroundColor:whitecolor];
    
    UIView * lineviewbottom = [[[UIView alloc]init]autorelease];
    [lineviewbottom setBackgroundColor:BackGroundColor];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UILabel * subcategoryLbl = [[[UILabel alloc]init]autorelease];
    [subcategoryLbl setFrame:CGRectMake(20,0,delegate.windowWidth-40,50)];
    [subcategoryLbl setText:[[[delegate.addcategoryFilterDict objectForKey:@"product_condition"] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [subcategoryLbl setTextColor:headercolor];
    [subcategoryLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
    [contentview addSubview:subcategoryLbl];
    
    UIImageView *checkiconimg = [[[UIImageView alloc] init] autorelease];
    [checkiconimg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
    if ([[delegate.postProductArray objectAtIndex:6] isEqualToString:[[[delegate.addcategoryFilterDict objectForKey:@"product_condition"] objectAtIndex:indexPath.row] objectForKey:@"name"]]) {
        [subcategoryLbl setTextColor:AppThemeColor];
        [checkiconimg setImage:[UIImage imageNamed:@"checkicon.png"]];
        [contentview addSubview:checkiconimg];
    }
    
    [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,51)];
    [lineviewbottom setFrame:CGRectMake(20,50,delegate.windowWidth-20,0.7)];
    //[contentview addSubview:lineviewbottom];
    
    UIView * lineview = [[[UIView alloc]init]autorelease];
    [lineview setBackgroundColor:lineviewColor];
    [lineview setFrame:CGRectMake(20,50,contentview.frame.size.width-40,1)];
    //[contentview addSubview:lineview];
    
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [subcategoryLbl setTextAlignment:NSTextAlignmentRight];
        [checkiconimg setFrame:CGRectMake(10, 10, 30, 30)];
    }
    [cell.contentView addSubview:contentview];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}


#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate.postProductArray replaceObjectAtIndex:6 withObject:[[[delegate.addcategoryFilterDict objectForKey:@"product_condition"] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [ProductconditionTableview reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [MainView release];
    [ProductconditionTableview release];
    [super dealloc];
}
@end
