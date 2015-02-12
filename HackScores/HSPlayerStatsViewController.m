//
//  HSPlayerStatsViewController.m
//  HackScores
//
//  Created by Connor Neville on 2/11/15.
//  Copyright (c) 2015 connorneville. All rights reserved.
//

#import "HSPlayerStatsViewController.h"
#import "HSSetStatsViewController.h"
#import "HSStatsViewController.h"
#import "HSHackSet.h"

@interface HSPlayerStatsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)returnButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet CNLabel *averageSetLabel;
@property (weak, nonatomic) IBOutlet CNLabel *averageRoundLabel;
@property (weak, nonatomic) IBOutlet CNLabel *averageHackLabel;
@property (weak, nonatomic) IBOutlet CNLabel *bestSetLabel;
@property (weak, nonatomic) IBOutlet CNLabel *bestRoundLabel;
@property (weak, nonatomic) IBOutlet CNLabel *bestHackLabel;

@end

@implementation HSPlayerStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Clear background
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    //Row height
    self.tableView.rowHeight = 90.0f;
    //Player name label
    [self.playerNameLabel setText:self.playerName];
    //Averages labels
    [self.averageSetLabel setTextToInt:[self getAverageSetScore]];
    [self.averageRoundLabel setTextToInt:[self getAverageRoundScore]];
    [self.averageHackLabel setText:[NSString stringWithFormat:@"%.02f",[self getAverageHack]]];
    //Bests labels
    [self.bestSetLabel setTextToInt:[self getBestSetScore]];
    [self.bestRoundLabel setTextToInt:[self getBestRound]];
    [self.bestHackLabel setTextToInt:[self getBestHack]];
}

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        NSLog(@"%@", subview);
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self hackData] count];
    //return MIN(5, [[self hackData] count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PlayerStatsTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    long index = MAX(0, [[self hackData] count] - 1 - indexPath.row);
    HSHackSet* currentData = [[self hackData] objectAtIndex: index];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Date of game
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEYYYYMMMdhmma" options:0 locale:[NSLocale currentLocale]]];
    
    NSString* dateAsString = [formatter stringFromDate:[currentData dateOfGame]];
    //Label for date of game
    UILabel* dateLabel = [[UILabel alloc] init];
    [dateLabel setText: dateAsString];
    [dateLabel setFont: [UIFont fontWithName:@"Avenir" size:18.0f]];
    [dateLabel setTextColor:[UIColor redColor]];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview: dateLabel];
    dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addConstraint: [NSLayoutConstraint constraintWithItem:dateLabel
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:cell.contentView
                                                                  attribute:NSLayoutAttributeLeadingMargin
                                                                 multiplier:1.0f
                                                                   constant:0.0f]];
    [cell.contentView addConstraint: [NSLayoutConstraint constraintWithItem:dateLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:cell.contentView
                                                                  attribute:NSLayoutAttributeTopMargin
                                                                 multiplier:1.0f
                                                                   constant:0.0f]];
    //Round scores
    NSMutableArray* roundScores = [currentData getRoundScores];
    NSString* roundScoresString = [NSString stringWithFormat:@"%@ - %@ - %@", roundScores[0], roundScores[1],
                                   roundScores[2]];
    //Label for round scores
    UILabel* roundScoresLabel = [[UILabel alloc] init];
    [roundScoresLabel setText: roundScoresString];
    [roundScoresLabel setFont:[UIFont fontWithName:@"DIN Condensed" size:42.0f]];
    [roundScoresLabel setTextColor:[UIColor whiteColor]];
    [cell.contentView addSubview: roundScoresLabel];
    roundScoresLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addConstraint: [NSLayoutConstraint constraintWithItem:roundScoresLabel
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:cell.contentView
                                                                  attribute:NSLayoutAttributeLeadingMargin
                                                                 multiplier:1.0f
                                                                   constant:0.0f]];
    [cell.contentView addConstraint: [NSLayoutConstraint constraintWithItem:roundScoresLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:dateLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:10.0f]];
    
    //Player names
    NSMutableArray* playerNames = [currentData playerNames];
    NSString* playerNamesString = playerNames[0];
    for(int i = 1; i < playerNames.count; i++) {
        playerNamesString = [playerNamesString stringByAppendingString:
                             [NSString stringWithFormat:@"\n%@", playerNames[i]]];
    }
    
    //Label for player names
    UILabel* playersLabel = [[UILabel alloc] init];
    [playersLabel setText: playerNamesString];
    [playersLabel setFont: [UIFont fontWithName:@"Avenir" size:18.0f]];
    [playersLabel setTextColor:[UIColor whiteColor]];
    [playersLabel setNumberOfLines:0];
    [playersLabel setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview: playersLabel];
    playersLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addConstraint: [NSLayoutConstraint constraintWithItem:playersLabel
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:cell.contentView
                                                                  attribute:NSLayoutAttributeTrailingMargin
                                                                 multiplier:1.0f
                                                                   constant:0.0f]];
    [cell.contentView addConstraint: [NSLayoutConstraint constraintWithItem:playersLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:cell.contentView
                                                                  attribute:NSLayoutAttributeTopMargin
                                                                 multiplier:1.0f
                                                                   constant:0.0f]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long index = MAX(0, [[self hackData] count] - 1 - indexPath.row);
    [self setSelectedData: [[self hackData] objectAtIndex:index]];
    [self performSegueWithIdentifier:@"PlayerStatsToSetStatsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PlayerStatsToSetStatsSegue"])
    {
        HSSetStatsViewController *destination = [segue destinationViewController];
        [destination setHackData: self.selectedData];
    }
}

//Methods to populate statistic labels

- (int)getAverageSetScore {
    double totalSetScores = 0;
    for(HSHackSet* hackSet in self.hackData) {
        totalSetScores += [hackSet getSetScore].doubleValue;
    }
    return (int)(totalSetScores / (double)self.hackData.count);
}

- (int)getAverageRoundScore {
    double totalRoundScores = 0;
    double numRounds = 0;
    for(HSHackSet* hackSet in self.hackData) {
        for(NSNumber* roundScore in [hackSet getRoundScores]) {
            totalRoundScores += roundScore.doubleValue;
            numRounds++;
        }
    }
    return (int)(totalRoundScores / numRounds);
}

- (double)getAverageHack {
    double totalHacks = 0;
    double numAttempts = 0;
    for(HSHackSet* hackSet in self.hackData) {
        for(NSNumber* attempt in [hackSet attempts]) {
            totalHacks += attempt.doubleValue;
            numAttempts++;
        }
    }
    return (totalHacks / numAttempts);
}

- (int)getBestSetScore {
    int bestSet = 0;
    for(HSHackSet* hackSet in self.hackData) {
        bestSet = MAX(bestSet, [hackSet getSetScore].intValue);
    }
    return bestSet;
}

- (int)getBestRound {
    int bestRound = 0;
    for(HSHackSet* hackSet in self.hackData) {
        for(NSNumber* roundScore in [hackSet getRoundScores]) {
            bestRound = MAX(bestRound, roundScore.intValue);
        }
    }
    return bestRound;
}

- (int)getBestHack {
    int bestHack = 0;
    for(HSHackSet* hackSet in self.hackData) {
        bestHack = MAX(bestHack, [hackSet getBestHack].intValue);
    }
    return bestHack;
}

//Return to previous scene
//No need to reload stats because game wasn't played
- (IBAction)returnButtonPressed:(id)sender {
    HSStatsViewController* previous = (HSStatsViewController*)self.presentingViewController;
    [previous dismissViewControllerAnimated:TRUE completion:nil];
}
@end
