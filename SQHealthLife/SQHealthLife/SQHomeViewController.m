//
//  SQHomeViewController.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/5/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import "SQHomeViewController.h"
#import "SQDataCenter.h"
#import "HLDocumentReaderViewController.h"

@interface SQHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSDictionary * articles;

@end

@implementation SQHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = NSLocalizedString(@"Articles", @"Articles");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.articles = [NSDictionary dictionaryWithContentsOfFile:[[SQDataCenter shareDataCenter] articlesFullPath]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_articles release];
    [_tableView release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.articles allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier] autorelease];
    }
    cell.textLabel.text = [[self.articles allKeys] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView.visibleCells objectAtIndex:indexPath.row];
    HLDocumentReaderViewController *readerViewController = [[[HLDocumentReaderViewController alloc] init] autorelease];
    readerViewController.document = [NSDictionary dictionaryWithObject:[self.articles objectForKey:cell.textLabel.text] forKey:cell.textLabel.text];
    readerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readerViewController animated:YES];
}
@end
