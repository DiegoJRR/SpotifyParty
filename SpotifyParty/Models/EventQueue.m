//
//  EventQueue.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 31/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "EventQueue.h"

@implementation EventQueue

@dynamic event;
@dynamic action;
@dynamic songURI;

+ (nonnull NSString *)parseClassName {
    return @"EventQueue";
}

- (instancetype) initLike: (NSString * _Nullable) songURI inEvent: (Event * _Nullable) event {
    self = [super init];
    if (self) {
        self.action = @"like";
        self.event = event;
        self.songURI = songURI;
    }
    
    return self;
}

- (instancetype) initAddSong: (NSString * _Nullable) songURI inEvent: (Event * _Nullable) event {
    self = [super init];
    if (self) {
        self.action = @"add";
        self.event = event;
        self.songURI = songURI;
    }
    
    return self;
}

- (instancetype) initWithDictionary: (NSDictionary * _Nullable) dictionary {
    self = [super init];
    if (self) {
        self.action = dictionary[@"action"];
        self.event = dictionary[@"event"];
        self.songURI = dictionary[@"songURI"];
    }
    
    return self;
}

@end
