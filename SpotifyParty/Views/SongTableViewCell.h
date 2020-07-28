//
//  SongTableViewCell.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 27/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SongTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *authorName;

@end

NS_ASSUME_NONNULL_END
