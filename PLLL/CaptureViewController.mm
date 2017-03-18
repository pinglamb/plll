//
//  CaptureViewController.m
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import "CaptureViewController.h"
#import "CorrectionViewController.h"

@interface CaptureViewController ()

@end

@implementation CaptureViewController

@synthesize acceptedColorsArray = _acceptedColorsArray;
@synthesize computedColorsArray = _computedColorsArray;
@synthesize photoCamera = _photoCamera;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.faceImagesArray = [[NSMutableArray alloc] init];

    // Load the SVM classifier
    NSString *svmClassifierPath = [[NSBundle mainBundle] pathForResource: @"color-classification-svm-2" ofType: @"yml"];
    std::string svmClassifierPathStd = std::string([svmClassifierPath UTF8String]);
    _colorDetector.LoadSVMFromFile(svmClassifierPathStd);

    // Alloc the detected colors array
    _acceptedColorsArray = [[NSMutableArray alloc] init];

    // Setup the camera parameters (force flash and 1280x720 resolution)
    _photoCamera = [[CvPhotoCamera alloc] initWithParentView:self.cameraImageView];
    _photoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    _photoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _photoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;

    // Force the camera to use the flash (if available)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device isFlashAvailable]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = AVCaptureFlashModeOn;
            [device unlockForConfiguration];
        } else {
            NSLog(@"unable to lock device for flash configuration %@", [error localizedDescription]);
        }
    }

    // Set the camera delegate
    _photoCamera.delegate = self;

    // Start the aquisition process
    [_photoCamera start];
}

#pragma mark - Protocol CvPhotoCameraDelegate

#ifdef __cplusplus

/**
 Saves a cv::Mat image to the documents folder (you can access it via iTunes)
 @param image The cv::Mat image to be saved
 @param imageName The name of the image, without extension (ex. "accepted_image")
 */
- (void)saveMatImageToDocumentsFolder:(const cv::Mat&)image named:(NSString*)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg", imageName, photoIndex]];
    NSData *imageData = UIImageJPEGRepresentation(MatToUIImage(image), 1);
    [imageData writeToFile:appFile atomically:NO];
}

/**
 Saves an image of type <b>UIImage</b> to the documents folder (you can access it via iTunes)
 @param image The cv::Mat image to be saved
 @param imageName The name of the image, without extension (ex. "accepted_image")
 */
- (void)saveUIImageToDocumentsFolder:(UIImage*)image named:(NSString*)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg", imageName, photoIndex]];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [imageData writeToFile:appFile atomically:NO];
}

/**
 Method invoked after taking a picture (CvPhotoCameraDelegate method)
 @param photoCamera The CvPhotoCamera object
 @param image The UIImage captured by the device
 */
- (void)photoCamera:(CvPhotoCamera*)photoCamera capturedImage:(UIImage *)image {
    try {
        [_photoCamera stop];

        self.captureImageButton.hidden = YES;
        self.acceptButton.hidden = NO;
        self.rejectButton.hidden = NO;
        self.instructionsLabel.text = @"Make sure that the corners are detected properly :)";

        self.capturedImage = image;

        // Convert the UIImage to a cv::Mat object
        cv::Mat capturedImageMat;
        UIImageToMat(image, capturedImageMat);

        // Rotate clockwise 90 degrees (portrait orientation in iOS...)
        cv::transpose(capturedImageMat, capturedImageMat);
        cv::flip(capturedImageMat, capturedImageMat, 1);

        // Convert the image from RGBA (device color format) to BGR (default OpenCV color format)
        cv::Mat bgrImage, outputImage, rgbaImage;
        cv::cvtColor(capturedImageMat, bgrImage, CV_RGBA2BGR);

        // Apply the segmentation algorithm
        _cubeDetector.SegmentFaces(bgrImage, outputImage, topImage, leftImage, rightImage, YES);

        auto topColors = _colorDetector.RecognizeColors(topImage);
        auto leftColors = _colorDetector.RecognizeColors(leftImage);
        auto rightColors = _colorDetector.RecognizeColors(rightImage);

        _computedColorsArray = [[NSMutableArray alloc] init];

        std::cout << std::endl;
        for (int i = 0; i < topColors.size(); i++) {
            [_computedColorsArray addObject: [NSString stringWithCString:topColors[i].c_str() encoding:[NSString defaultCStringEncoding]]];
            std::cout << topColors[i] << " ";
        }
        std::cout << std::endl;
        for (int i = 0; i < leftColors.size(); i++) {
            [_computedColorsArray addObject: [NSString stringWithCString:leftColors[i].c_str() encoding:[NSString defaultCStringEncoding]]];
            std::cout << leftColors[i] << " ";
        }
        std::cout << std::endl;
        for (int i = 0; i < rightColors.size(); i++) {
            [_computedColorsArray addObject: [NSString stringWithCString:rightColors[i].c_str() encoding:[NSString defaultCStringEncoding]]];
            std::cout << rightColors[i] << " ";
        }

        cv::cvtColor(outputImage, rgbaImage, CV_BGR2RGBA);
        cv::cvtColor(topImage, topImage, CV_BGR2RGBA);
        cv::cvtColor(leftImage, leftImage, CV_BGR2RGBA);
        cv::cvtColor(rightImage, rightImage, CV_BGR2RGBA);

        UIImage *segmentationImage = MatToUIImage(rgbaImage);

        photoIndex++;

        self.overlayImageView.image = segmentationImage;
        self.overlayImageView.alpha = 1.0;

    } catch (const std::out_of_range &exception) {
        // TODO: display error
        std::cout << exception.what() << std::endl;

        NSString *errorMessage = [NSString stringWithUTF8String:exception.what()];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ooops :-(" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self didPressRetakeImage:nil];
        }];

        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



/// Declared to conform to the delegation pattern (not used)
- (void)photoCameraCancel:(CvPhotoCamera*)photoCamera {

}

#endif

- (IBAction)didPressCaptureImage:(UIButton *)sender {
    [_photoCamera takePicture];
}

- (IBAction)didPressRetakeImage:(UIButton *)sender {

    NSString* fileName = [NSString stringWithFormat:@"rejected_photo_%d", rand()];
    [self saveUIImageToDocumentsFolder:self.capturedImage named:fileName];

    self.instructionsLabel.text = @"Take picture with yellow facing top";

    self.overlayImageView.image = [UIImage imageNamed:@"guide"];
    self.overlayImageView.alpha = 0.5;

    [self.photoCamera start];

    self.captureImageButton.hidden = NO;
    self.acceptButton.hidden = YES;
    self.rejectButton.hidden = YES;
}

- (IBAction)didPressAcceptImage:(UIButton *)sender {
    // Add the accepted colors to the accepted array
    [_acceptedColorsArray addObjectsFromArray:_computedColorsArray];

    // Add the face images to the array
    [self.faceImagesArray addObject:MatToUIImage(topImage)];
    [self.faceImagesArray addObject:MatToUIImage(leftImage)];
    [self.faceImagesArray addObject:MatToUIImage(rightImage)];

    // Go to the correction view
    for (UIImage *faceImage in self.faceImagesArray) {
        NSString* fileName = [NSString stringWithFormat:@"color_recognition_%d", rand()];
        [self saveUIImageToDocumentsFolder:faceImage named:fileName];
    }

    [self performSegueWithIdentifier:@"correctionSegue" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual: @"correctionSegue"]) {
        CorrectionViewController *destinationVC = [segue destinationViewController];
        destinationVC.faceColors = self.acceptedColorsArray;
        destinationVC.faceImages = self.faceImagesArray;
    }
}

@end
