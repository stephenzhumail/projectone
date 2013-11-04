//
//  WTTableViewController.m
//  Telenor OSE
//
//  Created by StephenZhu on 13-10-18.
//  Copyright (c) 2013年 StephenZhu. All rights reserved.
//

#import "WTTableViewController.h"
#import "WTAppDelegate.h"
#import "ZipArchive.H"
@interface WTTableViewController ()

@end

@implementation WTTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[USER_DEFAULT valueForKey:@"HTML"]count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    static NSString *CellIdentifier = @"AccountSearchCell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }

    if (indexPath.row == [[USER_DEFAULT valueForKey:@"HTML"]count]) {
        cell.textLabel.text  = @"Click here to add antoher demo!";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.textLabel.text = [[[USER_DEFAULT valueForKey:@"HTML"]objectAtIndex:indexPath.row]valueForKey:@"SHOWNAME"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[USER_DEFAULT valueForKey:@"HTML"]count]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add a new one" message:@"input link address and remark" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        tfurl = [alertView textFieldAtIndex:0];
        tfurl.placeholder = @"link address of zip file";
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:USERNAME])
//        {
//            loginName.text = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
//        }
        tfflodername = [alertView textFieldAtIndex:1];
        tfflodername.placeholder = @"remark";
        [alertView show];
    }
    else
    {
        [[WTAppDelegate appDelegate]showssss:[[[USER_DEFAULT valueForKey:@"HTML"]objectAtIndex:indexPath.row]valueForKey:@"SHOWNAME"]];
    }
    
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *sqliteDataPathOld = [documentsDirectory stringByAppendingPathComponent:tfflodername.text];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isdir = YES;
        if ([fileManager fileExistsAtPath:sqliteDataPathOld isDirectory:&isdir]) {
            {
                showErroMsg(@"已存在");
            }}
        else
        {
            [fileManager createDirectoryAtPath:sqliteDataPathOld withIntermediateDirectories:YES attributes:@{NSFilePosixPermissions : [NSNumber numberWithUnsignedLong:511]} error:nil];
            MBProgressHUD *hudProgress = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
            [self.view.window addSubview:hudProgress];
            [self.view.window bringSubviewToFront:hudProgress];
            //        hudProgress.delegate = self;
            hudProgress.labelText = @"加载中...";
            
            
            [hudProgress showAnimated:YES whileExecutingBlock:^{
                NSData *date = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:tfurl.text]];
                
                [date writeToFile:[NSString stringWithFormat:@"%@/a.zip",sqliteDataPathOld] atomically:YES];
                
                ZipArchive *unzip = [[ZipArchive alloc] init];
                if ([unzip UnzipOpenFile:[NSString stringWithFormat:@"%@/a.zip",sqliteDataPathOld]]) {
                    BOOL result = [unzip UnzipFileTo:[NSString stringWithFormat:@"%@",sqliteDataPathOld] overWrite:YES];
                    if (result) {
                        NSLog(@"unzip successfully");
                        isgoodzip = YES;
                    }
                    else
                    {
                        isgoodzip = NO;
                    }
                    [unzip UnzipCloseFile];
                }
                unzip = nil;
                
            }completionBlock:^{
                if (!isgoodzip) {
                    showErroMsg(@"链接错误");
                    return ;
                }
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:tfflodername.text,@"SHOWNAME", nil];
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[USER_DEFAULT valueForKey:@"HTML"]];
                [array addObject:dic];
                [USER_DEFAULT setValue:array forKey:@"HTML"];
                [USER_DEFAULT synchronize];
                [self.tableView reloadData];
                NSLog(@"haole");
            }];
            
        }
    }
            
        
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
