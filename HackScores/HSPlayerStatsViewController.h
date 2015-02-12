//
//  HSPlayerStatsViewController.h
//  HackScores
//
//  Created by Connor Neville on 2/11/15.
//  Copyright (c) 2015 connorneville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSHackSet.h"
#import "CNLabel.h"

@interface HSPlayerStatsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSString* playerName;
@property NSMutableArray* hackData;
@property HSHackSet* selectedData;
@property (weak, nonatomic) IBOutlet CNLabel *playerNameLabel;

@end
