//
//  HSHackSet.h - data object for a single "set"
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 ;. All rights reserved.
//

@interface HSHackSet : NSObject

@property NSDate* dateOfGame;
@property NSMutableArray* attempts;
@property NSMutableArray* playerNames;
@property bool wasRecentlyPlayed;

- (id) initWithPlayerNames: (NSMutableArray*) playerNames;
- (id) initWithAttempts: (NSMutableArray*) attempts;
- (id) initWithDate: (NSDate*) date andAttempts: (NSMutableArray*) attempts andPlayerNames: (NSMutableArray*) playerNames;

- (void) addAttempt: (int) attempt;

- (NSMutableArray*) getRoundScores;
- (NSNumber*) getBestHack;
- (NSNumber*) getBestRound;
- (int) getWorstRound;
- (NSNumber*) getSetScore;
- (int) getAverageHack;
- (int) getCommonHack;
- (int) getNumOccurrencesOf: (int) value;
- (NSString*) getRoundString: (int) round
               withDelimiter: (NSString*) delimiter;

typedef NS_ENUM(NSUInteger, SortMode) {
    SortByBestLine,
    SortByBestHack,
    SortByBestRound,
    SortBySetScore,
    SortByDate
};

- (NSComparisonResult)compare:(HSHackSet*)object;

- (void) writeToFile;

@end