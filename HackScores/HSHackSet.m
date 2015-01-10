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
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    int hacksPerRound = [delegate getHacksPerRound].intValue;
    if(self.roundScores != nil)
        return self.roundScores;
    NSMutableArray* roundScores = [[NSMutableArray alloc] init];
    //For each round (app does not allow variable no. of rounds)
    for(int i = 0; i < 3; i++) {
        int roundScore = 0;
        //For each (variable) number of hacks per round,
        //add to count
        for(int j = 0; j < hacksPerRound; j++) {
            int currentIndex = (hacksPerRound * i) + j;
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

//Get average hack: used to display add attempt buttons
- (int) getAverageHack {
    int total = 0;
    for(int i = 0; i < [self attempts].count; i++) {
        total += [[self.attempts objectAtIndex:i] intValue];
    }
    return total / [self attempts].count;
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

- (void) writeToCoreData {
    
    
}

//Compare method used to merge sort list of HSHackSets
//Each leaderboard uses a different dataSortMode
- (NSComparisonResult)compare:(HSHackSet*)object {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //How to compare two HSHackSets depends
    //on AppDelegate's sort mode
    switch(delegate.dataSortMode) {
            
        case SortByBestLine: {
            int netCount = 0;
            //For each of 3 major stats, increment count if self
            //has better value, decrement otherwise
            
            //Compare best hacks
            if([self getBestHack].intValue > [object getBestHack].intValue)
                netCount++;
            else if([self getBestHack].intValue < [object getBestHack].intValue)
                netCount--;
            
            //Compare best rounds
            if([self getBestRound].intValue > [object getBestRound].intValue)
                netCount++;
            else if([self getBestRound].intValue < [object getBestRound].intValue)
                netCount--;
            
            //Compare best rounds
            if([self getSetScore].intValue > [object getSetScore].intValue)
                netCount++;
            else if([self getSetScore].intValue < [object getSetScore].intValue)
                netCount--;
            //Return value based on overall sign (positive,
            //negative or zero) of netCount
            
            //NSLog(@"Comparing items with bestHacks (%d, %d),"
                  //"bestRounds (%d, %d), setScores (%d, %d) gives netCount %d",
                  //[self getBestHack].intValue, [object getBestHack].intValue,
                  //[self getBestRound].intValue, [object getBestRound].intValue,
                  //[self getSetScore].intValue, [object getSetScore].intValue, netCount);
            
            if(netCount > 0)
                return NSOrderedAscending;
            else if(netCount < 0)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }
            
        //Remaining 3 cases are far simpler than best overall
            
        case SortByBestHack: {
            if([self getBestHack].intValue > [object getBestHack].intValue)
                return NSOrderedAscending;
            else if([self getBestHack].intValue < [object getBestHack].intValue)
                return NSOrderedDescending;
            return NSOrderedSame;
        }
            
        case SortByBestRound: {
            if([self getBestRound].intValue > [object getBestRound].intValue)
                return NSOrderedAscending;
            else if([self getBestRound].intValue < [object getBestRound].intValue)
                return NSOrderedDescending;
            return NSOrderedSame;
        }
            
        case SortBySetScore: {
            if([self getSetScore].intValue > [object getSetScore].intValue)
                return NSOrderedAscending;
            else if([self getSetScore].intValue < [object getSetScore].intValue)
                return NSOrderedDescending;
            return NSOrderedSame;
        }
    }
}

@end