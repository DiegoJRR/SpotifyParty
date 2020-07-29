//
//  AddedSongs.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 29/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <Parse/Parse.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddedSongs : PFObject

@property (nonatomic, strong) PFUser *actingUser;
@property (nonatomic, strong) NSString *songURI;
@property (nonatomic, strong) Event *event;

+ (void) postSongToEvent: (NSString * _Nullable) uri toEvent: (Event * _Nullable) event withCompletion: (PFBooleanResultBlock  _Nullable) completion;

@end

NS_ASSUME_NONNULL_END
