//
//  HSSetStatsViewController.m
//  HackScores
//
//  Created by Connor Neville on 1/10/15.
//  Copyright (c) 2015 connorneville. All rights reserved.
//

#import "HSSetStatsViewController.h"
#import "HSStatsViewController.h"
#import "CNLabel.h"

@interface HSSetStatsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *playersLabel;

@property (weak, nonatomic) IBOutlet UIView *setDataView;

@property (weak, nonatomic) IBOutlet UILabel *bestHackLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestRoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *setScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *commonHackLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonHacksLabel;
@property (weak, nonatomic) IBOutlet UILabel *worstRoundLabel;

@property (strong, nonatomic) IBOutletCollection(CNLabel) NSArray *roundLabels;
@property (strong, nonatomic) IBOutletCollection(CNLabel) NSArray *roundTotalLabels;

- (IBAction)returnButtonPressed:(id)sender;

@end

@implementation HSSetStatsViewController

- (void)viewDidLoad {
    [self initializeLabels];
    [self stylizeSetView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) initializeLabels {
    //Date
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"YYYYMMMd" options:0 locale:[NSLocale currentLocale]]];
    
    NSString* dateAsString = [formatter stringFromDate:[self.hackData dateOfGame]];
    [self.dateLabel setText:dateAsString];
    
    //Player names
    NSString* playerNames = [[self.hackData playerNames] objectAtIndex: 0];
    for(int i = 1; i < [self.hackData.playerNames count]; i++) {
        playerNames = [playerNames stringByAppendingString:
                       [NSString stringWithFormat:@" | %@",
                        [self.hackData.playerNames objectAtIndex: i]]];
    }
    [self.playersLabel setText: playerNames];
    
    //Left side stats
    //Best hack
    [self.bestHackLabel setText:[NSString stringWithFormat: @"%d",
                                 [[self.hackData getBestHack] intValue]]];
    //Best round
    [self.bestRoundLabel setText:[NSString stringWithFormat: @"%d",
                                 [[self.hackData getBestRound] intValue]]];
    
    //Set score
    [self.setScoreLabel setText:[NSString stringWithFormat: @"%d",
                                 [[self.hackData getSetScore] intValue]]];
    
    //Most common hack
    [self.commonHackLabel setText:[NSString stringWithFormat: @"%d",
                                   [self.hackData getCommonHack]]];
    
    //Number of non-hacks
    [self.nonHacksLabel setText:[NSString stringWithFormat: @"%d",
                                   [self.hackData getNumOccurrencesOf:0]]];
    
    //Worst round
    [self.worstRoundLabel setText:[NSString stringWithFormat: @"%d",
                                 [self.hackData getWorstRound]]];
    
    //Round labels
    for(int i = 0; i < [self.roundLabels count]; i++) {
        CNLabel* currentLabel = [self.roundLabels objectAtIndex:i];
        [currentLabel displayMessage:[self.hackData getRoundString:i withDelimiter:@" • "] revertAfter:FALSE];
    }
    //Round total labels
    for(int i = 0; i < [self.roundTotalLabels count]; i++) {
        CNLabel* currentLabel = [self.roundTotalLabels objectAtIndex:i];
        [currentLabel displayMessage:[NSString stringWithFormat:@"%d",
                                      [[[self.hackData getRoundScores] objectAtIndex: i] intValue] ] revertAfter:FALSE];
    }

}

- (void) stylizeSetView {
    //Background color
    [self.setDataView setBackgroundColor:
     [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f]];
    //Border color
    [self.setDataView.layer setBorderColor:
     [[UIColor colorWithRed:200.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0f] CGColor]];
    //Rounded border
    [self.setDataView.layer setBorderWidth: 5.0f];
    [self.setDataView.layer setCornerRadius: 25.0f];
    //Size to fit contents
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Return to previous scene
//No need to reload stats because game wasn't played
- (IBAction)returnButtonPressed:(id)sender {
    HSStatsViewController* previous = (HSStatsViewController*)self.presentingViewController;
    [previous dismissViewControllerAnimated:TRUE completion:nil];
}

@end
