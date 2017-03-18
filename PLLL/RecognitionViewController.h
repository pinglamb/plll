//
//  RecognitionViewController.h
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecognitionViewController : UIViewController

@property (weak, nonatomic) NSMutableArray *sixColors;

@property (weak, nonatomic) IBOutlet UIButton *firstColorButton;
@property (weak, nonatomic) IBOutlet UIButton *secondColorButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdColorButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthColorButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthColorButton;
@property (weak, nonatomic) IBOutlet UIButton *sixthColorButton;

@property (weak, nonatomic) IBOutlet UILabel *pllCaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonsLabel;

@end
