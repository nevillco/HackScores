//
//  HSLeaderBoardView.m - view for a leaderboard (containing top 2 scores)
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "HSLeaderBoardView.h"
#import "HSStatsViewController.h"
#import "HSHackSetView.h"
#import "UIKit/UIKit.h"
#import "AppDelegate.h"

@implementation HSLeaderBoardView

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setExpanded: false];
        [self applySelfStyle];
        [self applyTitleStyle];
        [self addSubview: self.titleLabel];
        [self addTitleLabelConstraints];
        [self addZoomGesture];
        [self initializeHackSetViews];
    }
    return self;
}

//Zoom gesture
- (void) addZoomGesture {
    // what object is going to handle the gesture when it gets recognised ?
    // the argument for tap is the gesture that caused this message to be sent
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    
    // set number of taps required
    doubleTap.numberOfTapsRequired = 2;
    
    // now add the gesture recogniser to a view
    // this will be the view that recognises the gesture
    [self addGestureRecognizer:doubleTap];
}

//Double tap action adds size and entries
- (void) doubleTap: (UIGestureRecognizer *)gesture {
    NSArray* allConstraints = self.constraints;
    NSLayoutConstraint* heightConstraint;
    for(int i = 0; i < allConstraints.count; i++) {
        NSLayoutConstraint* constraint = allConstraints[i];
        //Height constraint found
        if(constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
        }
    }
    if(self.expanded) {
        heightConstraint.constant -= 200;
        [self removeNumberOfHackSetViews: 2];
        self.expanded = false;
    }
    else {
        heightConstraint.constant += 200;
        [self addNumberOfHackSetViews: 2];
        self.expanded = true;
    }
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:1.5 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void) initializeHackSetViews {
    [self addNumberOfHackSetViews: 2];
}

//Adds a number of HackSetViews to the view
- (void) addNumberOfHackSetViews: (int) count {
    if(self.hackSetViews == nil) {
        self.hackSetViews = [[NSMutableArray alloc] init];
    }
    int lastExistingIndex = (int)[self.hackSetViews count] - 1;
    for(int i = 0; i < count; i++) {
        HSHackSetView* currentView = [[HSHackSetView alloc] init];
        //Add to view & data
        [self addSubview:currentView];
        [self.hackSetViews addObject: currentView];
        //Leading & trailing
        currentView.translatesAutoresizingMaskIntoConstraints = FALSE;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:currentView
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0f
                                                          constant:10]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:currentView
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0f
                                                          constant:-10]];
        //Height
        [self addConstraint:[NSLayoutConstraint constraintWithItem:currentView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:90]];
        //Vertical position: special case 1st item
        if(lastExistingIndex == -1) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:currentView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0f
                                                              constant:30]];
        }
        else {
            HSHackSetView* previous = self.hackSetViews[lastExistingIndex];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:currentView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:previous
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f
                                                              constant:10]];
        }
        //Get data from delegate
        lastExistingIndex++;
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate setDataSortMode: self.sortMode];
        [delegate sortHackSetData];
        //Populate if there is a hack to do so
        if([[delegate getHackSetData] count] > lastExistingIndex) {
            [currentView addHackContent:[[delegate getHackSetData] objectAtIndex: lastExistingIndex]];
        }
    }
    [self setNeedsDisplay];
}

//Removes HackSetViews from the end of the array
- (void) removeNumberOfHackSetViews: (int) count {
    for(int i = (int)[self.hackSetViews count] - 1; i >=
        MAX(0, [self.hackSetViews count] - 1 - count); i--) {
        HSHackSetView* current = self.hackSetViews[i];
        [current removeFromSuperview];
        [self.hackSetViews removeLastObject];
    }
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
