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
#import "cartView.h"


@interface OrderDetailView ()

@end

@implementation OrderDetailView
@synthesize OrderDetailTableView;
@synthesize StatusMsg,CartNotification_LBL;
@synthesize OrderHistryDetailDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    childerDic=[OrderHistryDetailDic objectForKey:@"children"];
    NSLog(@"childerDic==%@",childerDic);
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        NSInteger qnttotal=0;
        for (int i=0; i<KmyappDelegate.MainCartArr.count; i++)
        {
            qnttotal=qnttotal+[[[KmyappDelegate.MainCartArr objectAtIndex:i]valueForKey:@"quatity"] integerValue];
        }
        
        [CartNotification_LBL setHidden:NO];
        CartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)qnttotal];
    }
    else
    {
        [CartNotification_LBL setHidden:YES];
    }
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    
    UINib *nib = [UINib nibWithNibName:@"OderDetailUperCell" bundle:nil];
    OderDetailUperCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    OrderDetailTableView.rowHeight = cell.frame.size.height;
    [OrderDetailTableView registerNib:nib forCellReuseIdentifier:@"OderDetailUperCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"OrderDetailLowerCell" bundle:nil];
    OrderDetailLowerCell *cell1 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    OrderDetailTableView.rowHeight = cell1.frame.size.height;
    [OrderDetailTableView registerNib:nib1 forCellReuseIdentifier:@"OrderDetailLowerCell"];
    //NSLog(@"mainoder=%@",OrderHistryDetailDic);
    
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //  return topCategoriesDic.count;
    return childerDic.count+1;
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
        NSString *orderDate=[[OrderHistryDetailDic valueForKey:@"orderDate"] valueForKey:@"date"];
        
        cell.OrderNumber_LBL.text=[OrderHistryDetailDic valueForKey:@"id"];
        cell.OrderAmount_LBL.text=[NSString stringWithFormat:@"£%@",[OrderHistryDetailDic valueForKey:@"total"]];
         cell.Discount_LBL.text=[NSString stringWithFormat:@"£%@",[OrderHistryDetailDic valueForKey:@"discount"]];
        cell.OrderDate_LBL.text=orderDate;
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
        
        cell1.ProductName_LBL.text=[[[childerDic valueForKey:@"product"] valueForKey:@"productName"]objectAtIndex:indexPath.section-1];
        cell1.ProductPrice_LBL.text=[NSString stringWithFormat:@"£%@",[[[childerDic valueForKey:@"product"] valueForKey:@"price"]objectAtIndex:indexPath.section-1]];
        
        NSInteger qutInt=[[[childerDic valueForKey:@"quantity"] objectAtIndex:indexPath.section-1] integerValue];
        cell1.ProductQuatity_LBL.text=[NSString stringWithFormat:@"%ld",(long)qutInt];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 130;
    }
    return 90;
    
}
- (IBAction)TopBarCartBtn_action:(id)sender
{
    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
    [self.navigationController pushViewController:vcr animated:YES];
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
