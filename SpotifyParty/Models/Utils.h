//
//  Utils.h
//  SpotifyParty
//
//  Created by Diego de Jesus Ramirez on 07/08/20.
//  Copyright © 2020 DiegoRamirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
