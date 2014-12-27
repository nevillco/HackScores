//
//  HSAboutViewController.m - view controller for about page
//  HackScores
//
//  Created by Connor Neville on 12/27/14.
//  Copyright (c) 2014 connorneville. All rights reserved.
//

#import "HSAboutViewController.h"

@interface HSAboutViewController ()

- (IBAction)returnButtonPressed:(id)sender;
- (IBAction)sendMailButtonPressed:(id)sender;

@end

@implementation HSAboutViewController

// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Return to previous scene
- (IBAction)returnButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//Send mail button
- (IBAction)sendMailButtonPressed:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"HackScores"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"nevillco@bc.edu"]];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}
@end
