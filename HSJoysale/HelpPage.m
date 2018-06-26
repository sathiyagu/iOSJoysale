//
//  HelpPage.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 16/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

/*
 * Help page for show web Information like terms and conditions
 * Profile page > More button tapped > help
 * This help page show for login user only.
 */

#import "HelpPage.h"
#import "HelpDetailPage.h"
@interface HelpPage ()

@end

@implementation HelpPage

- (void)viewDidLoad {
    
    //Initialize
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    
    HelpArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //Appearance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:BackGroundColor];
    [self.navigationController setNavigationBarHidden:NO];
    
    //Properties
    HelpTableView = [[UITableView alloc] init];
    HelpTableView.delegate=self;
    HelpTableView.dataSource=self;
    [HelpTableView setBackgroundColor:BackGroundColor];
    [HelpTableView reloadData];
    [HelpTableView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight-110)];
    [HelpTableView setSeparatorColor:clearcolor];
    [self.view addSubview:HelpTableView];
    
    loadingErrorViewBG = [[UIView alloc]init];
    loadingErrorViewBG.frame = CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];

   
    //Functions
    [self barButtonFunction];
    [self noItemFindFunction];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }
    else{
        [proxy helppage:apiusername :apipassword];
    }
    
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
    [titleLabel setText:[delegate.languageDict objectForKey:@"help"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark- barButtonFunctions

-(void)backBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - If no data in parsing it show alert

-(void) noItemFindFunction
{
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
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"No Help to be Displayed"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    [HelpTableView addSubview:loadingErrorViewBG];
}

#pragma mark - show and hide noitemfound

-(void)checkIfhavsData
{
    if ([HelpArray count]==0)
    {
        [loadingErrorViewBG setHidden:NO];
    }
    else
    {
        [loadingErrorViewBG setHidden:YES];
    }
}


#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [HelpArray count];
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

    UIView * contentview = [[[UIView alloc]init]autorelease];
    [contentview setBackgroundColor:[UIColor whiteColor]];
    [contentview setFrame:CGRectMake(0,0,delegate.windowWidth,50)];
    
    UILabel * contentLable = [[[UILabel alloc]init]autorelease];
    [contentLable setFrame:CGRectMake(15,0,((contentview.frame.size.width))-13,50)];
    [contentLable setBackgroundColor:[UIColor clearColor]];
    [contentLable setFont:[UIFont fontWithName:appFontRegular size:15]];
    [contentLable setText:[[HelpArray objectAtIndex:indexPath.row] objectForKey:@"page_name"]];
    [contentLable setTextColor:headercolor];
    [contentLable setTextAlignment:NSTextAlignmentLeft];
    [contentview addSubview:contentLable];
    
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [contentLable setFrame:CGRectMake(45,0,((contentview.frame.size.width))-53,50)];
        [contentLable setTextAlignment:NSTextAlignmentRight];
        UIImageView *arrowImg = [[[UIImageView alloc] init] autorelease];
        [arrowImg setImage:[UIImage imageNamed:@"OutArrowImg.png"]];
        [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
        [arrowImg setFrame:CGRectMake(5, 15, 20, 20)];
        [contentview addSubview:arrowImg];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    HelpDetailPage * helpDetailPageObj = [[HelpDetailPage alloc]initWithNibName:@"HelpDetailPage" bundle:nil];
    [helpDetailPageObj loadcontent:[HelpArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:helpDetailPageObj animated:YES];
}

#pragma mark - WSDL DelegateMethod

//proxy finished, (id)data is the object of the relevant method service
-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method{
    NSLog(@"Service %@ Done!",method);
//    NSLog(@"data:%@",data);
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    [defaultDict addEntriesFromDictionary:[delegate.defensiveClassObj helpPageData:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]]];
    [HelpArray addObjectsFromArray:[[defaultDict objectForKey:@"result"] objectForKey:@"helpdata"]];
    [HelpTableView reloadData];
    [self checkIfhavsData];
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [HelpTableView release];
    [super dealloc];
}
@end
