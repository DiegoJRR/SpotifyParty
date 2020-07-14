//
//  AppDelegate.m
//  SpotifyParty
//
<<<<<<< HEAD
//  Created by Diego de Jesus Ramirez on 14/07/20.
=======
//  Created by Diego de Jesus Ramirez on 13/07/20.
>>>>>>> a69bf0c7e3063e2193eb4f2a645aa6aedfa4b546
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "AppDelegate.h"
<<<<<<< HEAD
=======
#import <Parse/Parse.h>
>>>>>>> a69bf0c7e3063e2193eb4f2a645aa6aedfa4b546

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
<<<<<<< HEAD
    // Override point for customization after application launch.
    return YES;
}


=======
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"myAppId";
        configuration.server = @"https://spotify-party-fbu.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    return YES;
}

>>>>>>> a69bf0c7e3063e2193eb4f2a645aa6aedfa4b546
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
