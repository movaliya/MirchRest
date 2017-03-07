//
//  HomeView.m
//  MirchMasala
//
//  Created by Mango SW on 07/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "HomeView.h"
#import "CategoriesCell.h"
#import "MirchMasala.pch"
#import "AppDelegate.h"
#import "SubItemView.h"
@interface HomeView ()
@property AppDelegate *appDelegate;

@end

@implementation HomeView
@synthesize CategoriesTableView,MenuView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"CategoriesCell" bundle:nil];
    CategoriesCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CategoriesTableView.rowHeight = cell.frame.size.height;
    [CategoriesTableView registerNib:nib forCellReuseIdentifier:@"CategoriesCell"];
    
    CheckMenuBool=1;
    
    //Hide About Lable in cell
    [cell.AboutLable setHidden:YES];
    
    
    self.MenuView.layer.masksToBounds = NO;
    self.MenuView.layer.shadowOffset = CGSizeMake(-15, 2);
    self.MenuView.layer.shadowRadius = 10;
    self.MenuView.layer.shadowOpacity = 0.5;
    
    //About String
    
    AboutMessage=@"Welcome to Mirch Masala Indian Takeaway\n Situated in Pensnett, the Mirch Masala Indian Takeaway offers mouth-watering Indian cuisine.\n The Mirch Masala Indian Takeaway is renowned throughout the Pensnett and Dudley area for its divine style and presentation of traditional Indian cuisine, this is achieved by paying special attention to every fine detail and only using the very finest ingredients.\n If you looking for the most exquisite Indian food in the Pensnett and Dudley area, then take a look and order from our easy to use on screen menu, you will see that we offer something for every member of your family. Our on-line menu is fully customisable, so why give it a try! If your favourite meal is not on our menu just call 01384 78007 to ask us, and our chef will happily try and prepare it especially for you.\n            Our high quality Website is provided by tiffintom.com, please be sure to visit our website on a regular basis to see our latest menu updates.\n We deliver on all online orders to following postcods DY1 DY2 DY3 DY5 DY4 DY6 DY8 B69 plus more also Pensenett Dudley and Brierley hill";
    
    
    
    // Call Category List
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CategoriesList];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
}
-(void)CategoriesList
{
    
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"topCategories" forKey:@"METHOD"];
    
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
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             topCategoriesDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"topCategories"];
             
             if (topCategoriesDic) {
                 [CategoriesTableView reloadData];
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
    if (CheckMenuBool==1)
    {
         return topCategoriesDic.count;
    }
    else
    {
         return 1;
    }
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
    static NSString *CellIdentifier = @"CategoriesCell";
    CategoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    if (CheckMenuBool==1)
    {
        cell.TitleLable.text=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.section];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else
    {
        cell.AboutLable.text=AboutMessage;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubItemView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SubItemView"];
    vcr.CategoryId=[[topCategoriesDic valueForKey:@"id"] objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)MenuBtn_action:(id)sender
{
    // Set Bool and hide lable
    CheckMenuBool=1;
    UINib *nib = [UINib nibWithNibName:@"CategoriesCell" bundle:nil];
    CategoriesCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CategoriesTableView.rowHeight = cell.frame.size.height;
    [CategoriesTableView registerNib:nib forCellReuseIdentifier:@"CategoriesCell"];
    [cell.AboutLable setHidden:YES];
    [cell.TitleLable setHidden:NO];
    [cell.ArrowImageVW setHidden:NO];
    [CategoriesTableView reloadData];

    
   //Disable
    self.AboutLine.backgroundColor=[UIColor whiteColor];
    [self.AboutMenuBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
    self.menuLine.backgroundColor= [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.MenuBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];
    
}
- (IBAction)AboutBtn_action:(id)sender
{
    // Set Bool hide & show lable and image
    CheckMenuBool=0;
    
    UINib *nib = [UINib nibWithNibName:@"CategoriesCell" bundle:nil];
    CategoriesCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CategoriesTableView.rowHeight = cell.frame.size.height;
    [CategoriesTableView registerNib:nib forCellReuseIdentifier:@"CategoriesCell"];
    [cell.AboutLable setHidden:NO];
    [cell.TitleLable setHidden:YES];
    [cell.ArrowImageVW setHidden:YES];
     [CategoriesTableView reloadData];
    
    
    
    
    //Disable
    self.menuLine.backgroundColor=[UIColor whiteColor];
    [self.MenuBtn setTitleColor:[UIColor colorWithRed:(161/255.0) green:(156/255.0) blue:(156/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    //Enable
    self.AboutLine.backgroundColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    [self.AboutMenuBtn setTitleColor:[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0] forState:UIControlStateNormal];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
