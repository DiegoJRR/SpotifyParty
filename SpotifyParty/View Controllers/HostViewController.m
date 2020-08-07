//
//  HostViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 28/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "HostViewController.h"
#import "UIImage+DYQRCodeEncoder.h"
#import "EventHostViewController.h"


@interface HostViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.event.objectId);
    
    self.qrImageView.image = [UIImage DY_QRCodeImageWithString:self.event.objectId size:300.f];
    
}

- (IBAction)longPressedQR:(id)sender {
    
    // Add the qr image as an activity item and present the sharing view controller
    NSArray *activityItems = @[self.qrImageView.image];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"segueToHostEvent"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        
        // Set the viewController to segue into and pass the movie object
        EventHostViewController *eventHostViewController = navController.viewControllers[0];
        eventHostViewController.event = self.event;
        
    }

}

@end
