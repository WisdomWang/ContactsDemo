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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) UISearchController *searchController;

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
    
    [self loadMyFetchResultsController];
    
    [self createUI];
   
}

 - (void)createUI {

     self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
     
     //添加搜索栏
     self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
     self.tableView.tableHeaderView = self.searchController.searchBar;
     
     //这是搜索的代理
     self.searchController.delegate = self;
     self.searchController.searchResultsUpdater = self;
     
     //搜索时背景不暗淡
     self.searchController.dimsBackgroundDuringPresentation = NO;
     self.searchController.hidesNavigationBarDuringPresentation = NO;
     self.searchController.obscuresBackgroundDuringPresentation = NO;
     
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xScreenWidth, xScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.tableHeaderView = self.searchController.searchBar;;
    [self.view addSubview:_tableView];
}

-(void)loadMyFetchResultsController {
    
    ///创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"ContactsEntity"];
    ///设置请求排序器
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sectionName" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"namepinyin" ascending:YES]];
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[MyCoreDataManager shareInstace].managerContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    ///执行查询
    [_fetchedResultsController performFetch:nil];
    
    [self.tableView reloadData];

}

#pragma mark - UISearchResultsUpdating 协议
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取输入搜索的内容
    NSString * text = self.searchController.searchBar.text;
    
    //创建请求
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"ContactsEntity"];
    
    //创建排序器
    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"namepinyin" ascending:YES];
    [request setSortDescriptors:@[descriptor]];
    
    //创建谓词
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name contains %@",text];
    [request setPredicate:predicate];
    
    //初始化fetchResulteController
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[MyCoreDataManager shareInstace].managerContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    
    //执行
    NSError * error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    //刷新当前tableView
    [self.tableView reloadData];
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    
    //重新设置fetchResultsController的属性
    [self loadMyFetchResultsController];
    
    //刷新当前的tableView
    [self.tableView reloadData];
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    return self.fetchedResultsController.sectionIndexTitles;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [self.fetchedResultsController.sections objectAtIndex:section].indexTitle;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
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
    [self.searchController setActive:NO];
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
   // [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
