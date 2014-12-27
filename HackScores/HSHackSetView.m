//
//  HSHackSetView.m
//  HackScores
//
//  Created by Connor Neville on 12/26/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "HSHackSetView.h"
#import "HSHackSet.h"

@interface HSHackSetView ()

@property UILabel* roundScore;
@property UILabel* names;
@property UILabel* singleHack;
@property UILabel* singleHackDescription;
@property UILabel* bestRound;
@property UILabel* bestRoundDescription;
@property UILabel* setScore;
@property UILabel* setScoreDescription;

@end

@implementation HSHackSetView

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if(self) {
        [self applyStyle];
    }
    return self;
}

//Apply basic style
- (void) applyStyle {
    //Background: transparent black (darker than HSLeaderboardView)
    [self setBackgroundColor:[UIColor colorWithRed:0.0f
                                             green:0.0f
                                              blue:0.0f
                                             alpha:0.5f]];
    //Rounded white border
    [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.layer setBorderWidth: 1.0f];
    [self.layer setCornerRadius: 2.0f];
}

//Process for each label: generate (and apply style effects),
//Add to view, then add auto layout constraints
- (void) addHackContent: (HSHackSet*) hackSet {
    self.roundScore = [self generateRoundScoresLabel:hackSet];
    [self addSubview: self.roundScore];
    [self makeRoundScoreConstraints];
    
    self.names = [self generateNamesLabel:hackSet];
    [self addSubview:self.names];
    [self makeNamesConstraints];
    
    self.singleHack = [self generateSingleHackLabel: hackSet];
    [self addSubview:self.singleHack];
    [self makeSingleHackConstraints];
    
    self.singleHackDescription = [self generateSingleHackDescriptionLabel];
    [self addSubview:self.singleHackDescription];
    [self makeSingleHackDescriptionConstraints];
    
    self.bestRound = [self generateBestRoundLabel: hackSet];
    [self addSubview:self.bestRound];
    [self makeBestRoundConstraints];
    
    self.bestRoundDescription = [self generateBestRoundDescriptionLabel];
    [self addSubview:self.bestRoundDescription];
    [self makeBestRoundDescriptionConstraints];

    self.setScore = [self generateSetScoreLabel: hackSet];
    [self addSubview:self.setScore];
    [self makeSetScoreConstraints];
    
    self.setScoreDescription = [self generateSetScoreDescriptionLabel];
    [self addSubview:self.setScoreDescription];
    [self makeSetScoreDescriptionConstraints];
}

+ (UIColor*) darkRedColor {
    return [UIColor colorWithRed:(200.0f/255.0f)
                           green:(50.0f/255.0f)
                            blue:(50.0f/255.0f)
                           alpha:1.0f];
}
+ (CGFloat) sidebarFontSize {
    return 24.0f;
}
+ (NSString*) sidebarFontName {
    return @"DIN Condensed";
}

- (UILabel*) generateRoundScoresLabel: (HSHackSet*) hackSet {
    NSMutableArray* roundScores = [hackSet getRoundScores];
    UILabel* roundScore = [[UILabel alloc] init];
    [roundScore setText: [NSString stringWithFormat:@"%d-%d-%d",
                          [roundScores[0] intValue],
                          [roundScores[1] intValue],
                          [roundScores[2] intValue]]];
    [roundScore setFont:[UIFont fontWithName:@"DIN Condensed" size:52.0f]];
    [roundScore setTextAlignment:NSTextAlignmentCenter];
    [roundScore setTextColor: [UIColor whiteColor]];
    return roundScore;
}
- (void) makeRoundScoreConstraints {
    self.roundScore.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roundScore
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.5
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roundScore
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1.0
                                                      constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roundScore
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeadingMargin
                                                    multiplier:1.0
                                                      constant:0]];
}
- (UILabel*) generateNamesLabel: (HSHackSet*) hackSet {
    UILabel* names = [[UILabel alloc] init];
    [names setText: [NSString stringWithFormat:@"%@-%@-%@",
                     hackSet.playerNames[0],
                     hackSet.playerNames[1],
                     hackSet.playerNames[2]]];
    [names setNumberOfLines: 3];
    [names setTextColor: [UIColor whiteColor]];
    [names setFont: [UIFont fontWithName:@"Avenir" size:16.0f]];
    [names setTextAlignment:NSTextAlignmentCenter];
    return names;
}
- (void) makeNamesConstraints {
    self.names.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.names
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.roundScore
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.names
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.roundScore
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
}

