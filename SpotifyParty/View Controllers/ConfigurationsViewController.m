//
//  ConfigurationsViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 03/08/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "ConfigurationsViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface ConfigurationsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation ConfigurationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameLabel.text = [PFUser currentUser].username;
}

- (IBAction)logoutTapped:(id)sender {
    // Verify that the user wants to end the event
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Logout" message: @"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        // Logout the user from his parse account and segue to the login view
        SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            sceneDelegate.window.rootViewController = loginViewController;
        }];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
