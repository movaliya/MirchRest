//
//  SubItemView.m
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SubItemView.h"
#import "SubitemCell.h"
#import "MirchMasala.pch"

@interface SubItemView ()
{
    NSMutableArray *WithSelectArr,*WithoutSelectArr;
}

@property (strong, nonatomic) NSMutableDictionary *dic,*MainCount;
@end

@implementation SubItemView
@synthesize ItemTableView;
@synthesize CategoryId,categoryName,CategoryTitleLBL;
@synthesize dic,MainCount;
@synthesize OptionView,WithTBL,WithoutTBL;


- (BOOL)prefersStatusBarHidden
{
     return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    OptionView.hidden=YES;
    UINib *nib = [UINib nibWithNibName:@"SubitemCell" bundle:nil];
    SubitemCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    ItemTableView.rowHeight = cell.frame.size.height;
    [ItemTableView registerNib:nib forCellReuseIdentifier:@"SubitemCell"];
    CategoryTitleLBL.text=categoryName;
    
    self.OptionTitleView.layer.masksToBounds = NO;
    self.OptionTitleView.layer.shadowOffset = CGSizeMake(0, 1);
    // self.MenuView.layer.shadowRadius = 5;
    self.OptionTitleView.layer.shadowOpacity = 0.5;
    
    
    [self SUBCategoriesList];
    
}


-(void)SUBCategoriesList
{
    
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:CategoryId forKey:@"CATEGORYID"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"products" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         //NSLog(@"responseObject==%@",responseObject);
         [KVNProgress dismiss];
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             subCategoryDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"result"] objectForKey:@"products"];
             AllProductIngredientsDIC=[subCategoryDic valueForKey:@"ingredients"];
             arrayInt = [[NSMutableArray alloc] init];
             for (int i = 0; i <subCategoryDic.count; i++) {
                 [arrayInt addObject:@"1"];
             }
             
             dic=[[NSMutableDictionary alloc]init];
             MainCount=[[NSMutableDictionary alloc]init];
             [dic setObject:arrayInt forKey:@"Count"];
             [MainCount setObject:arrayInt forKey:@"MainCount"];
             
             if (subCategoryDic) {
                 [ItemTableView reloadData];
             }
         }
         
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}


