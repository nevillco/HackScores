//
//  HSLeaderBoardView.h - view for a leaderboard (containing top 2 scores)
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSHackSet.h"

@interface HSLeaderBoardView : UIView

@property UILabel* titleLabel;
@property NSMutableArray* hackSetViews;
@property SortMode sortMode;
@property bool expanded;

- (void) addNumberOfHackSetViews: (int) count;
- (void) removeNumberOfHackSetViews: (int) count;

@end
