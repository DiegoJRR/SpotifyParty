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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)likeTapped:(id)sender {
    // TODO: Check if the song is already liked
    if (YES) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.likeButton.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.likeButton.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 5/2, 5/2);
        }];
        
        EventQueue *newLike = [[EventQueue alloc] initLike:self.songURI inEvent:self.event];
        
        [newLike saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"Posted succesfully. Waiting for host");
                [UIView animateWithDuration:0.2 animations:^{
                    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                }];
            }
        }];
                
    } else {
        
    }
}

@end
