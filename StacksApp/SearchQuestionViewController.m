//
//  SearchQuestionViewController.m
//  StacksApp
//
//  Created by Pho Diep on 2/17/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "SearchQuestionViewController.h"
#import "QuestionCell.h"
#import "Question.h"
#import "StackOverFlowService.h"

#pragma mark - Interface
@interface SearchQuestionViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *questions;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

#pragma mark - Implementation
@implementation SearchQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.searchBar.delegate = self;
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.questions count] > 0) {
        return [self.questions count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
    
    Question *question = self.questions[indexPath.row];
    cell.text.text = question.title;
    cell.imageView.backgroundColor = [UIColor redColor];
    if (question.userAvatar == nil) {
        [[StackOverFlowService sharedService] fetchAvatarImage:question.userAvatarUrl completionHandler:^(UIImage *image) {
            question.userAvatar = image;
        }];
    }
    cell.avatarImageView.image = question.userAvatar;
    
    return cell;
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [[StackOverFlowService sharedService] fetchQuestionsWithSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSString *error) {
        self.questions = results;
        
        if (error != nil) {
            //show alert
        }
        [self.tableView reloadData];
    }];
}

@end
