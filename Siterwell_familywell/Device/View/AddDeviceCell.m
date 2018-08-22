//
//  AddDeviceCell.m
//  sHome
//
//  Created by 沈晓鹏 on 2017/4/11.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AddDeviceCell.h"

@implementation AddDeviceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initview];
    }
    return self;
}

-(void)initview{
    self.mainImageView = [[UIImageView alloc] init];
    UIImage *ds = [UIImage imageNamed:NSLocalizedString(@"adddevice_zh", nil)];
    [self.mainImageView setImage:ds];
    self.mainImageView.clipsToBounds = YES;
    [self.mainImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.mainImageView.contentMode =  UIViewContentModeScaleAspectFit;
    self.mainImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.mainImageView];
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
        make.height.equalTo (Main_Screen_Width * ds.size.height / ds.size.width);
    }];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
