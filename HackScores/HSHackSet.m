//
//  HSHackSet.m
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSHackSet.h"

@implementation HSHackSet

- (id) initWithAttempts: (NSMutableArray*) attempts {
    self = [super init];
    if(self) {
        [self setAttempts: attempts];
    }
    return self;
}

@end