//
//  OrderHistryView.m
//  MirchMasala
//
//  Created by Mango SW on 09/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "OrderHistryView.h"
#import "OrderHistry_Cell.h"
#import "OrderDetailView.h"


@interface OrderHistryView ()

@end

@implementation OrderHistryView
@synthesize OrderHistyTableView;
@synthesize CartNotification_LBL;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    if (KmyappDelegate.MainCartArr.count>0)
    {
        [CartNotification_LBL setHidden:NO];
        CartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    }
    else
    {
        [CartNotification_LBL setHidden:YES];
    }
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 10.0;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    UINib *nib = [UINib nibWithNibName:@"OrderHistry_Cell" bundle:nil];
    OrderHistry_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    OrderHistyTableView.rowHeight = cell.frame.size.height;
    [OrderHistyTableView registerNib:nib forCellReuseIdentifier:@"OrderHistry_Cell"];
     [cell.CancelBtn setHidden:YES];
    [cell.CancleIMG setHidden:YES];
    
    OrderStatus=@"Completed";
    
    // For tabbarView Shadow
    self.MenuView.layer.masksToBounds = NO;
    self.MenuView.layer.shadowOffset = CGSizeMake(0, 1);
   // self.MenuView.layer.shadowRadius = 5;
    self.MenuView.layer.shadowOpacity = 0.5;
    
    //Tab Bar Disable Object
    self.LBL_pending.backgroundColor=[UIColor whiteColor];
    [self.pendingBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    self.LBL_cancel.backgroundColor=[UIColor whiteColor];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //  return topCategoriesDic.count;
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"OrderHistry_Cell";
    OrderHistry_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    if ([OrderStatus isEqualToString:@"Pending"])
    {
        [cell.CancelBtn setHidden:NO];
        [cell.CancleIMG setHidden:NO];
    }
    else
    {
         [cell.CancelBtn setHidden:YES];
        [cell.CancleIMG setHidden:YES];
    }
    cell.OrderStatus_LBL.text=OrderStatus;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderDetailView"];
    vcr.StatusMsg=OrderStatus;
    [self.navigationController pushViewController:vcr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Completed_action:(id)sender
{
    
    
    //Disable
    self.LBL_pending.backgroundColor=[UIColor whiteColor];
    [self.pendingBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    self.LBL_cancel.backgroundColor=[UIColor whiteColor];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
     OrderStatus=@"Completed";
    self.LBL_complete.backgroundColor= [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.CompleteBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];
     [OrderHistyTableView reloadData];
    
}
- (IBAction)Pending_tabAction:(id)sender
{
    
    //Disable
    self.LBL_complete.backgroundColor=[UIColor whiteColor];
    [self.CompleteBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    self.LBL_cancel.backgroundColor=[UIColor whiteColor];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
     OrderStatus=@"Pending";
    self.LBL_pending.backgroundColor= [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.pendingBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];
     [OrderHistyTableView reloadData];
    
}
- (IBAction)Cancel_TabAction:(id)sender
{
    
    //Disable
    self.LBL_complete.backgroundColor=[UIColor whiteColor];
    [self.CompleteBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    self.LBL_pending.backgroundColor=[UIColor whiteColor];
    [self.pendingBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
     OrderStatus=@"Canceled";
    self.LBL_cancel.backgroundColor= [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];
    [OrderHistyTableView reloadData];
}

- (IBAction)ToggleMenu:(id)sender
{
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}
@end
