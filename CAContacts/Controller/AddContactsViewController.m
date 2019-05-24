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
#import "CommonTool.h"

@interface AddContactsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    NSArray *rowArray;
    UIButton *rightButton;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary * contactsDic;

@end

@implementation AddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    rowArray = @[@"姓名",@"电话",@"邮箱"];
    _contactsDic = [[NSMutableDictionary alloc]init];
    
    [self createUI];
}

- (void)createUI {
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(20, xStatusBarHeight, 40, 40);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [leftButton setTitleColor:[UIColor colorWithRed:45/255.0 green:120/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(80, xStatusBarHeight, xScreenWidth-160, 40);
    label.text = @"新建联系人";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:label];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(xScreenWidth-60, xStatusBarHeight, 40, 40);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [rightButton setTitleColor:[UIColor colorWithRed:45/255.0 green:120/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(FinishClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, xTopHeight, xScreenWidth, xScreenHeight) style:UITableViewStylePlain];
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
    if (indexPath.row == 1) {
        cell.detailText.keyboardType = UIKeyboardTypePhonePad;
    }
    
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

- (void)popClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)FinishClick {
    
    [self.view endEditing:YES];
    
    if (xNullString([_contactsDic valueForKey:@"姓名"])) {
        
        return;
    }
    
    ContactsEntity *c = [NSEntityDescription insertNewObjectForEntityForName:@"ContactsEntity" inManagedObjectContext:[MyCoreDataManager shareInstace].managerContext];
    c.name = [_contactsDic valueForKey:@"姓名"];
    c.namepinyin = [CommonTool getPinYinFromString:[_contactsDic valueForKey:@"姓名"]];
    c.phone = [_contactsDic valueForKey:@"电话"];
    c.email = [_contactsDic valueForKey:@"邮箱"];
    NSLog(@"%@",c.namepinyin);
    
    if ([CommonTool JudgeString:c.namepinyin] == YES) {
        c.sectionName = [[c.namepinyin substringToIndex:1] uppercaseString];
    } else {
        c.sectionName = @"#";
    }
    
    
    NSError *error = nil;
    
    if ([MyCoreDataManager shareInstace].managerContext.hasChanges) {
        [[MyCoreDataManager shareInstace].managerContext save:&error];
        [self dismissViewControllerAnimated:YES completion:nil];
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
