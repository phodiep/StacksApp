//
//  User.h
//  StacksApp
//
//  Created by Pho Diep on 2/18/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *accountId;
@property (strong, nonatomic) NSString *lastAccessDate;
@property (strong, nonatomic) NSString *creationDate;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userAvatarUrl;
@property (strong, nonatomic) UIImage *userAvatar;

+ (User*)parseForUserInfo:(NSData *)jsonData;

@end
