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
#import "LoginVW.h"

@interface cartView ()
{
    NSString *CoustmerID,*MainDiscount,*CategoryIdStr,*Select_Indx;
    float Total,MainTotal;
    
    
    NSMutableArray *WithSelectArr,*WithoutSelectArr;
    NSMutableArray *withSelectMain,*withoutselectMain;
}
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableDictionary *dic,*MainCount;

@end

@implementation cartView
@synthesize cartTable;
@synthesize arr,dic,MainCount,CheckoutTotal_LBL;
@synthesize OptionView,WithTBL,WithoutTBL,Notavailable_LBL,cartNotification_LBL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cartNotification_LBL.layer.masksToBounds = YES;
    cartNotification_LBL.layer.cornerRadius = 10.0;
    
    OptionView.hidden=YES;
    self.OptionTitleView.layer.masksToBounds = NO;
    self.OptionTitleView.layer.shadowOffset = CGSizeMake(0, 1);
    self.OptionTitleView.layer.shadowOpacity = 0.5;
    
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    if (KmyappDelegate.MainCartArr.count>0)
    {
        
        NSLog( @"%@",KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]]);
        
        Notavailable_LBL.hidden=YES;
        cartTable.hidden=NO;
        cellcount=KmyappDelegate.MainCartArr.count;
        [cartNotification_LBL setHidden:NO];
        cartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    }
    else
    {
        Notavailable_LBL.hidden=NO;
        cartTable.hidden=YES;
        [cartNotification_LBL setHidden:YES];
    }
    
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
    
    
    [self GetDiscount];
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
}

-(void)SUBCategoriesList :(NSString *)CategoryId buttonTag:(NSString *)ProductidStr Selecredinx:(NSString *)Selectcredinx
{
    [KVNProgress show] ;
    CategoryIdStr=CategoryId;
    Select_Indx=Selectcredinx;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:CategoryId forKey:@"CATEGORYID"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"products" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arrs = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arrs forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         [KVNProgress dismiss];
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             subCategoryDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"result"] objectForKey:@"products"];
             
             AllProductIngredientsDIC=[subCategoryDic valueForKey:@"ingredients"];
             arrayInt = [[NSMutableArray alloc] init];
             for (int i = 0; i <subCategoryDic.count; i++)
             {
                 [arrayInt addObject:@"1"];
             }
             
             dic=[[NSMutableDictionary alloc]init];
             MainCount=[[NSMutableDictionary alloc]init];
             [dic setObject:arrayInt forKey:@"Count"];
             [MainCount setObject:arrayInt forKey:@"MainCount"];
             
             NSArray *idarr=[subCategoryDic valueForKey:@"id"];
             NSInteger indx=[idarr indexOfObject:ProductidStr];
             
             [self OptionClick:[NSString stringWithFormat:@"%ld",(long)indx]];
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}

