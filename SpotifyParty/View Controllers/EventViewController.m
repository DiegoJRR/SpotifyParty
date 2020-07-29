//
//  EventViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 24/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "EventViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "Song.h"
#import "SongTableViewCell.h"

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) NSMutableArray *songs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) APIManager *apiManager;
@property (weak, nonatomic) IBOutlet UITextField *songsURLField;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set self as dataSource and delegate for the tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Set the app delegate, to see the users access tokens
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.apiManager = [[APIManager alloc] initWithToken:self.delegate.sessionManager.session.accessToken];
    // Set poster to nil to remove the old one (when refreshing) and query for the new one
    self.posterImageView.image = nil;
    [self.posterImageView setImageWithURL:[NSURL URLWithString: self.event.playlist.imageURLString]];
    self.eventNameLabel.text = self.event.eventName;
    
    self.songs = [[NSMutableArray alloc] init];
    [self fetchSongs];
    
}

- (void) fetchSongs {
    
    [self.apiManager getPlaylistTracks:self.event.playlist.spotifyID withCompletion:^(NSDictionary * _Nonnull responseData, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
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
- (IBAction)addSongTapped:(id)sender {
    
    if(self.songsURLField.hasText) {
        NSArray *urlComponents = [self.songsURLField.text componentsSeparatedByString:@"/"];
        NSString *path = urlComponents[4];
        NSString *trackURI = [path componentsSeparatedByString:@"?"][0];
        
        
        [self.apiManager getTrack:trackURI withCompletion:^(NSDictionary * _Nonnull responseData, NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                Song *song = [[Song alloc] initWithDictionary:responseData];
                [self.songs insertObject:song atIndex:0];
                [self.tableView reloadData];
            }
        }];
        
        [self.view endEditing:YES];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongTableViewCell"];
    Song *song = self.songs[indexPath.row];
    
    cell.songName.text = song.name;
    cell.authorName.text = song.authorName;
    
    //    cell.albumImage = nil;
    [cell.albumImage setImageWithURL:[NSURL URLWithString: song.imageURL]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (IBAction)tapped:(id)sender {
    [self.view endEditing:YES];
}

@end
