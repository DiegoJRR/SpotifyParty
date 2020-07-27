//
//  AppDelegate.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 13/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

// Credentials for the Spotify developer application
static NSString * const spotifyClientID = @"34a573be80d04976888bced902186479";
static NSString * const spotifyRedirectURLString = @"spotify-party-app-login://callback";

// URLs for the token swap heroku server
static NSString * const tokenSwapURLString = @"https://spotify-swap-tokens.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://spotify-swap-tokens.herokuapp.com/api/refresh_token";

@interface AppDelegate ()<SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ParseClientConfiguration *config = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"myAppId";
        configuration.server = @"https://spotify-party-fbu.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];

    return YES;
}

- (void) authorizationFlow {
    // TODO: Add a completion block, to do any follow up actions after the user authenticates 
    [self initialConfiguration];
    [self authenticateSession];
}

-(void)initialConfiguration{
    // Handles the initial configuration for the Spotify session manager and token swapping
    self.configuration =[[SPTConfiguration alloc]initWithClientID:spotifyClientID redirectURL:[NSURL URLWithString:spotifyRedirectURLString]];
    self.configuration.tokenSwapURL = [NSURL URLWithString:tokenSwapURLString];
    self.configuration.tokenRefreshURL = [NSURL URLWithString:tokenRefreshURLString];
    
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
    self.appRemote.delegate = self;
}

-(void)authenticateSession{
    // Authenticates a session, and open the Spotify app if available
    SPTScope requestedscopes = SPTPlaylistReadPrivateScope | SPTPlaylistModifyPublicScope | SPTPlaylistModifyPrivateScope |SPTUserFollowReadScope | SPTUserFollowModifyScope | SPTUserLibraryReadScope | SPTUserLibraryModifyScope | SPTUserTopReadScope | SPTAppRemoteControlScope | SPTUserReadEmailScope | SPTUserReadPrivateScope | SPTStreamingScope;
    
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:self.configuration delegate:self];
    [self.sessionManager initiateSessionWithScope:requestedscopes options:SPTDefaultAuthorizationOption];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"Called");
    [self.sessionManager application:app openURL:url options:options];
    return true;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

-(void)applicationWillResignActive:(UIApplication *)application{
    if(self.appRemote.isConnected){
        [self.appRemote disconnect];
        NSLog(@"Disconnected");
    }
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    if(self.appRemote.connectionParameters.accessToken){
        [self.appRemote connect];
         NSLog(@"Connected");
    }
}

#pragma mark - SPTSessionManagerDelegate
-(void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session{
    NSLog(@"Renewed: %@", session);
}

-(void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session{
    NSLog(@"Success: %@", session);
    self.appRemote.connectionParameters.accessToken = session.accessToken;
}

-(void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}
#pragma mark - SPTAppRemoteDelegate

- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote{
    NSLog(@"Trying to connect");
    
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error with connection%@",error.localizedDescription);
        } else{
            NSLog(@"Success");
        }
    }];
}

- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error{
    NSLog(@"Error connecting to Spotify app %@",error);
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"Disconnected");
}


-(void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState{
    NSLog(@"Track name: %@" , playerState.track.name);
}

@end
