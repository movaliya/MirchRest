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
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableDictionary *dic;

@end

@implementation cartView
@synthesize cartTable;
@synthesize arr,dic;

- (void)viewDidLoad {
    [super viewDidLoad];
    cellcount=15;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    UINib *nib = [UINib nibWithNibName:@"CartTableCell" bundle:nil];
    CartTableCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cartTable.rowHeight = cell.frame.size.height;
    [cartTable registerNib:nib forCellReuseIdentifier:@"CartTableCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"CartGrandTotalCell" bundle:nil];
    CartGrandTotalCell *cell1 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cartTable.rowHeight = cell1.frame.size.height;
    [cartTable registerNib:nib1 forCellReuseIdentifier:@"CartGrandTotalCell"];
    
    arr = [NSMutableArray array];
    for (int i = 0; i <15; i++) {
        [arr addObject:@"1"];
    }
    
    dic=[[NSMutableDictionary alloc]init];
    [dic setObject:arr forKey:@"Count"];
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      //  return topCategoriesDic.count;
    return cellcount+1;
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
        cell1.PlusBtn.tag=indexPath.section;
        cell1.MinusBtn.tag=indexPath.section;
        
        [cell1.PlusBtn addTarget:self action:@selector(PlushClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.MinusBtn addTarget:self action:@selector(MinushClick:) forControlEvents:UIControlEventTouchUpInside];
         [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == cellcount)
    {
        return 180;
    }
    return 72;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)PlushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[cellContentView superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    CartTableCell *cell = (CartTableCell *)[cartTable cellForRowAtIndexPath:pathOfTheCell];
    NSLog(@"senderButton.tag=%ld",(long)senderButton.tag);
    
    NSInteger count = [cell.Quatity_LBL.text integerValue];
    count = count + 1;
    cell.Quatity_LBL.text = [NSString stringWithFormat:@"%ld",count];
    
    [arr replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",count]];
    [dic setObject:arr forKey:@"Count"];
    
    
    ButtonTag=senderButton.tag;
    chechPlusMinus=1;
    //[TableView reloadData];
    
}

-(void)MinushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[cellContentView superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    CartTableCell *cell = (CartTableCell *)[cartTable cellForRowAtIndexPath:pathOfTheCell];
    
    NSInteger count = [cell.Quatity_LBL.text integerValue];
    count = count - 1;
    if (count!=0)
    {
        cell.Quatity_LBL.text = [NSString stringWithFormat:@"%ld",count];
        [arr replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",count]];
        [dic setObject:arr forKey:@"Count"];
        ButtonTag=senderButton.tag;
        chechPlusMinus=0;
    }
}

- (void)didReceiveMemoryWarning {
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
