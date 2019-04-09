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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *contactsArray;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

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
    [self.tableView reloadData];
    
//    if (self.contactsArray.count > 0) {
//        [self.contactsArray removeAllObjects];
//    }
//
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"ContactsEntity"];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"namepinyin" ascending:YES]];
//    NSArray <ContactsEntity *> *arr = [[MyCoreDataManager shareInstace].managerContext executeFetchRequest:request error:nil];
//    [arr enumerateObjectsUsingBlock:^(ContactsEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.contactsArray addObject:obj];
//    }];
//
//    [self.tableView reloadData];
    
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    ///创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"ContactsEntity"];
    ///设置请求排序器
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sectionName" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[MyCoreDataManager shareInstace].managerContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    ///执行查询
    [_fetchedResultsController performFetch:nil];
    
    [self.tableView reloadData];
    
    return _fetchedResultsController;
}

 - (void)createUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xScreenWidth, xScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return _contactsArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell"];
//    }
//
//    ContactsEntity *c = _contactsArray[indexPath.row];
//
//    cell.textLabel.text = c.name;
//
//    return cell;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    ContactsEntity *c = _contactsArray[indexPath.row];
//    ShowContactsViewController *vc = [[ShowContactsViewController alloc]init];
//    vc.c = c;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
//
//    for(char c = 'A'; c <= 'Z'; c++ ) {
//
//        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
//
//    }
//    return toBeReturned;
//}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

   // return self.fetchedResultsController.sectionIndexTitles[section];
    return [self.fetchedResultsController.sections objectAtIndex:section].indexTitle;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"%lu",(unsigned long)self.fetchedResultsController.sections.count);
    return  self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
    return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell"];
    }

    ContactsEntity *c = [_fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = c.name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactsEntity *c = [_fetchedResultsController objectAtIndexPath:indexPath];;
    ShowContactsViewController *vc = [[ShowContactsViewController alloc]init];
    vc.c = c;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath
{
    ///获取当前tableView组的数量
    NSInteger sectionNum = self.tableView.numberOfSections;
    
    //获取NSFetchedResultsController组的数量,如果和tableView组的数量不相等，就表示有新的数据插入
    NSInteger fetchSection = self.fetchedResultsController.sections.count;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            
            //插入数据
            [self.tableView beginUpdates];
            if (sectionNum != fetchSection) {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
            }else{
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            [self.tableView reloadData];
            ///tableView有开始更新，就有结束更新
            ///不能没有结束更新
            [self.tableView endUpdates];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView beginUpdates];
            if (sectionNum != fetchSection) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
            }else{
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            [self.tableView endUpdates];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView reloadData];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //刷新数据
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
            break;
            
        default:
            break;
    }
}

- (void)addContacts {
    
    AddContactsViewController *vc = [[AddContactsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
