//
//  HSResultsViewController.m
//  HackScores
//
//  Created by Connor Neville on 12/25/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "HSResultsViewController.h"
#import "HSPlayViewController.h"
#import "HSHackSet.h"

@interface HSResultsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *roundByRoundScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestRoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestHackLabel;
@property (weak, nonatomic) IBOutlet UILabel *setScoreLabel;

- (IBAction)returnButtonPressed:(id)sender;

@end

@implementation HSResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Populate all UILabels with data based on HSHackSet passed from HSPlayViewController
    [self.roundByRoundScoreLabel setText: [NSString stringWithFormat:
                                           @"%d-%d-%d", [[[self.hackSet getRoundScores] objectAtIndex:0] intValue],
                                           [[[self.hackSet getRoundScores] objectAtIndex:1] intValue],
                                           [[[self.hackSet getRoundScores] objectAtIndex:2] intValue]]];
    [self.bestRoundLabel setText: [NSString stringWithFormat:@"%d", [[self.hackSet getBestRound] intValue]]];
    [self.bestHackLabel setText: [NSString stringWithFormat:@"%d", [[self.hackSet getBestHack] intValue]]];
    [self.setScoreLabel setText: [NSString stringWithFormat:@"%d", [[self.hackSet getSetScore] intValue]]];
}

//Return to play scene
//Refresh play scene and update set number
- (IBAction)returnButtonPressed:(id)sender {
    HSPlayViewController* previousView = (HSPlayViewController*) self.presentingViewController;
    [previousView refreshRetainingSetNumber];
    [previousView dismissViewControllerAnimated:TRUE completion:nil];
}
@end
