//
//  AppDelegate.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 13/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@property (nonatomic, strong)SPTSessionManager *sessionManager;
@property (nonatomic, strong)SPTConfiguration *configuration;
@property (nonatomic, strong)SPTAppRemote *appRemote;


@end

