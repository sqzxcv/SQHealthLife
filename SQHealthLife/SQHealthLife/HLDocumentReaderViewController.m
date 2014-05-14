//
//  HLDocumentReaderViewController.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/10/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import "HLDocumentReaderViewController.h"

@interface HLDocumentReaderViewController ()

@end

@implementation HLDocumentReaderViewController

#pragma mark - default method

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [[self.document allKeys] lastObject];
    self.textView.text = [[self.document allValues] lastObject];
    UIBarButtonItem *keepBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Keep", @"Keep") style:UIBarButtonItemStyleBordered target:self action:@selector(keepDocuments:)] autorelease];
    UIBarButtonItem *goodBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Good", @"Good") style:UIBarButtonItemStyleBordered target:self action:@selector(goodDocument:)] autorelease];
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *fixedSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    fixedSpace.width = 10;
    self.toolbarItems = @[fixedSpace, keepBtn, flexibleSpace, goodBtn, fixedSpace];
    self.navigationController.toolbarHidden = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    [_document release];
    [_textView release];
    [super dealloc];
}

#pragma mark - Actions method

- (void) keepDocuments:(id) sender
{
    
}

- (void) goodDocument:(id) sender
{
    
}

@end
