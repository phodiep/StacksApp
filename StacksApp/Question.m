//
//  Question.m
//  StacksApp
//
//  Created by Pho Diep on 2/17/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Question.h"

#pragma mark - interface
@interface Question ()

@end

#pragma mark - Implementation
@implementation Question

+ (NSArray*)parseForQuestions:(NSData *)jsonData {
    NSError *serializationError;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&serializationError];
    
    if (serializationError != nil) {
        NSLog(@"%@", serializationError.localizedDescription);
        return nil;
    }
    
    NSArray *items = jsonDictionary[@"items"];
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    for (NSDictionary *item in items) {
        Question *question = [[Question alloc] init];
        
        question.title = item[@"title"];
        NSDictionary *ownerDictionary = item[@"owner"];
        question.userAvatarUrl = ownerDictionary[@"profile_image"];

        [questions addObject:question];
    }
    
    
    return [[NSArray alloc] initWithArray:questions];
}

@end
