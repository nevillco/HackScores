//
//  HSAddPlayersViewController.m - view controller for naming 3 players
//  HackScores
//
//  Created by Connor Neville on 12/26/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "HSStatsViewController.h"
#import "HSAddPlayersViewController.h"
#import "HSPlayViewController.h"
#import "CNLabel.h"

@interface HSAddPlayersViewController ()
//Button covering entire view for dismissing keyboard on tap
- (IBAction)backgroundButtonPressed:(id)sender;
//Continue button press for advancing to HSPlayViewController
- (IBAction)continueButtonPressed:(id)sender;
//Return to HSStatsViewController
- (IBAction)returnButtonPressed:(id)sender;
//TextFields containing 3 potential names
@property (weak, nonatomic) IBOutlet UITextField *name1TextField;
@property (weak, nonatomic) IBOutlet UITextField *name2TextField;
@property (weak, nonatomic) IBOutlet UITextField *name3TextField;
//Label displays error if any name is empty
@property (weak, nonatomic) IBOutlet CNLabel *descriptionLabel;

@end

@implementation HSAddPlayersViewController

- (void) viewDidLoad {
    [self populateWithInitialValues];
}

//Sets the subviews to their initial values
//Useful so that calling viewDidLoad clears
//any residual changes
- (void) populateWithInitialValues {
    [self.name1TextField setText:@""];
    [self.name2TextField setText:@""];
    [self.name3TextField setText:@""];
}

//Button covering entire view for dismissing keyboard on tap
- (IBAction)backgroundButtonPressed:(id)sender {
    [self.name1TextField resignFirstResponder];
    [self.name2TextField resignFirstResponder];
    [self.name3TextField resignFirstResponder];
}

//Continue button press for advancing to HSPlayViewController
- (IBAction)continueButtonPressed:(id)sender {
    //Check if any names are empty
    if([self.name1TextField.text length] < 1 ||
       [self.name2TextField.text length] < 1 ||
       [self.name3TextField.text length] < 1)
        [self.descriptionLabel displayMessage:@"Names can't be left blank."
                                  revertAfter:TRUE
                                    withColor:[CNLabel errorColor]];
    else {
        [self performSegueWithIdentifier:@"PlayGameSegue" sender:self];
    }
}

//Return to previous scene
//No need to reload stats because game wasn't played
- (IBAction)returnButtonPressed:(id)sender {
    HSStatsViewController* previous = (HSStatsViewController*)self.presentingViewController;
    [previous viewDidLoad];
    [previous dismissViewControllerAnimated:TRUE completion:nil];
}

//If game is ready to be played, populate target HSPlayViewController
//HSHackSet with player names
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PlayGameSegue"])
    {
        HSPlayViewController *vc = [segue destinationViewController];
        NSMutableArray* playerNames = [[NSMutableArray alloc] initWithObjects:
                                       self.name1TextField.text,
                                       self.name2TextField.text,
                                       self.name3TextField.text, nil];
        [vc setHackSet: [[HSHackSet alloc] initWithPlayerNames: playerNames]];
    }
}

@end
