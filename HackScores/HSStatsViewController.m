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

@property (weak, nonatomic) IBOutlet HSHackSetView *bestHacksTopHackView;
@property (weak, nonatomic) IBOutlet HSHackSetView *bestHacksSecondHackView;

@property (weak, nonatomic) IBOutlet HSHackSetView *bestRoundsTopHackView;
@property (weak, nonatomic) IBOutlet HSHackSetView *bestRoundsSecondHackView;

@property (weak, nonatomic) IBOutlet HSHackSetView *bestSetsTopHackView;
@property (weak, nonatomic) IBOutlet HSHackSetView *bestSetsSecondHackView;

//Button action to play new game (will send user to HSAddPlayersViewController)
- (IBAction)playNewButtonPressed:(id)sender;

@end

@implementation HSStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearContents];
    //Will need delegate object for hackSetData
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //Code for "Best Overall Lines" first leaderboard
    [self.bestLinesLeaderBoard.titleLabel setText:@"Best Overall Lines"];
    //Sort data (delegate initial sort mode is "Best Overall"
    [delegate sortHackSetData];
    //If we have 1 (or 2) HSHackSets, populate 1 (or 2) HSHackSetViews
    if([delegate getHackSetData].count > 0) {
        [self.bestLinesTopHackView addHackContent:[[delegate getHackSetData] objectAtIndex: 0]];
        if([delegate getHackSetData].count > 1)
            [self.bestLinesSecondHackView addHackContent:[[delegate getHackSetData] objectAtIndex: 1]];
    }
    
    [self.bestHacksLeaderBoard.titleLabel setText:@"Best Single Hacks"];
    //Change sorting mode
    [delegate setDataSortMode: SortByBestHack];
    //Sort data (delegate initial sort mode is "Best Overall"
    [delegate sortHackSetData];
    //If we have 1 (or 2) HSHackSets, populate 1 (or 2) HSHackSetViews
    if([delegate getHackSetData].count > 0) {
        [self.bestHacksTopHackView addHackContent:[[delegate getHackSetData] objectAtIndex: 0]];
        if([delegate getHackSetData].count > 1)
            [self.bestHacksSecondHackView addHackContent:[[delegate getHackSetData] objectAtIndex: 1]];
    }

    [self.bestRoundsLeaderBoard.titleLabel setText:@"Best Rounds (30 Hacks)"];
    //Change sorting mode
    [delegate setDataSortMode: SortByBestRound];
    //Sort data (delegate initial sort mode is "Best Overall"
    [delegate sortHackSetData];
    //If we have 1 (or 2) HSHackSets, populate 1 (or 2) HSHackSetViews
    if([delegate getHackSetData].count > 0) {
        [self.bestRoundsTopHackView addHackContent:[[delegate getHackSetData] objectAtIndex: 0]];
        if([delegate getHackSetData].count > 1)
            [self.bestRoundsSecondHackView addHackContent:[[delegate getHackSetData] objectAtIndex: 1]];
    }

    [self.bestSetsLeaderBoard.titleLabel setText:@"Best Sets (3 Rounds)"];
    //Change sorting mode
    [delegate setDataSortMode: SortBySetScore];
    //Sort data (delegate initial sort mode is "Best Overall"
    [delegate sortHackSetData];
    //If we have 1 (or 2) HSHackSets, populate 1 (or 2) HSHackSetViews
    if([delegate getHackSetData].count > 0) {
        [self.bestSetsTopHackView addHackContent:[[delegate getHackSetData] objectAtIndex: 0]];
        if([delegate getHackSetData].count > 1)
            [self.bestSetsSecondHackView addHackContent:[[delegate getHackSetData] objectAtIndex: 1]];
    }

}

- (void) clearContents {
    [[self.bestLinesTopHackView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.bestLinesSecondHackView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [[self.bestHacksTopHackView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.bestHacksSecondHackView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [[self.bestRoundsTopHackView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.bestRoundsSecondHackView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [[self.bestSetsTopHackView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.bestSetsSecondHackView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playNewButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"AddPlayersSegue" sender:self];
}
@end
