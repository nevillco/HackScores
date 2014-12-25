//
//  HSHackSet.h
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

@interface HSHackSet : NSObject

@property NSMutableArray* attempts;

- (id) initWithAttempts: (NSMutableArray*) attempts;

@end