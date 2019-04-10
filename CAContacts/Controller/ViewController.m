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
    
    [self createUI];
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    ///创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"ContactsEntity"];
    ///设置请求排序器
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"namepinyin" ascending:YES]];

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

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

//    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
//
//    for(char c = 'A'; c <= 'Z'; c++ ) {
//
//        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
//
//    }
//    return toBeReturned;
    
    return self.fetchedResultsController.sectionIndexTitles;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

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

#pragma mark - 实现 NSFetchResultsControllerDelegate 的方法

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //tableView开始更新
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type) {
            //如果是加入了新的组
        case NSFetchedResultsChangeInsert:
            //tableView插入新的组
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            //如果是删除了组
        case NSFetchedResultsChangeDelete:
            //tableView删除新的组
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            
            break;
        case NSFetchedResultsChangeUpdate:
            
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            //如果是组中加入新的对象
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            //如果是组中删除了对象
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            //如果是组中的对象发生了变化
        case NSFetchedResultsChangeUpdate:
            //**********我们需要修改的地方**********
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            //如果是组中的对象位置发生了变化
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //用自己算好的最有算法，进行排列更新
    [self.tableView endUpdates];
}


- (void)addContacts {
    
    AddContactsViewController *vc = [[AddContactsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
