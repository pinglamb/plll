//
//  PLLRecognizer.m
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//
//  Reference: https://sarah.cubing.net/3x3x3/pll-recognition-guide#section/introduction
//

#import "PLLRecognizer.h"

@interface PLLRecognizer ()

@end

@implementation PLLRecognizer

- (PLLCase)recognize:(NSArray *)pattern
{
    self.steps = [[NSMutableArray alloc] init];
    switch ([self cpRecognize:pattern]) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            switch ([self adjCpSectionRecognize:pattern]) {
                case 0:
                    break;
                case 1:
                    break;
                case 2:
                    break;
                case 3:
                    return [self adjCpDRecognize:pattern];
                case 4:
                    break;
                default:
                    return PLLError;
            }
        default:
            return PLLError;
    }

    return PLLError;
}

- (int)cpRecognize:(NSArray *)pattern
{
    if([pattern[0] isEqualToString:pattern[2]] && [pattern[3] isEqualToString:pattern[5]]) {
        // EPLL: There are a set of 'headlights' on each side (two of the same corner sticker colours on a face), no corners are swapped.
        [self.steps addObject:@"2 Headlights - EPLL"];
        return 0;
    } else {

        if([self numberOfColors:pattern] == 4) {
            // Each side has a set of two opposite colours, two diagonal corners are swapped.
            [self.steps addObject:@"4 different corner colors - Diag. CP"];
            return 1;
        } else {
            // Two adjacent corners are swapped
            [self.steps addObject:@"3 different corner colors - Adj. CP"];
            return 2;
        }
    }
}

- (int)adjCpSectionRecognize:(NSArray *)pattern
{
    int headlights = 0;
    int blocks = 0;
    if(pattern[0] == pattern[2]) { headlights++; }
    if(pattern[3] == pattern[5]) { headlights++; }
    if(pattern[0] == pattern[1]) { blocks++; }
    if(pattern[1] == pattern[2]) { blocks++; }
    if(pattern[3] == pattern[4]) { blocks++; }
    if(pattern[4] == pattern[5]) { blocks++; }

    if(blocks == 2 && headlights == 0) {
        // A: Two visible blocks, no visible set of headlights.
        [self.steps addObject:@"Two blocks, no headlights - Adj. CP A"];
        return 0;
    } else if(blocks == 1 && headlights == 1) {
        // B: One visible block, one set of visible set of headlights.
        [self.steps addObject:@"One block, one headlight - Adj. CP B"];
        return 1;
    } else if(blocks == 1 && headlights == 0) {
        // C: No visible set of headlights, one visible block.
        [self.steps addObject:@"One block, no headlights - Adj. CP C"];
        return 2;
    } else if(blocks == 0 && headlights == 1) {
        // D: No visible blocks, one set of visible set of headlights.
        [self.steps addObject:@"No blocks, one headlight - Adj. CP D"];
        return 3;
    } else {
        // E: No visible blocks, no visible set of headlights.
        [self.steps addObject:@"No blocks, no headlights - Adj. CP E"];
        return 4;
    }
}

- (PLLCase)adjCpDRecognize:(NSArray *)pattern
{
    int num = [self numberOfColors:pattern];
    if([pattern[0] isEqualToString:pattern[2]]) {
        // Left Headlight
        [self.steps addObject:@"Headlight on the left side"];
        if([self isOppositeFor:pattern[0] and:pattern[1]]) {
            // Opposite Edge In Between Headlights
            [self.steps addObject:@"Opposite color in between headlights"];
            if(num == 4) {
                // only three unique colours are visible
                [self.steps addObject:@"Only three unique colors - Gb"];
                return PLLGb;
            } else {
                // four unique colours are visible
                [self.steps addObject:@"Four unique colors - Gd"];
                self.adjustment = -1;
                return PLLGd;
            }
        } else {
            // Adjacent Edge In Between Headlights
            [self.steps addObject:@"Adjacent color in between headlights"];
            if(num == 3) {
                // only three unique colours are visible
                [self.steps addObject:@"Only three unique colors - Rb"];
                return PLLRb;
            } else if([pattern[0] isEqualToString:pattern[4]]) {
                // there is a checker pattern
                [self.steps addObject:@"4 colors with checker pattern - Ab"];
                return PLLAb;
            } else {
                // no checker pattern
                [self.steps addObject:@"4 colors without checker pattern - Gc"];
                return PLLGc;
            }
        }
    } else {
        // Right Headlight
        [self.steps addObject:@"Headlight on the right side"];
        if([self isOppositeFor:pattern[3] and:pattern[4]]) {
            // Opposite Edge In Between Headlights
            [self.steps addObject:@"Opposite color in between headlights"];
            if(num == 4) {
                // only three unique colours are visible
                [self.steps addObject:@"Only three unique colors - Gd"];
                return PLLGd;
            } else {
                // four unique colours are visible
                [self.steps addObject:@"Four unique colors - Gb"];
                return PLLGb;
            }
        } else {
            // Adjacent Edge In Between Headlights
            [self.steps addObject:@"Adjacent color in between headlights"];
            if(num == 3) {
                // only three unique colours are visible
                [self.steps addObject:@"Only three unique colors - Ra"];
                return PLLRa;
            } else if([pattern[0] isEqualToString:pattern[4]]) {
                // there is a checker pattern
                [self.steps addObject:@"4 colors with checker pattern - Aa"];
                return PLLAa;
            } else {
                // no checker pattern
                [self.steps addObject:@"4 colors without checker pattern - Ga"];
                return PLLGa;
            }
        }
    }
}

- (bool)isOppositeFor:(NSString *)c1 and:(NSString *)c2
{
    return ([c1 isEqualToString:@"R"] && [c2 isEqualToString:@"O"]) ||
        ([c1 isEqualToString:@"O"] && [c2 isEqualToString:@"R"]) ||
        ([c1 isEqualToString:@"B"] && [c2 isEqualToString:@"G"]) ||
        ([c1 isEqualToString:@"G"] && [c2 isEqualToString:@"B"]);
}

- (int)numberOfColors:(NSArray *)pattern
{
    NSSet *uniqued = [[NSSet alloc] initWithObjects:pattern[0], pattern[2], pattern[3], pattern[5], nil];
    return (int)uniqued.count;
}
@end
