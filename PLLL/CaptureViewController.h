//
//  CaptureViewController.h
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#ifdef __cplusplus

#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/ios.h>
#include "EdgeBasedCubeDetector.hpp"
#include "ColorDetector.hpp"

#endif

#ifdef __OBJC__

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#endif

@interface CaptureViewController : UIViewController<CvPhotoCameraDelegate>
{
    cv::Mat currentImage, topImage, leftImage, rightImage;
    cv::Mat threeFacesImage;

    int photoIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (weak, nonatomic) IBOutlet UIImageView *overlayImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property NSMutableArray *computedColorsArray;
@property NSMutableArray *acceptedColorsArray;
@property NSMutableArray *faceImagesArray;

@property CvPhotoCamera *photoCamera;
@property EdgeBasedCubeDetector cubeDetector;
@property ColorDetector colorDetector;
@property UIImage *capturedImage;

- (void)saveMatImageToDocumentsFolder:(const cv::Mat&)image named:(NSString*)imageName;
- (void)saveUIImageToDocumentsFolder:(UIImage*)image named:(NSString*)imageName;

@property (weak, nonatomic) IBOutlet UIButton *captureImageButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;

- (IBAction)didPressCaptureImage:(UIButton *)sender;
- (IBAction)didPressRetakeImage:(UIButton *)sender;
- (IBAction)didPressAcceptImage:(UIButton *)sender;

@end
