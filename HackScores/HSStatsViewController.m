//
//  HSStatsViewController.m - view controller for opening leaderboard scene
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "AppDelegate.h"
#import "HSStatsViewController.h"
#import "HSLeaderBoardView.h"
#import "HSHackSetView.h"

@interface HSStatsViewController ()

//Four leaderboard boxes (HSLeaderboardView)
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestLinesLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestHacksLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestRoundsLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestSetsLeaderBoard;

//Each leaderboard box has two HSHackSetView (8 totals)
@property (weak, nonatomic) IBOutlet HSHackSetView *bestLinesTopHackView;
@property (weak, nonatomic) IBOutlet HSHackSetView *bestLinesSecondHackView;

//Button action to play new game (will send user to HSAddPlayersViewController)
- (IBAction)playNewButtonPressed:(id)sender;

@end

@implementation HSStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Will need delegate object for hackSetData
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray* hackSetData = [delegate getHackSetData];
    
    //Code for "Best Overall Lines" first leaderboard
    [self.bestLinesLeaderBoard.titleLabel setText:@"Best Overall Lines"];
    //If we have 1 (or 2) HSHackSets, populate 1 (or 2) HSHackSetViews
    if([delegate getHackSetData].count > 0) {
        [self.bestLinesTopHackView addHackContent:[hackSetData objectAtIndex: 0]];
        if([delegate getHackSetData].count > 1)
            [self.bestLinesSecondHackView addHackContent:[hackSetData objectAtIndex: 1]];
    }
    
    [self.bestHacksLeaderBoard.titleLabel setText:@"Best Single Hacks"];
    [self.bestRoundsLeaderBoard.titleLabel setText:@"Best Rounds (30 Hacks)"];
    [self.bestSetsLeaderBoard.titleLabel setText:@"Best Sets (3 Rounds)"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playNewButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"AddPlayersSegue" sender:self];
}
@end
