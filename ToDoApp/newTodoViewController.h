//
//  newTodoViewController.h
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import <UIKit/UIKit.h>
#import "Todo.h"

NS_ASSUME_NONNULL_BEGIN

@interface newTodoViewController : UIViewController
@property NSString *buttonTitle;
@property Todo *todo;
@end

NS_ASSUME_NONNULL_END
