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
#import "UIImageView+AFNetworking.h"
#import "EventViewController.h"
#import "DYQRCodeDecoderViewController.h"

@interface FindEventsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *events;
@property (strong, nonatomic) AppDelegate *delegate;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(checkForEvent:)
        name:UIApplicationWillEnterForegroundNotification
        object:nil];
    
    //will refresh the table view
       self.refreshControl = [[UIRefreshControl alloc] init];
       [self.refreshControl addTarget:self action:@selector(fetchEvents) forControlEvents:UIControlEventValueChanged];
       [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0.7;
}

- (void) checkForEvent:(NSNotification *)notification {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *eventID = [userDefaults objectForKey:@"event"];
    
    if (eventID) {
        [self segueToEvent: eventID];
        [userDefaults setObject:nil forKey:@"event"];
    }
}

-(void)fetchEvents{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"playlist"];
    
    // Fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if (events != nil && !error) {
            // Reverse the posts to show the most recent ones first
//            events = [[events reverseObjectEnumerator] allObjects];
            
            self.events = [NSMutableArray arrayWithArray:events];
            [self.tableView  reloadData];
            [self.refreshControl endRefreshing];
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
    [event fetchIfNeeded];
    
    // Create the request for the poster image
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: event.playlist.imageURLString]];
    
    // Set poster to nil to remove the old one (when refreshing) and query for the new one
    cell.playlistImage.image = nil;
    
    // Instantiate a weak link to the cell and fade in the image in the request
    __weak EventTableViewCell *weakSelf = cell;
    [weakSelf.playlistImage setImageWithURLRequest:request placeholderImage:nil
                                           success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            weakSelf.playlistImage.alpha = 0.0;
            weakSelf.playlistImage.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.playlistImage.alpha = 1.0;
            }];
        }
        else {
            weakSelf.playlistImage.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    
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

- (void) segueToEvent: (NSString *) eventID {
    // TODO: Handle an error (non existing key/event for example)
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    query.limit = 1;
    [query whereKey:@"objectId" equalTo:eventID];
    [query includeKey:@"author"];
    [query includeKey:@"playlist"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if (events != nil && !error) {
            Event *event = (Event *)events[0];
            [self performSegueWithIdentifier:@"segueWithQR" sender:event];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)scanQR:(id)sender {
    DYQRCodeDecoderViewController *vc = [[DYQRCodeDecoderViewController alloc] initWithCompletion:^(BOOL succeeded, NSString *result) {
        if (succeeded) {
            NSLog(@"%@", result);
            
            // If there's a string decoded, query it from the Parse backend
            [self segueToEvent:result];
            
        } else {
            NSLog(@"failed");
        }
    }];

    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:NULL];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"eventViewSegue"]) {
        // Set the tappedCell as the cell that initiated the segue
        UITableViewCell *tappedCell = sender;
        
        // Get the corresponding indexPath of that cell
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)tappedCell];
        
        // Get the cell corresponding to that cell
        Event *event = self.events[indexPath.row];
        
        // Set the viewController to segue into and pass the movie object
        EventViewController *eventViewController = [segue destinationViewController];
        eventViewController.event = event;
        
    } else if ([segue.identifier isEqualToString:@"segueWithQR"]) {
        // Set the viewController to segue into and pass the movie object
        EventViewController *eventViewController = [segue destinationViewController];
        eventViewController.event = sender;
    }
    

}

@end
