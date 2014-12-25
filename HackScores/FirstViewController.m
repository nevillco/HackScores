//
//  FirstViewController.m
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "FirstViewController.h"
#import "HSLeaderBoardView.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestLinesLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestHacksLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestRoundsLeaderBoard;
@property (weak, nonatomic) IBOutlet HSLeaderBoardView *bestSetsLeaderBoard;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bestLinesLeaderBoard.titleLabel setText:@"Best Overall Lines"];
    [self.bestHacksLeaderBoard.titleLabel setText:@"Best Single Hacks"];
    [self.bestRoundsLeaderBoard.titleLabel setText:@"Best Rounds (30 Hacks)"];
    [self.bestSetsLeaderBoard.titleLabel setText:@"Best Sets (3 Rounds)"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
