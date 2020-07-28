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

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) NSMutableArray *songs;


@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set the app delegate, to see the users access tokens
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Set poster to nil to remove the old one (when refreshing) and query for the new one
    self.posterImageView.image = nil;
    [self.posterImageView setImageWithURL:[NSURL URLWithString: self.event.playlist.imageURLString]];
    self.eventNameLabel.text = self.event.playlist.name;
    
    self.songs = [[NSMutableArray alloc] init];
    
    APIManager *apiManager = [[APIManager alloc] initWithToken:self.delegate.sessionManager.session.accessToken];
    
    [apiManager getPlaylistTracks:self.event.playlist.spotifyID withCompletion:^(NSDictionary * _Nonnull responseData, NSError * _Nonnull error) {
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
        }
    }];
}

@end
