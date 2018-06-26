//
//  MyImagePickerViewController.h
//  cameratestapp
//
//  Created by pavan krishnamurthy on 6/24/14.
//  Copyright (c) 2014 pavan krishnamurthy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@protocol PKImagePickerViewControllerDelegate <NSObject>

-(void)imageSelected:(UIImage*)img;
-(void)imageSelectionCancelled;

@end

@interface PKImagePickerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //Class Declaration
    AppDelegate * delegate;
    
    //Variable Declaration
    NSMutableArray *selectedImageArray;
    
    //UI Declaration
    UIButton *flashbutton;
    UIButton *frontcamera;
    UIButton *camerabutton;
    UIButton *nextButton;
}
@property(nonatomic,strong) id<PKImagePickerViewControllerDelegate> delegate;

@end