-(void)OptionClick:(NSString *)indextag
{
    OptionView.hidden=NO;
    subItemIndex= [indextag integerValue];
    ProductIngredDic=[[subCategoryDic valueForKey:@"ingredients"] objectAtIndex:subItemIndex];
    
    int count=0;
    withoutIntegrate=[[NSMutableArray alloc] init];
    WithIntegrate=[[NSMutableArray alloc] init];
    
    withSelectMain=[[NSMutableArray alloc] init];
    withoutselectMain=[[NSMutableArray alloc] init];
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

-(void)GetDiscount
{
    [KVNProgress show] ;
    MainDiscount =@"0.00";
    NSMutableArray *ProdArr=[[NSMutableArray alloc]init];
    NSLog(@"===%@",KmyappDelegate.MainCartArr);
    for (int k=0; k<KmyappDelegate.MainCartArr.count; k++)
    {
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"ingredient"] mutableCopy];
        NSMutableArray *Withindgarr=[[NSMutableArray alloc]init];
        NSMutableArray *Withoutindgarr=[[NSMutableArray alloc]init];
        NSMutableDictionary *inddic=[[NSMutableDictionary alloc]init];
        
        ProdArr=[[NSMutableArray alloc]init];
        NSString *ProdidSr=[[NSString alloc]init];
        if ([Array isKindOfClass:[NSArray class]])
        {
            for (int i=0; i<Array.count; i++)
            {
                if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] isEqualToString:@"1"])
                {
                    [Withindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                else
                {
                    [Withoutindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                ProdidSr=[[Array objectAtIndex:i] valueForKey:@"product_id"];
            }
            if (Withindgarr.count>0)
            {
                [inddic setObject:Withindgarr forKey:@"WITHINGREDIENTID"];
            }
            if (Withoutindgarr.count>0)
            {
                [inddic setObject:Withoutindgarr forKey:@"WITHOUTINGREDIENTID"];
            }
        }
        
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"Productid"] forKey:@"ID"];
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"quatity"] forKey:@"QUANTITY"];
        [ProdArr addObject:inddic];
    }
    
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:@"Collection" forKey:@"ORDERTYPE"];
    [dictInner setObject:ProdArr forKey:@"PRODUCTS"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"calculateDiscount" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arrs = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arrs forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers  error:&error];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         [KVNProgress dismiss];
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"calculateDiscount"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             MainDiscount=[NSString stringWithFormat:@"%@",[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"calculateDiscount"]  objectForKey:@"result"] objectForKey:@"calculateDiscount"]];
         }
         //[cartTable reloadData];
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
    //NSLog(@"MainCartArr---%d",KmyappDelegate.MainCartArr.count);
    return KmyappDelegate.MainCartArr.count+1;
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
    return 10;
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
        static NSString *CellIdentifier1 = @"Cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
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
    else
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
            
            cell.SubTotal_LBL.text=[NSString stringWithFormat:@"%.02f",MainTotal];
            cell.Discount_LBL.text=MainDiscount;
            float Gt=[[NSString stringWithFormat:@"%.02f",MainTotal] floatValue] - [MainDiscount floatValue];
            cell.GrandTotal_LBL.text=[NSString stringWithFormat:@"%.02f",Gt];
            CheckoutTotal_LBL.text=[NSString stringWithFormat:@"£%@",cell.GrandTotal_LBL.text];
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
            
            Total=[[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"price"] floatValue];
             float integratPRICE=0.00;
            if ([Array isKindOfClass:[NSArray class]])
            {
                NSString *OptionStr=[[NSString alloc]init];
               
                for (int i=0; i<Array.count; i++)
                {
                   // Total=Total+[[[Array objectAtIndex:i] valueForKey:@"price"] floatValue];
                    
                    if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] boolValue]==0)
                    {
                        integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price_without"] floatValue];
                    }
                    else
                    {
                        integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price"] floatValue];
                    }
                    if (i==0)
                    {
                        OptionStr=[[Array objectAtIndex:i] valueForKey:@"ingredient_name"];
                    }
                    else
                    {
                        OptionStr=[NSString stringWithFormat:@"%@,%@",OptionStr,[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
                    }
                }
                 NSLog(@"integratPRICE===%f",integratPRICE);
                if (![OptionStr isEqualToString:@""])
                {
                    cell1.Option_LBL.text=OptionStr;
                }
            }
            
            
            Total=Total*[[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"quatity"] floatValue];
            NSLog(@"total=%f",Total);
            MainTotal=MainTotal+Total+integratPRICE;
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell1.Title_LBL.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"productName"];
            
            cell1.Qnt_TXT.text=[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"quatity"];
            cell1.Qnt_TXT.tag=indexPath.section;
            cell1.Price_LBL.text=[NSString stringWithFormat:@"£%@",[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section]valueForKey:@"price"]];
            
            [cell1.Close_BTN addTarget:self action:@selector(Close_Click:) forControlEvents:UIControlEventTouchUpInside];
            cell1.Close_BTN.tag=indexPath.section;
            
            [cell1.Update_BTN addTarget:self action:@selector(Update_Click:) forControlEvents:UIControlEventTouchUpInside];
            cell1.Update_BTN.tag=indexPath.section;

            [cell1.Change_BTN addTarget:self action:@selector(Change_Click:) forControlEvents:UIControlEventTouchUpInside];
            cell1.Change_BTN.tag=indexPath.section;

            return cell1;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithTBL || tableView==WithoutTBL)
    {
        return 44;
    }
    else
    {
        if (indexPath.section == cellcount)
        {
            return 137;
        }
        return 90;
    }    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==WithoutTBL)
    {
        if ([[WithoutSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
        {
            [WithoutSelectArr replaceObjectAtIndex:indexPath.row withObject:@"NO"];
            NSInteger indx=[withoutselectMain indexOfObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [withoutselectMain removeObjectAtIndex:indx];
        }
        else
        {
            [WithoutSelectArr replaceObjectAtIndex:indexPath.row withObject:@"YES"];
            [withoutselectMain addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
        }
        
        [WithoutTBL reloadData];
    }
    else if (tableView==WithTBL)
    {
        if ([[WithSelectArr objectAtIndex:indexPath.row] isEqualToString:@"YES"])
        {
            [WithSelectArr replaceObjectAtIndex:indexPath.row withObject:@"NO"];
            NSInteger indx=[withSelectMain indexOfObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [withSelectMain removeObjectAtIndex:indx];
        }
        else
        {
            [WithSelectArr replaceObjectAtIndex:indexPath.row withObject:@"YES"];
            [withSelectMain addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        
        [WithTBL reloadData];
    }

}

-(void)WithoutChkbox_click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"%ld",(long)senderButton.tag);
    
    if ([[WithoutSelectArr objectAtIndex:senderButton.tag] isEqualToString:@"YES"])
    {
        [WithoutSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"NO"];
        NSInteger indx=[withoutselectMain indexOfObject:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
        [withoutselectMain removeObjectAtIndex:indx];
        
    }
    else
    {
        [WithoutSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"YES"];
        [withoutselectMain addObject:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
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
        NSInteger indx=[withSelectMain indexOfObject:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
        [withSelectMain removeObjectAtIndex:indx];
    }
    else
    {
        [WithSelectArr replaceObjectAtIndex:senderButton.tag withObject:@"YES"];
        [withSelectMain addObject:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
        
    }
    [WithTBL reloadData];
}

- (IBAction)Cancle_Click:(id)sender
{
    OptionView.hidden=YES;
    [WithTBL reloadData];
    [WithoutTBL reloadData];
}

-(void)checkLoginAndPresentContainer
{
    LoginVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVW"];
    vcr.ShowBack=@"YES";
    [self.navigationController  pushViewController:vcr animated:YES];
}

- (IBAction)Confirm_Click:(id)sender
{
    if ([KmyappDelegate isUserLoggedIn] == NO)
    {
        [self performSelector:@selector(checkLoginAndPresentContainer) withObject:nil afterDelay:0.0];
    }
    else
    {
        NSMutableArray *arrs=[[NSMutableArray alloc]init];
        for (int i=0; i<withSelectMain.count; i++)
        {
            [arrs addObject:[WithIntegrate objectAtIndex:[[withSelectMain objectAtIndex:i] integerValue]]];
        }
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        for (int i=0; i<withoutselectMain.count; i++)
        {
            [arr2 addObject:[withoutIntegrate objectAtIndex:[[withoutselectMain objectAtIndex:i] integerValue]]];
        }
        
        NSArray *FinalArray=[arrs arrayByAddingObjectsFromArray:arr2];
        OptionView.hidden=YES;
        [WithTBL reloadData];
        [WithoutTBL reloadData];
        
        NSString *prductNM=[[subCategoryDic valueForKey:@"productName"] objectAtIndex:subItemIndex];
        NSString *prductPRICE=[[subCategoryDic valueForKey:@"price"] objectAtIndex:subItemIndex];
        NSString *Quatity=[[MainCount valueForKey:@"MainCount"] objectAtIndex:subItemIndex];
        NSString *Productid=[[subCategoryDic valueForKey:@"id"] objectAtIndex:subItemIndex];
        
        NSMutableDictionary *AddTocardDic = [[NSMutableDictionary alloc] init];
        [AddTocardDic setObject:prductNM forKey:@"productName"];
        [AddTocardDic setObject:prductPRICE forKey:@"price"];
        [AddTocardDic setObject:Quatity forKey:@"quatity"];
        [AddTocardDic setObject:Productid forKey:@"Productid"];
        [AddTocardDic setObject:CategoryIdStr forKey:@"CategoryId"];
        
        [AddTocardDic setObject:FinalArray forKey:@"ingredient"];
        NSLog(@"AddTocardDic===%@",AddTocardDic);
        
        NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
        NSString *CoustmerIDs=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerIDs]];
        [KmyappDelegate.MainCartArr removeObjectAtIndex:[Select_Indx integerValue]];
        [KmyappDelegate.MainCartArr insertObject:AddTocardDic atIndex:[Select_Indx integerValue]];

       // [KmyappDelegate.MainCartArr addObject:AddTocardDic];
        [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerIDs];
        NSLog(@"==%@",KmyappDelegate.MainCartArr);
        
        [self GetDiscount];
        Total=0.0;
        MainTotal=0.0;
        [cartTable reloadData];
      
    }
}

-(void)Change_Click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    [self SUBCategoriesList:[[KmyappDelegate.MainCartArr objectAtIndex:senderButton.tag] valueForKey:@"CategoryId"] buttonTag:[[KmyappDelegate.MainCartArr objectAtIndex:senderButton.tag] valueForKey:@"Productid"] Selecredinx:[NSString stringWithFormat:@"%ld",(long)senderButton.tag]];
}

-(void)Update_Click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:0 inSection:senderButton.tag];
    CartTableCell *cell = (CartTableCell *)[cartTable cellForRowAtIndexPath:changedRow];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDictionary *oldDict = (NSDictionary *)[KmyappDelegate.MainCartArr objectAtIndex:senderButton.tag];
    [newDict addEntriesFromDictionary:oldDict];
    [newDict setObject:cell.Qnt_TXT.text forKey:@"quatity"];
    [KmyappDelegate.MainCartArr replaceObjectAtIndex:senderButton.tag withObject:newDict];
    [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
    KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    [self GetDiscount];
    Total=0.0;
    MainTotal=0.0;
    [cartTable reloadData];
}

-(void)Close_Click:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    [KmyappDelegate.MainCartArr removeObjectAtIndex:senderButton.tag];
    [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
    KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    cellcount=KmyappDelegate.MainCartArr.count;
    
     [self GetDiscount];
    
    Total=0.0;
    MainTotal=0.0;
    [cartTable reloadData];
    
    if (KmyappDelegate.MainCartArr.count>0)
    {
        [cartNotification_LBL setHidden:NO];
        cartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    }
    else
    {
        [cartNotification_LBL setHidden:YES];
    }
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
