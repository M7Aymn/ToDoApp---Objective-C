//
//  todo.h
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Todo : NSObject <NSCoding, NSSecureCoding>

@property NSString *uuid;
@property NSString *todoTitle;
@property NSString *todoDescription;
@property int priority;
@property int type;
@property NSDate *date;

-(instancetype) initWithTitle: (NSString*) title description: (NSString*) description priority: (int) priority type: (int) type andDate: (NSDate*) date;

-(void) encodeWithCoder: (NSCoder *)encoder;
+(void) saveDataWithKey: (NSString *)key withArray: (NSMutableArray *)data;
+(NSArray<Todo*> *) readDataWithKey: (NSString *)key;
@end

NS_ASSUME_NONNULL_END
