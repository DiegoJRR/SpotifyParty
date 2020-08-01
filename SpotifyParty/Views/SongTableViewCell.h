//
//  SongTableViewCell.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 27/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface SongTableViewCell : UITableViewCell

@property (weak, nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) NSString *songURI;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

NS_ASSUME_NONNULL_END
