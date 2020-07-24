//
//  Playlist.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 23/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Playlist : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *spotifyID;
@property (nonatomic, strong) NSNumber *collaborative;
@property (nonatomic, strong) NSURL *imageURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
