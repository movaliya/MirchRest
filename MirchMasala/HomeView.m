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
#import "cartView.h"

@interface HomeView ()
{
    UIImageView *Headerimg;
    NSMutableDictionary *Searchdic;
}
@property AppDelegate *appDelegate;

@end

@implementation HomeView
@synthesize CategoriesTableView,MenuView,HeaderScroll,PageControll;
@synthesize CartNotification_LBL,SearhBR;
@synthesize Pagecontrollypos,Pagecontrollhight;

- (BOOL)prefersStatusBarHidden
{
     return NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        [CartNotification_LBL setHidden:NO];
        CartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    }
    else
    {
        [CartNotification_LBL setHidden:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    SearhBR.hidden=YES;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];

    
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    
    UINib *nib = [UINib nibWithNibName:@"CategoriesCell" bundle:nil];
    CategoriesCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CategoriesTableView.rowHeight = cell.frame.size.height;
    [CategoriesTableView registerNib:nib forCellReuseIdentifier:@"CategoriesCell"];
    
    CheckMenuBool=1;
    
    [cell.AboutLable setHidden:YES];
    
    
    self.MenuView.layer.masksToBounds = NO;
    self.MenuView.layer.shadowOffset = CGSizeMake(0, 1);
    self.MenuView.layer.shadowOpacity = 0.5;
    
    NSString * htmlString = @"<html><body><h3><center>Welcome to Mirch Masala Indian Takeaway</center></h3><br><span>Situated in Pensnett, the Mirch Masala Indian Takeaway offers mouth-watering Indian cuisine.</span></br><br>The Mirch Masala Indian Takeaway is renowned throughout the Pensnett and Dudley area for its divine style and presentation of traditional Indian cuisine, this is achieved by paying special attention to every fine detail and only using the very finest ingredients.</br><br>If you looking for the most exquisite Indian food in the Pensnett and Dudley area, then take a look and order from our easy to use on screen menu, you will see that we offer something for every member of your family. Our on-line menu is fully customisable, so why give it a try! If your favourite meal is not on our menu just call 01384 78007 to ask us, and our chef will happily try and prepare it especially for you.</br><br>Our high quality Website is provided by tiffintom.com, please be sure to visit our website on a regular basis to see our latest menu updates.\n We deliver on all online orders to following postcods DY1 DY2 DY3 DY5 DY4 DY6 DY8 B69 plus more also Pensenett Dudley and Brierley hill</br></body></html>";
    AboutMessage = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    
    // Call Category List
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CategoriesList];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    [self SetheaderScroll];
}

-(void)SetheaderScroll
{
    int x=0;
    for (int i=0; i<3; i++)
    {
        Headerimg=[[UIImageView alloc]initWithFrame:CGRectMake(x, -20, SCREEN_WIDTH, 260)];
        Headerimg.image=[UIImage imageNamed:@"HomeLogo"];
        [HeaderScroll addSubview:Headerimg];
        
        x=x+SCREEN_WIDTH;
    }
    
    [HeaderScroll setContentSize:CGSizeMake(x, 130)];
    PageControll.numberOfPages =3;
    PageControll.currentPage = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if([sender isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    if (sender==HeaderScroll)
    {
        CGFloat pageWidth = HeaderScroll.frame.size.width;
        float fractionalPage = HeaderScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        PageControll.currentPage = page;
    }
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
             
             Searchdic =[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"result"] objectForKey:@"topCategories"] mutableCopy];
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
        cell.TitleLable.hidden=YES;
        cell.ArrowImageVW.hidden=YES;
        cell.AboutLable.attributedText=AboutMessage;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (CheckMenuBool==1)
    {
        SubItemView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SubItemView"];
        vcr.CategoryId=[[topCategoriesDic valueForKey:@"id"] objectAtIndex:indexPath.section];
        vcr.categoryName=[[topCategoriesDic valueForKey:@"categoryName"] objectAtIndex:indexPath.section];
        [self.navigationController pushViewController:vcr animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (CheckMenuBool!=1)
    {
        return 400;
    }
    return 44;
    
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction)TopBarCartBtn_action:(id)sender
{
    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)NavtoggleBtn_action:(id)sender
{
    [self.rootNav drawerToggle];

}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}

#pragma mark - SerachBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    Pagecontrollypos.constant=160;
    Pagecontrollhight.constant=37;
    HeaderScroll.hidden=NO;
    SearhBR.hidden=YES;

    topCategoriesDic=[Searchdic mutableCopy];
    [SearhBR resignFirstResponder];
    [CategoriesTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    Pagecontrollypos.constant=0;
    Pagecontrollhight.constant=0;
    HeaderScroll.hidden=YES;
    
    SearhBR.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [CategoriesTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
     topCategoriesDic=[Searchdic mutableCopy];
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        topCategoriesDic=[Searchdic mutableCopy];
        [CategoriesTableView reloadData];
        return;
    }
    
   NSMutableArray *resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in topCategoriesDic)
    {
        NSString *wineName = [wine objectForKey:@"categoryName"];
        NSRange range = [wineName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    topCategoriesDic=[resultObjectsArray mutableCopy];
    [CategoriesTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    topCategoriesDic=[Searchdic mutableCopy];
    if([searchBar.text isEqualToString:@""] || searchBar.text==nil)
    {
        topCategoriesDic=[Searchdic mutableCopy];
        [CategoriesTableView reloadData];
        return;
    }
   NSMutableArray *resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in topCategoriesDic)
    {
        NSString *wineName = [wine objectForKey:@"categoryName"];
        NSRange range = [wineName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    topCategoriesDic=[resultObjectsArray mutableCopy];
    [CategoriesTableView reloadData];
    [SearhBR resignFirstResponder];
}

- (IBAction)Search_Click:(id)sender
{
    SearhBR.hidden=NO;
    SearhBR.text=@"";
    [SearhBR becomeFirstResponder];
}
@end
