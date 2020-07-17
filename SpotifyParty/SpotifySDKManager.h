//
//  SpotifySDKManager.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 16/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifySDKManager : SPTSessionManager <SPTSessionManagerDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;

- (void) loginSpotify;

@end

NS_ASSUME_NONNULL_END
