//
//  CommentPage.m
//  HSJoysale
//
//  Created by BTMani on 04/01/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "CommentPage.h"
#import "NewProfilePage.h"
#import "NSDate+DateMath.h"

#define CommentMAX_LENGTH 120
@interface NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end


@interface CommentPage ()

@end

@implementation CommentPage

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Initialization
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    commentArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //Appearance
    
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];

    //Properties
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    [Mainview setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-64)];
    [commenttableView setBackgroundColor:BackGroundColor];
   // [commentView setBackgroundColor:[UIColor whiteColor]];
    commentTextField.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 20);
    [commentTextField setText:[delegate.languageDict objectForKey:@"addcomments"]];
    [commentTextField setTextColor:CommentDaysTextColor];
    [commentButton setBackgroundColor:AppThemeColor];

    commentButton.layer.masksToBounds=YES;
    commentButton.layer.cornerRadius=5;
    
    commentTextField.layer.masksToBounds=YES;
    commentTextField.layer.cornerRadius=7;
    
    [commentButton setTitle:[delegate.languageDict objectForKey:@"send"] forState:UIControlStateNormal];
    
    loadingErrorViewBG = [[UIView alloc]init];
    loadingErrorViewBG.frame = CGRectMake(0, 0, 320, 517);
    [loadingErrorViewBG setBackgroundColor:[UIColor clearColor]];
    [loadingErrorViewBG setHidden:YES];
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [commentTextField setTextAlignment:NSTextAlignmentRight];
        [commentButton setFrame:CGRectMake(10, commentButton.frame.origin.y, commentButton.frame.size.width, commentButton.frame.size.height)];
        [commentTextField setFrame:CGRectMake(commentButton.frame.size.width+15, commentTextField.frame.origin.y, commentTextField.frame.size.width, commentTextField.frame.size.height)];
    }
    [commentButton setTitleColor:AppThemeColor forState:UIControlStateNormal];

    [commentButton.titleLabel setFont:ButtonFont];
    [commentTextField setFont:[UIFont fontWithName:appFontRegular size:15]];
    //FunctionCall
    [self noItemFindFunction];
    [self barButtonFunction];
    

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
-(void) viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];

    //Appearance
    [self.view setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight+100)];

    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];
    [self.navigationController setNavigationBarHidden:NO];
    [self barButtonFunction];

}

#pragma mark - NaviagationBar customization

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
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:clearcolor];
    [backBtn setTag:1000];
    [backBtn setFrame:CGRectMake(0+[HSUtility adjustablePadding],2,45,40)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:backBtn];
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"comments"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:clearcolor];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:16]];
    [titleLabel setFrame:CGRectMake(55+[HSUtility adjustablePadding],5,100,34)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [leftNaviNaviButtonView addSubview:titleLabel];

    UILabel * UserName = [[[UILabel alloc]init]autorelease];
    [UserName setText:[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_name"]];
    [UserName setTextColor:[UIColor whiteColor]];
    [UserName setBackgroundColor:clearcolor];
    [UserName setFont:[UIFont fontWithName:appFontRegular size:14]];
    [UserName setFrame:CGRectMake((delegate.windowWidth/2)+[HSUtility adjustablePadding],5,(delegate.windowWidth/2)-55,34)];
    [UserName setTextAlignment:NSTextAlignmentRight];
    [leftNaviNaviButtonView addSubview:UserName];

    UIImageView * UserImage = [[[UIImageView alloc] init] autorelease];
    [UserImage setBackgroundColor:AppThemeColor];
    [UserImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]objectForKey:@"seller_img"]]]placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
    [UserImage setFrame:CGRectMake(delegate.windowWidth-50+[HSUtility adjustablePadding], 2.5, 35, 35)];
    [UserImage setContentMode:UIViewContentModeScaleAspectFill];
    UserImage.layer.masksToBounds=YES;
    UserImage.layer.cornerRadius=17.5;
    [leftNaviNaviButtonView addSubview:UserImage];

    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark - Loading Progresswheel Initialize

