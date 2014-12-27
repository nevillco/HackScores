//
//  HSPlayViewController.h - view controller for actual ingame scoreboard
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSHackSet.h"
#import "CNLabel.h"

@interface HSPlayViewController : UIViewController

@property HSHackSet* hackSet;

- (void) refreshRetainingSetNumber;

@end

