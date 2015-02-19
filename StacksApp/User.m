//
//  User.m
//  StacksApp
//
//  Created by Pho Diep on 2/18/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "User.h"
#import <UIKit/UIKit.h>

@implementation User

+ (User*)parseForUserInfo:(NSData *)jsonData {
    
    NSError *serializationError;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&serializationError];

    if (serializationError != nil) {
        NSLog(@"%@", serializationError.localizedDescription);
        return nil;
    }
    
    NSArray *items = jsonDictionary[@"items"];
    NSDictionary *item = items[0];
    
    User *user = [[User alloc] init];
    user.accountId = item[@"account_id"];
    user.lastAccessDate = item[@"last_access_date"];
    user.creationDate = item[@"creation_date"];
    user.userType = item[@"user_type"];
    user.userId = item[@"user_id"];
    user.userUrl = item[@"link"];
    user.name = item[@"display_name"];
    user.userAvatarUrl = item[@"profile_image"];

    return user;
}

@end
