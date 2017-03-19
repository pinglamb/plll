//
//  PLLRecognizer.h
//  PLLL
//
//  Created by pinglamb on 19/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import "Foundation/Foundation.h"

typedef enum {
    PLLAa,
    PLLAb,
    PLLE,
    PLLF,
    PLLGa,
    PLLGb,
    PLLGc,
    PLLGd,
    PLLH,
    PLLJa,
    PLLJb,
    PLLNa,
    PLLNb,
    PLLT,
    PLLRa,
    PLLRb,
    PLLUa,
    PLLUb,
    PLLV,
    PLLY,
    PLLZ,
    PLLSkip,
    PLLError,
} PLLCase;

#define PLLNames [NSArray arrayWithObjects: \
    @"Aa", \
    @"Ab", \
    @"E", \
    @"F", \
    @"Ga", \
    @"Gb", \
    @"Gc", \
    @"Gd", \
    @"H", \
    @"Ja", \
    @"Jb", \
    @"Na", \
    @"Nb", \
    @"T", \
    @"Ra", \
    @"Rb", \
    @"Ua", \
    @"Ub", \
    @"V", \
    @"Y", \
    @"Z", \
    @"PLLSkip", \
    @"???", \
    nil \
]

@interface PLLRecognizer : NSObject

@property PLLCase answer;
@property NSMutableArray *steps;
@property int adjustment;

- (PLLCase)recognize:(NSArray *)pattern;
- (NSString *)adjustmentText;

@end
