//
//  NewEventViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 20/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "NewEventViewController.h"
#import "Event.h"

@interface NewEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventNameField;
@property (weak, nonatomic) IBOutlet UITextField *playlistNameField;
@property (weak, nonatomic) IBOutlet UISwitch *banExplicitToggle;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)createEventPressed:(id)sender {
    [Event postEvent:self.playlistNameField.text withName:self.eventNameField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    // Code to exectute when posted successfully
    if (!error) {
        NSLog(@"Event Posted");
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)viewPressed:(id)sender {
    [self.view endEditing:YES];
}

@end
