//
//  AppDelegate.h
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSHackSet.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property SortMode dataSortMode;

- (NSMutableArray*) getHackSetData;
- (void) sortHackSetData;

+ (int) HACKS_PER_ROUND;
+ (NSString*) hackSetDataPath;

@end

