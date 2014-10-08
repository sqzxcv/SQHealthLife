//
//  HLImageBrowserViewController.m
//  SQHealthLife
//
//  Created by ShengQiang on 5/31/14.
//  Copyright (c) 2014 SQ. All rights reserved.
//

#import "HLImageBrowserViewController.h"
#import "iCarousel.h"
#import "SQDataCenter.h"

@interface HLImageBrowserViewController()
<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, retain) iCarousel *carouseView;

@end


@implementation HLImageBrowserViewController

- (void)dealloc
{
    [_item release];
    [_carouseView release];
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = self.item[@"title"];
    self.carouseView = [[iCarousel alloc] init];
    self.carouseView.dataSource = self;
    self.carouseView.delegate = self;
    [self.view addSubview:self.carouseView];
    self.view.backgroundColor = [UIColor blackColor];
    UIView *selfview = self.view;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_carouseView, selfview);
    NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_carouseView]|"
                                                           options:0
                                                           metrics:nil
                                                             views:viewsDict];
    arr = [arr arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_carouseView]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:viewsDict]];

    
    self.carouseView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:arr];
    
    if ([self.item[kResourceType] isEqualToString:kResourceSeedType])
    {
        UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        UIBarButtonItem *downloadbtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Download", @"Download") style:UIBarButtonItemStyleBordered target:self action:@selector(downloadSeedFile:)] autorelease];
        self.toolbarItems = @[flexibleSpace, downloadbtn, flexibleSpace];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (0 != [self.toolbarItems count])
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void) downloadSeedFile:(id) sender
{
    
}

#pragma mark - iCarouselDataSource, iCarouselDelegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSArray *images = self.item[kResourceFilesTypeImages];
    return [images count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    NSArray *images = self.item[kResourceFilesTypeImages];
    NSString *imageRootPath = nil;
    if ([self.item[kResourceType] isEqualToString:kResourceSeedType])
    {
        imageRootPath = [[SQDataCenter shareDataCenter] seedsFullPath];
    }
    else if ([self.item[kResourceType] isEqualToString:kResourcePhotoType])
    {
        imageRootPath = [[SQDataCenter shareDataCenter] photosFullPath];
    }

    NSString *base64str = [NSString stringWithContentsOfFile:[imageRootPath stringByAppendingPathComponent:images[index]] encoding:NSUTF8StringEncoding error:NULL];
    NSData *base64 = [base64str dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *image = [[[UIImage alloc] initWithData:[base64 base64Decoded]] autorelease];
    UIView *view = [[[UIImageView alloc] initWithImage:image] autorelease];
    view.frame = CGRectMake(70, 80, 180, 260);
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    NSArray *images = self.item[kResourceFilesTypeImages];
    return [images count];;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 200;
}

//- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
//{
//    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
//    
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = self.carousel.perspective;
//    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
//    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
//}
//
//- (BOOL)carouselShouldWrap:(iCarousel *)carousel
//{
//    return wrap;
//}

@end