-(void) loadingIndicator
{
    if (delegate==nil)
    {
        delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    }
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
#pragma mark - show and hide noitemfound

-(void)checkIfhavsData
{
    if ([commentArray count]==0)
    {
        [loadingErrorViewBG setHidden:NO];
    }
    else
    {
        [loadingErrorViewBG setHidden:YES];
    }
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
    [noItemFindLabel setText:[delegate.languageDict objectForKey:@"nocommentfound"]];
    [noItemFindLabel setTextColor:NoItemFindColor];
    [noItemFindLabel setFont:[UIFont fontWithName:appFontBold size:16]];
    [loadingErrorViewBG addSubview:noItemFindLabel];
    noItemFindLabel.frame = CGRectMake(delegate.windowWidth/2-125,sorryTextLabel.frame.size.height+sorryTextLabel.frame.origin.y,250,30);
    [noItemFindLabel setTextAlignment:NSTextAlignmentCenter];
    [commenttableView addSubview:loadingErrorViewBG];
}
#pragma mark - back Button Clicked

-(void)backBtnClicked
{
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Loading comment parsing Function

-(void) loadingComment:(NSString*)itemIdval
{
    [self loadingIndicator];
    [self performSelectorOnMainThread:@selector(startLoadig) withObject:nil waitUntilDone:YES];
    itemIdArray = [[NSMutableArray alloc]init];
    [itemIdArray addObject:[NSString stringWithFormat:@"%@",itemIdval]];
    [self getcommentsApi];
}

#pragma mark - call API

-(void)getcommentsApi
{
    proxy = [[ApiControllerServiceProxy alloc]initWithUrl:siteurl AndDelegate:self];
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
    [proxy getcomments:apiusername :apipassword :[itemIdArray objectAtIndex:0]];
    }
}


#pragma mark - Post Comment 

-(IBAction)commentBtnTapped:(id)sender
{
    [loadingErrorViewBG setHidden:YES];
    [self.view bringSubviewToFront:commenttableView];
    NSString *trimmedString = [commentTextField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    [commentTextField resignFirstResponder];
    //    -(void)postcomment:(NSString *)api_username :(NSString *)api_password :(NSString *)comment :(NSString *)user_id :(NSString *)item_id ;

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]==NULL)
    {
        [self showAlertconroll:@"Please login to post comment" subject:[delegate.languageDict objectForKey:@"alert"] tag:0];
        [self checkIfhavsData];

    }
    else if ([commentTextField.text isEqualToString:[delegate.languageDict objectForKey:@"addcomments"]] || commentTextField.textColor==CommentDaysTextColor || trimmedString.length==0)
    
    {
        [self showAlertconroll:@"Please enter some comment" subject:[delegate.languageDict objectForKey:@"alert"] tag:0];
        [self checkIfhavsData];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(postCommandfunction) withObject:nil waitUntilDone:YES];
        [commenttableView reloadData];
    }
}

#pragma mark PostComment API Send

-(void) postCommandfunction
{
    if ([delegate connectedToNetwork] == NO)
    {
        [delegate networkError];
    }else{
    [proxy postcomment:apiusername :apipassword :commentTextField.text:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[itemIdArray objectAtIndex:0]];
    
    [commentTextField setText:[delegate.languageDict objectForKey:@"addcomments"]];
    commentTextField.textColor = [UIColor lightGrayColor]; //optional
    }
}

#pragma mark - FrameChanges

/**
 This function is used to assign the keyboard frame based on screen size
 */
-(void)keyboardFrameDidChange:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    
    kKeyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [commentView setFrame:CGRectMake(0,kKeyBoardFrame.origin.y-126,delegate.windowWidth, 50)];
    [UIView commitAnimations];
    [self.view bringSubviewToFront:commentView];
    
}

