//
//  HSRecentGamesViewController.m
//  HackScores
//
//  Created by Connor Neville on 1/11/15.
//  Copyright (c) 2015 connorneville. All rights reserved.
//

#import "HSRecentGamesViewController.h"
#import "HSStatsViewController.h"
#import "HSSetStatsViewController.h"
#import "HSHackSet.h"

@interface HSRecentGamesViewController ()

- (IBAction)returnButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property HSHackSet* selectedData;

@end

@implementation HSRecentGamesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Row height
    self.tableView.rowHeight = 90.0f;
    //Clear background
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    // Do any additional setup after loading the view.
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

//Number of rows up to 10
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(10, [self.hackData count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"RecentGamesTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    HSHackSet* currentData = self.hackData[indexPath.row];
    
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
    [dateLabel setTextColor:[UIColor whiteColor]];
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
                             [NSString stringWithFormat:@" - %@", playerNames[i]]];
    }
    
    //Label for player names
    UILabel* playersLabel = [[UILabel alloc] init];
    [playersLabel setText: playerNamesString];
    [playersLabel setFont: [UIFont fontWithName:@"Avenir" size:18.0f]];
    [playersLabel setTextColor:[UIColor whiteColor]];
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
    [self setSelectedData: self.hackData[indexPath.row]];
    [self performSegueWithIdentifier:@"RecentGamesToSetStatsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RecentGamesToSetStatsSegue"])
    {
        HSSetStatsViewController *destination = [segue destinationViewController];
        [destination setHackData: self.selectedData];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
