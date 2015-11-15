//
//  SettingsViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-12-25.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChangePwdViewController.h"
#import "ChangeSkinController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)okBtnClick
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"取消"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(okBtnClick)];
    self.navigationItem.rightBarButtonItem = commitButton;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
   
  
    
    NSArray *ary = [NSArray arrayWithObjects:@"密码修改",@"更换界面主题",  nil];
    cell.textLabel.text =[ary objectAtIndex:indexPath.section];
    if(indexPath.section == 0)
        cell.imageView.image = [UIImage imageNamed:@"change_password.png"];
    else
        cell.imageView.image = [UIImage imageNamed:@"change_theme.png"];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (indexPath.section == 0) {
        ChangePwdViewController *controller = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
         ChangeSkinController*controller = [[ChangeSkinController alloc] initWithNibName:@"ChangeSkinController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
