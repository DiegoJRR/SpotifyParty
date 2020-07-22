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

@interface FindEventsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *events;


@end

@implementation FindEventsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.events = [[NSMutableArray alloc] init];
    
    // Set self as dataSource and delegate for the tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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

@end
