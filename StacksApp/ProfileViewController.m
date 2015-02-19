//
//  ProfileViewController.m
//  StacksApp
//
//  Created by Pho Diep on 2/18/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "ProfileViewController.h"
#import "StackOverFlowService.h"
#import "User.h"

#pragma mark - Interface
@interface ProfileViewController ()

@property (retain, nonatomic) User *user;

@property (retain, nonatomic) IBOutlet UILabel *accountlabel;
@property (retain, nonatomic) IBOutlet UILabel *lastAccessLabel;
@property (retain, nonatomic) IBOutlet UILabel *creationLabel;
@property (retain, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UILabel *userUrlLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *userIdLabel;

@end

#pragma mark - Implementation
@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[StackOverFlowService sharedService] fetchUserProfile:^(User *results, NSString *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            self.user = results;
            
            self.accountlabel.text = [NSString stringWithFormat:@"Account ID: %@", self.user.accountId ];
            self.userTypeLabel.text = [NSString stringWithFormat:@"User Type: %@", self.user.userType ];
            self.userUrlLabel.text = [NSString stringWithFormat:@"User URL: %@", self.user.userUrl ];
            self.nameLabel.text = [NSString stringWithFormat:@"User Name: %@", self.user.name ];
            self.userIdLabel.text = [NSString stringWithFormat:@"User ID: %@", self.user.userId ];
            
            self.lastAccessLabel.text = [NSString stringWithFormat:@"Last Accessed: %@",
                                         [self convertEpochToShortDate:self.user.lastAccessDate] ];
            self.creationLabel.text = [NSString stringWithFormat:@"Account Created: %@",
                                       [self convertEpochToShortDate:self.user.creationDate] ];

            if (self.user.userAvatar == nil) {
                [[StackOverFlowService sharedService] fetchAvatarImage:self.user.userAvatarUrl completionHandler:^(UIImage *image) {
                    if (image != nil) {
                        self.user.userAvatar = image;
                    }
                    self.avatarImage.image = self.user.userAvatar;
                }];
            }
        }
    }];
}

-(NSString*)convertEpochToShortDate:(NSString*)timeStamp {
    if ([timeStamp isEqual: @""]) {
        return nil;
    }
    
    NSTimeInterval interval = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    NSString *dateString = [dateFormatter stringFromDate: date];
    
    return dateString;
}

-(void)dealloc {
    [self.user release];
    [self.accountlabel release];
    [self.lastAccessLabel release];
    [self.creationLabel release];
    [self.userTypeLabel release];
    [self.avatarImage release];
    [self.userUrlLabel release];
    [self.nameLabel release];
    [self.userIdLabel release];
    
    [super dealloc];
}


@end
