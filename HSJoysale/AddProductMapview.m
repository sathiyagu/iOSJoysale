//
//  AddProductMapview.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 28/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
/*
 * When add product we need to select location for posting product
 */

#import "AddProductMapview.h"
#import "AppDelegate.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

@interface AddProductMapview ()<UISearchBarDelegate>

@end

@implementation AddProductMapview
@synthesize addProductmapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Class initialization.
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    //Variable / Functionality
    choosedDataArray = [[NSMutableArray alloc]init];
    if([[delegate.postProductArray objectAtIndex:10] isEqualToString:@""]){
        [choosedDataArray addObject:[NSString stringWithFormat:@"%0.f",delegate.currentlatitude]];
        [choosedDataArray addObject:[NSString stringWithFormat:@"%0.f",delegate.currentlongitude]];
        [choosedDataArray addObject:[delegate.postProductArray objectAtIndex:7]];
    }else{
        [choosedDataArray addObject:[delegate.postProductArray objectAtIndex:10]];
        [choosedDataArray addObject:[delegate.postProductArray objectAtIndex:11]];
        [choosedDataArray addObject:[delegate.postProductArray objectAtIndex:7]];
    }
    
    //Properties
    
    [FilterView setFrame:CGRectMake(0, 0, delegate.windowWidth, delegate.windowHeight-60)];
    
    [mapPinImageView setImage:[UIImage imageNamed:@"locationGreen.png"]];
    [mapPinImageView setContentMode:UIViewContentModeScaleAspectFit];
    [mapPinImageView bringSubviewToFront:ResignSearchBarTextBtn];
    [self.view addSubview:mapPinImageView];
    [self.addProductmapView setHidden:YES];
    [currentLocationButton setBackgroundColor:AppThemeColor];
    [RemoveLocationButton setTitleColor:AppThemeColor forState:UIControlStateNormal];
    
    locationBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, delegate.windowHeight-124,delegate.windowWidth, 60)];
   // [RemoveLocationButton setFrame:CGRectMake(5, 10, (delegate.windowWidth/2)-7.5, 40)];
    [currentLocationButton setFrame:CGRectMake(5, 10, delegate.windowWidth-10, 40)];
    [locationBtnView setBackgroundColor:whitecolor];
    [locationBtnView addSubview:currentLocationButton];
    //[locationBtnView addSubview:RemoveLocationButton];
    
    [currentLocationButton setTitle:[delegate.languageDict objectForKey:@"set_location"] forState:UIControlStateNormal];
    [RemoveLocationButton setTitle:[delegate.languageDict objectForKey:@"remove_location"] forState:UIControlStateNormal];
    
    locationBtnView.layer.masksToBounds = NO;
    
    searchBarSearchButton = [[[UISearchBar alloc]init]autorelease];
    for (UIView * view in searchBarSearchButton.subviews)
    {
        if ([view isKindOfClass:NSClassFromString (@"UISearchBarBackground")])
        {
            [view removeFromSuperview];
            break;
        }
    }
    searchBarSearchButton.barTintColor = [UIColor whiteColor];
    
    for (UIView *searchBarSubview in [searchBarSearchButton subviews]) {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                [(UITextField *)searchBarSubview setBorderStyle:UITextBorderStyleNone];
            }
            @catch (NSException * e) {
            }
        }
    }
    
    searchbarmainView= [[UIView alloc] initWithFrame:CGRectMake(10,15,delegate.windowWidth-20,37)];
    searchbarView = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.windowWidth-20,37)];
    [searchBarSearchButton setDelegate:self];
    [searchbarView setBackgroundColor:whitecolor];
    [searchBarSearchButton setFrame:CGRectMake(-8,-1,searchbarView.frame.size.width+16,39)];
    [searchBarSearchButton setPlaceholder:[delegate.languageDict objectForKey:@"search"]];
    searchBarSearchButton.layer.masksToBounds=YES;
    UITextField *textfield=(UITextField*)[[searchBarSearchButton subviews] objectAtIndex:0];
    //    [textfield setFrame:CGRectMake(0,0,searchbarView.frame.size.width-10,37)];
    
    
    [textfield setBackgroundColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
                                                                                                 NSFontAttributeName: [UIFont fontWithName:appFontRegular size:16],
                                                                                                 }];
    [searchbarView addSubview:searchBarSearchButton];
    searchbarView.layer.cornerRadius=5;
    searchbarmainView.layer.shadowColor = whitecolor.CGColor;
    searchbarmainView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    searchbarmainView.layer.shadowRadius = 2.0;
    searchbarmainView.layer.shadowOpacity = 0.5;
    searchbarView.layer.masksToBounds = YES;
    [searchbarmainView addSubview:searchbarView];
    
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 100.0;
    
    [autocompleteView setFrame:CGRectMake(10,searchbarView.frame.origin.y+searchbarView.frame.size.height+20,delegate.windowWidth-20,autocompleteView.frame.size.height)];
    autocompleteView.layer.cornerRadius=5;
    [autocompleteView setBackgroundColor:[UIColor clearColor]];
    autocompleteView.layer.masksToBounds=YES;
    [autocompleteTableView setFrame:CGRectMake(0,0,autocompleteView.frame.size.width,autocompleteView.frame.size.height)];
    [autocompleteView setHidden:YES];
    [autocompleteTableView setTag:100];
    
    [ResignSearchBarTextBtn setHidden:YES];
    ResignSearchBarTextBtn.layer.masksToBounds=YES;
    
    [self.view addSubview:searchbarmainView];
    [self.view addSubview:locationBtnView];
    [self.view bringSubviewToFront:locationBtnView];
    
    //function call
    
    [self settingFrames];
    [self performSelectorOnMainThread:@selector(setRegionForMap) withObject:nil waitUntilDone:YES];
    [self barButtonFunction];
}
#pragma mark - for backNavigation
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark view appear
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}
-(void) viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];

    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [delegate.tabViewControllerObj.tabBarController hideNewTabBar];

}

