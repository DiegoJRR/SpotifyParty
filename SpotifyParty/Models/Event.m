//
//  Event.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 21/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "Event.h"
#import "Playlist.h"

@implementation Event
    
@dynamic eventName;
@dynamic userID;
@dynamic author;
@dynamic explicitSongs;
@dynamic eventDescription;
@dynamic playlist;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

- (instancetype) initWithConfig: (NSString * _Nullable ) description withName: (NSString * _Nullable) name withExplicit: (NSNumber *_Nullable) explicit withPlaylist: (Playlist *_Nullable) myPlaylist {
    self = [Event new];
    if(self) {
        self.author = [PFUser currentUser];
        self.eventName = name;
        self.eventDescription = description;
        self.explicitSongs = explicit;
        self.playlist = myPlaylist;
    }
    
    return self;
}


@end
