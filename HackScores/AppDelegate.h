//
//  AppDelegate.h
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSMutableArray*) getHackSetData;

+ (int) HACKS_PER_ROUND;
+ (NSString*) hackSetDataPath;

@end

