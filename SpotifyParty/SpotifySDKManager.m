//
//  SpotifySDKManager.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 16/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "SpotifySDKManager.h"

static NSString * const SpotifyClientID = @"34a573be80d04976888bced902186479";
static NSString * const SpotifyRedirectURLString = @"spotify-party-login://callback";

@interface SpotifySDKManager () <SPTSessionManagerDelegate>

@property (nonatomic, strong) SPTConfiguration *configuration;

@end

@implementation SpotifySDKManager

#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    [self presentAlertControllerWithTitle:@"Authorization Succeeded"
                                  message:session.description
                              buttonTitle:@"Nice"];
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    [self presentAlertControllerWithTitle:@"Authorization Failed"
                                  message:error.description
                              buttonTitle:@"Bummer"];
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    [self presentAlertControllerWithTitle:@"Session Renewed"
                                  message:session.description
                              buttonTitle:@"Sweet"];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self.sessionManager application:app openURL:url options:options];
    
    NSLog(@"Returned to the application, do something here!");
    return true;
}

- (void)loginSpotify {
    [self initialConfig];
    /*
     Scopes let you specify exactly what types of data your application wants to
     access, and the set of scopes you pass in your call determines what access
     permissions the user is asked to grant.
     For more information, see https://developer.spotify.com/web-api/using-scopes/.
     */
    SPTScope requestedScope = SPTAppRemoteControlScope;
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    
//    SPTScope scope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;
//
//    // Start the authorization process. This requires user input.
//    if (@available(iOS 11, *)) {
//        // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
//        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
//    } else {
//        // Use this on iOS versions < 11 to use SFSafariViewController
//        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption presentingViewController:self];
//    }
}

- (void)initialConfig {
    // This configuration object holds your client ID and redirect URL.
    self.configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
                                                                      redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];

    // Set these url's to your backend which contains the secret to exchange for an access token
    // You can use the provided ruby script spotify_token_swap.rb for testing purposes
    self.configuration.tokenSwapURL = [NSURL URLWithString: @"https://spotify-party-token.herokuapp.com/api/token"];
    self.configuration.tokenRefreshURL = [NSURL URLWithString: @"https://spotify-party-token.herokuapp.com/api/refresh_token"];


    // The session manager lets you authorize, get access tokens, and so on.
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:self.configuration
                                                                    delegate:self];
}


- (void)presentAlertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                            buttonTitle:(NSString *)buttonTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:buttonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:dismissAction];
    });
}


@end
