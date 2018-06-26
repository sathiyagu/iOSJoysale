//
//  LanguagePage.m
//  HSJoysale
//
//  Created by HitasoftMac2 on 12/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "LanguagePage.h"
#import "JsonParsing.h"
@interface LanguagePage ()

@end

@implementation LanguagePage

- (void)viewDidLoad {
    //Initalization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //Appearance
    if (isAboveiOSVersion7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    //Properties
    [MainView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [LanguageTableView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight)];
    [LanguageTableView setBackgroundColor:BackGroundColor];
    
    LanguageArray = [[NSMutableArray alloc]initWithCapacity:0];
    [LanguageArray addObject:@"English"];
    [LanguageArray addObject:@"French"];
//    [LanguageArray addObject:@"German"];
//    [LanguageArray addObject:@"Spanish"];
//    [LanguageArray addObject:@"Swedish"];
    [LanguageArray addObject:@"Arabic"];

    
    [LanguageTableView reloadData];
    
    [self barButtonFunction];
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
    [titleLabel setText:[delegate.languageDict objectForKey:@"language"]];
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

#pragma mark TableViewDataSource
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
    return [LanguageArray count];
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
    
    UILabel * languageLbl = [[[UILabel alloc]init]autorelease];
    [languageLbl setFrame:CGRectMake(10,0,delegate.windowWidth-20,51)];
    [languageLbl setText:[LanguageArray objectAtIndex:indexPath.row]];
    [languageLbl setBackgroundColor:clearcolor];
    [languageLbl setTextColor:AppTextColor];
    [languageLbl setFont:[UIFont fontWithName:appFontRegular size:16]];
    [contentview addSubview:languageLbl];
    
    UIImageView *checkiconimg = [[[UIImageView alloc] init] autorelease];
    [checkiconimg setFrame:CGRectMake(delegate.windowWidth-40, 15, 20, 20)];
    if ([delegate.languageSelected isEqualToString:[LanguageArray objectAtIndex:indexPath.row]]) {
        [languageLbl setTextColor:AppThemeColor];
        [checkiconimg setImage:[UIImage imageNamed:@"checkicon.png"]];
        [contentview addSubview:checkiconimg];
    }
    
    [contentview setFrame:CGRectMake(0,0,delegate.windowWidth-0,50)];
    [lineviewbottom setFrame:CGRectMake(0,55,delegate.windowWidth,5)];
    //[contentview addSubview:lineviewbottom];
    
    UIView * lineview = [[[UIView alloc]init]autorelease];
    [lineview setBackgroundColor:BackGroundColor];
    [lineview setFrame:CGRectMake(0,50,contentview.frame.size.width,1)];
   // [contentview addSubview:lineview];
    
    [cell.contentView addSubview:contentview];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApiControllerServiceProxy *proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    delegate.languageSelected=[LanguageArray objectAtIndex:indexPath.row];
    delegate.langchangeFlag = YES;
    [[NSUserDefaults standardUserDefaults]  setObject:[LanguageArray objectAtIndex:indexPath.row] forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self languageChangeFunction:[LanguageArray objectAtIndex:indexPath.row]];
    if ([delegate.devicetokenArray count]!=0)
    {
    [proxy adddeviceid:apiusername :apipassword :[delegate.devicetokenArray objectAtIndex:0] :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@"0" :[delegate.devicetokenArray objectAtIndex:0] :devicemodeValue :[delegate gettingLanguageCode]];
    }
    else
    {
        [proxy adddeviceid:apiusername :apipassword :@"aaa" :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :@"0" :@"aaa" :devicemodeValue :[delegate gettingLanguageCode]];
        
    }

}

-(void) languageChangeFunction:(NSString*) language
{
    [delegate.languageDict removeAllObjects];
    NSError *error;
    NSData *languagedata=[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:delegate.languageSelected ofType:@"json"]];
    
    [delegate.languageDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:languagedata options:kNilOptions error:&error]];
    [LanguageTableView reloadData];
   // [self performSelectorOnMainThread:@selector(checkadmindatasapi) withObject:nil waitUntilDone:YES];
 }

-(void)checkadmindatasapi
{
    ApiControllerServiceProxy *adminproxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    [adminproxy admindatas:apiusername :apipassword :[delegate gettingLanguageCode] ];
}

-(void)proxyRecievedError:(NSException*)ex InMethod:(NSString*)method{
    NSLog(@"Exeption in service %@",method);
}

//proxy finished, (id)data is the object of the relevant method service
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString*)method
{
    NSLog(@"Service %@ Done!",method);
    
   
    
}


#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [MainView release];
    [LanguageTableView release];
    [super dealloc];
}

@end
