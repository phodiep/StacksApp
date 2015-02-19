//
//  StackOverFlowService.h
//  StacksApp
//
//  Created by Pho Diep on 2/17/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface StackOverFlowService : NSObject

+(id)sharedService;

-(void)fetchUserProfile:(void (^)(User *results, NSString *error))completionHandler;

-(void)fetchQuestionsWithSearchTerm:(NSString*)searchTerm completionHandler:(void (^)(NSArray *results, NSString *error))completionHandler;

-(void)fetchAvatarImage:(NSString*)avatarUrl completionHandler:(void (^)(UIImage *image))completionHandler;

@end
