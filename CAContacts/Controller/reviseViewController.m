//
//  reviseViewController.m
//  CAContacts
//
//  Created by Cary on 2019/3/21.
//  Copyright © 2019 Cary. All rights reserved.
//

#import "reviseViewController.h"
#import "TheHeaderFile.h"
#import "reviseCell.h"
#import "MyCoreDataManager.h"
#import "CommonTool.h"

@interface reviseViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    NSArray *labelArr;
    NSMutableArray *detailLabelArr;
    BOOL hadUpdate;
    UIButton *rightButton;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation reviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(reviseFinishClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    hadUpdate = NO;
    
    labelArr = @[@"姓名",@"电话",@"邮箱"];
    detailLabelArr = [NSMutableArray arrayWithObjects:_c.name,_c.phone,_c.email, nil];
    
    [self createUI];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xScreenWidth, xScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        reviseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviseContactCell"];
        if (!cell) {
            cell = [[reviseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reviseContactCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailText.delegate = self;
        cell.detailText.tag = indexPath.row + 1;
        cell.labelText.text = labelArr[indexPath.row];
        cell.detailText.text = detailLabelArr[indexPath.row];
        cell.detailText.placeholder = labelArr[indexPath.row];
        
        if (indexPath.row == 1 || indexPath.row == 2) {
            cell.detailText.textColor = [UIColor colorWithRed:45/255.0 green:120/255.0 blue:250/255.0 alpha:1];
        }
        
        if (indexPath.row == 1) {
            cell.detailText.keyboardType = UIKeyboardTypePhonePad;
        }
        
        return cell;
    }
    
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deleteCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deleteCell"];
        }
        
        cell.textLabel.text = @"删除联系人";
        cell.textLabel.textColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除联系人" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ContactsEntity"];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", self->_c.name];
            request.predicate = predicate;
            
            NSError *error = nil;
            NSArray<ContactsEntity *> *employees = [[MyCoreDataManager shareInstace].managerContext executeFetchRequest:request error:&error];
            
            [employees enumerateObjectsUsingBlock:^(ContactsEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[MyCoreDataManager shareInstace].managerContext deleteObject:obj];
            }];
            
            if ([MyCoreDataManager shareInstace].managerContext.hasChanges) {
                [[MyCoreDataManager shareInstace].managerContext save:&error];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            if (error) {
                NSLog(@"CoreData Delete Data Error : %@", error);
            }
            
        }];
        
        [alert addAction:cancel];
        [alert addAction:delete];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
        
      
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [rightButton setTitleColor:[UIColor colorWithRed:45/255.0 green:120/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    hadUpdate = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1) {
        
        [detailLabelArr replaceObjectAtIndex:0 withObject:textField.text];
    }
    else if (textField.tag == 2) {
        
        [detailLabelArr replaceObjectAtIndex:1 withObject:textField.text];
    }
    else if (textField.tag == 3) {
        
        [detailLabelArr replaceObjectAtIndex:2 withObject:textField.text];
    }
}


- (void)reviseFinishClick {
    
    if (hadUpdate == YES) {
        
        [self.view endEditing:YES];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ContactsEntity"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", _c.name];
        request.predicate = predicate;
        
        NSError *error = nil;
        NSArray<ContactsEntity *> *employees = [[MyCoreDataManager shareInstace].managerContext  executeFetchRequest:request error:&error];
        [employees enumerateObjectsUsingBlock:^(ContactsEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.name = self->detailLabelArr[0];
            obj.namepinyin = [CommonTool getPinYinFromString:self->detailLabelArr[0]];
            obj.phone = self->detailLabelArr[1];
            obj.email = self->detailLabelArr[2];
            obj.sectionName = [[obj.namepinyin substringFromIndex:0] uppercaseString];
        }];
        
        if ([MyCoreDataManager shareInstace].managerContext.hasChanges) {
            [[MyCoreDataManager shareInstace].managerContext save:&error];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if (error) {
            NSLog(@"CoreData Update Data Error : %@", error);
        }
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
