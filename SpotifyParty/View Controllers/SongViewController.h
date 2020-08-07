//
//  SongViewController.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 05/08/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface SongViewController : UIViewController

@property (nonatomic, strong) Song *song;
@end

NS_ASSUME_NONNULL_END
