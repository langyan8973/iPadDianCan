//
//  DisplayUtils.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-22.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "DisplayUtils.h"

@implementation DisplayUtils
+(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];    
    view.backgroundColor = [UIColor clearColor];    
    [tableView setTableFooterView:view];    
    [view release];
}
@end
