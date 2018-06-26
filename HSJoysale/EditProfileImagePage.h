//
//  EditProfileImagePage.h
//  HSJoysale
//
//  Created by HitasoftMac2 on 05/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKImagePickerViewController.h"

@class AppDelegate;

@interface EditProfileImagePage : UIViewController<UINavigationControllerDelegate>
{
    //Class Declaration
    AppDelegate * delegate;
    

    //UI Declaration
    UIButton * camerabutton;
    UIButton *flashbutton;
    UIButton *frontcamera;
}

@property (retain, nonatomic) IBOutlet UIView *frameForCapture;
@property (retain, nonatomic) IBOutlet UIImageView *userImageView;
@property (retain, nonatomic) IBOutlet UIButton *retakeButton;
@property (retain, nonatomic) IBOutlet UIButton *usePhotoButton;
@property (strong, nonatomic) UIImage *imageForUser;
- (IBAction)retakeButtonTapped:(id)sender;
- (IBAction)usePhotoButtonTapped:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
