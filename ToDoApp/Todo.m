//
//  todo.m
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import "Todo.h"
#import "Constants.h"

@implementation Todo

- (instancetype)initWithTitle:(nonnull NSString *)title description:(nonnull NSString *)description priority:(int)priority type:(int)type andDate:(nonnull NSDate *)date {
    self = [super init];
    if(self) {
        NSUUID *uuid = [NSUUID UUID];
        _uuid = [uuid UUIDString];
        _todoTitle = title;
        _todoDescription = description;
        _priority = priority;
        _type = type;
        _date = date;
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:_uuid forKey:uuidKey];
    [encoder encodeObject:_todoTitle forKey:titleKey];
    [encoder encodeObject:_todoDescription forKey:descKey];
    [encoder encodeInt:_priority forKey:priorityKey];
    [encoder encodeInt:_type forKey:typeKey];
    [encoder encodeObject:_date forKey:dateKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        _uuid = [decoder decodeObjectOfClass:[NSString class] forKey:uuidKey];
        _todoTitle = [decoder decodeObjectOfClass:[NSString class] forKey:titleKey];
        _todoDescription = [decoder decodeObjectOfClass:[NSString class] forKey:descKey];
        _date = [decoder decodeObjectOfClass:[NSDate class] forKey:dateKey];
        _priority = [decoder decodeIntForKey:priorityKey];
        _type = [decoder decodeIntForKey:typeKey];
    }
    return self;
}

+(void) saveDataWithKey: (NSString *)key withArray: (NSMutableArray *)data {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSError *error;
    NSDate *archiveData = [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:&error];
        
    if (error) {
           NSLog(@"Error archiving data: %@", error.localizedDescription);
       } else {
           [defaults setObject:archiveData forKey:key];
           [defaults synchronize];
       }

}

+(NSArray<Todo*> *) readDataWithKey: (NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSError *error;
    NSDate *savedData = [defaults objectForKey:key];
    
    if (!savedData) {
        NSLog(@"No data found for key: %@", key);
        return nil;
    }

    NSSet *set = [NSSet setWithArray:@[
        [NSArray class],
        [Todo class],
    ]];
    
    NSArray<Todo*> *todoArray = (NSArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    
    if (error) {
        NSLog(@"Error unarchiving data: %@", error.localizedDescription);
        return nil;
    }
    
    for (int i=0; i<todoArray.count; i++) {
        printf("title: %s, desc: %s \n",[todoArray[i].todoTitle UTF8String],[todoArray[i].todoDescription UTF8String]);
    }
    
    return todoArray;
}


+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
