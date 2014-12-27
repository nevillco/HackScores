//
//  AppDelegate.m
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "AppDelegate.h"
#import "HSHackSet.h"

@interface AppDelegate ()

@property NSMutableArray* hackSetData;

@end

@implementation AppDelegate

+ (int) HACKS_PER_ROUND {
    return 5;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString* path = [AppDelegate hackSetDataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Uncomment to clear data
    //if([fileManager fileExistsAtPath: path]){
        //NSError* error;
        //[fileManager removeItemAtPath:path error:&error];
    //}
    
    //Create file if it doesn't exist
    if(![fileManager fileExistsAtPath: path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    [self setHackSetData: [self readHackSetData]];
    return YES;
}

//Returns a path to the hack set data file
+ (NSString*) hackSetDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"records.txt"];
}

- (NSMutableArray*) getHackSetData {
    //SHOULD already be instantiated in didFinishLaunchingWithOptions
    if(!self.hackSetData)
        self.hackSetData = [self readHackSetData];
    return self.hackSetData;
}

//Reads data text file into an array of HSHackSet objects
- (NSMutableArray*) readHackSetData {
    NSMutableArray* hackSetData = [[NSMutableArray alloc] init];
    
    NSError* error;
    //String of entire text file contents
    NSString* textFileAsString = [NSString stringWithContentsOfFile:[AppDelegate hackSetDataPath] encoding:NSUTF8StringEncoding error:&error];
    
    //Array of line-by-line contents
    NSArray* hackSetStrings = [textFileAsString componentsSeparatedByCharactersInSet:
                                      [NSCharacterSet newlineCharacterSet]];
    
    //Loop through each line
    for(NSString* hackSetString in hackSetStrings) {
        if([hackSetString isEqualToString:@""])
            return hackSetData;
        //Each name is separated by "|" (as is the last name from all scores)
        NSArray* hackSetComponents = [hackSetString componentsSeparatedByString:@"|"];
        //Player names is done
        NSMutableArray* playerNames = [[NSMutableArray alloc] initWithObjects: hackSetComponents[0],
                                       hackSetComponents[1], hackSetComponents[2], nil];
        //All attempts (integers) separated by spaces
        NSArray* hackValuesAsStrings = [hackSetComponents[3] componentsSeparatedByString:@" "];
        //Now need to convert each string to NSNumber
        NSMutableArray* attempts = [[NSMutableArray alloc] init];
        for(NSString* hackValueString in hackValuesAsStrings) {
            [attempts addObject: [NSNumber numberWithInt:[hackValueString intValue]]];
        }
        //Add HSHackSet object to array
        [hackSetData addObject:[[HSHackSet alloc] initWithAttempts:attempts andPlayerNames:playerNames]];
    }
    return hackSetData;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
