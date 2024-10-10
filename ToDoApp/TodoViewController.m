//
//  ViewController.m
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import "TodoViewController.h"
#import "newTodoViewController.h"
#import "TodoList.h"
#import "Constants.h"

@interface TodoViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *noTasksImage;
@property TodoList *todoList;

@end

@implementation TodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar.delegate = self;
    
    self.tabBarController.navigationItem.title = @"Todo Notes";
    self.tabBarController.navigationItem.rightBarButtonItems[0].hidden = NO;
    self.tabBarController.navigationItem.rightBarButtonItems[1].hidden = YES;
    
    _tableView.sectionHeaderHeight = 0;
    [self reloadTableWithUserDefaults:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.title = @"Todo Notes";
    self.tabBarController.navigationItem.rightBarButtonItems[0].hidden = NO;
    self.tabBarController.navigationItem.rightBarButtonItems[1].hidden = YES;

    [self reloadTableWithUserDefaults:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray<NSArray<Todo*>*> *todoArray = @[_todoList.lowPriorityTodos, _todoList.mediumPriorityTodos, _todoList.highPriorityTodos];
//        [[TodoList alloc] removeObjectAtIndex:(int)indexPath.row fromSection:(int)indexPath.section];
        [[TodoList alloc] removeObjectWithUUID:todoArray[indexPath.section][indexPath.row].uuid];
        [self reloadTableWithUserDefaults:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return _todoList.lowPriorityTodos.count;
        case 1:
            return _todoList.mediumPriorityTodos.count;
        case 2:
            return _todoList.highPriorityTodos.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return @"Low Priority";
        case 1:
            return @"Medium Priority";
        case 2:
            return @"High Priority";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<Todo*> *todoArray;
//    TodoList *todoList = (TodoList*)[[TodoList alloc] readList];
    switch (indexPath.section) {
        case 0:
            todoArray =  _todoList.lowPriorityTodos;
            break;
        case 1:
            todoArray =  _todoList.mediumPriorityTodos;
            break;
        case 2:
            todoArray =  _todoList.highPriorityTodos;
            break;
        default:
            break;
    }
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = todoArray[indexPath.row].todoTitle;
    cell.imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"%d", todoArray[indexPath.row].priority]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    newTodoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"newTodo"];
    vc.buttonTitle = @"Edit";
    if (indexPath.section == 0) {
        vc.todo = _todoList.lowPriorityTodos[indexPath.row];
    } else if (indexPath.section == 1) {
        vc.todo = _todoList.mediumPriorityTodos[indexPath.row];
    } else if (indexPath.section == 2) {
        vc.todo = _todoList.highPriorityTodos[indexPath.row];
    }
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)reloadTableWithUserDefaults: (BOOL) reload {
    if (reload) {
        _todoList = [[TodoList alloc] getTodoListForType:0];
    }
    [_tableView reloadData];
    if (_todoList.lowPriorityTodos.count == 0 && _todoList.mediumPriorityTodos.count == 0 && _todoList.highPriorityTodos.count == 0) {
        [_tableView setHidden:YES];
        [_noTasksImage setHidden:NO];
    } else {
        [_tableView setHidden:NO];
        [_noTasksImage setHidden:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self reloadTableWithUserDefaults:YES];
    } else {
//        _todoList = [[TodoList alloc] getTodoListForType:0];
        [self reloadTableWithUserDefaults:YES];
        TodoList *newSearchList = [TodoList new];
        newSearchList.lowPriorityTodos = [NSMutableArray new];
        newSearchList.mediumPriorityTodos = [NSMutableArray new];
        newSearchList.highPriorityTodos = [NSMutableArray new];
        for (Todo *todo in _todoList.lowPriorityTodos) {
            NSRange r = [todo.todoTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (r.location != NSNotFound) {
                [newSearchList.lowPriorityTodos addObject:todo];
            }
        }
        for (Todo *todo in _todoList.mediumPriorityTodos) {
            NSRange r = [todo.todoTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (r.location != NSNotFound) {
                [newSearchList.mediumPriorityTodos addObject:todo];
            }
        }
        for (Todo *todo in _todoList.highPriorityTodos) {
            NSRange r = [todo.todoTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (r.location != NSNotFound) {

                [newSearchList.highPriorityTodos addObject:todo];
            }
        }
        _todoList = newSearchList;
        [self reloadTableWithUserDefaults:NO];
    }
}
@end