#pragma mark setFrames

-(void) settingFrames
{
    [filterMapView setFrame:CGRectMake(0,0,delegate.windowWidth,delegate.windowHeight-115)];
    [mapPinImageView setFrame:CGRectMake((delegate.windowWidth/2)-20,(filterMapView.frame.size.height/2)-20,40,40)];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor lightGrayColor]];
    searchBarSearchButton.barTintColor = [UIColor whiteColor];
    RemoveLocationButton.layer.borderWidth = 1;
    RemoveLocationButton.layer.borderColor = AppThemeColor.CGColor;
    RemoveLocationButton.layer.cornerRadius=4;
    currentLocationButton.layer.borderWidth = 1;
    currentLocationButton.layer.borderColor = AppThemeColor.CGColor;
    currentLocationButton.layer.cornerRadius=4;
    RemoveLocationButton.layer.masksToBounds=YES;
    currentLocationButton.layer.masksToBounds=YES;
    
    [currentLocationButton.titleLabel setFont:ButtonFont];
    [RemoveLocationButton.titleLabel setFont:ButtonFont];

}

#pragma mark - Navigation View

-(void) barButtonFunction
{
    UIView * leftNaviNaviButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,delegate.windowWidth, 44)];
    [leftNaviNaviButtonView setBackgroundColor:AppThemeColor];
    UIBarButtonItem * negativeSpacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]autorelease];
    if (isAboveiOSVersion7)
    {
        negativeSpacer.width = -20;
    }
    else
    {
        negativeSpacer.width = -10;
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setTag:1000];
    [backBtn setFrame:CGRectMake(0+[HSUtility adjustablePadding],2,45,40)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftNaviNaviButtonView addSubview:backBtn];
    
    UILabel * titleLabel = [[[UILabel alloc]init]autorelease];
    [titleLabel setText:[delegate.languageDict objectForKey:@"change_location"]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:appFontRegular size:20]];
    [titleLabel setFrame:CGRectMake(50+[HSUtility adjustablePadding],7,delegate.windowWidth-100,30)];
    [leftNaviNaviButtonView addSubview:titleLabel];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,[[[UIBarButtonItem alloc] initWithCustomView:leftNaviNaviButtonView]autorelease], nil]];
    [leftNaviNaviButtonView release];
}

#pragma mark Back button Action

