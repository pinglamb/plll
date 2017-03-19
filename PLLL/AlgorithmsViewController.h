//
//  AlgorithmsViewController.h
//  PLLL
//
//  Created by pinglamb on 20/3/2017.
//  Copyright © 2017 Ging Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlgorithmsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
