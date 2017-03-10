//
//  OrderDetailView.m
//  MirchMasala
//
//  Created by Mango SW on 09/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "OrderDetailView.h"
#import "OrderDetailLowerCell.h"
#import "OderDetailUperCell.h"

@interface OrderDetailView ()

@end

@implementation OrderDetailView
@synthesize OrderDetailTableView;
@synthesize StatusMsg;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UINib *nib = [UINib nibWithNibName:@"OderDetailUperCell" bundle:nil];
    OderDetailUperCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    OrderDetailTableView.rowHeight = cell.frame.size.height;
    [OrderDetailTableView registerNib:nib forCellReuseIdentifier:@"OderDetailUperCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"OrderDetailLowerCell" bundle:nil];
    OrderDetailLowerCell *cell1 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    OrderDetailTableView.rowHeight = cell1.frame.size.height;
    [OrderDetailTableView registerNib:nib1 forCellReuseIdentifier:@"OrderDetailLowerCell"];
    
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //  return topCategoriesDic.count;
    return 11;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"OderDetailUperCell";
        OderDetailUperCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.OrderStatus_LBL.text=StatusMsg;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"OrderDetailLowerCell";
        OrderDetailLowerCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell1=nil;
        if (cell1 == nil)
        {
            cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 137;
    }
    return 60;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ToggleMenuBtn_Action:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}


@end