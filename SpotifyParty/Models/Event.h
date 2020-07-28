//
//  Event.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 21/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <Parse/Parse.h>
#import "Playlist.h"

NS_ASSUME_NONNULL_BEGIN

@interface Event : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSNumber *explicitSongs;
@property (nonatomic, strong) Playlist *playlist;

- (instancetype) initWithConfig: (NSString * _Nullable ) description withName: (NSString * _Nullable) name withExplicit: (NSNumber *_Nullable) explicit withPlaylist: (Playlist *_Nullable) myPlaylist;

//+ (Event *) postEvent:  withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
