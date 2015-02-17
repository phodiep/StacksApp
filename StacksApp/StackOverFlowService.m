//
//  StackOverFlowService.m
//  StacksApp
//
//  Created by Pho Diep on 2/17/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "StackOverFlowService.h"
#import "Constants.h"
#import "Question.h"

@implementation StackOverFlowService

NSString *const endPointUrl = @"https://api.stackexchange.com/2.2/";

#pragma mark - Singleton
+(id)sharedService {
    static StackOverFlowService *sharedService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[StackOverFlowService alloc] init];
    });
    return sharedService;
}

-(void)fetchQuestionsWithSearchTerm:(NSString*)searchTerm
                  completionHandler:(void (^)(NSArray *results, NSString *error))completionHandler {
    
    NSString *urlString = endPointUrl;
    urlString = [urlString stringByAppendingString:@"search?order=desc&sort=activity&site=stackoverflow&intitle="];
    urlString = [urlString stringByAppendingString:searchTerm];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token != nil) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&access_token=%@", token]];
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&key=%@", kApiKey]];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completionHandler(nil, @"Unable to connect");
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCode = httpResponse.statusCode;
            
            switch (statusCode) {
                case 200 ... 299: {
                    //good
                    NSLog(@"StatusCode: %ld", (long)statusCode);
                    
                    NSArray *results = [Question parseForQuestions:data];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (results != nil) {
                            completionHandler(results, nil);
                        } else {
                            completionHandler(nil, @"Search couldn't be completed");
                        }
                    });
                    
                    break;
                }
                default:
                    //bad
                    NSLog(@"Bad ResponseCode: %ld", (long)statusCode);
                    break;
            }
        }
    }];
    
    [dataTask resume];
}

-(void)fetchAvatarImage:(NSString *)avatarUrl completionHandler:(void (^)(UIImage *))completionHandler {
    dispatch_queue_t imageQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(imageQueue, ^{
        NSURL *url = [NSURL URLWithString:avatarUrl];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(image);
        });
    });
}


@end
