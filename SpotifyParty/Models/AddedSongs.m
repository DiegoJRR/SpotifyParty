//
//  AddedSongs.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 29/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "AddedSongs.h"

@implementation AddedSongs

@dynamic actingUser;
@dynamic songURI;
@dynamic event;

+ (nonnull NSString *)parseClassName {
    return @"AddedSongs";
}

+ (void) postSongToEvent: (NSString * _Nullable) uri toEvent: (Event * _Nullable) event withCompletion: (PFBooleanResultBlock  _Nullable) completion {
    AddedSongs *newSongPost = [AddedSongs new];
    newSongPost.songURI = uri;
    newSongPost.actingUser = [PFUser currentUser];
    newSongPost.event = event;
    
    [newSongPost saveInBackgroundWithBlock:completion];
}

@end
