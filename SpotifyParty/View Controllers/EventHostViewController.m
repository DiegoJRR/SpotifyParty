//
//  EventHostViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 02/08/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "EventHostViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "Song.h"
#import "SongTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>

@interface EventHostViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) APIManager *apiManager;
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSMutableArray *likeActions;
@property (strong, nonatomic) NSMutableArray *addActions;

@end

@implementation EventHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.topItem.title = self.event.eventName;
    
    // Set self as dataSource and delegate for the tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Set the app delegate, to see the users access tokens
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.apiManager = [[APIManager alloc] initWithToken:self.delegate.sessionManager.session.accessToken];
    
    // Initialize mutable arrays
    self.songs = [[NSMutableArray alloc] init];
    self.likeActions = [[NSMutableArray alloc] init];
    self.addActions = [[NSMutableArray alloc] init];
    
    // Fetch the songs
    [self fetchSongs];
}

- (void) fetchSongs {
    [self.apiManager getPlaylistTracks:self.event.playlist.spotifyID withCompletion:^(NSDictionary * _Nonnull responseData, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            [self.songs removeAllObjects];
            
            NSArray *songs = responseData[@"items"];
            
            for (NSDictionary *dictionary in songs) {
                // Allocate memory for object and initialize with the dictionary
                Song *song = [[Song alloc] initWithDictionary:dictionary[@"track"]];
                
                // Add the object to the Playlist's array
                [self.songs addObject:song];
            }
            
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)refreshTapped:(id)sender {
    // This method will query the queue for the given event
    PFQuery *query = [PFQuery queryWithClassName:@"EventQueue"];
    [query whereKey:@"event" equalTo:self.event];
    
    // Fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *actions, NSError *error) {
        if (actions != nil && !error) {
            
            for (NSDictionary *action in actions) {
                EventQueue *actionRequest = [[EventQueue alloc] initWithDictionary:action];
                
                if ([actionRequest.action isEqualToString:@"like"]) {
                    [self.likeActions addObject:actionRequest];
                } else if ([actionRequest.action isEqualToString:@"add"]) {
                    [self.addActions addObject:actionRequest];
                }
                
            }
            
            NSArray *completeSongs = [self addSongsToPlaylist:self.songs withAdded:self.addActions];
            NSArray *newPlaylist = [self reorderSongs: completeSongs withLikes:self.likeActions];
            [self.apiManager replacePlaylist:newPlaylist toPlaylist:self.event.playlist.spotifyID withCompletion:^(NSDictionary * _Nonnull responseData, NSError * _Nonnull error) {
                if (error) {
                    NSLog(@"%@", [error localizedDescription]);
                } else {
                    NSLog(@"Success updating the playlist");
                    
                    // Fetch the new playlist
                    [self fetchSongs];
                    
                    // Remove the add and like requests from the backend
                    for (EventQueue *addAction in self.addActions) {
                        [addAction deleteInBackground];
                    }
                    
                    for (EventQueue *likeAction in self.likeActions) {
                        [likeAction deleteInBackground];
                    }
                    
                    // Clean the local variables
                    [self.addActions removeAllObjects];
                    [self.likeActions removeAllObjects];
                }
            }];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
    
}

- (NSArray *) reorderSongs: (NSArray * _Nullable) songs withLikes: (NSArray * _Nullable) likesActions{
    NSMutableDictionary *songsLikes = [[NSMutableDictionary alloc] init];
    
    // Populate the array with the existing songs
    for (NSString *songURI in songs) {
        [songsLikes setValue: @(0) forKey: songURI];
    }
    
    // Create the dictionary with the like count for the songs modified
    for (EventQueue *like in likesActions) {
        
        if (songsLikes[like.songURI]) {
            int likes = [songsLikes[like.songURI] intValue];
            likes = likes + 1;
            [songsLikes setValue: @(likes) forKey: like.songURI];
        } else {
            int likes = 1;
            [songsLikes setValue: @(likes) forKey: like.songURI];
        }
    }
    
    // Logic to sort the songsURIs in the dictionary by the number of likes
    NSArray *sortedValues = [songsLikes.allValues sortedArrayUsingSelector:@selector(compare:)];
    NSOrderedSet *uniqueValues = [NSOrderedSet orderedSetWithArray:sortedValues];
    NSMutableArray *sortedKeys = [NSMutableArray arrayWithCapacity:songsLikes.count];
    
    for (id val in uniqueValues) {
        NSArray *keys = [songsLikes allKeysForObject:val];
        
        // This sorts all the keys, songURIs, in the dictionary by the likes each one has
        [sortedKeys addObjectsFromArray:[keys sortedArrayUsingSelector:@selector(compare:)]];
    }
    
    // Put them in descending order
    sortedKeys = [[[sortedKeys reverseObjectEnumerator] allObjects] mutableCopy];
    
    return sortedKeys;
}

- (NSArray *) addSongsToPlaylist: (NSArray * _Nullable) songs withAdded: (NSArray * _Nullable) addedActions {
    NSMutableArray *completeSongs = [[NSMutableArray alloc] initWithArray:[songs valueForKey: @"spotifyID"]];
    
    // Go through the addActions array and all the songs to the playlist
    for (EventQueue *addSong in addedActions) {
        [completeSongs addObject:addSong.songURI];
    }
    
    return completeSongs;
}

- (IBAction)endEventTapped:(id)sender {
    // Verify that the user wants to end the event
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"End event" message: @"Are you sure you want to end your event?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self endEvent];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)endEvent {
    [self.event deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    if (succeeded) {
        SceneDelegate *sceneDelegate = (SceneDelegate *) self.view.window.windowScene.delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *mainTabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        sceneDelegate.window.rootViewController = mainTabBar;
    } else {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    }];
}
    
- (IBAction)shareTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:[@"spotify-party-app-login://event/" stringByAppendingString:self.event.objectId]];
    
    // Add the qr image as an activity item and present the sharing view controller
    NSArray *activityItems = @[url];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongTableViewCell"];
    Song *song = self.songs[indexPath.row];
    
    cell.songName.text = song.name;
    cell.authorName.text = song.authorName;
    
    [cell.albumImage setImageWithURL:[NSURL URLWithString: song.imageURL]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

@end
