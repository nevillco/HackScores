//
//  HSSettingsViewController.m - view controller for settings page
//  HackScores
//
//  Created by Connor Neville on 12/27/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "HSSettingsViewController.h"
#import "HSStatsViewController.h"
#import "AppDelegate.h"
#import "CNLabel.h"

@interface HSSettingsViewController ()

@property (weak, nonatomic) IBOutlet CNLabel*numberOfHacksLabel;
@property (weak, nonatomic) IBOutlet UITextField*numberOfHacksField;
@property (weak, nonatomic) IBOutlet CNLabel*savedNamesLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *savedNameFields;
@property bool alertAccepted;
- (IBAction)returnButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)clearDataButtonPressed:(id)sender;
- (IBAction)backgroundButtonPressed:(id)sender;

@end

@implementation HSSettingsViewController

- (void) viewDidLoad {
    //Populate text fields with prior settings
    [self initializeTextfieldValues];
    //Set all textfield delegates to this controller
    for(UITextField* field in self.savedNameFields) {
        [field setDelegate:self];
    }
    [self.numberOfHacksField setDelegate: self];
}

//Populate text fields with prior settings
- (void) initializeTextfieldValues {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //Set number of hacks
    [self.numberOfHacksField setText:[NSString stringWithFormat:@"%d",
                                      [delegate getHacksPerRound].intValue]];
    //Set each text field to a saved name while there is one
    for(int i = 0; i < [delegate getSavedNames].count; i++) {
        UITextField* currentField = self.savedNameFields[i];
        [currentField setText:[[delegate getSavedNames] objectAtIndex: i]];
    }
}

//Retrieves strings from non-empty text fields
//Returns a set, automatically removing duplicates
- (NSMutableSet*) getSavedNamesFromTextFields {
    NSMutableSet* names = [[NSMutableSet alloc] init];
    for(UITextField* nameField in self.savedNameFields)
        if(![nameField.text isEqualToString:@""])
            [names addObject:nameField.text];
    return names;
}

//Go back to previous (stats) scene, reloading it
- (IBAction)returnButtonPressed:(id)sender {
    HSStatsViewController* previous = (HSStatsViewController*)self.presentingViewController;
    [previous viewDidLoad];
    [previous dismissViewControllerAnimated:TRUE completion:nil];
}

//Save button press action
- (IBAction)saveButtonPressed:(id)sender {
    //Resign keyboards
    [self resignKeyboardResponders];
    
    //Needed for error check
    //and comparison to old value
    int numberOfHacks = [self.numberOfHacksField text].intValue;
    
    //Error check: if field value is (somehow) non-integer,
    //number of hacks will also be 0
    if(numberOfHacks <= 0) {
        [self.numberOfHacksLabel displayMessage:@"The number of hacks must be a positive number."
                                    revertAfter:TRUE
                                      withColor:[CNLabel errorColor]];
        return;
    }
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //If the entered value is different from the previous
    //setting, all data has to be cleared
    if(numberOfHacks != [delegate getHacksPerRound].intValue) {
        //Data will wipe: alert user before continuing
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear Stats"
                                                        message:@"You have changed the number of hacks. For score consistency, this will clear the leaderboard stats. Continue?"
                                                       delegate:self
                                              cancelButtonTitle:@"Continue"
                                              otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
    //No change in hacks per round
    else {
        [self saveDataAndClose];
    }
}

//Action for the "clear data" button (uses same
//alertview method
- (IBAction)clearDataButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear Stats"
                                                    message:@"This will wipe your leaderboards and records. Continue?"
                                                   delegate:self
                                          cancelButtonTitle:@"Continue"
                                          otherButtonTitles:@"Cancel", nil];
    [alert show];
}

//Background tap remove keyboards
- (IBAction)backgroundButtonPressed:(id)sender {
    [self resignKeyboardResponders];
}

//UIAlertView action: clear data if user accepts
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self resignKeyboardResponders];
    bool clearData = (buttonIndex == 0);
    if (clearData){
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate clearHackData];
        [delegate initializeTextFilesIfNeeded];
        [self saveDataAndClose];
        
    }
}

//Method that removes the keyboard from the screen
//on any button press (including hidden background
//button)
- (void) resignKeyboardResponders {
    for(UITextField* nameField in self.savedNameFields) {
        [nameField resignFirstResponder];
    }
    [self.numberOfHacksField resignFirstResponder];
}

//Method for saving settings and returning home
- (void) saveDataAndClose {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //Retrieve data
    NSMutableSet* savedNames = [self getSavedNamesFromTextFields];
    NSMutableArray* savedNamesArray = [[savedNames allObjects] mutableCopy];
    
    int numberOfHacks = [self.numberOfHacksField text].intValue;
    
    //Write settings to text file and display message
    [delegate writeSettingsWithHacksPerRound:[NSNumber numberWithInt:numberOfHacks]
                               andSavedNames:savedNamesArray];
    
    //Use return segue to go back
    [self returnButtonPressed: nil];
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

//UITextField delegate method - requires numbers-only input
//for numberOfHacksField
#define ACCEPTABLE_CHARECTERS @"0123456789"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:
        (NSRange)range replacementString:(NSString *)string  {
    if (textField==self.numberOfHacksField)
    {
        NSCharacterSet *cs =
        [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}
@end
