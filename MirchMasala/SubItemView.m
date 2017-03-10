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
@property (strong, nonatomic) NSMutableDictionary *dic,*MainCount;
@end

@implementation SubItemView
@synthesize ItemTableView;
@synthesize CategoryId,categoryName,CategoryTitleLBL;
@synthesize dic,MainCount;
- (BOOL)prefersStatusBarHidden {
     return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UINib *nib = [UINib nibWithNibName:@"SubitemCell" bundle:nil];
    SubitemCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    ItemTableView.rowHeight = cell.frame.size.height;
    [ItemTableView registerNib:nib forCellReuseIdentifier:@"SubitemCell"];
    CategoryTitleLBL.text=categoryName;
    
    
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
    return subCategoryDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubitemCell";
    SubitemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    cell.PlusBtn.tag=indexPath.section;
    cell.MinusBtn.tag=indexPath.section;
    
    [cell.PlusBtn addTarget:self action:@selector(PlushClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.MinusBtn addTarget:self action:@selector(MinushClick:) forControlEvents:UIControlEventTouchUpInside];
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
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
