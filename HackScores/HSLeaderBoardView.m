//
//  HSLeaderBoardView.m - view for a leaderboard (containing top 2 scores)
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "HSLeaderBoardView.h"
#import "UIKit/UIKit.h"

@implementation HSLeaderBoardView

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self applySelfStyle];
        [self applyTitleStyle];
        [self addSubview: self.titleLabel];
        [self addTitleLabelConstraints];
    }
    return self;
}

//Stylize self
- (void) applySelfStyle {
    //Background color: transparent black
    [self setBackgroundColor:[UIColor colorWithRed:0.0f
                                             green:0.0f
                                              blue:0.0f
                                             alpha:0.3f]];
    //White rounded border
    [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.layer setBorderWidth: 2.0f];
    [self.layer setCornerRadius: 12.0f];
}

//Stylize title label
- (void) applyTitleStyle {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"Title";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel setFont: [UIFont fontWithName:@"Avenir" size:16.0f]];
}

//Title constraints: center X, top Y (within margins)
- (void) addTitleLabelConstraints {
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1.0
                                                      constant:0]];
}

@end
