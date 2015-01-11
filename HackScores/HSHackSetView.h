//
//  HSHackSetView.h - view for displaying data of a HSHackSet
//  HackScores
//
//  Created by Connor Neville on 12/26/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSHackSet.h"

@interface HSHackSetView : UIControl

- (id) init;
- (id) initWithCoder:(NSCoder *)aDecoder;

@property HSHackSet* hackData;

- (void) addHackContent: (HSHackSet*) hackSet;

@end
