//
//  SceneDelegate.m
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 13/07/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <SpotifyiOS/SpotifyiOS.h>

@interface SceneDelegate ()

@property (strong, nonatomic) AppDelegate *delegate;

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    }
    
     self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

-(void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts{
    NSLog(@"Calling in Scene Delegate %@", URLContexts);
    
    UIOpenURLContext *ctx = [URLContexts allObjects][0];
    NSLog(@"%@", self.delegate.sessionManager.session.accessToken);
    [self.delegate application:[UIApplication sharedApplication] openURL:ctx.URL options:ctx.options];
}

@end
