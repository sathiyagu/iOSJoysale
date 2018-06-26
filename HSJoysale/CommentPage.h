//
//  CommentPage.h
//  HSJoysale
//
//  Created by BTMani on 04/01/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BLMultiColorLoader.h"

@interface CommentPage : UIViewController<UITableViewDelegate,UITableViewDataSource,Wsdl2CodeProxyDelegate,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
{
    //Class object declaration
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;
    CGRect kKeyBoardFrame;

    //Variable declaration
    NSMutableArray * commentArray;
    NSMutableArray * itemIdArray;
    NSDateFormatter * dateFormatter; // Date formater for format unix time stamp to date

    //UI Declaration
    IBOutlet UITableView * commenttableView;
    IBOutlet UIView * commentView;
    IBOutlet UITextView * commentTextField;
    IBOutlet UIButton * commentButton;
    IBOutlet UIView *Mainview;
    UIView *loadingErrorViewBG;
    
    int commentIndex;
}

-(IBAction)commentBtnTapped:(id)sender;
-(void) loadingComment:(NSString*)itemId;
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;

@end
