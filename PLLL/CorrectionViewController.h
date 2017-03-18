//
//  CorrectionViewController.h
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorrectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *firstPatchButton;
@property (weak, nonatomic) IBOutlet UIButton *secondPatchButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdPatchButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthPatchButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthPatchButton;
@property (weak, nonatomic) IBOutlet UIButton *sixtPatchButton;
@property (weak, nonatomic) IBOutlet UIButton *seventhPatchButton;
@property (weak, nonatomic) IBOutlet UIButton *eightPatchButton;
@property (weak, nonatomic) IBOutlet UIButton *ninethPatchButton;

@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UIButton *previousFaceButton;
@property (weak, nonatomic) IBOutlet UIButton *nextFaceButton;

@property (weak, nonatomic) UIButton *selectedButton;

@property NSInteger currentFaceIndex;
@property NSInteger currentSquareIndexInCube;

@property (weak, nonatomic) NSMutableArray *faceColors;
@property (weak, nonatomic) NSMutableArray *faceImages;

- (void) setColorsFromArray: (NSInteger) faceIndex;

/// Returns the UIColor representation from the cube face color string (ex. "R" -> [UIColor redColor])
- (UIColor*) getUIColorFromString: (NSString*) stringRepresentation;
- (void) removeAllBorders;
- (void) addBorderToButton: (UIButton*) button;

- (IBAction)didPressFirstPatchButton:(UIButton *)sender;
- (IBAction)didPressSecondPatchButton:(UIButton *)sender;
- (IBAction)didPressThirdPatchButton:(UIButton *)sender;
- (IBAction)didPressFourthPatchButton:(UIButton *)sender;
- (IBAction)didPressFifthPatchButton:(UIButton *)sender;
- (IBAction)didPressSixthPatchButton:(UIButton *)sender;
- (IBAction)didPressSeventhPatchButton:(UIButton *)sender;
- (IBAction)didPressEightPatchButton:(UIButton *)sender;
- (IBAction)didPressNinethPatchButton:(UIButton *)sender;

- (IBAction)didPressRedColorButton:(UIButton *)sender;
- (IBAction)didPressOrangeColorButton:(UIButton *)sender;
- (IBAction)didPressGreenColorButton:(UIButton *)sender;
- (IBAction)didPressBlueColorButton:(UIButton *)sender;
- (IBAction)didPressYellowColorButton:(UIButton *)sender;
- (IBAction)didPressWhiteColorButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *faceIndexLabel;
- (IBAction)didPressNextFaceButton:(id)sender;
- (IBAction)didPressPreviousFaceButton:(id)sender;

@end
