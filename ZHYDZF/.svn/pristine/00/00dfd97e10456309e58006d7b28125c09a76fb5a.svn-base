//
//  PersonChooseVC.m
//  BoandaProject
//
//  Created by 张仁松 on 13-10-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PersonChooseVC.h"

@interface PersonChooseVC ()
@property(nonatomic,strong)NSArray *aryDeparts;
@property(nonatomic,strong)NSArray *aryUsers;

@end

@implementation PersonChooseVC
@synthesize aryDeparts,aryUsers,multiUsers,parentBMBH,delegate,aryChoosedPersons;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        usersHelper = [[UsersHelper alloc] init];
        
    }
    return self;
}

-(void)okBtnPressed:(id)sender{
    [delegate personChoosed:aryChoosedPersons];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(multiUsers){
        UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(okBtnPressed:)];
        
        self.navigationItem.rightBarButtonItem = commitButton;
        
    }
    if ([parentBMBH length] <= 0 || [parentBMBH isEqualToString:@"ROOT"]) {
        self.aryChoosedPersons = [NSMutableArray arrayWithCapacity:3];
        self.aryDeparts = [usersHelper queryAllRootDept];
        self.aryUsers = [usersHelper queryAllUsers:@"ROOT"];
        NSLog(@"---1");
    }else{
        self.aryDeparts = [usersHelper queryAllSubDept:parentBMBH];
        self.aryUsers = [usersHelper queryAllUsers:parentBMBH];
        NSLog(@"---2");
    }
    NSLog(@"----%@",self.aryUsers);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) 
        return [aryDeparts count];
    else 
        return [aryUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
  //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [[aryDeparts objectAtIndex:indexPath.row] objectForKey:@"ZZQC"];
        cell.imageView.image = [UIImage imageNamed:@"depart"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.textLabel.text = [[aryUsers objectAtIndex:indexPath.row] objectForKey:@"YHMC"];
        cell.imageView.image = [UIImage imageNamed:@"user"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *curUserID = [[aryUsers objectAtIndex:indexPath.row] objectForKey:@"YHID"];
        for(NSDictionary *dicItem in aryChoosedPersons){
            if([[dicItem objectForKey:@"YHID"] isEqualToString:curUserID]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (count == 0) {
        
        count ++;
        if ([(id)delegate respondsToSelector:@selector(getBMMC:)]) {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [delegate getBMMC:cell.textLabel.text];
        }
    }*/
    // Navigation logic may go here. Create and push another view controller.
    if (indexPath.section == 0) {
        
        if ([(id)delegate respondsToSelector:@selector(getBMMC:)]) {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [delegate getBMMC:cell.textLabel.text];
        }
        PersonChooseVC *controller = [[PersonChooseVC alloc] initWithStyle:UITableViewStyleGrouped];
        controller.aryChoosedPersons = aryChoosedPersons;
        controller.multiUsers = multiUsers;
        controller.parentBMBH = [[aryDeparts objectAtIndex:indexPath.row] objectForKey:@"ZZBH"];
        controller.delegate = delegate;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        if (multiUsers) {
            if([aryChoosedPersons containsObject:[aryUsers objectAtIndex:indexPath.row]])
            {
                [aryChoosedPersons removeObject:[aryUsers objectAtIndex:indexPath.row]];
            }
            else{
                [aryChoosedPersons addObject:[aryUsers objectAtIndex:indexPath.row]];
            }
            [tableView reloadData];
        }else{
            [delegate personChoosed:aryChoosedPersons];
        }
    }
}

@end
