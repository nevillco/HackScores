//
//  AppDelegate.m
//  HackScores
//
//  Created by Connor Neville on 12/24/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "AppDelegate.h"
#import "HSHackSet.h"
#import "UIKit/UIKit.h"
#import "CoreData/CoreData.h"
#import "Foundation/Foundation.h"

@interface AppDelegate ()

@property NSMutableArray* hackSetData;
@property NSNumber* hacksPerRound;
@property NSMutableArray* savedNames;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.dataSortMode = SortByBestLine;
    [self initializeTextFilesIfNeeded];
    [self setHackSetData: [self readHackSetData]];
    [self readSettings];
    
    return YES;
}

- (void) initializeTextFilesIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Create file if it doesn't exist
    if(![fileManager fileExistsAtPath: [AppDelegate hackSetDataPath]]) {
        [fileManager createFileAtPath:[AppDelegate hackSetDataPath] contents:nil attributes:nil];
    }
    
    //Write default settings
    if(![fileManager fileExistsAtPath: [AppDelegate settingsDataPath]]) {
        [self writeSettingsWithHacksPerRound: [NSNumber numberWithInt: 30]
                               andSavedNames: [[NSMutableArray alloc] init]];
    }
}

//Methods to get data from settings files.
//Because of small size of file/infrequency of use,
//should be okay to reread settings in case of changes
//before access.

- (NSNumber*) getHacksPerRound {
    [self readSettings];
    return self.hacksPerRound;
}

- (NSMutableArray*) getSavedNames {
    [self readSettings];
    return self.savedNames;
}

//Clears the data file
- (void) clearHackData {
    NSString* path = [AppDelegate hackSetDataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath: path]){
        NSError* error;
        [fileManager removeItemAtPath:path error:&error];
    }
    //Also reset the array
    self.hackSetData = [[NSMutableArray alloc] init];
}

//Clears the data file
- (void) clearSettings {
    NSString* path = [AppDelegate settingsDataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath: path]){
        NSError* error;
        [fileManager removeItemAtPath:path error:&error];
    }
}

//Returns a path to the hack set data file
+ (NSString*) hackSetDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"records.txt"];
}

//Returns a path to the settings data file
+ (NSString*) settingsDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"settings.txt"];
}

//Gets the hackSetData property, initializing it if it hasn't already been accessed
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
    NSString* textFileAsString = [NSString stringWithContentsOfFile:
                                  [AppDelegate hackSetDataPath] encoding:NSUTF8StringEncoding error:&error];
    
    //Array of line-by-line contents
    NSArray* hackSetStrings = [[textFileAsString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]
                               componentsSeparatedByCharactersInSet:
                               [NSCharacterSet newlineCharacterSet]];
    
    //Loop through each line
    for(NSString* hackSetString in hackSetStrings) {
        if([hackSetString isEqualToString:@""])
            return hackSetData;
        //Each name is separated by "|" (as is the last name from all scores)
        NSArray* hackSetComponents = [hackSetString componentsSeparatedByString:@"|"];
        //Get date
        NSString* dateAsString = hackSetComponents[0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        NSDate *dateOfGame = [formatter dateFromString: dateAsString];
        //Get player names
        NSMutableArray* playerNames = [[NSMutableArray alloc] initWithObjects: hackSetComponents[1],
                                       hackSetComponents[2], hackSetComponents[3], nil];
        //All attempts (integers) separated by spaces
        NSArray* hackValuesAsStrings = [hackSetComponents[4] componentsSeparatedByString:@" "];
        //Now need to convert each string to NSNumber
        NSMutableArray* attempts = [[NSMutableArray alloc] init];
        for(NSString* hackValueString in hackValuesAsStrings) {
            [attempts addObject: [NSNumber numberWithInt:[hackValueString intValue]]];
        }
        //Add HSHackSet object to array
        [hackSetData addObject:[[HSHackSet alloc] initWithDate:dateOfGame andAttempts:attempts andPlayerNames:playerNames]];
    }
    return hackSetData;
}

//Reads the settings text file, initializing self.HacksPerRound and self.savedNames
- (void) readSettings {
    NSError* error;
    //String of entire text file contents
    NSString* textFileAsString = [NSString stringWithContentsOfFile:[AppDelegate settingsDataPath] encoding:NSUTF8StringEncoding error:&error];
    //Array of line-by-line contents
    NSArray* contentsByLine = [textFileAsString componentsSeparatedByCharactersInSet:
                               [NSCharacterSet newlineCharacterSet]];
    
    self.hacksPerRound = [NSNumber numberWithInt: [[contentsByLine[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""] intValue]];
    
    NSMutableArray* savedNames = [[NSMutableArray alloc] init];
    for(int i = 1; i < contentsByLine.count; i++) {
        NSString* currentLine = [contentsByLine[i] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if(currentLine.length > 0)
           [savedNames addObject:currentLine];
    }
    self.savedNames = savedNames;
}

//Writes data to settings file
- (void) writeSettingsWithHacksPerRound: (NSNumber*) hacksPerRound
                          andSavedNames: (NSMutableArray*) savedNames {
    
    [self clearSettings];
    [[NSFileManager defaultManager] createFileAtPath:[AppDelegate settingsDataPath] contents:nil attributes:nil];
    
    NSString* stringToWrite = [NSString stringWithFormat:@"%d\n", [hacksPerRound intValue]];
    for(NSString* name in savedNames)
        stringToWrite = [stringToWrite stringByAppendingString:
                         [NSString stringWithFormat:@"%@\n",
                          name]];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[AppDelegate settingsDataPath]];
    [fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
}

//Publically accessible method: calls mergeSort
//on hackSetData
- (void) sortHackSetData {
    self.hackSetData = [self mergeSort:self.hackSetData];
}

//Merge sort implementation
//Can work on NSMutableArray of any object type
-(NSMutableArray *)mergeSort:(NSMutableArray *)unsortedArray
{
    if ([unsortedArray count] < 2)
    {
        return unsortedArray;
    }
    int middle = (int)([unsortedArray count]/2);
    NSRange left = NSMakeRange(0, middle);
    NSRange right = NSMakeRange(middle, ([unsortedArray count] - middle));
    NSMutableArray *rightArr = [[unsortedArray subarrayWithRange:right] mutableCopy];
    NSMutableArray *leftArr = [[unsortedArray subarrayWithRange:left] mutableCopy];
    return [self merge:[self mergeSort:leftArr] andRight:[self mergeSort:rightArr]];
}

//Merge function called by mergeSort
-(NSMutableArray *)merge:(NSMutableArray *)leftArr andRight:(NSMutableArray *)rightArr
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    int right = 0;
    int left = 0;
    
    while (left < [leftArr count] && right < [rightArr count])
    {
        HSHackSet* leftObj = leftArr[left];
        HSHackSet* rightObj = rightArr[right];
        NSComparisonResult comparison = [leftObj compare:rightObj];
        if (comparison != NSOrderedDescending)
        {
            [result addObject:[leftArr objectAtIndex:left++]];
        }
        else
        {
            [result addObject:[rightArr objectAtIndex:right++]];
        }
    }
    NSRange leftRange = NSMakeRange(left, ([leftArr count] - left));
    NSRange rightRange = NSMakeRange(right, ([rightArr count] - right));
    NSArray *newRight = [rightArr subarrayWithRange:rightRange];
    NSArray *newLeft = [leftArr subarrayWithRange:leftRange];
    newLeft = [result arrayByAddingObjectsFromArray:newLeft];
    return [[newLeft arrayByAddingObjectsFromArray:newRight] mutableCopy];
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
