//
//  PracticeViewController.h
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *firstColorButton;
@property (weak, nonatomic) IBOutlet UIButton *secondColorButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdColorButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthColorButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthColorButton;
@property (weak, nonatomic) IBOutlet UIButton *sixthColorButton;

@property (weak, nonatomic) UIButton *selectedButton;
@property int selectedIndex;

@property (weak, nonatomic) IBOutlet UILabel *pllCaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonsLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAnswerButton;

@property (weak, nonatomic) IBOutlet UIView *algoSectionView;
@property (weak, nonatomic) IBOutlet UILabel *adjustmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *algoLabel;

- (IBAction)randomDidTap:(UIButton *)sender;
- (IBAction)showDidTap:(UIButton *)sender;

- (IBAction)didPressFirstPatchButton:(UIButton *)sender;
- (IBAction)didPressSecondPatchButton:(UIButton *)sender;
- (IBAction)didPressThirdPatchButton:(UIButton *)sender;
- (IBAction)didPressFourthPatchButton:(UIButton *)sender;
- (IBAction)didPressFifthPatchButton:(UIButton *)sender;
- (IBAction)didPressSixthPatchButton:(UIButton *)sender;

@end
