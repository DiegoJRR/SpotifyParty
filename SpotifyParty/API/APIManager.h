//
//  APIManager.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 23/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

@property (nonatomic, strong) NSString *accessToken;

- (instancetype)initWithToken:(NSString *)token;
- (void) getUserPlaylists: (void (^)(NSDictionary  *responseData, NSError *error))completion;
- (void) getPlaylistTracks: (NSString * _Nullable) playlistID withCompletion: (void (^)(NSDictionary *responseData, NSError *error)) completion;
- (void) getTrack: (NSString * _Nullable) trackURI withCompletion: (void (^)(NSDictionary *responseData, NSError *error)) completion;

@end

NS_ASSUME_NONNULL_END
