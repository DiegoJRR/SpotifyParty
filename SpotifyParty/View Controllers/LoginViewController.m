//
//  LoginViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 14/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)presentAlert:(NSString *)title message:(NSString *)message_body {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message: message_body preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)loginActionPressed:(id)sender {
    if (self.usernameLabel.hasText && self.passwordLabel.hasText) {
        
        // Get users data from the text fields
        NSString *username = self.usernameLabel.text;
        NSString *password = self.passwordLabel.text;
        
        // Login using the Parser pod
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                
                [self presentAlert:@"Error" message: error.localizedDescription];
            } else {
                NSLog(@"User logged in successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"mainTabBarSegue" sender:nil];
            }
        }];
    } else {
        [self presentAlert:@"Missing information" message: @"Missing username/password. Please add them and try again."];
    }
}

- (IBAction)signUpPressed:(id)sender {
    if (self.usernameLabel.hasText && self.passwordLabel.hasText) {
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameLabel.text;
        newUser.password = self.passwordLabel.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                
                [self presentAlert:@"Error" message: error.localizedDescription];
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"mainTabBarSegue" sender:nil];
            }
        }];
    } else {
        [self presentAlert:@"Missing information" message: @"Missing username/password. Please add them and try again."];
    }
}

@end
