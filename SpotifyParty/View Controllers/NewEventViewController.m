//
//  NewEventViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 20/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "NewEventViewController.h"
#import "Event.h"

@interface NewEventViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *eventNameField;
@property (weak, nonatomic) IBOutlet UISwitch *allowExplicitToggle;
@property (weak, nonatomic) IBOutlet UIPickerView *playlistPicker;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionField;

@property (nonatomic, strong) NSArray *playlists;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playlists = @[@"Rock Playlist", @"Hip Hop Playlist", @"My epic playlist", @"Another Option"];
    
    self.playlistPicker.dataSource = self;
    self.playlistPicker.delegate = self;
}

- (IBAction)createEventPressed:(id)sender {
    NSString *playlist;
    playlist = [self.playlists objectAtIndex:[self.playlistPicker selectedRowInComponent:0]];
    
    if (self.eventDescriptionField.hasText && self.eventNameField.hasText) {
        [Event postEvent:self.eventDescriptionField.text withName:self.eventNameField.text withExplicit: @(self.allowExplicitToggle.on ? 1 : 0) withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            // Code to exectute when posted successfully
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
