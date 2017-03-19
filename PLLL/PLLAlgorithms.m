//
//  PLLAlgorithms.m
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import "PLLAlgorithms.h"

@interface PLLAlgorithms ()

@end

@implementation PLLAlgorithms

+ (NSString *)forPLL:(PLLCase)pll {
    switch (pll) {
        case PLLAa:
            return @"";
        case PLLAb:
            return @"";
        case PLLE:
            return @"";
        case PLLF:
            return @"";
        case PLLGa:
            return @"R L U2 R' L' (y') R' U L' U2 R U' L";
        case PLLGb:
            return @"";
        case PLLGc:
            return @"";
        case PLLGd:
            return @"L U' R U2 L' U R' (y) R' L' U2 R L";
        case PLLH:
            return @"";
        case PLLJa:
            return @"R U' L' U R' U2 L U' L' U2 L";
        case PLLJb:
            return @"L' U R U' L U2 R' U R U2 R'";
        case PLLNa:
            return @"";
        case PLLNb:
            return @"";
        case PLLT:
            return @"";
        case PLLRa:
            return @"";
        case PLLRb:
            return @"R' U2 R U2 R' F (R U R' U') R' F' R2' U'";
        case PLLUa:
            return @"M2 U M U2 M' U M2";
        case PLLUb:
            return @"M2 U' M U2 M' U' M2";
        case PLLV:
            return @"R' U2 R U2 L U' R' U L' U L U' R U L'";
        case PLLY:
            return @"F R U' R' U' R U R' F' R U R' U' R' F R F'";
        case PLLZ:
            return @"M2' U2 M' U M2' U M2' U M'";
        default:
            return @"???????";
    }
}

@end
