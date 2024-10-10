//
//  TodoList.h
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import <Foundation/Foundation.h>
#import "Todo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodoList : NSObject <NSCoding, NSSecureCoding>
@property NSMutableArray<Todo*>* highPriorityTodos;
@property NSMutableArray<Todo*>* mediumPriorityTodos;
@property NSMutableArray<Todo*>* lowPriorityTodos;

-(void) encodeWithCoder: (NSCoder *)encoder;

- (void)addTodo: (Todo*) todo;

-(void) saveList;
-(NSArray<TodoList*> *) readList;
+ (void)removeToDoAtIndex:(NSUInteger)index forSection: (NSUInteger) section fromKey:(NSString *)key;
-(void) removeObjectAtIndex: (int) index fromSection: (int) section ;
-(void) removeObjectWithUUID: (NSString*) uuid;
-(void) editForUUID: (NSString*) uuid withTitle: (NSString *) title description: (NSString*) description priority: (int) priority type: (int) type andDate: (NSDate*) date;

-(TodoList *) getTodoListForType: (int) type;

@end

NS_ASSUME_NONNULL_END
