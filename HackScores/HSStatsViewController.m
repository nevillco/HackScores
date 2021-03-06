//
//  HSStatsViewController.m - view controller for opening leaderboard scene
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "AppDelegate.h"
#import "HSStatsViewController.h"
#import "HSSetStatsViewController.h"
#import "HSRecentGamesViewController.h"
#import "HSPlayerStatsViewController.h"
#import "HSLeaderBoardView.h"
#import "HSHackSetView.h"

@interface HSStatsViewController ()

//Four leaderboard boxes (HSLeaderboardView)
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestLinesLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestHacksLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestRoundsLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestSetsLeaderBoard;

@property UIAlertView* playerStatsAlert;

//Button action to play new game (will send user to HSAddPlayersViewController)
- (IBAction)playNewButtonPressed:(id)sender;
- (IBAction)aboutButtonPressed:(id)sender;
- (IBAction)viewSetStatsTouched:(id)sender;
- (IBAction)recentGamesButtonPressed:(id)sender;
- (IBAction)playerStatsButtonPressed:(id)sender;

@end

@implementation HSStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateAllLeaderboards];
}

- (void) populateAllLeaderboards {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self.bestLinesLeaderBoard setSortMode:SortByBestLine];
    [self.bestHacksLeaderBoard setSortMode:SortByBestHack];
    [self.bestRoundsLeaderBoard setSortMode:SortByBestRound];
    [self.bestSetsLeaderBoard setSortMode:SortBySetScore];
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
    for(int i = 0; i < self.bestLinesLeaderBoard.hackSetViews.count; i++) {
        HSHackSetView* current = self.bestLinesLeaderBoard.hackSetViews[i];
        [current.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //Populate as many views as possible (bounded by how many views
    //are on screen and by how many data objects we have)
    int numViewsToPopulate = (int)MIN([delegate getHackSetData].count,
                                      self.bestLinesLeaderBoard.hackSetViews.count);
    for(int i = 0; i < numViewsToPopulate; i++) {
        //Clear ALL views
        [[[self.bestLinesLeaderBoard.hackSetViews objectAtIndex:i] subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];

        [[self.bestLinesLeaderBoard.hackSetViews objectAtIndex:i] addHackContent:
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
    for(int i = 0; i < self.bestHacksLeaderBoard.hackSetViews.count; i++) {
        HSHackSetView* current = self.bestHacksLeaderBoard.hackSetViews[i];
        [current.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //Populate as many views as possible (bounded by how many views
    //are on screen and by how many data objects we have)
    int numViewsToPopulate = (int)MIN([delegate getHackSetData].count,
                                      self.bestHacksLeaderBoard.hackSetViews.count);
    
    for(int i = 0; i < numViewsToPopulate; i++) {
        //Remove all content from HSHackSetView
        //in case view was previously loaded
        [[[self.bestHacksLeaderBoard.hackSetViews objectAtIndex:i] subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];

        [[self.bestHacksLeaderBoard.hackSetViews objectAtIndex:i] addHackContent:
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
    for(int i = 0; i < self.bestRoundsLeaderBoard.hackSetViews.count; i++) {
        HSHackSetView* current = self.bestRoundsLeaderBoard.hackSetViews[i];
        [current.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //Populate as many views as possible (bounded by how many views
    //are on screen and by how many data objects we have)
    int numViewsToPopulate = (int)MIN([delegate getHackSetData].count,
                                      self.bestRoundsLeaderBoard.hackSetViews.count);
    
    for(int i = 0; i < numViewsToPopulate; i++) {
        //Remove all content from HSHackSetView
        //in case view was previously loaded
        [[[self.bestRoundsLeaderBoard.hackSetViews objectAtIndex:i] subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [[self.bestRoundsLeaderBoard.hackSetViews objectAtIndex:i] addHackContent:
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
    for(int i = 0; i < self.bestSetsLeaderBoard.hackSetViews.count; i++) {
        HSHackSetView* current = self.bestSetsLeaderBoard.hackSetViews[i];
        [current.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //Populate as many views as possible (bounded by how many views
    //are on screen and by how many data objects we have)
    int numViewsToPopulate = (int)MIN([delegate getHackSetData].count,
                                      self.bestSetsLeaderBoard.hackSetViews.count);
    
    for(int i = 0; i < numViewsToPopulate; i++) {
        //Remove all content from HSHackSetView
        //in case view was previously loaded
        [[[self.bestSetsLeaderBoard.hackSetViews objectAtIndex:i] subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [[self.bestSetsLeaderBoard.hackSetViews objectAtIndex:i] addHackContent:
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

//Prepare for SetStatsSegue and PlayerStatsSegue by passing appropriate
//game stats
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SetStatsSegue"]) {
        HSSetStatsViewController *destination = [segue destinationViewController];
        HSHackSetView* senderView = sender;
        [destination setHackData:[senderView hackData]];
    }
    else if([[segue identifier] isEqualToString:@"PlayerStatsSegue"]) {
        HSPlayerStatsViewController *destination = [segue destinationViewController];
        NSString* playerName = sender;
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate setDataSortMode: SortByDate];
        [delegate sortHackSetData];
        NSMutableArray* hackSetWithPlayer = [delegate hackSetsWithPlayer:playerName];
        [destination setHackData:hackSetWithPlayer];
        [destination setPlayerName:[playerName uppercaseString]];
    }
}

//UIAlertView action: return if user accepts
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == [alertView firstOtherButtonIndex]) { //Go button pressed
        NSString* playerName = [alertView textFieldAtIndex:0].text;
        //Pass playerName via sender (kind of a hack)
        [self performSegueWithIdentifier:@"PlayerStatsSegue" sender:playerName];
    }
}

//Perform segue, sending HSHackSetView as sender
- (IBAction)viewSetStatsTouched:(id)sender {
    [self performSegueWithIdentifier:@"SetStatsSegue" sender:sender];
}

- (IBAction)recentGamesButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"RecentGamesSegue" sender:self];
}

- (IBAction)playerStatsButtonPressed:(id)sender {
    //AlertView asking for name to view
    //Then pass HSHackSet to new VC
    self.playerStatsAlert = [[UIAlertView alloc] initWithTitle:@"Player Stats"
                                                    message:@"Enter the name of a player to view stats."
                                                   delegate:self
                                          cancelButtonTitle:@"Go"
                                          otherButtonTitles:@"Cancel", nil];
    self.playerStatsAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.playerStatsAlert setDelegate:self];
    [self.playerStatsAlert show];
}

//UIAlertView delegate method for return button
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //On return button press, act as if Go button was pressed
    [self.playerStatsAlert dismissWithClickedButtonIndex:
     self.playerStatsAlert.firstOtherButtonIndex animated:YES];
    return YES;
}
@end
