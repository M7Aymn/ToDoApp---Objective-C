//
//  InprogrssViewController.h
//  ToDoApp
//
//  Created by Mohamed Ayman on 17/07/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InProgressViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)reloadTableWithUserDefaults: (BOOL) reload;

@end

NS_ASSUME_NONNULL_END
