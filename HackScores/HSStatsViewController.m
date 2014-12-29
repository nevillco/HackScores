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
@property (strong, nonatomic) IBOutletCollection(HSHackSetView) NSArray* bestLinesHackViews;
@property (strong, nonatomic) IBOutletCollection(HSHackSetView) NSArray* bestHacksHackViews;
@property (strong, nonatomic) IBOutletCollection(HSHackSetView) NSArray* bestRoundsHackViews;
@property (strong, nonatomic) IBOutletCollection(HSHackSetView) NSArray* bestSetsHackViews;

//Button action to play new game (will send user to HSAddPlayersViewController)
- (IBAction)playNewButtonPressed:(id)sender;
- (IBAction)aboutButtonPressed:(id)sender;

@end

@implementation HSStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Will need delegate object for hackSetData
    //(can't just reference hackSetData because
    //delegate repeatedly sorts it)
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self populateBestLinesLeaderboard:delegate];
    [self populateBestHacksLeaderboard:delegate];
    [self populateBestRoundsLeaderboard:delegate];
    [self populateBestSetsLeaderboard:delegate];
}

- (void) populateBestLinesLeaderboard: (AppDelegate*) delegate {
    
    //Title text
    [self.bestLinesLeaderBoard.titleLabel setText:@"Best Overall Lines"];
    
    //Sort by appropriate mode
    [delegate setDataSortMode:SortByBestLine];
    [delegate sortHackSetData];
    
    //Clear all views
    for(int i = 0; i < self.bestLinesHackViews.count; i++) {
        HSHackSetView* current = self.bestLinesHackViews[i];
        [current.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //Populate as many views as possible (bounded by how many views
    //are on screen and by how many data objects we have)
    int numViewsToPopulate = (int)MIN([delegate getHackSetData].count,
                                      self.bestLinesHackViews.count);
    for(int i = 0; i < numViewsToPopulate; i++) {
        //Clear ALL views
        [[[self.bestLinesHackViews objectAtIndex:i] subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];

        [[self.bestLinesHackViews objectAtIndex:i] addHackContent:
         [[delegate getHackSetData] objectAtIndex: i]];
    }
}

- (void) populateBestHacksLeaderboard: (AppDelegate*) delegate {
    
    //Title text
    [self.bestHacksLeaderBoard.titleLabel setText:@"Best Single Hacks"];
    
    //Sort by appropriate mode
    [delegate setDataSortMode:SortByBestHack];
    [delegate sortHackSetData];
    
    //Clear all views
    for(int i = 0; i < self.bestHacksHackViews.count; i++) {
        HSHackSetView* current = self.bestHacksHackViews[i];
        [current.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //Populate as many views as possible (bounded by how many views
    //are on screen and by how many data objects we have)
    int numViewsToPopulate = (int)MIN([delegate getHackSetData].count,
                                      self.bestHacksHackViews.count);
    
    for(int i = 0; i < numViewsToPopulate; i++) {
        //Remove all content from HSHackSetView
        //in case view was previously loaded
        [[[self.bestHacksHackViews objectAtIndex:i] subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];

        [[self.bestHacksHackViews objectAtIndex:i] addHackContent:
         [[delegate getHackSetData] objectAtIndex: i]];
    }
}

- (void) populateBestRoundsLeaderboard: (AppDelegate*) delegate {
    
    //Title text
    [self.bestRoundsLeaderBoard.titleLabel setText:
     [NSString stringWithFormat: @"Best Rounds (%d hacks)",
      [delegate getHacksPerRound].intValue]];
    
    //Sort by appropriate mode
    [delegate setDataSortMode:SortByBestRound];
    [delegate sortHackSetData];
    
    //Clear all views
    for(int i = 0; i < self.bestRoundsHackViews.count; i++) {
        HSHackSetView* current = self.bestRoundsHackViews[i];
        [current.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //Populate as many views as possible (bounded by how many views
    //are on screen and by how many data objects we have)
    int numViewsToPopulate = (int)MIN([delegate getHackSetData].count,
                                      self.bestRoundsHackViews.count);
    
    for(int i = 0; i < numViewsToPopulate; i++) {
        //Remove all content from HSHackSetView
        //in case view was previously loaded
        [[[self.bestRoundsHackViews objectAtIndex:i] subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [[self.bestRoundsHackViews objectAtIndex:i] addHackContent:
         [[delegate getHackSetData] objectAtIndex: i]];
    }
}

- (void) populateBestSetsLeaderboard: (AppDelegate*) delegate {
    //Title text
    [self.bestSetsLeaderBoard.titleLabel setText: @"Best Sets (3 Rounds)"];
    
    //Sort by appropriate mode
    [delegate setDataSortMode:SortBySetScore];
    [delegate sortHackSetData];
    
    //Clear all views
    for(int i = 0; i < self.bestSetsHackViews.count; i++) {
        HSHackSetView* current = self.bestSetsHackViews[i];
        [current.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //Populate as many views as possible (bounded by how many views
    //are on screen and by how many data objects we have)
    int numViewsToPopulate = (int)MIN([delegate getHackSetData].count,
                                      self.bestSetsHackViews.count);
    
    for(int i = 0; i < numViewsToPopulate; i++) {
        //Remove all content from HSHackSetView
        //in case view was previously loaded
        [[[self.bestSetsHackViews objectAtIndex:i] subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [[self.bestSetsHackViews objectAtIndex:i] addHackContent:
         [[delegate getHackSetData] objectAtIndex: i]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playNewButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"AddPlayersSegue" sender:self];
}
- (IBAction)settingsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
}

- (IBAction)aboutButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"AboutSegue" sender:self];
}
@end
