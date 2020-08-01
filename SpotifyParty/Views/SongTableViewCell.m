//
//  SongTableViewCell.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 27/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "SongTableViewCell.h"

@implementation SongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeTapped:(id)sender {
    // TODO: Check if the song is already liked
    if (YES) {
        EventQueue *newLike = [[EventQueue alloc] initLike:self.songURI inEvent:self.event];
        
        [newLike saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"Posted succesfully. Waiting for host");
                // Set local variable to liked
                [self.likeButton.imageView setImage:[UIImage imageNamed:@"heart-fill"]];
            }
        }];
    } else {
        
    }
}

@end
