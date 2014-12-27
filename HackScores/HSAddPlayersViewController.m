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
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray* nameFields;
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
    for(UITextField* nameField in self.nameFields) {
        [nameField setText:@""];
        [nameField setDelegate:self];
    }
}

//Button covering entire view for dismissing keyboard on tap
- (IBAction)backgroundButtonPressed:(id)sender {
    for(UITextField* nameField in self.nameFields) {
        [nameField resignFirstResponder];
    }
}

//UITextField delegate method - lets return key go from
//one text field to the next
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType==UIReturnKeyNext) {
        UIView *next = [[textField superview] viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    } else if (textField.returnKeyType==UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

//Continue button press for advancing to HSPlayViewController
- (IBAction)continueButtonPressed:(id)sender {
    //Track total length of names (for displaying them on leaderboards,
    //a cap is needed).
    int totalNamesLength = 0;
    //Array of names to check for duplicates
    NSMutableArray* namesProcessed = [[NSMutableArray alloc] init];
    //Check if any names are empty
    for(UITextField* nameField in self.nameFields) {
        int nameLength = (int)[nameField.text length];
        //If name is blank
        if(nameLength == 0) {
            [self.descriptionLabel displayMessage:@"Names can't be left blank."
                                      revertAfter:TRUE
                                        withColor:[CNLabel errorColor]];
            return;
        }
        if([namesProcessed containsObject:nameField.text]) {
            [self.descriptionLabel displayMessage:@"One or more of the names is a duplicate."
                                      revertAfter:TRUE
                                        withColor:[CNLabel errorColor]];
            return;
        }
        [namesProcessed addObject: nameField.text];
        totalNamesLength += nameLength;
    }
    int maxTotalLength = 21;
    if(totalNamesLength > maxTotalLength) {
        [self.descriptionLabel displayMessage:[NSString stringWithFormat:
                                               @"The combined length of your names"
                                               "are too long (max %d characters).",
                                               maxTotalLength]
                                  revertAfter:TRUE
                                    withColor:[CNLabel errorColor]];
        return;
    }
    [self performSegueWithIdentifier:@"PlayGameSegue" sender:self];
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
        NSMutableArray* playerNames = [[NSMutableArray alloc] init];
        for(UITextField* nameField in self.nameFields) {
            [playerNames addObject: nameField.text];
        }
        [vc setHackSet: [[HSHackSet alloc] initWithPlayerNames: playerNames]];
    }
}

@end
