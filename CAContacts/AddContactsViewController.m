//
//  addContactsViewController.m
//  CAContacts
//
//  Created by Cary on 2019/3/21.
//  Copyright © 2019 Cary. All rights reserved.
//

#import "AddContactsViewController.h"
#import "TheHeaderFile.h"
#import "AddContactsCell.h"
#import "MyCoreDataManager.h"
#import "ContactsEntity+CoreDataProperties.h"

@interface AddContactsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    NSArray *rowArray;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary * contactsDic;

@end

@implementation AddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"新建联系人";
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(FinishClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
    rowArray = @[@"姓名",@"电话",@"邮箱"];
    _contactsDic = [[NSMutableDictionary alloc]init];
    [self createUI];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xScreenWidth, xScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addContactCell"];
    if (!cell) {
        cell = [[AddContactsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addContactCell"];
    }
    
    cell.detailText.placeholder = rowArray[indexPath.row];
    cell.detailText.delegate = self;
    cell.detailText.tag = indexPath.row + 1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1) {
        
        [_contactsDic setValue:textField.text forKey:@"姓名"];
    }
    else if (textField.tag == 2) {
        
        [_contactsDic setValue:textField.text forKey:@"电话"];
    }
    else if (textField.tag == 3) {
        
        [_contactsDic setValue:textField.text forKey:@"邮箱"];
    }
}

- (void)FinishClick {
    
    
    
    [self.view endEditing:YES];
    
    if (xNullString([_contactsDic valueForKey:@"姓名"])) {
        
        return;
    }
    
    
    ContactsEntity *c = [NSEntityDescription insertNewObjectForEntityForName:@"ContactsEntity" inManagedObjectContext:[MyCoreDataManager shareInstace].managerContext];
    c.name = [_contactsDic valueForKey:@"姓名"];
    c.phone = [_contactsDic valueForKey:@"电话"];
    c.email = [_contactsDic valueForKey:@"邮箱"];
    
    NSError *error = nil;
    
    if ([MyCoreDataManager shareInstace].managerContext.hasChanges) {
        [[MyCoreDataManager shareInstace].managerContext save:&error];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
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
