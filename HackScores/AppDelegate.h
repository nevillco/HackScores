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

- (void) sortHackSetData;
- (void) writeSettingsWithHacksPerRound: (NSNumber*) hacksPerRound
                          andSavedNames: (NSMutableArray*) savedNames;

- (NSMutableArray*) getHackSetData;
- (NSNumber*) getHacksPerRound;
- (NSMutableArray*) getSavedNames;
- (void) clearHackData;
- (void) initializeTextFilesIfNeeded;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (NSString*) hackSetDataPath;

@end

