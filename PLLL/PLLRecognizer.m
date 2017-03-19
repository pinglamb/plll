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
            return [self epllRecognize:pattern];
        case 1:
            return [self diagCpRecognize:pattern];
        case 2:
            switch ([self adjCpSectionRecognize:pattern]) {
                case 0:
                    return [self adjCPARecognize:pattern];
                case 1:
                    return [self adjCpBRecognize:pattern];
                case 2:
                    return [self adjCpCRecognize:pattern];
                case 3:
                    return [self adjCpDRecognize:pattern];
                case 4:
                    return [self adjCpERecognize:pattern];
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
    if([self leftIsHeadlight:pattern] && [self rightIsHeadlight:pattern]) {
        // EPLL: There are a set of 'headlights' on each side (two of the same corner sticker colours on a face), no corners are swapped.
        [self.steps addObject:@"2 Headlights - EPLL"];
        return 0;
    } else {
        NSSet *uniqued = [[NSSet alloc] initWithObjects:pattern[0], pattern[2], pattern[3], pattern[5], nil];
        if(uniqued.count == 4) {
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

    if([self leftIsOuterBlock:pattern] || [self leftIsInnerBlock:pattern]) {
        blocks++;
    } else if([self leftIsHeadlight:pattern]) {
        headlights++;
    }
    if([self rightIsInnerBlock:pattern] || [self rightIsOuterBlock:pattern]) {
        blocks++;
    } else if([self rightIsHeadlight:pattern]) {
        headlights++;
    }

    if(blocks == 2 && headlights == 0) {
        // A: Two visible blocks, no visible set of headlights.
        [self.steps addObject:@"Two blocks, no headlights - Adj. CP A"];
        return 0;
    } else if(blocks == 1 && headlights == 1) {
        // B: One visible block, one set of visible set of headlights.
        [self.steps addObject:@"One block, one headlight - Adj. CP B"];
        return 1;
    } else if(blocks == 1 && headlights == 0) {
        // C: One visible block, no visible set of headlights.
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

- (int)epllRecognize:(NSArray *)pattern
{
    if([self leftIs3x1:pattern] && [self rightIs3x1:pattern]) {
        [self.steps addObject:@"PLL Skip"];
        return PLLSkip;
    } else if([self leftIs3x1:pattern]) {
        [self.steps addObject:@"Left is 3x1"];
        if([self isOppositeFor:pattern[3] and:pattern[4]]) {
            [self.steps addObject:@"Opposite color between headlight - Ub"];
            return PLLUb;
        } else {
            [self.steps addObject:@"Adjacent color between headlight - Ua"];
            self.adjustment = 2;
            return PLLUa;
        }
    } else if([self rightIs3x1:pattern]) {
        [self.steps addObject:@"Right is 3x1"];
        if([self isOppositeFor:pattern[0] and:pattern[1]]) {
            [self.steps addObject:@"Opposite color between headlight - Ua"];
            return PLLUa;
        } else {
            [self.steps addObject:@"Adjacent color between headlight - Ub"];
            return PLLUb;
        }
    } else {
        [self.steps addObject:@"No 3x1"];
        if([self isOppositeFor:pattern[0] and:pattern[1]] && [self isOppositeFor:pattern[3] and:pattern[4]]) {
            [self.steps addObject:@"Both headlight has opposite color in between - H"];
            self.adjustment = 0;
            return PLLH;
        } else if([self isOppositeFor:pattern[0] and:pattern[1]]) {
            [self.steps addObject:@"Only left side has opposite color between headlight - Ub"];
            self.adjustment = 1;
            return PLLUb;
        } else if([self isOppositeFor:pattern[3] and:pattern[4]]) {
            [self.steps addObject:@"Only right side has opposite color between headlight - Ua"];
            return PLLUa;
        } else {
            [self.steps addObject:@"No opposite edges in between headlights"];
            if([pattern[1] isEqualToString:pattern[3]] && [pattern[2] isEqualToString:pattern[4]]) {
                [self.steps addObject:@"Both side has checker pattern - Z"];
                self.adjustment = 1;
                return PLLZ;
            } else if([pattern[1] isEqualToString:pattern[3]]) {
                [self.steps addObject:@"Checker pattern on left side only - Ua"];
                self.adjustment = 1;
                return PLLUa;
            } else if([pattern[2] isEqualToString:pattern[4]]) {
                [self.steps addObject:@"Checker pattern on right side only - Ub"];
                self.adjustment = 0;
                return PLLUb;
            } else {
                [self.steps addObject:@"No Checker pattern - Z"];
                self.adjustment = 0;
                return PLLZ;
            }
        }
    }
}

- (int)diagCpRecognize:(NSArray *)pattern
{
    int blocks = 0;
    if([self leftIsOuterBlock:pattern] || [self leftIsInnerBlock:pattern]) {
        blocks++;
    }
    if([self rightIsInnerBlock:pattern] || [self rightIsOuterBlock:pattern]) {
        blocks++;
    }

    if(blocks == 2) {
        [self.steps addObject:@"Two 2x1 blocks"];
        if([self leftIsInnerBlock:pattern] && [self rightIsInnerBlock:pattern]) {
            [self.steps addObject:@"Both are inner blocks - V"];
            return PLLV;
        } else if([self leftIsOuterBlock:pattern] && [self rightIsOuterBlock:pattern]) {
            [self.steps addObject:@"Both are outer blocks - Y"];
            return PLLY;
        } else if([self leftIsInnerBlock:pattern] && [self rightIsOuterBlock:pattern]) {
            [self.steps addObject:@"Left is inner and right is outer - Na"];
            return PLLNa;
        } else {
            [self.steps addObject:@"Left is outer and right is inner - Nb"];
            return PLLNb;
        }
    } else if (blocks == 1) {
        [self.steps addObject:@"One 2x1 block"];
        if([self leftIsOuterBlock:pattern] || [self rightIsOuterBlock:pattern]) {
            [self.steps addObject:@"Outer 2x1 block - V"];
            self.adjustment = 2;
            return PLLV;
        } else {
            [self.steps addObject:@"Inner 2x1 block - Y"];
            self.adjustment = -1;
            return PLLY;
        }
    } else {
        [self.steps addObject:@"No blocks"];
        if([pattern[1] isEqualToString:pattern[3]] && [pattern[2] isEqualToString:pattern[4]]) {
            [self.steps addObject:@"Inner blocks have checker pattern - V"];
            return PLLV;
        } else if([pattern[0] isEqualToString:pattern[4]] && [pattern[1] isEqualToString:pattern[5]]) {
            [self.steps addObject:@"Inner blocks have checker pattern - Y"];
            return PLLY;
        } else {
            if([pattern[1] isEqualToString:pattern[3]]) {
                [self.steps addObject:@"Half checker pattern on the left - E"];
                self.adjustment = 0;
                return PLLE;
            } else {
                [self.steps addObject:@"Half checker pattern on the right - E"];
                self.adjustment = 1;
                return PLLE;
            }
        }
    }
}

- (PLLCase)adjCPARecognize:(NSArray *)pattern
{
    // A: Two visible blocks, no visible set of headlights.
    if([self leftIs3x1:pattern]) {
        [self.steps addObject:@"Left is 3x1"];
        if([self rightIsInnerBlock:pattern]) {
            [self.steps addObject:@"Right is inner 2x1 - Ja"];
            return PLLJa;
        } else {
            [self.steps addObject:@"Right is outer 2x1 - Jb"];
            self.adjustment = 1;
            return PLLJb;
        }
    } else if([self rightIs3x1:pattern]) {
        [self.steps addObject:@"Right is 3x1"];
        if([self leftIsInnerBlock:pattern]) {
            [self.steps addObject:@"Left is inner 2x1 - Jb"];
            return PLLJb;
        } else {
            [self.steps addObject:@"Left is outer 2x1 - Ja"];
            self.adjustment = 0;
            return PLLJa;
        }
    } else if([self leftIsOuterBlock:pattern]) {
        [self.steps addObject:@"Left outer, right inner - Ja"];
        self.adjustment = 1;
        return PLLJa;
    } else if([self rightIsOuterBlock:pattern]) {
        [self.steps addObject:@"Left outer, right inner - Jb"];
        return PLLJb;
    } else {
        [self.steps addObject:@"2 inner blocks"];
        if([self isOppositeFor:pattern[0] and:pattern[1]]) {
            [self.steps addObject:@"Left outer corner is of opposite color - Ab"];
            return PLLAb;
        } else {
            [self.steps addObject:@"Right outer corner is of opposite color - Aa"];
            return PLLAa;
        }
    }
}

- (PLLCase)adjCpBRecognize:(NSArray *)pattern
{
    // B: One visible block, one set of visible set of headlights.
    int num = [self numberOfColors:pattern];
    if([self leftIsOuterBlock:pattern]) {
        [self.steps addObject:@"Left is outer 2x1"];
        if(num == 3) {
            [self.steps addObject:@"Only three unique colors - Ab"];
            return PLLAb;
        } else {
            [self.steps addObject:@"Four unique colors - Gc"];
            return PLLGc;
        }
    } else if([self leftIsInnerBlock:pattern]) {
        [self.steps addObject:@"Left is inner 2x1"];
        if([self isOppositeFor:pattern[3] and:pattern[4]]) {
            [self.steps addObject:@"Opposite color between headlight - T"];
            self.adjustment = 2;
            return PLLT;
        } else {
            [self.steps addObject:@"Adjacent color between headlight - Rb"];
            return PLLRb;
        }
    } else if([self rightIsInnerBlock:pattern]) {
        [self.steps addObject:@"Right is inner 2x1"];
        if([self isOppositeFor:pattern[0] and:pattern[1]]) {
            [self.steps addObject:@"Opposite color between headlight - T"];
            self.adjustment = 1;
            return PLLT;
        } else {
            [self.steps addObject:@"Adjacent color between headlight - Ra"];
            self.adjustment = 0;
            return PLLRa;
        }
    } else {
        [self.steps addObject:@"Right is outer 2x1"];
        if(num == 3) {
            [self.steps addObject:@"Only three unique colors - Aa"];
            self.adjustment = 2;
            return PLLAa;
        } else {
            [self.steps addObject:@"Four unique colors - Ga"];
            self.adjustment = 0;
            return PLLGa;
        }
    }
}

- (PLLCase)adjCpCRecognize:(NSArray *)pattern
{
    // C: One visible block, no visible set of headlights.
    int num = [self numberOfColors:pattern];
    if([self leftIs3x1:pattern] || [self rightIs3x1:pattern]) {
        // A 3x1 Block
        [self.steps addObject:@"A 3x1 block - F"];
        return PLLF;
    } else if([self leftIsOuterBlock:pattern]) {
        // Left Outer Block
        [self.steps addObject:@"Left Outer Block"];
        if([self isOppositeFor:pattern[0] and:pattern[2]]) {
            // Opposite color next to the block
            [self.steps addObject:@"Opposite color beside the block"];
            if(num == 3) {
                [self.steps addObject:@"Only three unique colors - Gd"];
                self.adjustment = 1;
                return PLLGd;
            } else {
                [self.steps addObject:@"Four unique colors - Aa"];
                return PLLAa;
            }
        } else {
            [self.steps addObject:@"Adjacent color beside the block"];
            if(num == 3) {
                [self.steps addObject:@"Only three unique colors - Ra"];
                return PLLRa;
            } else {
                [self.steps addObject:@"Four unique colors - T"];
                self.adjustment = 0;
                return PLLT;
            }
        }
    } else if([self leftIsInnerBlock:pattern]) {
        // Left Inner Block
        [self.steps addObject:@"Left Inner Block"];
        if([self isOppositeFor:pattern[0] and:pattern[1]]) {
            [self.steps addObject:@"Opposite color beside the block - Gb"];
            return PLLGb;
        } else {
            [self.steps addObject:@"Adjacent color beside the block - Ga"];
            self.adjustment = -1;
            return PLLGa;
        }
    } else if([self rightIsInnerBlock:pattern]) {
        // Right Inner Block
        [self.steps addObject:@"Right Inner Block"];
        if([self isOppositeFor:pattern[4] and:pattern[5]]) {
            [self.steps addObject:@"Opposite color beside the block - Gd"];
            self.adjustment = 1;
            return PLLGd;
        } else {
            [self.steps addObject:@"Adjacent color beside the block - Gc"];
            self.adjustment = 2;
            return PLLGc;
        }
    } else {
        // Right Outer Block
        [self.steps addObject:@"Right Outer Block"];
        if([self rightIsOuterBlock:pattern]) {
            // Opposite color next to the block
            [self.steps addObject:@"Opposite color beside the block"];
            if(num == 3) {
                [self.steps addObject:@"Only three unique colors - Gb"];
                self.adjustment = -1;
                return PLLGb;
            } else {
                [self.steps addObject:@"Four unique colors - Ab"];
                return PLLAb;
            }
        } else {
            [self.steps addObject:@"Adjacent color beside the block"];
            if(num == 3) {
                [self.steps addObject:@"Only three unique colors - Rb"];
                return PLLRa;
            } else {
                [self.steps addObject:@"Four unique colors - T"];
                self.adjustment = -1;
                return PLLT;
            }
        }
    }
}

- (PLLCase)adjCpDRecognize:(NSArray *)pattern
{
    // D: No visible blocks, one set of visible set of headlights.
    int num = [self numberOfColors:pattern];
    if([self leftIsHeadlight:pattern]) {
        // Left Headlight
        [self.steps addObject:@"Headlight on the left side"];
        if([self isOppositeFor:pattern[0] and:pattern[1]]) {
            // Opposite Edge In Between Headlights
            [self.steps addObject:@"Opposite color in between headlights"];
            if(num == 3) {
                // only three unique colours are visible
                [self.steps addObject:@"Only three unique colors - Gd"];
                self.adjustment = -1;
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
            if(num == 3) {
                // only three unique colours are visible
                [self.steps addObject:@"Only three unique colors - Gb"];
                return PLLGd;
            } else {
                // four unique colours are visible
                [self.steps addObject:@"Four unique colors - Gd"];
                self.adjustment = 0;
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
                self.adjustment = 1;
                return PLLGa;
            }
        }
    }
}

- (PLLCase)adjCpERecognize:(NSArray *)pattern
{
    // E: No visible blocks, no visible set of headlights.
    if([self numberOfColors:pattern] == 3) {
        [self.steps addObject:@"Only three unique colors - F"];
        self.adjustment = 2;
        return PLLF;
    } else if([self isOppositeFor:pattern[0] and:pattern[1]]) {
        [self.steps addObject:@"Left outer block is in opposite color - Gc"];
        return PLLGc;
    } else if([self isOppositeFor:pattern[1] and:pattern[2]]) {
        [self.steps addObject:@"Left inner block is in opposite color - Rb"];
        self.adjustment = -1;
        return PLLRb;
    } else if([self isOppositeFor:pattern[3] and:pattern[4]]) {
        [self.steps addObject:@"Right inner block is in opposite color - Ra"];
        return PLLRa;
    } else {
        [self.steps addObject:@"Right outer block is in opposite color - Ga"];
        self.adjustment = 2;
        return PLLGa;
    }
}

- (int)numberOfColors:(NSArray *)pattern
{
    NSSet *uniqued = [[NSSet alloc] initWithObjects:pattern[0], pattern[1], pattern[2], pattern[3], pattern[4], pattern[5], nil];
    return (int)uniqued.count;
}

- (bool)isOppositeFor:(NSString *)c1 and:(NSString *)c2
{
    return ([c1 isEqualToString:@"R"] && [c2 isEqualToString:@"O"]) ||
    ([c1 isEqualToString:@"O"] && [c2 isEqualToString:@"R"]) ||
    ([c1 isEqualToString:@"B"] && [c2 isEqualToString:@"G"]) ||
    ([c1 isEqualToString:@"G"] && [c2 isEqualToString:@"B"]);
}

- (bool)leftIs3x1:(NSArray *)pattern
{
    return ([pattern[0] isEqualToString:pattern[1]] && [pattern[1] isEqualToString:pattern[2]]);
}

- (bool)rightIs3x1:(NSArray *)pattern
{
    return ([pattern[3] isEqualToString:pattern[4]] && [pattern[4] isEqualToString:pattern[5]]);
}

- (bool)leftIsHeadlight:(NSArray *)pattern
{
    return ([pattern[0] isEqualToString:pattern[2]]);
}

- (bool)rightIsHeadlight:(NSArray *)pattern
{
    return ([pattern[3] isEqualToString:pattern[5]]);
}

- (bool)leftIsOuterBlock:(NSArray *)pattern
{
    return ([pattern[0] isEqualToString:pattern[1]]);
}

- (bool)leftIsInnerBlock:(NSArray *)pattern
{
    return ([pattern[1] isEqualToString:pattern[2]]);
}

- (bool)rightIsInnerBlock:(NSArray *)pattern
{
    return ([pattern[3] isEqualToString:pattern[4]]);
}

- (bool)rightIsOuterBlock:(NSArray *)pattern
{
    return ([pattern[4] isEqualToString:pattern[5]]);
}

@end
