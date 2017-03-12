//
//  cartView.m
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "cartView.h"
#import "CartTableCell.h"
#import "CartGrandTotalCell.h"
@interface cartView ()
{
    NSString *CoustmerID;
}
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableDictionary *dic,*MainCount;

@end

@implementation cartView
@synthesize cartTable;
@synthesize arr,dic,MainCount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    NSLog( @"%@",KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]]);
    cellcount=KmyappDelegate.MainCartArr.count;
    
    UINib *nib = [UINib nibWithNibName:@"CartTableCell" bundle:nil];
    CartTableCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cartTable.rowHeight = cell.frame.size.height;
    [cartTable registerNib:nib forCellReuseIdentifier:@"CartTableCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"CartGrandTotalCell" bundle:nil];
    CartGrandTotalCell *cell1 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cartTable.rowHeight = cell1.frame.size.height;
    [cartTable registerNib:nib1 forCellReuseIdentifier:@"CartGrandTotalCell"];
    
    arr = [NSMutableArray array];
    for (int i = 0; i <15; i++)
    {
        [arr addObject:@"1"];
    }
    
    dic=[[NSMutableDictionary alloc]init];
    MainCount=[[NSMutableDictionary alloc]init];
    [dic setObject:arr forKey:@"Count"];
    [MainCount setObject:arr forKey:@"MainCount"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      //  return topCategoriesDic.count;
    return KmyappDelegate.MainCartArr.count+1;
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
    
    if (indexPath.section == cellcount)
    {
        static NSString *CellIdentifier = @"CartGrandTotalCell";
        CartGrandTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"CartTableCell";
        CartTableCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell1=nil;
        if (cell1 == nil)
        {
            cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section] valueForKey:@"ingredient"] mutableCopy];
        if ([Array isKindOfClass:[NSArray class]])
        {
            NSString *OptionStr=[[NSString alloc]init];
            for (int i=0; i<Array.count; i++)
            {
                if (i==0)
                {
                    OptionStr=[[Array objectAtIndex:i] valueForKey:@"ingredient_name"];
                }
                else
                {
                    OptionStr=[NSString stringWithFormat:@"%@,%@",OptionStr,[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
                }
            }
            if (![OptionStr isEqualToString:@""])
            {
                cell1.Option_LBL.text=OptionStr;
            }
        }
       
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell1.Title_LBL.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"productName"];
       
        cell1.Qnt_TXT.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"quatity"];
        cell1.Price_LBL.text=[NSString stringWithFormat:@"£%@",[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"price"]];
        
        [cell1.Close_BTN addTarget:self action:@selector(Close_Click:) forControlEvents:UIControlEventTouchUpInside];
        cell1.Close_BTN.tag=indexPath.section;
       
        return cell1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == cellcount)
    {
        return 137;
    }
    return 90;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)Close_Click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    [KmyappDelegate.MainCartArr removeObjectAtIndex:senderButton.tag];
    [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
    KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    cellcount=KmyappDelegate.MainCartArr.count;
    [cartTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ToggleMenuBtn_action:(id)sender
{
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}

@end
