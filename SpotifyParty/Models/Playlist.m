//
//  Playlist.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 23/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

@dynamic name;
@dynamic spotifyID;
@dynamic imageURLString;
@dynamic collaborative;

+ (nonnull NSString *)parseClassName {
    return @"Playlist";
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.spotifyID = dictionary[@"owner"][@"id"];
        self.imageURLString = dictionary[@"images"][0][@"url"];
        self.collaborative = (NSNumber *)dictionary[@"collaborative"];
    }
    
    return self;
}


@end
