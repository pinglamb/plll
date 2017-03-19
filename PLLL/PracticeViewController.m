//
//  PracticeViewController.m
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import "PracticeViewController.h"
#import "PLLRecognizer.h"
#import "PLLGenerator.h"

@interface PracticeViewController ()

@property NSMutableArray *sixColors;

@end

@implementation PracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self generateAndShow];
}

- (void)generateAndShow {
    self.sixColors = [PLLGenerator generate];
    [self.firstColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[0]]];
    [self.secondColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[1]]];
    [self.thirdColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[2]]];
    [self.fourthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[3]]];
    [self.fifthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[4]]];
    [self.sixthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[5]]];

    self.pllCaseLabel.hidden = YES;
    self.reasonsLabel.hidden = YES;
    self.showAnswerButton.hidden = NO;
}

- (IBAction)randomDidTap:(UIButton *)sender {
    [self generateAndShow];
}

- (IBAction)showDidTap:(UIButton *)sender {
    PLLRecognizer *recognizer = [[PLLRecognizer alloc] init];
    PLLCase pll = [recognizer recognize:self.sixColors];
    [self.reasonsLabel setText:[recognizer.steps componentsJoinedByString:@"\n"]];
    [self.reasonsLabel sizeToFit];
    [self.pllCaseLabel setText:PLLNames[pll]];

    self.pllCaseLabel.hidden = NO;
    self.reasonsLabel.hidden = NO;
    self.showAnswerButton.hidden = YES;
}

- (UIColor*) getUIColorFromString: (NSString*) stringRepresentation {

    if ([stringRepresentation isEqualToString:@"R"]) return [UIColor redColor];
    if ([stringRepresentation isEqualToString:@"G"]) return [UIColor greenColor];
    if ([stringRepresentation isEqualToString:@"B"]) return [UIColor blueColor];
    if ([stringRepresentation isEqualToString:@"O"]) return [UIColor orangeColor];
    if ([stringRepresentation isEqualToString:@"W"]) return [UIColor whiteColor];
    if ([stringRepresentation isEqualToString:@"Y"]) return [UIColor yellowColor];

    return [UIColor blackColor];
}

@end
