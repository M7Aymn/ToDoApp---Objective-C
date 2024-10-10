//
//  TabBarController.m
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import "TabBarController.h"
#import "newTodoViewController.h"
#import "InProgressViewController.h"
#import "DoneViewController.h"

@interface TabBarController ()
@property BOOL isFilterEnabled;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFilterEnabled = NO;
    self.selectedIndex = 1;
    self.selectedIndex = 2;
    self.selectedIndex = 0;
}

- (IBAction)addButton:(UIBarButtonItem *)sender {
    newTodoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"newTodo"];
    vc.buttonTitle = @"Add";
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)filterButton:(UIBarButtonItem *)sender {
    InProgressViewController * prog = self.viewControllers [1];
    DoneViewController *done = self.viewControllers [2];

    prog.tableView.sectionHeaderHeight = _isFilterEnabled ? 40 : 0;
    done.tableView.sectionHeaderHeight = _isFilterEnabled ? 40 : 0;

    [prog reloadTableWithUserDefaults:NO];
    [done reloadTableWithUserDefaults:NO];
    
    _isFilterEnabled = !_isFilterEnabled;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
