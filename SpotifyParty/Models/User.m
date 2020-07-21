//
//  User.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 21/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.username = dictionary[@"name"];
        self.profileImageURL = [NSURL URLWithString: dictionary[@"profile_image_url_https"]];
    }
    return self;
}

@end
