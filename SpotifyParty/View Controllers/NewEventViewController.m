//
//  NewEventViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 20/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "NewEventViewController.h"
#import "Event.h"
#import "Playlist.h"
#import "AppDelegate.h"
#import "APIManager.h"

@interface NewEventViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *eventNameField;
@property (weak, nonatomic) IBOutlet UISwitch *allowExplicitToggle;
@property (weak, nonatomic) IBOutlet UIPickerView *playlistPicker;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionField;

@property (nonatomic, strong) NSMutableArray *playlists;
@property (strong, nonatomic) AppDelegate *delegate;

// TODO: Add album cover image, pulled from spotify playlist selected

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playlistPicker.delegate = self;
    self.playlistPicker.dataSource = self;
    
    // Set the app delegate, to see the users access tokens
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.playlists = [[NSMutableArray alloc] init];
    
    [self fetchPlaylists];
}

- (void)fetchPlaylists {
    APIManager *apiManager = [[APIManager alloc] initWithToken:self.delegate.sessionManager.session.accessToken];
    
    [apiManager getUserPlaylists:^(NSDictionary * _Nonnull responseData, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSArray *playlists = responseData[@"items"];
            
            for (NSDictionary *dictionary in playlists) {
                // Allocate memory for object and initialize with the dictionary
                Playlist *playlist = [[Playlist alloc] initWithDictionary:dictionary];
                
                // Add the object to the Playlist's array
                [self.playlists addObject:playlist];
            }
            
            // Reload picker view components with newly fetched playlists
            [self.playlistPicker reloadAllComponents];
        }
    }];
    
}

- (IBAction)createEventPressed:(id)sender {
    // TODO: Add alerts, similar to login view
    
    NSString *playlist;
    playlist = [self.playlists objectAtIndex:[self.playlistPicker selectedRowInComponent:0]];
    // TODO: Send the playlist URI instead of its name, when they are actually loaded from Spotify
    
    if (self.eventDescriptionField.hasText && self.eventNameField.hasText) {
        [Event postEvent:self.eventDescriptionField.text withName:self.eventNameField.text withExplicit: @(self.allowExplicitToggle.on ? 1 : 0) withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Event Posted");
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (IBAction)viewPressed:(id)sender {
    [self.view endEditing:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.playlists.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Playlist *playlist = [self.playlists objectAtIndex:row];
    return playlist.name;
}

@end
