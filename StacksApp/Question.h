//
//  Question.h
//  StacksApp
//
//  Created by Pho Diep on 2/17/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *userAvatarUrl;
@property (strong, nonatomic) UIImage *userAvatar;

+ (NSArray*)parseForQuestions:(NSData*)jsonData;

@end
