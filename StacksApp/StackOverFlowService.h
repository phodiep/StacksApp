//
//  StackOverFlowService.h
//  StacksApp
//
//  Created by Pho Diep on 2/17/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackOverFlowService : NSObject

+(id)sharedService;

-(void)fetchQuestionsWithSearchTerm:(NSString*)searchTerm completionHandler:(void (^)(NSArray *results, NSString *error))completionHandler;


@end
