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
- (IBAction)saveButtonPressed:(id)sender;

@end

@implementation HSSettingsViewController

- (void) viewDidLoad {
    //Populate text fields with prior settings
    [self initializeTextfieldValues];
    //Set all textfield delegates to this controller
    for(UITextField* field in self.savedNameFields) {
        [field setDelegate:self];
    }
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
    NSMutableSet* savedNames = [self getSavedNamesFromTextFields];
    NSMutableArray* savedNamesArray = [[savedNames allObjects] mutableCopy];
    
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
        [delegate clearHackData];
        [delegate initializeTextFilesIfNeeded];
    }
    
    //Write settings to text file and display message
    [delegate writeSettingsWithHacksPerRound:[NSNumber numberWithInt:numberOfHacks]
                               andSavedNames:savedNamesArray];
    [self.savedNamesLabel displayMessage:@"Your settings have been saved." revertAfter:TRUE];
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
@end