-(void)backBtnClicked
{
    [self.tabBarController.tabBar setHidden:NO];
    [delegate.tabViewControllerObj.tabBarController showNewTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LocationManager

-(void) setRegionForMap
{
    float lat;
    float log;
    if ([[choosedDataArray objectAtIndex:0]isEqualToString:@""])
    {
        lat = delegate.currentlatitude;
        log = delegate.currentlongitude;
    }
    else
    {
        lat = [[choosedDataArray objectAtIndex:0]floatValue];
        log = [[choosedDataArray objectAtIndex:1]floatValue];
    }
    
    [choosedDataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",lat]];
    [choosedDataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",log]];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat,log);
    filterMapView.centerCoordinate =coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(1, 1));
    region.span.longitudeDelta = 0.005f;
    region.span.latitudeDelta = 0.005f;
    [filterMapView setRegion:region animated:NO];
    [filterMapView setNeedsDisplay];
}

-(void) getLocationnonvoid
{
    locationManager=[[CLLocationManager alloc] init];
    if(IS_OS_8_OR_LATER)
    {
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        else
        {
            [locationManager requestAlwaysAuthorization];
        }
    }
    [locationManager setDelegate:self];
    locationManager.distanceFilter = 100.0; //whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D location=newLocation.coordinate;
    if ([[choosedDataArray objectAtIndex:1]floatValue]==0)
    {
        [choosedDataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",location.latitude]];
        [choosedDataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",location.longitude]];
        [self performSelectorOnMainThread:@selector(getLocationName) withObject:nil waitUntilDone:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations == nil)
        return;
    CLLocation *location = [manager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    if ([[choosedDataArray objectAtIndex:1]floatValue]==0)
    {
        [choosedDataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",coordinate.latitude]];
        [choosedDataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",coordinate.longitude]];
        [self performSelectorOnMainThread:@selector(getLocationName) withObject:nil waitUntilDone:YES];
    }
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if ([[NSString stringWithFormat:@"%.0f",mapView.centerCoordinate.longitude]isEqualToString:@"-40"])
    {
        regionWillChangeAnimatedCalled = NO;
        if ([[NSString stringWithFormat:@"%.0f",mapView.centerCoordinate.latitude]isEqualToString:[NSString stringWithFormat:@"%.0f",[[choosedDataArray objectAtIndex:0]floatValue]]])
        {
            regionWillChangeAnimatedCalled = YES;
        }
    }
    else
    {
        regionWillChangeAnimatedCalled = YES;
    }
    if (regionWillChangeAnimatedCalled)
    {
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
        [choosedDataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",mapView.centerCoordinate.latitude]];
        [choosedDataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",mapView.centerCoordinate.longitude]];
        [ceo reverseGeocodeLocation:loc
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      CLPlacemark *placemark = [placemarks objectAtIndex:0];
                      NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
                      if (locatedAt!=NULL)
                      {
                          [choosedDataArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",locatedAt]];
                      }
                  }
         ];
    }
}

-(void) getLocationName
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[choosedDataArray objectAtIndex:0]floatValue] longitude:[[choosedDataArray objectAtIndex:1]floatValue]];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
                  if (locatedAt!=NULL)
                  {
                      [choosedDataArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",locatedAt]];
                      float lat;
                      float log;
                      lat = [[choosedDataArray objectAtIndex:0]floatValue];
                      log = [[choosedDataArray objectAtIndex:1]floatValue];
                      [choosedDataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",lat]];
                      [choosedDataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",log]];
                      CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat,log);
                      filterMapView.centerCoordinate =coordinate;
                      MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(1, 1));
                      region.span.longitudeDelta = 0.005f;
                      region.span.latitudeDelta = 0.005f;
                      [filterMapView setRegion:region animated:YES];
                      [filterMapView setNeedsDisplay];
                  }
              }
     ];
}
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@&language=%@", esc_addr,[delegate.languageSelected substringToIndex:2]];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    return center;
}

#pragma  mark - search bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [ResignSearchBarTextBtn setHidden:NO];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [ResignSearchBarTextBtn setHidden:YES];
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        region.center = [(CLCircularRegion *)placemark.region center];
        MKCoordinateSpan span;
        double radius = [(CLCircularRegion*)placemark.region radius] / 1000; // convert to km
        span.latitudeDelta = radius / 112.0;
        region.span = span;
        region.span.longitudeDelta = 0.005f;
        region.span.latitudeDelta = 0.005f;
        [autocompleteView setHidden:YES];
        [filterMapView setRegion:region animated:YES];
    }];
}

- (void)handleSearchForSearchString:(NSString *)searchString
{
    if (searchString.length!=0)
    {
        searchQuery.location = self.addProductmapView.userLocation.coordinate;
        searchQuery.input = searchString;
        [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
            if (error)
            {
            } else {
                autocompleteTableView.tag=100;
                [searchResultPlaces release];
                searchResultPlaces = [places retain];
                [autocompleteTableView reloadData];
                if(!searchBarSearchButton.isFocused){
                    [autocompleteView setHidden:NO];
                }else{
                    [autocompleteView setHidden:YES];
                }
            }
        }];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    [ResignSearchBarTextBtn setHidden:YES];
    [autocompleteView setHidden:YES];
    [aSearchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length <= 1)
    {
        [autocompleteView setHidden:YES];
    }
    else
    {
        [self handleSearchForSearchString:[NSString stringWithFormat:@"%@",searchText ]];
        [autocompleteView setHidden:NO];
        autocompleteTableView.hidden = NO;
    }
    
}
- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(int)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath];
}

#pragma mark - Button action
#pragma mark set location

-(void) saveBtnTapped
{
    if([[choosedDataArray objectAtIndex:0] intValue]==0){
        [choosedDataArray replaceObjectAtIndex:0 withObject:@""];
        [choosedDataArray replaceObjectAtIndex:1 withObject:@"0"];
        [choosedDataArray replaceObjectAtIndex:1 withObject:@"WorldWide"];
    }
    [[NSUserDefaults standardUserDefaults]setObject:choosedDataArray forKey:@"addchoosedDataArray"];
    [delegate.postProductArray replaceObjectAtIndex:10 withObject:[choosedDataArray objectAtIndex:0]];
    [delegate.postProductArray replaceObjectAtIndex:11 withObject:[choosedDataArray objectAtIndex:1]];
//    [delegate.postProductArray replaceObjectAtIndex:7 withObject:[choosedDataArray objectAtIndex:2]];
//    [delegate.mapLocationArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",[choosedDataArray objectAtIndex:0]]];
//    [delegate.mapLocationArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",[choosedDataArray objectAtIndex:1]]];
//    [delegate.mapLocationArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",[choosedDataArray objectAtIndex:2]]];
//    [delegate.mapLocationArray replaceObjectAtIndex:6 withObject:@"setLocation"];
  //  [[NSUserDefaults standardUserDefaults]  setValue:delegate.mapLocationArray forKey:@"location"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark go to current location

- (IBAction)LocationBtnTapped:(id)sender {
    if (delegate.currentlatitude!=0)
    {
        [choosedDataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",delegate.currentlatitude]];
        [choosedDataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",delegate.currentlongitude]];
        [self performSelectorOnMainThread:@selector(getLocationName) withObject:nil waitUntilDone:YES];
    }
    else
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if(status==2){
            [delegate requestWhenInUseAuthorization];
        }else{
            [delegate getLocationnonvoid];
            if (delegate.currentlatitude!=0)
            {
                [choosedDataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",delegate.currentlatitude]];
                [choosedDataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",delegate.currentlongitude]];
                [self performSelectorOnMainThread:@selector(getLocationName) withObject:nil waitUntilDone:YES];
            }
        }
    }
}

#pragma mark Save location

-(IBAction)currentLocationBtnTapped:(id)sender
{
    [self saveBtnTapped];
}


-(IBAction)RemoveLocationBtnTapped:(id)sender
{
    
}
#pragma mark resign search bar keypad

- (IBAction)ResignSearchBarTextBtnTapped:(id)sender {
    [searchBarSearchButton resignFirstResponder];
}

#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    /**** it is show the auto complete location ****/
    if (tableView.tag==100)
    {
        [cell.textLabel setFont:[UIFont fontWithName:appFontRegular size:14]];
        [cell.textLabel setText:[self placeAtIndexPath:(int)indexPath.row].name];
    }
    return cell;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBarSearchButton setText:[self placeAtIndexPath:(int)indexPath.row].name];
    [autocompleteView setHidden:YES];
    [self getLocationFromAddressString:[self placeAtIndexPath:(int)indexPath.row].name];
}


#pragma  mark - Dealloc and memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    //    [currentLocationButton release];
    //    [searchBarSearchButton release];
    [LocationBtn release];
    [FilterView release];
    [ResignSearchBarTextBtn release];
    [super dealloc];
}
@end
