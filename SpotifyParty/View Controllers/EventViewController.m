//
//  EventViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 24/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "EventViewController.h"
#import "UIImageView+AFNetworking.h"

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set poster to nil to remove the old one (when refreshing) and query for the new one
    self.posterImageView.image = nil;
    [self.posterImageView setImageWithURL:[NSURL URLWithString: self.event.playlist.imageURLString]];
    self.eventNameLabel.text = self.event.playlist.name;
}

@end
