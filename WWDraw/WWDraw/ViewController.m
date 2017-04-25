//
//  ViewController.m
//  WWDraw
//
//  Created by 王伟 on 2017/4/25.
//  Copyright © 2017年 王伟. All rights reserved.
//

#import "ViewController.h"
#import "WaveViewController.h"

@interface ViewController () <UITableViewDelegate>


/** 数据 */
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WaveViewController *vc = [[WaveViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 1) {
    
    } else if (indexPath.row == 2) {
    
    }
    
}


@end
