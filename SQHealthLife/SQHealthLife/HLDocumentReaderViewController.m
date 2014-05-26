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
    self.title = [self.document objectForKey:kResourceTitle];
    self.textView.text = [self.document objectForKey:kResourceContent];
    
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *fixedSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    fixedSpace.width = 10;
    BOOL exist = NO;
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteArticlesUserDefaultKey];
    for (NSDictionary *document in arr)
    {
        if (YES == [self.document[kResourceID] isEqualToString:document[kResourceID]])
        {
            exist = YES;
            break;
        }
    }
    if (NO == exist)
    {
        UIBarButtonItem *keepBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Favorite", @"Favorite") style:UIBarButtonItemStyleBordered target:self action:@selector(favoriteDocuments:)] autorelease];
        UIBarButtonItem *goodBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Good", @"Good") style:UIBarButtonItemStyleBordered target:self action:@selector(goodDocument:)] autorelease];
        self.toolbarItems = @[fixedSpace, keepBtn, flexibleSpace, goodBtn, fixedSpace];
    }
    else
    {
        UIBarButtonItem *keepBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel Favorite", @"Cancel Favorite") style:UIBarButtonItemStyleBordered target:self action:@selector(deleteFromFavoriteDocuments:)] autorelease];
        UIBarButtonItem *goodBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Good", @"Good") style:UIBarButtonItemStyleBordered target:self action:@selector(goodDocument:)] autorelease];
        self.toolbarItems = @[fixedSpace, keepBtn, flexibleSpace, goodBtn, fixedSpace];
    }
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
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

- (void) deleteFromFavoriteDocuments:(id) sender
{
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *fixedSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    fixedSpace.width = 10;
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteArticlesUserDefaultKey];
    NSDictionary *currentDoc = nil;
    for (NSDictionary *document in arr)
    {
        if (YES == [self.document[kResourceID] isEqualToString:document[kResourceID]])
        {
            currentDoc = document;
            break;
        }
    }
    if (nil != currentDoc)
    {
        NSMutableArray *arrDoc = [NSMutableArray arrayWithArray:arr];
        [arrDoc removeObject:currentDoc];
        [[NSUserDefaults standardUserDefaults] setObject:arrDoc forKey:kFavoriteArticlesUserDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIBarButtonItem *keepBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel Favorite", @"Cancel Favorite") style:UIBarButtonItemStyleBordered target:self action:@selector(deleteFromFavoriteDocuments:)] autorelease];
        UIBarButtonItem *goodBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Good", @"Good") style:UIBarButtonItemStyleBordered target:self action:@selector(goodDocument:)] autorelease];
        self.toolbarItems = @[fixedSpace, keepBtn, flexibleSpace, goodBtn, fixedSpace];
    }
}

- (void) favoriteDocuments:(id) sender
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteArticlesUserDefaultKey];
    if (nil == arr)
    {
        arr = [NSArray arrayWithObject:self.document];
    }
    else
    {
        arr = [arr arrayByAddingObject:self.document];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:kFavoriteArticlesUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIBarButtonItem *keepBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel Favorite", @"Cancel Favorite") style:UIBarButtonItemStyleBordered target:self action:@selector(deleteFromFavoriteDocuments:)] autorelease];
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    self.toolbarItems = @[flexibleSpace, keepBtn, flexibleSpace];
}

- (void) goodDocument:(id) sender
{
    
}

@end
