//
//  SQMineViewController.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/5/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import "SQMineViewController.h"
#import "HLScoreViewController.h"
#import "HLMyFavoritesViewController.h"

@interface SQMineViewController ()
<UITableViewDataSource,
UITableViewDelegate>
{
    
}
@property (retain, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation SQMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = NSLocalizedString(@"Mine", @"Mine");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableview release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Mine", @"Mine");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier] autorelease];
    }
    if (0 == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"MineScores", @"");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"MyBookMark", @"");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.section)
    {
        switch (indexPath.row)
        {
                // score view
            case 0:
            {
                HLScoreViewController *scoreViewController = [[[HLScoreViewController alloc] init] autorelease];
                scoreViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scoreViewController animated:YES];
                break;
            }
                // favorite.
            case 1:
            {
                HLMyFavoritesViewController *favoriteViewController = [[[HLMyFavoritesViewController alloc] init] autorelease];
                favoriteViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:favoriteViewController animated:YES];
//                [favoriteViewController release];
                break;
            }
            default:
                break;
        }
    }
}


@end
