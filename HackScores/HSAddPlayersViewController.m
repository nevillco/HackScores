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
#import "AppDelegate.h"

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
@property (weak, nonatomic) IBOutlet UILabel *savedPlayersLabel;

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
    [self createSavedNameButtons];
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

//Creates UIButtons for each saved name stores in AppDelegate
- (void) createSavedNameButtons {
    //Necessary to use savedPlayersLabel in constraints
    [self.view addSubview:self.savedPlayersLabel];
    //Get saved names
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray* savedNames =[delegate getSavedNames];
    //Store all buttons in temporary array to
    //reference one another in constraints
    NSMutableArray* buttons = [[NSMutableArray alloc] init];
    //Constants used in loop
    int buttonsPerColumn = 4;
    int spacing = 10;
    for(int i = 0; i < savedNames.count; i++) {
        //Button appearance
        UIButton* currentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [currentButton setTitle:savedNames[i] forState:UIControlStateNormal];
        [currentButton setTitleColor:[UIColor colorWithRed:200.0f/255.0f
                                                     green:50.0f/255.0f
                                                      blue:50.0f/255.0f
                                                     alpha:1.0f]
                            forState:UIControlStateNormal];
        [currentButton.titleLabel setFont:[UIFont fontWithName:@"DIN Condensed" size:42.0f]];
        [currentButton.titleLabel setTextColor:[UIColor whiteColor]];
        [currentButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //Add button to view and to array
        [self.view addSubview:currentButton];
        [buttons addObject: currentButton];
        //Add button action
        [currentButton addTarget:self
                   action:@selector(savedNameButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        
        //Constraints
        currentButton.translatesAutoresizingMaskIntoConstraints = NO;
        //Fixed width (for gridlike display)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute 
                                                        multiplier:1.0 
                                                          constant:250]];
        //Vertical position
        if(i % buttonsPerColumn == 0) {
            //If button is first in column, vertical position
            //is based on above label
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.savedPlayersLabel
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:spacing]];
        }
        else {
            //Otherwise, vertical position is based on
            //previously created UIButton
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:buttons[i - 1]
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:spacing]];
            
        }
        //Horizontal position
        if(i < buttonsPerColumn) {
            //If button is in first column, horizontal
            //position is based on view left bound
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeadingMargin
                                                                 multiplier:1.0
                                                                   constant:0]];
        }
        else {
            //Otherwise, horizontal position is based
            //on button from previous column
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:buttons[i - buttonsPerColumn]
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:spacing]];
        }
    }
}

//Return to previous scene
//No need to reload stats because game wasn't played
- (IBAction)returnButtonPressed:(id)sender {
    HSStatsViewController* previous = (HSStatsViewController*)self.presentingViewController;
    [previous viewDidLoad];
    [previous dismissViewControllerAnimated:TRUE completion:nil];
}

//Returns the textfield that should be populated with
//a saved name. Should be the first blank one -
//if none are blank, return the last one
- (UITextField*) nextTextFieldToPopulate {
    int i;
    for(i = 0; i < self.nameFields.count; i++) {
        UITextField* currentTextField = self.nameFields[i];
        if([currentTextField.text length] == 0)
            return currentTextField;
    }
    return self.nameFields[i - 1];
}

//Action shared by all buttons generated for saved names
- (IBAction)savedNameButtonPressed:(id)sender {
    NSString* namePressed = [((UIButton*)sender).titleLabel text];
    UITextField* fieldToPopulate = [self nextTextFieldToPopulate];
    [fieldToPopulate setText: namePressed];
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
