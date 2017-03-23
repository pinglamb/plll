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
#import "PLLAlgorithms.h"

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
    [self display];

    self.pllCaseLabel.hidden = YES;
    self.reasonsLabel.hidden = YES;
    self.algoSectionView.hidden = YES;
    self.showAnswerButton.hidden = NO;
    self.randomButton.hidden = YES;
}

- (IBAction)randomDidTap:(UIButton *)sender {
    [self generateAndShow];
}

- (IBAction)showDidTap:(UIButton *)sender {
    [self recognize];
    self.pllCaseLabel.hidden = NO;
    self.reasonsLabel.hidden = NO;
    self.algoSectionView.hidden = NO;
    self.showAnswerButton.hidden = YES;
    self.randomButton.hidden = NO;
}

- (IBAction)didPressFirstPatchButton:(UIButton *)sender {
    self.selectedButton = sender;
    self.selectedIndex = 0;
    [self presentPicker];
}

- (IBAction)didPressSecondPatchButton:(UIButton *)sender {
    self.selectedButton = sender;
    self.selectedIndex = 1;
    [self presentPicker];
}
- (IBAction)didPressThirdPatchButton:(UIButton *)sender {
    self.selectedButton = sender;
    self.selectedIndex = 2;
    [self presentPicker];
}
- (IBAction)didPressFourthPatchButton:(UIButton *)sender {
    self.selectedButton = sender;
    self.selectedIndex = 3;
    [self presentPicker];
}
- (IBAction)didPressFifthPatchButton:(UIButton *)sender {
    self.selectedButton = sender;
    self.selectedIndex = 4;
    [self presentPicker];
}
- (IBAction)didPressSixthPatchButton:(UIButton *)sender {
    self.selectedButton = sender;
    self.selectedIndex = 5;
    [self presentPicker];
}

- (void)presentPicker {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"Red" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self updateColor:@"R"];
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"Green" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self updateColor:@"G"];
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"Orange" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self updateColor:@"O"];
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"Blue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self updateColor:@"B"];
    }]];

    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)updateColor:(NSString *)color {
    [self.sixColors replaceObjectAtIndex:self.selectedIndex withObject:color];
    [self display];
    [self recognize];
}

- (void) display {
    [self.firstColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[0]]];
    [self.secondColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[1]]];
    [self.thirdColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[2]]];
    [self.fourthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[3]]];
    [self.fifthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[4]]];
    [self.sixthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[5]]];
}

- (void) recognize {
    PLLRecognizer *recognizer = [[PLLRecognizer alloc] init];
    PLLCase pll = [recognizer recognize:self.sixColors];
    [self.reasonsLabel setText:[recognizer.steps componentsJoinedByString:@"\n"]];
    [self.reasonsLabel sizeToFit];
    [self.pllCaseLabel setText:PLLNames[pll]];

    [self.adjustmentLabel setText:[NSString stringWithFormat:@"Align: [%@]", [recognizer adjustmentText]]];
    [self.algoLabel setText:[PLLAlgorithms forPLL:pll]];
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