#pragma mark - Textfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return commentTextField.text.length + (string.length - range.length) <= 120;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:[delegate.languageDict objectForKey:@"addcomments"]] || textView.textColor==CommentDaysTextColor)
    {
        textView.text = @"";
        textView.textColor = headercolor; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{

    if ([textView.text isEqualToString:@""] || textView.textColor==headercolor) {
        textView.text = [delegate.languageDict objectForKey:@"addcomments"];
        textView.textColor = CommentDaysTextColor; //optional
    }
    [self.view endEditing:YES];
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([textView.text length]<500){
        if([textView.text length]>0){
            NSString *lastChar = [textView.text substringFromIndex:[textView.text length] - 1];
            if([lastChar isEqualToString:@" "]){
                if([text isEqualToString:lastChar]){
                    return NO;
                }
            }
        }
        if (textView.textColor==CommentDaysTextColor)
        {
            textView.text = @"";
            textView.textColor = headercolor; //optional
        }
        
        const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        
        if( ![text isEqualToString:[text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]] ) {
            [textView resignFirstResponder];
            return NO;
        }
        else  if (isBackSpace == -8)
        {
            return YES;
        }
        else if([[textView text] length] > CommentMAX_LENGTH)
        {
            return NO;
        }

    }else{
        return NO;
    }
        return YES;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark  Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==-121)
    {
        return 40;
    }
    else
    {
        NSString * commentStr;
        commentStr = [[commentArray objectAtIndex:indexPath.row]objectForKey:@"comment"];
        NSRange r;
        while ((r = [commentStr rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            commentStr = [commentStr stringByReplacingCharactersInRange:r withString:@""];
        

        CGSize nameLblSuggestedSize = [delegate.sizeMakeClass lableSuggetionSize:commentStr font:[UIFont fontWithName:appFontRegular size:16] lableWidth:delegate.windowWidth-100 lableHeight:FLT_MAX];
        if(indexPath.row==0){
            return nameLblSuggestedSize.height+70;
        }else{
        return nameLblSuggestedSize.height+73;
        }
        }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] init]autorelease];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellidentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell ==nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier]autorelease];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    
    NSString * commentStr = [[commentArray objectAtIndex:indexPath.row]objectForKey:@"comment"];
    NSRange r;
    while ((r = [commentStr rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        commentStr = [commentStr stringByReplacingCharactersInRange:r withString:@""];
    commentStr =[commentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * usernameStr =[NSString stringWithFormat:@"%@",[[commentArray objectAtIndex:indexPath.row]objectForKey:@"user_name"]];
    
    
    UIView * contentview = [[[UIView alloc]init]autorelease];
    [contentview setBackgroundColor:whitecolor];
    
    UIScrollView * imageScroll = [[[UIScrollView alloc]init] autorelease];
    [imageScroll setFrame:CGRectMake(10,10,60,60)];
    
    UIImageView * userImageview = [[[UIImageView alloc]init]autorelease];
    [userImageview setFrame:CGRectMake(0,0,60,60)];
    [userImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[commentArray objectAtIndex:indexPath.row]objectForKey:@"user_img"]]]placeholderImage:[UIImage imageNamed:@"profilelogo.png"]];
    [userImageview setContentMode:UIViewContentModeScaleAspectFill];
    userImageview.layer.cornerRadius = 30;
    userImageview.layer.masksToBounds=YES;
    if(![[[commentArray objectAtIndex:indexPath.row]objectForKey:@"user_id"] isKindOfClass:[NSNull class]])
    {
        [userImageview setTag:[[[commentArray objectAtIndex:indexPath.row]objectForKey:@"user_id"] intValue]];

    }
    [imageScroll addSubview:userImageview];
    [contentview addSubview:imageScroll];
    
    UITapGestureRecognizer *usergesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usergestureAction:)];
    [userImageview addGestureRecognizer:usergesture];
    userImageview.userInteractionEnabled = YES;
    
    UILabel * usernameLable = [[[UILabel alloc]init]autorelease];
    [usernameLable setText:usernameStr];
    [usernameLable setFont:[UIFont fontWithName:appFontRegular size:20]];
    [usernameLable setTextAlignment:NSTextAlignmentLeft];
    [usernameLable setNumberOfLines:1];
    [usernameLable setTextColor:headercolor];
    [usernameLable setFrame:CGRectMake(85,5,delegate.windowWidth-100,25)];
    [usernameLable setBackgroundColor:clearcolor];
    [contentview addSubview:usernameLable];

    UILabel * commentLable = [[[UILabel alloc] init]autorelease];
    UIFont *f = [UIFont fontWithName:appFontRegular size:16];
    commentLable.text = commentStr;
    commentLable.font = f;
    commentLable.lineBreakMode = NSLineBreakByWordWrapping;
    commentLable.numberOfLines = 0;
    commentLable.textColor = filterHeadercolor;
    [commentLable setBackgroundColor:clearcolor];
    [contentview addSubview:commentLable];

    CGSize nameLblSuggestedSize = [delegate.sizeMakeClass lableSuggetionSize:commentStr font:[UIFont fontWithName:appFontRegular size:16] lableWidth:delegate.windowWidth-100 lableHeight:FLT_MAX];
    
    [commentLable setFrame:CGRectMake(85,35,delegate.windowWidth-100,nameLblSuggestedSize.height+5)];
    
    UILabel * cmdTimeLable = [[[UILabel alloc] init]autorelease];
    UIFont *d = [UIFont fontWithName:appFontRegular size:14];
    
    
    double unixTimeStamp =[[[commentArray objectAtIndex:indexPath.row]objectForKey:@"comment_time"] doubleValue];
    NSTimeInterval timeInterval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString=[dateFormatter stringFromDate:date];
    [cmdTimeLable setText:[NSDate dateDiff:dateString]];

    
