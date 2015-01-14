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
//Return button pressed - reverts segue
- (IBAction)returnButtonPressed:(id)sender;
//Add attempt button pressed
- (IBAction)addAttempt:(id)sender;
//Undo button pressed
- (IBAction)undoButtonPressed:(id)sender;

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
//Collection of buttons for various values to add
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *addAttemptButtons;
@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property int currentAverage;

@end

@implementation HSPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCurrentAverage: 0];
    [self populateWithInitialValues];
    [self initializeAddAttemptButtons];
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
    [self.roundLabel setText:@"1"];
    [self.setLabel setText:@"1"];
    [self.hackLabelSmall setText:@"1"];
    [self.pointsLabel setText:@"0"];
    [self.hackLabelBig setText:@"1"];
    [self.previousRound1 setText:@""];
    [self.previousRound2 setText:@""];
}

//Initialize displays and values of add attempt buttons
- (void) initializeAddAttemptButtons {
    //Initialize decrease button
    //Must be first so it is a descendant of UIView
    //before addAttemptButtonConstraints
    [self applyRoundedStyleToButton:self.decreaseButton];
    [self addDecreaseButtonConstraints];
    
    //All constraints for increaseButton and undoButton
    //Can be done in IB and will adapt to programmatic constraints
    [self applyRoundedStyleToButton:self.increaseButton];
    [self applyRoundedStyleToButton:self.undoButton];
    
    //Disable until there is an attempt to undo
    [self.undoButton setEnabled:FALSE];
    
    [self addAttemptButtonConstraints];
    NSArray* initialValues = @[@0, @1, @2, @0];
    //Up to 4 buttons can be found, extras not used
    int numButtonsToUse = MIN((int)[self.addAttemptButtons count], 4);
    for(int i = 0; i < numButtonsToUse; i++) {
        UIButton* current = [self.addAttemptButtons objectAtIndex:i];
        [current setTitle: [NSString stringWithFormat:@"%d",
                            [initialValues[i] intValue]] forState:UIControlStateNormal];
        [self applyRoundedStyleToButton:current];
    }
}

//Applies static style to a given button
- (void) applyRoundedStyleToButton: (UIButton*) button {
    //Border color same as text color
    [button.layer setBorderColor:
     [[button titleColorForState:UIControlStateNormal] CGColor]];
    //Rounded border
    [button.layer setBorderWidth: 5.0f];
    [button.layer setCornerRadius: 25.0f];
    [button setClipsToBounds:TRUE];
}

//Add fixed width constraint to decrease button
- (void) addDecreaseButtonConstraints {
    [self.view addSubview: self.decreaseButton];
    [self.decreaseButton sizeToFit];
    self.decreaseButton.translatesAutoresizingMaskIntoConstraints = NO;
    int numButtonsToUse = MIN((int)[self.addAttemptButtons count], 4);
    int padding = 30;
    //Horizontal position: trailing to self.view trailing
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.decreaseButton
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:-1 * padding]];
    //Fixed width: based on how many buttons and superview
    int fixedWidth = (self.view.bounds.size.width - (padding * (numButtonsToUse + 1))) / numButtonsToUse;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.decreaseButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:fixedWidth]];
}

//Add constraints to add attempts buttons
- (void) addAttemptButtonConstraints {
    int numButtonsToUse = MIN((int)[self.addAttemptButtons count], 4);
    int padding = 30;
    for(int i = 0; i < numButtonsToUse; i++) {
        UIButton* currentButton = [self.addAttemptButtons objectAtIndex:i];
        //Add to view (required to add constraints)
        [self.view addSubview:currentButton];
        //Constraints
        currentButton.translatesAutoresizingMaskIntoConstraints = NO;
        //Fixed width: based on how many buttons and superview
        int fixedWidth = (self.view.bounds.size.width - (padding * (numButtonsToUse + 1))) / numButtonsToUse;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:fixedWidth]];
        //Fixed height: based on suggested height and constant for appearance
        CGFloat suggestedHeight = [currentButton sizeThatFits:self.view.bounds.size].height;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:suggestedHeight + 110]];
        
        
        //Horizontal position: first is special case
        //Special case: leading to leading of view
        if(i == 0) {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0
                                                                   constant:padding]];
        }
        //Normal case: leading to trailing of previous button
        else {
            UIButton* previousButton = [self.addAttemptButtons objectAtIndex:i - 1];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:previousButton
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:padding]];
        }
        //Vertical position: above decrease button
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.decreaseButton
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:-1 * padding]];
    }
}

