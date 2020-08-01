//
//  HostViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 28/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "HostViewController.h"
#import "UIImage+DYQRCodeEncoder.h"


@interface HostViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.event.objectId);
    
    self.qrImageView.image = [UIImage DY_QRCodeImageWithString:self.event.objectId size:300.f];
    
}



@end
