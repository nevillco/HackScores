//
//  HSSettingsViewController.m
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
- (IBAction)saveNamesButtonPressed:(id)sender;

@end

@implementation HSSettingsViewController

- (void) viewDidLoad {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self.numberOfHacksField setText:[NSString stringWithFormat:@"%d",
                                      [delegate getHacksPerRound].intValue]];
    for(int i = 0; i < [delegate getSavedNames].count; i++) {
        UITextField* currentField = self.savedNameFields[i];
        [currentField setText:[[delegate getSavedNames] objectAtIndex: i]];
    }
}

- (NSMutableSet*) getSavedNamesFromTextFields {
    NSMutableSet* names = [[NSMutableSet alloc] init];
    for(UITextField* nameField in self.savedNameFields)
        if(![nameField.text isEqualToString:@""])
            [names addObject:nameField.text];
    return names;
}

- (IBAction)returnButtonPressed:(id)sender {
    HSStatsViewController* previous = (HSStatsViewController*)self.presentingViewController;
    [previous viewDidLoad];
    [previous dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)saveNamesButtonPressed:(id)sender {
    NSMutableSet* savedNames = [self getSavedNamesFromTextFields];
    NSMutableArray* savedNamesArray = [[savedNames allObjects] mutableCopy];
    
    int numberOfHacks = [self.numberOfHacksField text].intValue;
    if(numberOfHacks <= 0) {
        [self.numberOfHacksLabel displayMessage:@"The number of hacks must be a positive number."
                                    revertAfter:TRUE
                                      withColor:[CNLabel errorColor]];
        return;
    }
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate writeSettingsWithHacksPerRound:[NSNumber numberWithInt:numberOfHacks]
                               andSavedNames:savedNamesArray];
    [self.savedNamesLabel displayMessage:@"Your settings have been saved." revertAfter:TRUE];
}
@end
