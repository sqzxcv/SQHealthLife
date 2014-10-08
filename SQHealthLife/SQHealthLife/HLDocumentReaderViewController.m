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
    NSDictionary *allFavorites = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteResourcesUserDefaultKey];
    NSArray *arr = [allFavorites allValues];
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
        self.toolbarItems = @[flexibleSpace, keepBtn, flexibleSpace];

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
    NSDictionary *allFavorite = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteResourcesUserDefaultKey];
    NSArray *arr = [allFavorite allValues];
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
        NSArray *relativeKeys = [allFavorite allKeysForObject:currentDoc];
        NSMutableDictionary *resultAllFavorites = [NSMutableDictionary dictionaryWithDictionary:allFavorite];
        [resultAllFavorites removeObjectsForKeys:relativeKeys];
        [[NSUserDefaults standardUserDefaults] setObject:resultAllFavorites forKey:kFavoriteResourcesUserDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIBarButtonItem *keepBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Favorite", @"Favorite") style:UIBarButtonItemStyleBordered target:self action:@selector(favoriteDocuments:)] autorelease];
        UIBarButtonItem *goodBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Good", @"Good") style:UIBarButtonItemStyleBordered target:self action:@selector(goodDocument:)] autorelease];
        self.toolbarItems = @[fixedSpace, keepBtn, flexibleSpace, goodBtn, fixedSpace];
    }
}

- (void) favoriteDocuments:(id) sender
{
    NSDictionary *allFavorites = [[NSUserDefaults standardUserDefaults] objectForKey:kFavoriteResourcesUserDefaultKey];
    if (nil == allFavorites)
    {
        allFavorites = @{[@([[NSDate date] timeIntervalSince1970]) stringValue]: self.document};
    }
    else
    {
        NSMutableDictionary *resultFavorites = [NSMutableDictionary dictionaryWithDictionary:allFavorites];
        [resultFavorites setObject:self.document forKey:[@([[NSDate date] timeIntervalSince1970]) stringValue]];
        allFavorites = resultFavorites;
    }
    [[NSUserDefaults standardUserDefaults] setObject:allFavorites forKey:kFavoriteResourcesUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIBarButtonItem *keepBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel Favorite", @"Cancel Favorite") style:UIBarButtonItemStyleBordered target:self action:@selector(deleteFromFavoriteDocuments:)] autorelease];
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    self.toolbarItems = @[flexibleSpace, keepBtn, flexibleSpace];
}

- (void) goodDocument:(id) sender
{
    
}

@end
