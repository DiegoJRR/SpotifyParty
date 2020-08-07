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
#import "Utils.h"
#import "PFImageView.h"

@interface ConfigurationsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *eventNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *eventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *banExplicit;

@end

@implementation ConfigurationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameLabel.text = [PFUser currentUser].username;
    
    // Load the default values defined by the user
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.eventNameLabel.text = [defaults valueForKey:@"eventName"];
    self.eventDescriptionLabel.text = [defaults valueForKey:@"eventDescription"];
    self.banExplicit.on = [defaults boolForKey:@"banExplicit"];
}

- (IBAction)onTapProfileImage:(id)sender {
    NSLog(@"Picture Button is being pushed");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//if camera is available then take picture
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        //checks to see if the camera is able to be used, if not then it results to use the library
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //after taken or choosen the picture you are able to go back to the original screen
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.profileImage.image = editedImage;
    
    PFUser.currentUser[@"userimage"] = [Utils getPFFileFromImage: self.profileImage.image];
    [PFUser.currentUser saveInBackground];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.eventNameLabel.text forKey:@"eventName"];
    [defaults setValue:self.eventDescriptionLabel.text forKey:@"eventDescription"];
    [defaults setBool:self.banExplicit.on forKey:@"banExplicit"];
    [defaults synchronize];
}


@end
