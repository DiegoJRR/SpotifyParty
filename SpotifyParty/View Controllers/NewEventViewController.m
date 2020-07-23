//
//  NewEventViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 20/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "NewEventViewController.h"
#import "Event.h"
#import "AppDelegate.h"
#import "APIManager.h"

@interface NewEventViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *eventNameField;
@property (weak, nonatomic) IBOutlet UISwitch *allowExplicitToggle;
@property (weak, nonatomic) IBOutlet UIPickerView *playlistPicker;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionField;

// TODO: Pull the users playlists from spotify and load them in the view picker
// TODO: Add album cover image, pulled from spotify playlist selected

@property (nonatomic, strong) NSArray *playlists;
@property (strong, nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) NSDictionary *trackInfo;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the app delegate, to see the users access tokens
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    APIManager *apiManager = [[APIManager alloc] initWithToken:self.delegate.sessionManager.session.accessToken];
    
    [apiManager getTrack:^(NSDictionary * _Nonnull responseData, NSError * _Nonnull error) {
        self.trackInfo = responseData;
        
        // TODO: Instantiate playlists & parse the,
        // TODO: Reload picker view data
    }];

    self.playlists = @[@"Rock Playlist", @"Hip Hop Playlist", @"My epic playlist", @"Another Option"];
    
    self.playlistPicker.dataSource = self;
    self.playlistPicker.delegate = self;
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
    return self.playlists[row];
}

@end
