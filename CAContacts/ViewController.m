//
//  ViewController.m
//  CAContacts
//
//  Created by Cary on 2019/3/19.
//  Copyright © 2019 Cary. All rights reserved.
//

#import "ViewController.h"
#import "MyCoreDataManager.h"
#import "ContactsEntity+CoreDataProperties.h"
#import "MyCoreDataManager.h"
#import "TheHeaderFile.h"
#import "AddContactsViewController.h"
#import "ShowContactsViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *contactsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"通讯录";
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton addTarget:self action:@selector(addContacts) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
    _contactsArray = [[NSMutableArray alloc]init];
    
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.contactsArray.count > 0) {
        [self.contactsArray removeAllObjects];
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"ContactsEntity"];
    NSArray <ContactsEntity *> *arr = [[MyCoreDataManager shareInstace].managerContext executeFetchRequest:request error:nil];
    [arr enumerateObjectsUsingBlock:^(ContactsEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contactsArray addObject:obj];
    }];
    
    [self.tableView reloadData];
    
}

- (void)createUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xScreenWidth, xScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell"];
    }
    
    ContactsEntity *c = _contactsArray[indexPath.row];
    
    cell.textLabel.text = c.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactsEntity *c = _contactsArray[indexPath.row];
    ShowContactsViewController *vc = [[ShowContactsViewController alloc]init];
    vc.c = c;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)addContacts {
    
    AddContactsViewController *vc = [[AddContactsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
