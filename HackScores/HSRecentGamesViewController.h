//
//  HSRecentGamesViewController.h
//  HackScores
//
//  Created by Connor Neville on 1/11/15.
//  Copyright (c) 2015 connorneville. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSRecentGamesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray* hackData;

@end