//Current attempt score: increase button pressed
- (IBAction)increaseAttemptScore:(id)sender {
    //Enable decrease button
    UIColor* customRed = [UIColor colorWithRed:200.0f/255.0f
                                         green:50.0f/255.0f
                                          blue:50.0f/255.0f
                                         alpha:1.0f];
    [self.decreaseButton setTitleColor:customRed
                          forState:UIControlStateNormal];
    [self.decreaseButton.layer setBorderColor:[customRed CGColor]];
    [self.decreaseButton setEnabled:TRUE];
    
    UIButton* changeableButton = [self.addAttemptButtons lastObject];
    int currentValue = [changeableButton.titleLabel.text intValue];
    [changeableButton setTitle:[NSString stringWithFormat:@"%d", (currentValue + 1)] forState:UIControlStateNormal];
}

//Current attempt score: decrease button pressed
//Decrements to a minimum of 0
- (IBAction)decreaseAttemptScore:(id)sender {
    UIButton* changeableButton = [self.addAttemptButtons lastObject];
    int currentValue = [changeableButton.titleLabel.text intValue];
    if(currentValue != 0)
        [changeableButton setTitle:[NSString stringWithFormat:@"%d", (currentValue - 1)] forState:UIControlStateNormal];
    if(currentValue == 1) {
        //Disable decrease button
        [self.decreaseButton setTitleColor:[UIColor grayColor]
                              forState:UIControlStateNormal];
        [self.decreaseButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [self.decreaseButton setEnabled:TRUE];
    }
        
}

//Action triggered when an add attempt button is pressed
- (IBAction)addAttempt:(id)sender {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //Value of current attempt
    UIButton* buttonPressed = sender;
    int attemptValue = [buttonPressed.titleLabel.text intValue];
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
        
        //Change color & enable undo button
        UIColor* customRed = [UIColor colorWithRed:200.0f/255.0f
                                             green:50.0f/255.0f
                                              blue:50.0f/255.0f
                                             alpha:1.0f];
        [self.undoButton setTitleColor:customRed
                              forState:UIControlStateNormal];
        [self.undoButton.layer setBorderColor:[customRed CGColor]];
        [self.undoButton setEnabled:TRUE];
    }
    //If there is a change in the average hack, change attempt buttons
    int newHackAverage = [self.hackSet getAverageHack];
    if(newHackAverage != self.currentAverage) {
        [self setCurrentAverage: newHackAverage];
        [self updateAttemptButtonValues];
    }
}

//Undo button action
- (IBAction)undoButtonPressed:(id)sender {
    //Go back 1 hack
    [self.hackLabelBig decrementTextAndRevertAfter:FALSE];
    [self.hackLabelSmall decrementTextAndRevertAfter:FALSE];
    //Subtract points
    int previousAttempt = [[self.hackSet.attempts lastObject] intValue];
    [self.pointsLabel addIntToText:(-1 * previousAttempt) revertAfter:FALSE];
    int currentHack = [self.hackLabelBig.text intValue];
    //Can't undo first hack of round (may change in future but
    //would require a lot of manipulation of labels in clunky way)
    if(currentHack == 1) {
        [self.undoButton setEnabled:FALSE];
        [self.undoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.undoButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    }
    //Remove last hack
    [self.hackSet.attempts removeLastObject];
}

- (void) updateAttemptButtonValues {
    //Buttons contain {a, b, c} starting with
    //a = average - 1 (bounded by 0)
    int firstValue = MAX(0, self.currentAverage - 1);
    for(int i = 0; i < 3; i++) {
        [[self.addAttemptButtons objectAtIndex: i] setTitle:
         [NSString stringWithFormat:@"%d", firstValue + i] forState:UIControlStateNormal];
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

//Set complete - save & display data
- (void) setComplete {
    //Make wasRecentlyPlayed: changes appearance in stats
    self.hackSet.wasRecentlyPlayed = true;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Return"
                                                    message:@"You're in the middle of a game. Are you sure you want to return? You will lose your progress."
                                                   delegate:self
                                          cancelButtonTitle:@"Continue"
                                          otherButtonTitles:@"Cancel", nil];
    [alert show];
}


//UIAlertView action: return if user accepts
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    bool clearData = (buttonIndex == 0);
    if (clearData){
        [self returnToPresentingViewController];
    }
}

- (void) returnToPresentingViewController {
    HSAddPlayersViewController* previous = (HSAddPlayersViewController*)self.presentingViewController;
    [previous viewDidLoad];
    [previous dismissViewControllerAnimated:TRUE completion:nil];
    
}
@end
