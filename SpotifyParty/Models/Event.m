//
//  Event.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 21/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "Event.h"
@implementation Event
    
@dynamic eventID;
@dynamic eventName;
@dynamic userID;
@dynamic author;
@dynamic explicitSongs;
@dynamic eventDescription;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

+ (void) postEvent: ( NSString * _Nullable )description withName: (NSString * _Nullable) name withExplicit: (NSNumber *_Nullable) explicit withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Event *newEvent = [Event new];
    newEvent.author = [PFUser currentUser];
    newEvent.eventName = name;
    newEvent.eventDescription = description;
    newEvent.explicitSongs = explicit;
    
    [newEvent saveInBackgroundWithBlock: completion];
}

@end
