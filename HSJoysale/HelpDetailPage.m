//
//  HelpDetailPage.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 29/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "HelpDetailPage.h"
#import "NSString+HTML.h"

@interface HelpDetailPage ()

@end

@implementation HelpDetailPage

#pragma  mark - View load

- (void)viewDidLoad {
    
    //class Initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    //Apperance
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    
    detailWebView = [[[UIWebView alloc] init] autorelease];
    detailWebView.delegate = self;
    [detailWebView setFrame:CGRectMake(0, 0, delegate.windowWidth,mainView.frame.size.height)];
    [detailWebView loadHTMLString:[[helpContent objectAtIndex:0] objectForKey:@"page_content"] baseURL:nil];
    [detailWebView.scrollView setBounces:NO];
    [detailWebView.scrollView setBouncesZoom:NO];
    
    //Properties
    [mainView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-64)];
    //[helpDetailTableview setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-64)];
    
    //Function Call
    [mainView addSubview:detailWebView];

    [self barButtonFunction];
    [super viewDidLoad];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma barButtonFunctions
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
    [titleLabel setText:[[helpContent objectAtIndex:0] objectForKey:@"page_name"]];
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

#pragma mark - TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [[[helpContent objectAtIndex:indexPath.row] objectForKey:@"page_content"] dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    
    CGSize page_contentSuggestionSize = [delegate.sizeMakeClass lableSuggetionSize:[NSString stringWithFormat:@"%@",attributedString] font:[UIFont fontWithName:appFontRegular size:16] lableWidth:delegate.windowWidth-20 lableHeight:FLT_MAX];
    
    return page_contentSuggestionSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    [contentview setBackgroundColor:clearcolor];
    [contentview setFrame:CGRectMake(0,0,delegate.windowWidth,50)];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [[[helpContent objectAtIndex:indexPath.row] objectForKey:@"page_content"] dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    
    
    NSString * page_content = [NSString stringWithFormat:@"%@",attributedString];
    page_content = [self convertHTML:page_content];
    CGSize page_contentSuggestionSize = [delegate.sizeMakeClass lableSuggetionSize:page_content font:[UIFont fontWithName:appFontRegular size:16] lableWidth:delegate.windowWidth-20 lableHeight:FLT_MAX];
    
    
    UITextView * contentTxtView = [[[UITextView alloc]init]autorelease];
    [contentTxtView setFrame:CGRectMake(10,0,delegate.windowWidth-20,page_contentSuggestionSize.height+20)];
    [contentTxtView setBackgroundColor:clearcolor];
//    [contentTxtView setFont:[UIFont fontWithName:appFontRegular size:16]];
    contentTxtView.editable = NO;
    contentTxtView.dataDetectorTypes = UIDataDetectorTypeAll;
    [contentTxtView setTextColor:headercolor];
    [contentTxtView setTextAlignment:NSTextAlignmentLeft];
    [contentTxtView setAttributedText:attributedString];
    
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [contentTxtView setTextAlignment:NSTextAlignmentRight];
    }
    
    [contentview addSubview:contentTxtView];
    [cell.contentView addSubview:contentview];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return true;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - LoadContent

-(void)loadcontent:(NSMutableArray *)helpcontent
{
    helpContent = [[NSMutableArray alloc] init];
    [helpContent addObject:helpcontent];
}

#pragma mark - Convert HTML to string format

-(NSString *)convertHTML:(NSString *)html
{
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    while ([myScanner isAtEnd] == NO) {
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        [myScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *decodedString = [html stringByDecodingHTMLEntities];
    return decodedString;
}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [mainView release];
    [helpDetailTableview release];
    [super dealloc];
}
@end
