//
//  CategoryAdvSearch.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 20/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface CategoryAdvSearch  : UIViewController<UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    //Class object Declaration
    AppDelegate * delegate;

    //Variable Declaration
    NSMutableArray *postwithinArray;
    NSMutableArray *shortbyArray;

    //UI Declaration
    IBOutlet UIView *FilterView;
    IBOutlet UIButton *SaveFilter;
    IBOutlet UITableView * advanceSearchPageTabel;

    //For Slider distance
    UIImageView *homeimg;
    UIImageView *designimg;
    UIImageView *mileimg;
    UILabel *milelable;

}
- (IBAction)saveBtnTapped:(id)sender;

@end
