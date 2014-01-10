//
//  RecipeCategoryCell.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-22.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecipeCategoryCell.h"

@implementation RecipeCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect=self.textLabel.frame;
    rect.origin.x=5;
    rect.size.width=35;
    [self.textLabel setFrame:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
