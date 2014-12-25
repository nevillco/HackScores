//
//  SecondViewController.m
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "PlayViewController.h"
#import "CNLabel.h"
#import "HSHackSet.h"

@interface PlayViewController ()

- (IBAction)increaseAttemptScore:(id)sender;
- (IBAction)decreaseAttemptScore:(id)sender;

@property (weak, nonatomic) IBOutlet CNLabel *attemptScoreLabel;
@property (weak, nonatomic) IBOutlet CNLabel *pointsLabel;
@property (weak, nonatomic) IBOutlet CNLabel *hackLabel;
@property (weak, nonatomic) IBOutlet CNLabel *roundLabel;
@property (weak, nonatomic) IBOutlet CNLabel *setLabel;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hackSet = [[HSHackSet alloc] initWithAttempts:[[NSMutableArray alloc] init]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)increaseAttemptScore:(id)sender {
    [self.attemptScoreLabel incrementTextAndRevertAfter:FALSE];
}

- (IBAction)decreaseAttemptScore:(id)sender {
    [self.attemptScoreLabel decrementTextAndRevertAfter:FALSE withBound:0];
}
@end
