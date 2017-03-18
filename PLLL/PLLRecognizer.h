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
    PLLGa,
    PLLGb,
    PLLGc,
    PLLGd,
    PLLRa,
    PLLRb,
    PLLError,
} PLLCase;

@interface PLLRecognizer : NSObject

@property PLLCase answer;
@property NSMutableArray *steps;
@property int adjustment;

- (PLLCase)recognize:(NSArray *)pattern;

@end
