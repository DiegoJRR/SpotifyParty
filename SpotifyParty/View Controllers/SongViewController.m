//
//  SongViewController.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 05/08/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "SongViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#include <ColorArt/UIImage+ColorArt.h>

@interface SongViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) APIManager *apiManager;

@end

@implementation SongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.albumImageView setImageWithURL:[NSURL URLWithString: self.song.imageURL]];
    self.albumImageView.layer.cornerRadius = 10;
    
    // Use external library to analyze the colors of the album colors
    SLColorArt *colorArt = [self.albumImageView.image colorArt];
    self.view.backgroundColor = colorArt.backgroundColor;
    self.songTitleLabel.text = self.song.name;
    self.songTitleLabel.textColor = colorArt.primaryColor;
    
    self.authorNameLabel.text = self.song.authorName;
    self.authorNameLabel.textColor = colorArt.secondaryColor;
    
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Return the navigation controller to a solid color 
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;

}

- (IBAction)likeTapped:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.likeButton.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.likeButton.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 5/2, 5/2);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];}];
}

@end