#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 1;
    }
    return subCategoryDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==WithTBL )
    {
        return WithIntegrate.count;
    }
    else if (tableView==WithoutTBL )
    {
        return withoutIntegrate.count;
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 1;
    }
    return 10.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return nil;
    }
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIButton *ChkButton=[[UIButton alloc]initWithFrame:CGRectMake(8, 14.5, 15, 15)];
        UILabel *titleLBL=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 44)];
        titleLBL.font=[UIFont systemFontOfSize:15.0f];
        if (tableView==WithTBL)
        {
            if ([[WithSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
            {
                [ChkButton setBackgroundImage:[UIImage imageNamed:@"Orange_chkIcon"] forState:UIControlStateNormal];
            }
            else
            {
                [ChkButton setBackgroundImage:[UIImage imageNamed:@"Orange_UnchkIcon"] forState:UIControlStateNormal];
            }
             [ChkButton addTarget:self action:@selector(WithChkbox_click:) forControlEvents:UIControlEventTouchUpInside];
            titleLBL.text=[[WithIntegrate valueForKey:@"ingredient_name"] objectAtIndex:indexPath.row];

        }
        else
        {
            if ([[WithoutSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
            {
                [ChkButton setBackgroundImage:[UIImage imageNamed:@"Orange_chkIcon"] forState:UIControlStateNormal];
            }
            else
            {
                [ChkButton setBackgroundImage:[UIImage imageNamed:@"Orange_UnchkIcon"] forState:UIControlStateNormal];
            }
             [ChkButton addTarget:self action:@selector(WithoutChkbox_click:) forControlEvents:UIControlEventTouchUpInside];
             titleLBL.text=[[withoutIntegrate valueForKey:@"ingredient_name"] objectAtIndex:indexPath.row];
        }
        
        ChkButton.tag=indexPath.row;
        [cell addSubview:ChkButton];
        [cell addSubview:titleLBL];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
    
    static NSString *CellIdentifier = @"SubitemCell";
    SubitemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    cell.PlusBtn.tag=indexPath.section;
    cell.MinusBtn.tag=indexPath.section;
    cell.optionBtn.tag=indexPath.section;
    
    [cell.PlusBtn addTarget:self action:@selector(PlushClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.MinusBtn addTarget:self action:@selector(MinushClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionBtn addTarget:self action:@selector(OptionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSInteger *Main=[[[MainCount valueForKey:@"MainCount"] objectAtIndex:indexPath.section] integerValue];
    
    NSInteger *Second=[[[dic valueForKey:@"Count"] objectAtIndex:indexPath.section] integerValue];
    
    if (Main==Second)
    {
        cell.Quatity_LBL.text=[NSString stringWithFormat:@"%ld",Main];
        
        
    }
    else
    {
        cell.Quatity_LBL.text=[NSString stringWithFormat:@"%ld",Second];
    }
    
    cell.ProductName.text=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:indexPath.section];
    cell.PriceLable.text=[NSString stringWithFormat:@"£%@",[[subCategoryDic valueForKey:@"price"] objectAtIndex:indexPath.section]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithoutTBL)
    {
        if ([[WithoutSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
        {
            [WithoutSelectArr replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        }
        else
        {
            [WithoutSelectArr replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        }
        
        [WithoutTBL reloadData];
    }
    else if (tableView==WithTBL)
    {
        if ([[WithSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
        {
            [WithSelectArr replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        }
        else
        {
            [WithSelectArr replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        }
        
        [WithTBL reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 44;
    }
    return 65;
    
}


-(void)WithoutChkbox_click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld",(long)senderButton.tag);
    
    if ([[WithoutSelectArr objectAtIndex:senderButton.tag] isEqualToString:@"YES"])
    {
        [WithoutSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"NO"];
    }
    else
    {
        [WithoutSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"YES"];
    }
    
    [WithoutTBL reloadData];
}

-(void)WithChkbox_click:(id)sender
{
     UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld",(long)senderButton.tag);
    
    if ([[WithSelectArr objectAtIndex:senderButton.tag] isEqualToString:@"YES"])
    {
        [WithSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"NO"];
    }
    else
    {
        [WithSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"YES"];
    }
    [WithTBL reloadData];
}

-(void)PlushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    SubitemCell *cell = (SubitemCell *)[ItemTableView cellForRowAtIndexPath:pathOfTheCell];
    NSLog(@"senderButton.tag=%ld",(long)senderButton.tag);
    
    NSInteger count = [cell.Quatity_LBL.text integerValue];
    count = count + 1;
    cell.Quatity_LBL.text = [NSString stringWithFormat:@"%ld",(long)count];
    
    [arrayInt replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",(long)count]];
    [dic setObject:arrayInt forKey:@"Count"];
    
    
    ButtonTag=senderButton.tag;
    chechPlusMinus=1;
    //[TableView reloadData];
    
}

-(void)MinushClick:(id)sender
{
    
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    SubitemCell *cell = (SubitemCell *)[ItemTableView cellForRowAtIndexPath:pathOfTheCell];
    
    NSInteger count = [cell.Quatity_LBL.text integerValue];
    count = count - 1;
    if (count!=0)
    {
        cell.Quatity_LBL.text = [NSString stringWithFormat:@"%ld",(long)count];
        [arrayInt replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",(long)count]];
        [dic setObject:arrayInt forKey:@"Count"];
        ButtonTag=senderButton.tag;
        chechPlusMinus=0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)OptionClick:(id)sender
{
    OptionView.hidden=NO;
    UIButton *senderButton = (UIButton *)sender;
    subItemIndex=senderButton.tag;
    NSLog(@"senderButton.tag=%ld",(long)senderButton.tag);
    ProductIngredDic=[[subCategoryDic valueForKey:@"ingredients"] objectAtIndex:senderButton.tag];
    
    int count=0;
    withoutIntegrate=[[NSMutableArray alloc] init];
    WithIntegrate=[[NSMutableArray alloc] init];
    for (NSMutableArray *dic1 in ProductIngredDic)
    {
        if ([[dic1 valueForKey:@"is_with"] boolValue]==0)
        {
            [withoutIntegrate addObject:dic1];
        }
        else
        {
             [WithIntegrate addObject:dic1];
        }
        count++;
    }
    
    
    WithSelectArr=[[NSMutableArray alloc]init];
    WithoutSelectArr=[[NSMutableArray alloc]init];
    for (int i=0; i<withoutIntegrate.count; i++)
    {
        [WithoutSelectArr addObject:@"NO"];
    }
    for (int i=0; i<WithIntegrate.count; i++)
    {
        [WithSelectArr addObject:@"NO"];
    }
    [WithoutTBL reloadData];
    [WithTBL reloadData];
    NSLog(@"withoutIntegrate=%@",withoutIntegrate);
    
}

- (IBAction)Cancle:(id)sender
{
    //WithSelectArr=[[NSMutableArray alloc]init];
   // WithoutSelectArr=[[NSMutableArray alloc]init];
   // for (int i=0; i<20; i++)
   // {
       // [WithSelectArr addObject:@"NO"];
       // [WithoutSelectArr addObject:@"NO"];
   // }
    OptionView.hidden=YES;
    [WithTBL reloadData];
    [WithoutTBL reloadData];
}

- (IBAction)Confirm_Click:(id)sender
{
   
    OptionView.hidden=YES;
    [WithTBL reloadData];
    [WithoutTBL reloadData];
    NSString *prductNM=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:subItemIndex];
    NSString *prductPRICE=[[subCategoryDic valueForKey:@"price"] objectAtIndex:subItemIndex];
    NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:subItemIndex];
    
    NSMutableDictionary *AddTocardDic = [[NSMutableDictionary alloc] init];
    
    [AddTocardDic setObject:prductNM forKey:@"productName"];
    
    [AddTocardDic setObject:prductPRICE forKey:@"price"];
    [AddTocardDic setObject:Quatity forKey:@"quatity"];
    
    [AddTocardDic setObject:[withoutIntegrate objectAtIndex:1] forKey:@"ingredient"];
    NSLog(@"AddTocardDic===%@",AddTocardDic);
    
}

@end
