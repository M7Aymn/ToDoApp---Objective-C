//
//  TodoList.m
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import "TodoList.h"
#import "Constants.h"

@implementation TodoList

- (instancetype) init {
    self = [super init];
    if (self) {
        _lowPriorityTodos = [NSMutableArray new];
        _mediumPriorityTodos = [NSMutableArray new];
        _highPriorityTodos = [NSMutableArray new];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [Todo saveDataWithKey:lowKey withArray:_lowPriorityTodos];
    [Todo saveDataWithKey:midKey withArray:_mediumPriorityTodos];
    [Todo saveDataWithKey:highKey withArray:_highPriorityTodos];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        _highPriorityTodos = [NSMutableArray arrayWithArray: [Todo readDataWithKey:highKey]];
        _mediumPriorityTodos = [NSMutableArray arrayWithArray:[Todo readDataWithKey:midKey]];
        _lowPriorityTodos = [NSMutableArray arrayWithArray:[Todo readDataWithKey:lowKey]];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void) saveList{
    [self encodeWithCoder:[NSCoder new]];
}

-(TodoList *) readList{
    return [self initWithCoder:[NSCoder new]];
}

- (void)addTodo: (Todo*) todo {
    TodoList *todoList = (TodoList *)[self readList];
    switch (todo.priority) {
        case 0:
            [todoList.lowPriorityTodos addObject:todo];
            break;
        case 1:
            [todoList.mediumPriorityTodos addObject:todo];
            break;
        case 2:
            [todoList.highPriorityTodos addObject:todo];
            break;
        default:
            break;
    }
    [self saveList];
}

+ (void)removeToDoAtIndex:(NSUInteger)index forSection: (NSUInteger) section fromKey:(NSString *)key {
    TodoList *todoList = (TodoList *)[[TodoList alloc] readList];

    if (todoList) {
        switch (section) {
            case 2:
                if (index < todoList.highPriorityTodos.count) {
                    [todoList.highPriorityTodos removeObjectAtIndex:index];
                }
                break;
            case 1:
                if (index < todoList.mediumPriorityTodos.count) {
                    [todoList.mediumPriorityTodos removeObjectAtIndex:index];
                }
                break;
            case 0:
                if (index < todoList.lowPriorityTodos.count) {
                    [todoList.lowPriorityTodos removeObjectAtIndex:index];
                }
                break;
                
            default:
                break;
        }

        [[TodoList alloc]saveList];
    }
}

-(void) removeObjectAtIndex: (int) index fromSection: (int) section {
    [self initWithCoder:[NSCoder new]];
    switch (section) {
        case 0:
            [_lowPriorityTodos removeObjectAtIndex:index];
            break;
        case 1:
            [_mediumPriorityTodos removeObjectAtIndex:index];
            break;
        case 2:
            [_highPriorityTodos removeObjectAtIndex:index];
            break;
        default:
            break;
    }
    [self saveList];
}

-(void) removeObjectWithUUID: (NSString*) uuid {
    [self initWithCoder:[NSCoder new]];
    for (int i=0; i<_lowPriorityTodos.count; i++) {
        if ([_lowPriorityTodos[i].uuid isEqual: uuid]) {
            [_lowPriorityTodos removeObjectAtIndex:i];
        }
    }
    for (int i=0; i<_mediumPriorityTodos.count; i++) {
        if ([_mediumPriorityTodos[i].uuid isEqual: uuid]) {
            [_mediumPriorityTodos removeObjectAtIndex:i];
        }
    }
    for (int i=0; i<_highPriorityTodos.count; i++) {
        if ([_highPriorityTodos[i].uuid isEqual: uuid]) {
            [_highPriorityTodos removeObjectAtIndex:i];
        }
    }
    [self saveList];
}

-(TodoList *) getTodoListForType: (int) type {
    [self initWithCoder:[NSCoder new]];
    TodoList *newList = [TodoList new];
    for (int i =0; i<_lowPriorityTodos.count; i++) {
        if (_lowPriorityTodos[i].type == type) {
            [newList.lowPriorityTodos addObject:_lowPriorityTodos[i]];
        }
    }
    for (int i =0; i<_mediumPriorityTodos.count; i++) {
        if (_mediumPriorityTodos[i].type == type) {
            [newList.mediumPriorityTodos addObject:_mediumPriorityTodos[i]];
        }
    }
    for (int i =0; i<_highPriorityTodos.count; i++) {
        if (_highPriorityTodos[i].type == type) {
            [newList.highPriorityTodos addObject:_highPriorityTodos[i]];
        }
    }
    return newList;
}

-(void) editForUUID: (NSString*) uuid withTitle: (NSString *) title description: (NSString*) description priority: (int) priority type: (int) type andDate: (NSDate*) date {
    [self initWithCoder:[NSCoder new]];
    for (int i=0; i<_lowPriorityTodos.count; i++) {
        if ([_lowPriorityTodos[i].uuid isEqual: uuid]) {
            _lowPriorityTodos[i].todoTitle = title;
            _lowPriorityTodos[i].todoDescription = description;
            _lowPriorityTodos[i].date = date;
            _lowPriorityTodos[i].type = type;
            if (_lowPriorityTodos[i].priority != priority) {
                Todo *temp = _lowPriorityTodos[i];
                [_lowPriorityTodos removeObjectAtIndex:i];
                if (priority == 1) {
                    temp.priority = priority;
                    [_mediumPriorityTodos addObject:temp];
                } else if (priority == 2) {
                    temp.priority = priority;
                    [_highPriorityTodos addObject:temp];
                }
                goto end;
            }
        }
    }
    for (int i=0; i<_mediumPriorityTodos.count; i++) {
        if ([_mediumPriorityTodos[i].uuid isEqual: uuid]) {
            _mediumPriorityTodos[i].todoTitle = title;
            _mediumPriorityTodos[i].todoDescription = description;
            _mediumPriorityTodos[i].date = date;
            _mediumPriorityTodos[i].type = type;
            if (_mediumPriorityTodos[i].priority != priority) {
                Todo *temp = _mediumPriorityTodos[i];
                [_mediumPriorityTodos removeObjectAtIndex:i];
                if (priority == 0) {
                    temp.priority = priority;
                    [_lowPriorityTodos addObject:temp];
                } else if (priority == 2) {
                    temp.priority = priority;
                    [_highPriorityTodos addObject:temp];
                }
                goto end;
            }
        }
    }
    for (int i=0; i<_highPriorityTodos.count; i++) {
        if ([_highPriorityTodos[i].uuid isEqual: uuid]) {
            _highPriorityTodos[i].todoTitle = title;
            _highPriorityTodos[i].todoDescription = description;
            _highPriorityTodos[i].date = date;
            _highPriorityTodos[i].type = type;
            if (_highPriorityTodos[i].priority != priority) {
                Todo *temp = _highPriorityTodos[i];
                [_highPriorityTodos removeObjectAtIndex:i];
                if (priority == 0) {
                    temp.priority = priority;
                    [_lowPriorityTodos addObject:temp];
                } else if (priority == 1) {
                    temp.priority = priority;
                    [_mediumPriorityTodos addObject:temp];
                }
                goto end;
            }
        }
    }
end: [self saveList];
}

@end
