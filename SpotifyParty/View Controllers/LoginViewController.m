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
    // Do any additional setup after loading the view.
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
                
//                [self presentAlert:@"Error" message: error.localizedDescription];
            } else {
                NSLog(@"User logged in successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"mainTabBarSegue" sender:nil];
            }
        }];
    } else {
        NSLog(@"Missing information for Sign Up");
    }
}

- (IBAction)signUpPressed:(id)sender {
    
    if (self.usernameLabel.hasText && self.passwordLabel) {
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameLabel.text;
        newUser.password = self.passwordLabel.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"mainTabBarSegue" sender:nil];
                
            }
        }];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
