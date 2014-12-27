//
//  HSHackSet.m - data object for a single "set"
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSHackSet.h"
#import "AppDelegate.h"

@interface HSHackSet ()

//Properties are calculated once, then, once calculated,
//Accessed via a getter method (presumed HSHackSet attempt
//data won't change once complete)

@property (strong, nonatomic) NSMutableArray* roundScores;
@property (strong, nonatomic) NSNumber* bestHack;
@property (strong, nonatomic) NSNumber* bestRound;
@property (strong, nonatomic) NSNumber* setScore;

@end

@implementation HSHackSet

//Constructor specifying only player names
//Used in HSAddPlayersViewController
- (id) initWithPlayerNames:(NSMutableArray*) playerNames {
    self = [super init];
    if(self) {
        [self setPlayerNames: playerNames];
        [self setAttempts: [[NSMutableArray alloc] init]];
    }
    return self;
}

//Constructor specifying only attempts
//Not currently used
- (id) initWithAttempts: (NSMutableArray*) attempts {
    self = [super init];
    if(self) {
        [self setPlayerNames:[[NSMutableArray alloc] init]];
        [self setAttempts: attempts];
    }
    return self;
}

//Constructor specifying both public properties
//Used in AppDelegate when reading HSHackSets from text file
- (id) initWithAttempts:(NSMutableArray *)attempts
         andPlayerNames: (NSMutableArray*) playerNames {
    self = [super init];
    if(self) {
        [self setPlayerNames: playerNames];
        [self setAttempts: attempts];
    }
    return self;
}

//Add attempt to array
- (void) addAttempt: (int) attempt {
    [self.attempts addObject:[NSNumber numberWithInt: attempt]];
}

//Get 3 round scores from (attempts per round * 3) attempts
- (NSMutableArray*) getRoundScores {
    if(self.roundScores != nil)
        return self.roundScores;
    NSMutableArray* roundScores = [[NSMutableArray alloc] init];
    //For each round (app does not allow variable no. of rounds)
    for(int i = 0; i < 3; i++) {
        int roundScore = 0;
        //For each (variable) number of hacks per round,
        //add to count
        for(int j = 0; j < [AppDelegate HACKS_PER_ROUND]; j++) {
            int currentIndex = ([AppDelegate HACKS_PER_ROUND] * i) + j;
            roundScore += [[self.attempts objectAtIndex:currentIndex] intValue];
        }
        [roundScores addObject: [NSNumber numberWithInt: roundScore]];
    }
    self.roundScores = roundScores;
    return self.roundScores;
}

//Simple calculation of max value of attempts
- (NSNumber*) getBestHack {
    if(self.bestHack != nil)
        return self.bestHack;
    int bestHack = 0;
    for(int i = 0; i < [self.attempts count]; i++) {
        bestHack = MAX(bestHack, [self.attempts[i] intValue]);
    }
    return [NSNumber numberWithInt: bestHack];
}

//Simple calculation of max value of rounds
//Uses getRoundScores values
- (NSNumber*) getBestRound {
    if(self.bestRound != nil)
        return self.bestRound;
    int bestRound = 0;
    for(int i = 0; i < [self getRoundScores].count; i++) {
        bestRound = MAX(bestRound, [[[self getRoundScores] objectAtIndex:i] intValue]);
    }
    self.bestRound = [NSNumber numberWithInt: bestRound];
    return self.bestRound;
}

//Simple calculation of total value of attempts
- (NSNumber*) getSetScore {
    if(self.setScore != nil)
        return self.setScore;
    int setScore = 0;
    for(int i = 0; i < [self attempts].count; i++) {
        setScore += [[[self attempts] objectAtIndex: i] intValue];
    }
    self.setScore = [NSNumber numberWithInt: setScore];
    return self.setScore;
}

//Write HSHackSet data to end of file
- (void) writeToFile {
    //Names (may contain spaces) separated by "|"
    NSString* namesAsString = [self.playerNames componentsJoinedByString: @"|"];
    //Attempts (integers) separated by spaces
    NSString* dataAsString = [self.attempts componentsJoinedByString:@" "];
    //Last player name separated from attempts by "|"
    NSString* stringToWrite = [NSString stringWithFormat:@"%@|%@\n", namesAsString, dataAsString];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[AppDelegate hackSetDataPath]];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

@end