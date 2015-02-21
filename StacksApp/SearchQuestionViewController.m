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
#import "AnswerWebViewController.h"

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
    QuestionCell *cell = (QuestionCell*)[self.tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
    
    Question *question = self.questions[indexPath.row];
    cell.avatarImageView.image = nil;
    cell.text.text = question.title;
    if (question.userAvatar == nil) {
        [[StackOverFlowService sharedService] fetchAvatarImage:question.userAvatarUrl completionHandler:^(UIImage *image) {
            question.userAvatar = image;
            cell.avatarImageView.image = question.userAvatar;
        }];
    } else {
        cell.avatarImageView.image = question.userAvatar;
    }
    
    return cell;
}


#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [[StackOverFlowService sharedService] fetchQuestionsWithSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSString *error) {
        self.questions = results;
        
        if (error != nil) {
            //show alert
        }
        [self.tableView reloadData];
    }];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [self validateString:text];
}

-(BOOL)validateString:(NSString*)string{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[^A-Za-z0-9\n-]" options:0 error:nil];
    NSInteger elements = [string length];
    NSRange range = NSMakeRange(0, elements);
    
    NSInteger matches = [regex numberOfMatchesInString:string options:0 range:range];
    
    if (matches > 0) {
        return false;
    }
    return true;
    
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"SEGUE_ANSWERS"]) {
        AnswerWebViewController *answerVC = (AnswerWebViewController*)segue.destinationViewController;

        NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
        Question *selectedQuestion = (Question*)self.questions[selectedIndex.row];
        
        answerVC.link = selectedQuestion.link;

    }
}

@end
