//
//  addContactsCell.m
//  CAContacts
//
//  Created by Cary on 2019/3/21.
//  Copyright © 2019 Cary. All rights reserved.
//

#import "AddContactsCell.h"
#import "TheHeaderFile.h"
@implementation AddContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        _detailText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, xScreenWidth, 44)];
        
        [self.contentView addSubview:_detailText];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
