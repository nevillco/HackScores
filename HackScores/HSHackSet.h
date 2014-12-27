//
//  HSHackSet.h - data object for a single "set"
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

@interface HSHackSet : NSObject

@property NSMutableArray* attempts;
@property NSMutableArray* playerNames;

- (id) initWithPlayerNames: (NSMutableArray*) playerNames;
- (id) initWithAttempts: (NSMutableArray*) attempts;
- (id) initWithAttempts: (NSMutableArray*) attempts andPlayerNames: (NSMutableArray*) playerNames;

- (void) addAttempt: (int) attempt;

- (NSMutableArray*) getRoundScores;
- (NSNumber*) getBestHack;
- (NSNumber*) getBestRound;
- (NSNumber*) getSetScore;

typedef NS_ENUM(NSUInteger, SortMode) {
    SortByBestLine,
    SortByBestHack,
    SortByBestRound,
    SortBySetScore
};

- (NSComparisonResult)compare:(HSHackSet*)object;

- (void) writeToFile;

@end