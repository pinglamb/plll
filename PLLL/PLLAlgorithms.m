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
            // Headlight facing back
            return @"R' U2 R2 U' L' U R' U' L U R' U2 R";
        case PLLAb:
            // Headlight at right
            return @"R' U2 R U' L' U R U' L U R2 U2 R";
        case PLLE:
            // Horizontal corners exchange
            return @"R2 U R' U' (y) (R U R' U')2 R U R' (y') R U' R2'";
        case PLLF:
            return @"R' U R U' R2 (y') R' U' R U (y x) R U R' U' R2 (x')";
        case PLLGa:
            // Headlight facing front
            return @"R L U2 R' L' (y') R' U L' U2 R U' L";
        case PLLGb:
            // Headlight facing front
            return @"R' U L' U2 R U' L (y) R L U2 L' R'";
        case PLLGc:
            // Headlight facing front
            return @"L' R' U2 L R (y) L U' R U2 L' U R'";
        case PLLGd:
            // Headlight facing front
            return @"L U' R U2 L' U R' (y) R' L' U2 R L";
        case PLLH:
            return @"M2' U M2' U2 M2' U M2'";
        case PLLJa:
            // 3x1 at right
            return @"R U' L' U R' U2 L U' L' U2 L";
        case PLLJb:
            // 3x1 at left
            return @"L' U R U' L U2 R' U R U2 R'";
        case PLLNa:
            return @"(L U' R U2 L' U R')2 U'";
        case PLLNb:
            return @"(R' U L' U2 R U' L)2 U";
        case PLLT:
            // Headlight at left
            return @"F R U' R' U R U R2 F' R U R U' R'";
        case PLLRa:
            // Headlight facing front
            return @"L U2 L' U2 L F' L' U' L U L F L2";
        case PLLRb:
            // Headlight facing front
            return @"R' U2 R U2 R' F (R U R' U') R' F' R2' U'";
        case PLLUa:
            // 3x1 facing back
            return @"M2 U M U2 M' U M2";
        case PLLUb:
            // 3x1 facing back
            return @"M2 U' M U2 M' U' M2";
        case PLLV:
            // 2 Inner blocks on left
            return @"R' U2 R U2 L U' R' U L' U L U' R U L'";
        case PLLY:
            // 2 Outer blocks on right
            return @"F R U' R' U' R U R' F' R U R' U' R' F R F'";
        case PLLZ:
            return @"M2' U2 M' U M2' U M2' U M'";
        default:
            return @"???????";
    }
}

@end
