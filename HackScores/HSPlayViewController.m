//
//  HSPlayViewController.m - view controller for actual ingame scoreboard
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "HSPlayViewController.h"
#import "HSResultsViewController.h"
#import "HSAddPlayersViewController.h"
#import "CNLabel.h"
#import "HSHackSet.h"
#import "AppDelegate.h"

@interface HSPlayViewController ()

//Current attempt score: "right arrow" button pressed
- (IBAction)increaseAttemptScore:(id)sender;
//Current attempt score: "left arrow" button pressed
- (IBAction)decreaseAttemptScore:(id)sender;
//"Add Attempt" button pressed
- (IBAction)addAttempt:(id)sender;
//Return button pressed - reverts segue
- (IBAction)returnButtonPressed:(id)sender;

//Label with current attempt score
@property (weak, nonatomic) IBOutlet CNLabel *attemptScoreLabel;
//Labels in top right for set - round - hack
@property (weak, nonatomic) IBOutlet CNLabel *roundLabel;
@property (weak, nonatomic) IBOutlet CNLabel *setLabel;
@property (weak, nonatomic) IBOutlet CNLabel *hackLabelSmall;
//Labels in middle of screen for points - hack
@property (weak, nonatomic) IBOutlet CNLabel *pointsLabel;
@property (weak, nonatomic) IBOutlet CNLabel *hackLabelBig;
//Labels in bottom of screen for previous rounds
@property (weak, nonatomic) IBOutlet CNLabel *previousRound1;
@property (weak, nonatomic) IBOutlet CNLabel *previousRound2;

@end

@implementation HSPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateWithInitialValues];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Sets the subviews to their initial values
//Useful so that calling viewDidLoad clears
//any residual changes
- (void) populateWithInitialValues {
    [self.attemptScoreLabel setText:@"0"];
    [self.roundLabel setText:@"1"];
    [self.setLabel setText:@"1"];
    [self.hackLabelSmall setText:@"1"];
    [self.pointsLabel setText:@"0"];
    [self.hackLabelBig setText:@"1"];
    [self.previousRound1 setText:@""];
    [self.previousRound2 setText:@""];
}

//Current attempt score: "right arrow" button pressed
- (IBAction)increaseAttemptScore:(id)sender {
    [self.attemptScoreLabel incrementTextAndRevertAfter:FALSE];
}

//Current attempt score: "left arrow" button pressed
//Decrements to a minimum of 0
- (IBAction)decreaseAttemptScore:(id)sender {
    [self.attemptScoreLabel decrementTextAndRevertAfter:FALSE withBound:0];
}

- (IBAction)addAttempt:(id)sender {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //Value of current attempt
    int attemptValue = [self.attemptScoreLabel.text intValue];
    //Add attempt to HSHackSet object
    [self.hackSet addAttempt: attemptValue];
    //Add attempt to total points
    [self.pointsLabel addIntToText:attemptValue revertAfter:FALSE];
    int hacks = [self.hackLabelBig.text intValue];
    //If round is over, start new round
    if(hacks == [delegate getHacksPerRound].intValue)
        [self startNewRound];
    else {
        //Increment both round labels
        [self.hackLabelBig incrementTextAndRevertAfter:FALSE];
        [self.hackLabelSmall incrementTextAndRevertAfter:FALSE];
    }
}

//Change all labels necessary for new round
- (void) startNewRound {
    //Restart hack labels and points label on new round
    [self.hackLabelSmall displayMessage:@"1" revertAfter:FALSE];
    [self.hackLabelBig displayMessage:@"1" revertAfter:FALSE];
    //Possible rounds values: 1, 2, 3
    int rounds = [self.roundLabel.text intValue];
    //If round 1 or 2: increment round label and
    //Display appropriate previous round label
    if(rounds == 1) {
        [self.previousRound1 displayMessage:[self.pointsLabel text] revertAfter:FALSE];
        [self.roundLabel incrementTextAndRevertAfter:FALSE];
    }
    else if(rounds == 2) {
        [self.previousRound2 displayMessage:[self.pointsLabel text] revertAfter:FALSE];
        [self.roundLabel incrementTextAndRevertAfter:FALSE];
    }
    //Round = 3 (last round), set complete
    else
        [self setComplete];
    [self.pointsLabel displayMessage:@"0" revertAfter:FALSE];
}

- (void) setComplete {
    //Write completed HSHackSet to file
    [self.hackSet writeToFile];
    //Add to delegate data
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [[delegate getHackSetData] addObject: self.hackSet];
    
    //Display results (Go to HSResultsViewController)
    [self performSegueWithIdentifier:@"DisplayResultsSegue" sender:self];
}

//Pass HSHackSet to HSResultsViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DisplayResultsSegue"])
    {
        HSResultsViewController *vc = [segue destinationViewController];
        [vc setHackSet: self.hackSet];
    }
}

//Refresh all data for a new game and increment set label
- (void) refreshRetainingSetNumber {
    NSString* setLabelText = [self.setLabel text];
    [self viewDidLoad];
    [self.setLabel setText:setLabelText];
    [self.setLabel incrementTextAndRevertAfter:FALSE];
    
}

//Return to previous scene
- (IBAction)returnButtonPressed:(id)sender {
    HSAddPlayersViewController* previous = (HSAddPlayersViewController*)self.presentingViewController;
    [previous viewDidLoad];
    [previous dismissViewControllerAnimated:TRUE completion:nil];
}
@end
