//
//  RecognitionFLViewController.m
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import "RecognitionFLViewController.h"
#import "PLLRecognizer.h"

@interface RecognitionFLViewController ()

@end

@implementation RecognitionFLViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sixColors = [[NSMutableArray alloc] initWithCapacity:6];

    [self.sixColors addObject:[self.faceColors objectAtIndex:9]];
    [self.sixColors addObject:[self.faceColors objectAtIndex:10]];
    [self.sixColors addObject:[self.faceColors objectAtIndex:11]];
    [self.sixColors addObject:[self.faceColors objectAtIndex:18]];
    [self.sixColors addObject:[self.faceColors objectAtIndex:19]];
    [self.sixColors addObject:[self.faceColors objectAtIndex:20]];

    [self displayAndRecognize];
}

- (void)displayAndRecognize {
    [self.firstColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[0]]];
    [self.secondColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[1]]];
    [self.thirdColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[2]]];
    [self.fourthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[3]]];
    [self.fifthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[4]]];
    [self.sixthColorButton setBackgroundColor:[self getUIColorFromString:self.sixColors[5]]];

    PLLRecognizer *recognizer = [[PLLRecognizer alloc] init];
    PLLCase pll = [recognizer recognize:self.sixColors];
    [self.reasonsLabel setText:[recognizer.steps componentsJoinedByString:@"\n"]];
    [self.reasonsLabel sizeToFit];
    [self.pllCaseLabel setText:PLLNames[pll]];
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
    [self displayAndRecognize];
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
