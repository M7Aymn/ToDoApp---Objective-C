//
//  newTodoViewController.m
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import "newTodoViewController.h"
#import "TodoList.h"
#import "Constants.h"
#import <UserNotifications/UserNotifications.h>

bool isGrantedNotificationAccess;
@interface newTodoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *addEditButton;

@end

@implementation newTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datePicker.minimumDate = NSDate.now;
//    [_imageView setImage:[UIImage imageNamed:@"1"]];

    isGrantedNotificationAccess = false;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert +UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            isGrantedNotificationAccess = granted;
    }];
    
    [_addEditButton setTitle:_buttonTitle forState:UIControlStateNormal];
    [self setSegmented];
    [self updateUI];
}

-(void) setSegmented {
    if ([_buttonTitle isEqual:@"Add"]) {
        [_typeSegmentedControl setEnabled:YES forSegmentAtIndex:0];
        [_typeSegmentedControl setEnabled:NO forSegmentAtIndex:1];
        [_typeSegmentedControl setEnabled:NO forSegmentAtIndex:2];
    } else if ([_buttonTitle isEqual:@"Edit"]) {
        if (_todo.type == 0) {
            [_typeSegmentedControl setEnabled:YES forSegmentAtIndex:0];
            [_typeSegmentedControl setEnabled:YES forSegmentAtIndex:1];
            [_typeSegmentedControl setEnabled:YES forSegmentAtIndex:2];
        } else if (_todo.type == 1) {
            [_typeSegmentedControl setEnabled:NO forSegmentAtIndex:0];
            [_typeSegmentedControl setEnabled:YES forSegmentAtIndex:1];
            [_typeSegmentedControl setEnabled:YES forSegmentAtIndex:2];
        } else if (_todo.type == 2) {
            [_typeSegmentedControl setEnabled:NO];
            [_prioritySegmentedControl setEnabled:NO];
            [_titleTextField setEnabled:NO];
            [_descriptionTextView setEditable:NO];
            [_datePicker setEnabled:NO];
            [_addEditButton setHidden:YES];
        }
        
    }
}

-(void) updateUI {
    if ([_buttonTitle isEqual:@"Edit"]) {
        _titleTextField.text = _todo.todoTitle;
        _descriptionTextView.text = _todo.todoDescription;
        [_datePicker setDate: _todo.date];
        [_prioritySegmentedControl setSelectedSegmentIndex:_todo.priority];
        [_typeSegmentedControl setSelectedSegmentIndex:_todo.type];
        _imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"%d", _todo.priority]];
    }
}

- (IBAction)addEditButtonAction:(UIButton *)sender {
    if ([_buttonTitle isEqual:@"Add"]) {
        if (_titleTextField.text.length>0) {
            Todo *newToDo = [[Todo alloc] initWithTitle:_titleTextField.text description:_descriptionTextView.text priority:(int)_prioritySegmentedControl.selectedSegmentIndex type:(int)_typeSegmentedControl.selectedSegmentIndex andDate:_datePicker.date];
            
                [[TodoList new] addTodo:newToDo];
//            [self dismissViewControllerAnimated:YES completion:nil];
            
            if(isGrantedNotificationAccess){
                
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                    content.title = @"Todo";
                    content.subtitle = newToDo.todoTitle;
                    content.body = @"It is todo time";
                    content.sound = [UNNotificationSound defaultSound];
                    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:newToDo.date.timeIntervalSinceNow repeats:NO];
                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:newToDo.todoTitle content:content trigger:trigger];

                    // add notification for current notification centre
                    [center addNotificationRequest:request withCompletionHandler:nil];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Date Status" message:@"Please assign a vlid date" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSMutableString *title = [NSMutableString new];
            NSMutableString *message = [NSMutableString new];
            NSString *actionButton1Text;
            NSString *actionButton2Text;
            
            [title setString:@"Failed to add Todo"];
            [message setString:@"Please enter title for todo."];
            actionButton1Text = @"ok";
            actionButton2Text = @"cancel";
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actionButton1 = [UIAlertAction actionWithTitle:actionButton1Text style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *actionButton2 = [UIAlertAction actionWithTitle:actionButton2Text style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:actionButton1];
            [alert addAction:actionButton2];
            [self presentViewController:alert animated:YES completion:NULL];
        }
        
    } else if([_buttonTitle isEqual:@"Edit"]) {
        NSMutableString *title = [NSMutableString new];
        NSMutableString *message = [NSMutableString new];
        NSString *actionButton1Text;
        NSString *actionButton2Text;
        
        [title setString:@"Confirm Editing"];
        [message setString:@"Are you sure you want to save."];
        actionButton1Text = @"ok";
        actionButton2Text = @"cancel";
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionButton1 = [UIAlertAction actionWithTitle:actionButton1Text style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[TodoList alloc] editForUUID:self.todo.uuid withTitle:self.titleTextField.text description:self.descriptionTextView.text priority:(int)self.prioritySegmentedControl.selectedSegmentIndex type:(int)self.typeSegmentedControl.selectedSegmentIndex andDate:self.datePicker.date];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *actionButton2 = [UIAlertAction actionWithTitle:actionButton2Text style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:actionButton1];
        [alert addAction:actionButton2];
        [self presentViewController:alert animated:YES completion:NULL];
    }
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
