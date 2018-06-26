//
//  AdvanceSearchPage.h
//  HSJoysale
//
//  Created by BTMANI on 17/12/14.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface AdvanceSearchPage : UIViewController<UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate,UIGestureRecognizerDelegate,Wsdl2CodeProxyDelegate>
{
    
    //Class object Declaration
    AppDelegate * delegate;

    //Variable Declaration
    NSMutableArray *postwithinArray;
    NSMutableArray *shortbyArray;

    //UI Declaration
    IBOutlet UITableView * advanceSearchPageTabel;
    IBOutlet UIView *FilterView;
    IBOutlet UIButton *SaveFilter;

    //For Slider distance
    UIImageView *homeimg;
    UIImageView *designimg;
    UIImageView *mileimg;
    UILabel *milelable;
}
- (IBAction)saveBtnTapped:(id)sender;

@end