- (UILabel*) generateSingleHackLabel: (HSHackSet*) hackSet {
    UILabel* singleHack = [[UILabel alloc] init];
    int singleHackValue = [[hackSet getBestHack] intValue];
    [singleHack setText: [NSString stringWithFormat:@"%d", singleHackValue]];
    [singleHack setTextColor: [HSHackSetView darkRedColor]];
    [singleHack setFont: [UIFont fontWithName:[HSHackSetView sidebarFontName] size:[HSHackSetView sidebarFontSize]]];
    return singleHack;
}
- (void) makeSingleHackConstraints {
    self.singleHack.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.singleHack
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailingMargin
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.singleHack
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1
                                                      constant:0]];
}
- (UILabel*) generateSingleHackDescriptionLabel {
    UILabel* singleHackDescription = [[UILabel alloc] init];
    [singleHackDescription setText: @"SINGLE HACK"];
    [singleHackDescription setTextColor: [UIColor whiteColor]];
    [singleHackDescription setFont: [UIFont fontWithName:[HSHackSetView sidebarFontName] size:[HSHackSetView sidebarFontSize]]];
    return singleHackDescription;
}
- (void) makeSingleHackDescriptionConstraints {
    self.singleHackDescription.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.singleHackDescription
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.singleHack
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.singleHackDescription
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1
                                                      constant:0]];
}
- (UILabel*) generateBestRoundLabel: (HSHackSet*) hackSet {
    UILabel* bestRound = [[UILabel alloc] init];
    int bestRoundValue = [[hackSet getBestRound] intValue];
    [bestRound setText: [NSString stringWithFormat:@"%d", bestRoundValue]];
    [bestRound setTextColor: [HSHackSetView darkRedColor]];
    [bestRound setFont: [UIFont fontWithName:[HSHackSetView sidebarFontName] size:[HSHackSetView sidebarFontSize]]];
    return bestRound;
}
- (void) makeBestRoundConstraints {
    self.bestRound.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bestRound
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailingMargin
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bestRound
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.singleHack
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:5]];
}
- (UILabel*) generateBestRoundDescriptionLabel {
    UILabel* bestRoundDescription = [[UILabel alloc] init];
    [bestRoundDescription setText: @"BEST ROUND"];
    [bestRoundDescription setTextColor: [UIColor whiteColor]];
    [bestRoundDescription setFont: [UIFont fontWithName:[HSHackSetView sidebarFontName] size:[HSHackSetView sidebarFontSize]]];
    return bestRoundDescription;
}
- (void) makeBestRoundDescriptionConstraints {
    self.bestRoundDescription.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bestRoundDescription
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.bestRound
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bestRoundDescription
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.singleHackDescription
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:5]];
}
- (UILabel*) generateSetScoreLabel: (HSHackSet*) hackSet {
    UILabel* setScore = [[UILabel alloc] init];
    int setScoreValue = [[hackSet getSetScore] intValue];
    [setScore setText: [NSString stringWithFormat:@"%d", setScoreValue]];
    [setScore setTextColor: [HSHackSetView darkRedColor]];
    [setScore setFont: [UIFont fontWithName:[HSHackSetView sidebarFontName] size:[HSHackSetView sidebarFontSize]]];
    return setScore;
}
- (void) makeSetScoreConstraints {
    self.setScore.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.setScore
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailingMargin
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.setScore
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.bestRound
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:5]];
}
- (UILabel*) generateSetScoreDescriptionLabel {
    UILabel* setScoreDescription = [[UILabel alloc] init];
    [setScoreDescription setText: @"SET SCORE"];
    [setScoreDescription setTextColor: [UIColor whiteColor]];
    [setScoreDescription setFont: [UIFont fontWithName:[HSHackSetView sidebarFontName] size:[HSHackSetView sidebarFontSize]]];
    return setScoreDescription;
}
- (void) makeSetScoreDescriptionConstraints {
    self.setScoreDescription.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.setScoreDescription
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.setScore
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.setScoreDescription
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.bestRoundDescription
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:5]];
}

@end
