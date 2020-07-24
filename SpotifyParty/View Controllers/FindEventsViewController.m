//
//  FindEventsViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 21/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "FindEventsViewController.h"
#import <Parse/Parse.h>
#import "Event.h"
#import "EventTableViewCell.h"
#import "AppDelegate.h"

@interface FindEventsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *events;
@property (strong, nonatomic) AppDelegate *delegate;

@end

@implementation FindEventsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.events = [[NSMutableArray alloc] init];
    
    // Set self as dataSource and delegate for the tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Set the app delegate, to see the users access tokens
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self fetchEvents];
    
}

-(void)fetchEvents{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    query.limit = 20;
    [query includeKey:@"author"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if (events != nil && !error) {
            // Reverse the posts to show the most recent ones first
            events = [[events reverseObjectEnumerator] allObjects];

            self.events = [NSMutableArray arrayWithArray:events];
            [self.tableView  reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTableViewCell"];
    
    Event *event = self.events[indexPath.row];
    
    cell.eventName.text = event.eventName;
    cell.eventDescription.text = event.eventDescription;
    cell.explicitSongs.text = [event.explicitSongs isEqualToNumber:@(1)] ? @"Explicit" : @"Not Explicit";
    
    return cell;
}

- (IBAction)newEventTapped:(id)sender {
    //This function checks if the user is logged in to Spotify.
    
    // If the user has an access token
    if(self.delegate.sessionManager.session.accessToken) {
        // Manually segue to new event view
        [self performSegueWithIdentifier:@"newEventSegue" sender:nil];
    } else {
        // Prompt the user to sign in with Spotify
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Authorize the app via Spotify" message: @"To create a new event, the app needs to be authorized via your Spotify account" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
        [alert addAction:cancelAction];
        
        // If the user wants to sign in, prompt him here
        UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"Authorize" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self.delegate authorizationFlow];
        }];
        [alert addAction:authAction];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

@end
