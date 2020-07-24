//
//  Playlist.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 23/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.spotifyID = dictionary[@"owner"][@"id"];
        self.imageURL = [NSURL URLWithString:dictionary[@"images"][0][@"url"]];
        self.collaborative = (NSNumber *)dictionary[@"collaborative"];
    }
    
    return self;
}


@end
