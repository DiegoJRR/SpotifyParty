//
//  Song.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 27/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "Song.h"

@implementation Song

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.id = dictionary[@"id"];
        self.explicit = (NSNumber *)dictionary[@"explicit"];
        self.duration = (NSNumber *)dictionary[@"duration_ms"];
        self.imageURL = dictionary[@"album"][@"images"][0][@"url"];
        self.authorName = dictionary[@"artists"][0][@"name"];
    }
    
    return self;
}

@end
