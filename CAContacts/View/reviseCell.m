//
//  reviseCell.m
//  CAContacts
//
//  Created by Cary on 2019/3/27.
//  Copyright © 2019 Cary. All rights reserved.
//

#import "reviseCell.h"
#import "TheHeaderFile.h"

@implementation reviseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _labelText = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 44)];
        [self.contentView addSubview:_labelText];
        
        _detailText = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, xScreenWidth-120, 44)];
        
        [self.contentView addSubview:_detailText];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