//    NSString * cmttimestr=[[commentArray objectAtIndex:indexPath.row]objectForKey:@"comment_time"];
//    if([cmttimestr isEqualToString:@" ago"]){
//        cmttimestr=@"Just now";
//    }
   // cmdTimeLable.text = cmttimestr;
    cmdTimeLable.font = d;
    cmdTimeLable.lineBreakMode = NSLineBreakByWordWrapping;
    cmdTimeLable.numberOfLines = 0;
    cmdTimeLable.textColor = CommentDaysTextColor;
    [cmdTimeLable setBackgroundColor:clearcolor];
    [cmdTimeLable setFrame:CGRectMake(85,commentLable.frame.origin.y+commentLable.frame.size.height+2,delegate.windowWidth-160,15)];
    [contentview addSubview:cmdTimeLable];
    
    UIButton * deleteButton = [UIButton new];
    [deleteButton setTitle:[delegate.languageDict objectForKey:@"delete"] forState:UIControlStateNormal];
    [deleteButton setTitle:[delegate.languageDict objectForKey:@"delete"] forState:UIControlStateSelected];
    [deleteButton setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [deleteButton setTitleColor:AppThemeColor forState:UIControlStateSelected];
    [deleteButton.titleLabel setFont:[UIFont fontWithName:appFontRegular size:14]];
    [deleteButton setTag:indexPath.row];
    [deleteButton setFrame:CGRectMake(delegate.windowWidth-70,commentLable.frame.origin.y+commentLable.frame.size.height,60,20)];
    
    if ([[[commentArray objectAtIndex:indexPath.row]objectForKey:@"user_id"]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]])
    {
        [contentview addSubview:deleteButton];
    }
    
    
    [deleteButton addTarget:self action:@selector(deleteBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTag:indexPath.row];

    
    if(indexPath.row==0){
        [contentview setFrame:CGRectMake(0,0,delegate.windowWidth, cmdTimeLable.frame.origin.y+cmdTimeLable.frame.size.height+10)];
    }else{
    [contentview setFrame:CGRectMake(0,3,delegate.windowWidth, cmdTimeLable.frame.origin.y+cmdTimeLable.frame.size.height+10)];
    }
    if([delegate.languageSelected isEqualToString:@"Arabic"]){
        [imageScroll setFrame:CGRectMake(delegate.windowWidth-70,10,60,60)];
        [usernameLable setFrame:CGRectMake(10,5,delegate.windowWidth-100,25)];
        [commentLable setFrame:CGRectMake(10,35,delegate.windowWidth-100,nameLblSuggestedSize.height+5)];
        [cmdTimeLable setFrame:CGRectMake(10,commentLable.frame.origin.y+commentLable.frame.size.height+2,delegate.windowWidth-100,15)];
        [cmdTimeLable setTextAlignment:NSTextAlignmentRight];
        [usernameLable setTextAlignment:NSTextAlignmentRight];
        [commentLable setTextAlignment:NSTextAlignmentRight];
    }
    
    [cell.contentView addSubview:contentview];

    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma  mark - Redirect to profile page

-(void)usergestureAction:(UITapGestureRecognizer *) sender
{
    if([[NSString stringWithFormat:@"%ld",(long)(UIGestureRecognizer*)[sender.view tag]] intValue]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                        message:[delegate.languageDict objectForKey:@"user_not_registered_yet"]
                                                       delegate:self
                                              cancelButtonTitle:[delegate.languageDict objectForKey:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
        
    }else
    
    {
        [delegate.userIDArray removeAllObjects];
        [delegate.userIDArray addObject:[NSString stringWithFormat:@"%ld",(long)(UIGestureRecognizer*)[sender.view tag]]];
    NewProfilePage * profilePageObj = [[NewProfilePage alloc]init];
    [profilePageObj loadingOtherUserData:[NSString stringWithFormat:@"%ld",(long)(UIGestureRecognizer*)[sender.view tag]]:@"NO"];
    [self.navigationController pushViewController:profilePageObj animated:YES];
    }
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
    
    NSLog(@"%@",data);
    
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
    if ([method isEqualToString:@"postcomment"])
    {
        delegate.commentCount+=1;
        delegate.favHomeFlag = YES;
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if ([[defaultDict objectForKey:@"status"]isEqualToString:@"true"]) {
            [commentArray addObject:defaultDict];
            int commentCount = (int)[commentArray count];
            [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"comments_count"];
        }
        else
        {
            [self showAlertconroll:@"Comment Posted Failed" subject:[delegate.languageDict objectForKey:@"failed"] tag:0];
        }
    }
    else if ([method isEqualToString:@"deletecomment"])
    {
        delegate.commentCount= delegate.commentCount-1;
        delegate.favHomeFlag = YES;
        
        NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
        [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
        if ([[defaultDict objectForKey:@"status"]isEqualToString:@"true"]) {
            [commentArray removeObjectAtIndex:commentIndex];
            int commentCount = (int)[commentArray count];
            [[delegate.detailPageArray objectAtIndex:delegate.detailArraySelectedIndex]setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"comments_count"];
        }
        else
        {
            [self showAlertconroll:[data objectForKey:@"message"] subject:[delegate.languageDict objectForKey:@"failed"] tag:0];
        }

        
        //commentIndex

    }
    else
    {
    NSMutableDictionary * defaultDict = [[NSMutableDictionary alloc]init];
    [defaultDict addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    [commentArray addObjectsFromArray:[[defaultDict objectForKey:@"result"]objectForKey:@"comments"]];
    }
    [self checkIfhavsData];

    [commenttableView reloadData];
}

#pragma  mark - Show Alert Customization

-(void) showAlertconroll:(NSString*)message subject:(NSString*)subject tag:(int)tag
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: subject
                                                                        message: message
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ok"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            
                                                                                                                    }];
    
    [controller addAction: alertAction];
    
    [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];
}

-(void)deleteBtnTapped:(id) sender
{
    int tag = (int)[sender tag];
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:[delegate.languageDict objectForKey:@"alert"]
                                                                        message:[delegate.languageDict objectForKey:@"Did you like to delete this comment?"]
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: [delegate.languageDict objectForKey:@"ok"]
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action)
    
    {
        //-(void)deletecomment:(NSString *)api_username :(NSString *)api_password :(NSString *)user_id :(NSString *)commentid {
        commentIndex = tag;
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]);
        NSLog(@"%@",[[commentArray objectAtIndex:tag]objectForKey:@"comment_id"]);

        [proxy deletecomment:apiusername :apipassword :[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"] :[[commentArray objectAtIndex:tag]objectForKey:@"comment_id"]:[itemIdArray objectAtIndex:0]];

    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[delegate.languageDict objectForKey:@"cancel"]
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            
                                                        }];

    
    [controller addAction: alertAction];
    [controller addAction: cancelAction];

    [self.view.window.rootViewController presentViewController: controller animated: YES completion: nil];

}

#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [Mainview release];
    [super dealloc];
}
@end
