//
//  PLLGenerator.m
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import "PLLGenerator.h"

@interface PLLGenerator ()

@end

@implementation PLLGenerator

+ (NSMutableArray *)generate
{
    NSArray *corners = @[@[@"R", @"G"], @[@"G", @"O"], @[@"O", @"B"], @[@"B", @"R"]];
    NSArray *edges = @[@"R", @"G", @"O", @"B"];

    NSArray *cornersPerm = [self generateUniqueNumbers:3];
    NSArray *edgesPerm = [self generateUniqueNumbers:2];

    NSNumber *leftOuterPiece = cornersPerm[0];
    NSNumber *centerPiece = cornersPerm[1];
    NSNumber *rightOuterPiece = cornersPerm[2];
    NSNumber *leftEdgePiece = edgesPerm[0];
    NSNumber *rightEdgePiece = edgesPerm[1];

    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:6];
    [colors addObject:corners[[leftOuterPiece intValue]][1]];
    [colors addObject:edges[[leftEdgePiece intValue]]];
    [colors addObject:corners[[centerPiece intValue]][0]];
    [colors addObject:corners[[centerPiece intValue]][1]];
    [colors addObject:edges[[rightEdgePiece intValue]]];
    [colors addObject:corners[[rightOuterPiece intValue]][0]];

    return colors;
}

+ (NSArray *)generateUniqueNumbers:(int)total {
    NSMutableArray *unqArray = [[NSMutableArray alloc] init];
    int randNum = arc4random() % (4);
    int counter = 0;
    while (counter < total) {
        if (![unqArray containsObject:[NSNumber numberWithInt:randNum]]) {
            [unqArray addObject:[NSNumber numberWithInt:randNum]];
            counter++;
        } else {
            randNum = arc4random() % (4);
        }

    }

    return unqArray;
}

@end
