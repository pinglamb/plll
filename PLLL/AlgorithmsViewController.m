//
//  AlgorithmsViewController.m
//  PLLL
//
//  Created by pinglamb on 20/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import "AlgorithmsViewController.h"
#import "PLLRecognizer.h"
#import "PLLAlgorithms.h"
#import "PLLTableViewCell.h"

@interface AlgorithmsViewController ()

@property NSArray *pllCases;
@end

@implementation AlgorithmsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pllCases = @[
        [NSNumber numberWithInt:PLLAa],
        [NSNumber numberWithInt:PLLAb],
        [NSNumber numberWithInt:PLLE],
        [NSNumber numberWithInt:PLLF],
        [NSNumber numberWithInt:PLLGa],
        [NSNumber numberWithInt:PLLGb],
        [NSNumber numberWithInt:PLLGc],
        [NSNumber numberWithInt:PLLGd],
        [NSNumber numberWithInt:PLLH],
        [NSNumber numberWithInt:PLLJa],
        [NSNumber numberWithInt:PLLJb],
        [NSNumber numberWithInt:PLLNa],
        [NSNumber numberWithInt:PLLNb],
        [NSNumber numberWithInt:PLLT],
        [NSNumber numberWithInt:PLLRa],
        [NSNumber numberWithInt:PLLRb],
        [NSNumber numberWithInt:PLLUa],
        [NSNumber numberWithInt:PLLUb],
        [NSNumber numberWithInt:PLLV],
        [NSNumber numberWithInt:PLLY],
        [NSNumber numberWithInt:PLLZ],
    ];

    [self.tableView setBackgroundColor:[UIColor colorWithRed:(20.0/255)green:(163.0/255) blue:(215.0/255) alpha:1]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pllCases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PLLTableViewCell"];
    PLLCase pll = [[self.pllCases objectAtIndex:indexPath.row] intValue];
    [cell.pllCaseLabel setText:PLLNames[pll]];
    [cell.algoLabel setText:[PLLAlgorithms forPLL:pll]];
    [cell.hintLabel setText:[NSString stringWithFormat:@"(Orientation: %@)", [PLLAlgorithms orientationForPLL:pll]]];
    return cell;
}
@end
