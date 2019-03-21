//
//  ShowContactsViewController.m
//  CAContacts
//
//  Created by Cary on 2019/3/21.
//  Copyright © 2019 Cary. All rights reserved.
//

#import "ShowContactsViewController.h"
#import "TheHeaderFile.h"

@interface ShowContactsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    NSArray *labelArr;
    NSArray *detailLabelArr;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ShowContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(reviseClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
    labelArr = @[@"姓名",@"电话",@"邮箱"];
    detailLabelArr = @[_c.name,_c.phone,_c.email];

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showContactCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"showContactCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = labelArr[indexPath.row];
    cell.detailTextLabel.text = detailLabelArr[indexPath.row];
    
    return cell;
}

- (void)reviseClick {
    
    
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
