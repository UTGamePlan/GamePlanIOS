//
//  UserMenuViewController.m
//
//  Created by Jeremy Hintz on 6/18/14.
//  Copyright (c) 2014 Jeremy Hintz. All rights reserved.
//

#import "GPUserMenuViewController.h"
#import "GPMapViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "GPNavigationController.h"
#import "PendingInvitesTableViewCell.h"
#import "HostingTableViewCell.h"
#import "PlaybookTableViewCell.h"
#import "Event.h"
#import "GPEventDetailViewController.h"
#import "EditEventVC.h"

@interface GPUserMenuViewController (){
    NSDictionary *events;
    NSArray *sectionTitles;
    NSArray *eventsIHostNames;
    NSArray *eventsIHostIDs;
    NSDictionary *eventsIHostDict;
    NSArray *pendingInvites;
    NSMutableDictionary *pendingInvitesDict;
    NSArray *pendingInvitesIDs;
    NSArray *playbook;
    NSMutableDictionary *playbookDict;
    NSArray *playbookIDs;
}

@end

@implementation GPUserMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        UIImage *userProfileImage;
        if([defaults objectForKey:@"pictureURL"]!=nil) {
            userProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[defaults objectForKey:@"pictureURL"]]]];
        } else {
            userProfileImage = [UIImage imageNamed:@"default_profile.jpg"];
        }
        imageView.image = userProfileImage;
        //imageView.contentMode = UIViewContentModeCenter;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = [defaults objectForKey:@"name"];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
    //initalizing arrays for tables
    
    NSMutableArray *arr = [[PFUser currentUser] objectForKey:@"EventsIHost"];
    eventsIHostDict = [arr firstObject];
    eventsIHostIDs = [eventsIHostDict allKeys];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSString *key in eventsIHostIDs) {
        Event *event = (Event *)[PFQuery getObjectOfClass:[eventsIHostDict objectForKey:key] objectId:key];
        [temp addObject:event.name];
    }
    eventsIHostNames = temp;
    
    
    arr = [[PFUser currentUser] objectForKey:@"pendingInvites"];
    pendingInvitesDict = [arr firstObject];
    pendingInvitesIDs = [pendingInvitesDict allKeys];
    temp = [[NSMutableArray alloc] init];
    for (NSString *key in pendingInvitesIDs) {
        Event *event = (Event *)[PFQuery getObjectOfClass:[pendingInvitesDict objectForKey:key] objectId:key];
        [temp addObject:event.name];
    }
    pendingInvites = temp;
    
    arr = [[PFUser currentUser] objectForKey:@"Playbook"];
    playbookDict = [arr firstObject];
    playbookIDs = [playbookDict allKeys];
    temp = [[NSMutableArray alloc] init];
    for (NSString *key in playbookIDs) {
        Event *event = (Event *)[PFQuery getObjectOfClass:[playbookDict objectForKey:key] objectId:key];
        [temp addObject:event.name];
    }
    playbook = temp;
    
    events = @{
               @"Events I am Hosting:" : eventsIHostNames,
               @"Pending Invites:" : pendingInvites,
               @"My Playbook:" : playbook
               };
    sectionTitles = @[@"Events I am Hosting:", @"Pending Invites:", @"My Playbook:"];

}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return nil;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    //label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//    
//    return view;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
//    if (sectionIndex == 0)
//        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //get eventID and class
    NSString *eventID;
    NSString *class;
    if (indexPath.section == 0) {
        eventID = [eventsIHostIDs objectAtIndex:indexPath.row];
        class = [eventsIHostDict objectForKey:eventID];
    } else if(indexPath.section == 1){
        eventID = [pendingInvitesIDs objectAtIndex:indexPath.row];
        class = [pendingInvitesDict objectForKey:eventID];
    } else {
        eventID = [playbookIDs objectAtIndex:indexPath.row];
        class = [playbookDict objectForKey:eventID];
    }
    
    //set up event view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GPEventDetailViewController *eventDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"event-details"];
    Event *event = (Event *)[PFQuery getObjectOfClass:class objectId:eventID];
    eventDetailViewController.event = event;
    eventDetailViewController.eventType = [class lowercaseString];
    eventDetailViewController.view.backgroundColor = [UIColor lightGrayColor];
    //present event view
    [self presentViewController:eventDetailViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [sectionTitles objectAtIndex:section];
    NSArray *eventsForSection = [events objectForKey:sectionTitle];
    return [eventsForSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
    UIImage *testImage = [UIImage imageNamed:@"app_icon.png"];
    if ([sectionTitle isEqualToString:@"Pending Invites:"]) {
        static NSString *simpleTableIdentifier = @"PendingInvitesTableCell";
        
        PendingInvitesTableViewCell *cell = (PendingInvitesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingInvitesTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSArray *eventsInSection = [events objectForKey:sectionTitle];
        NSString *event = [eventsInSection objectAtIndex:indexPath.row];
        cell.eventName.text = event;
        cell.thumbnailImageView.image = testImage;
        cell.yesButton.tag = indexPath.row;
        [cell.yesButton addTarget:self action:@selector(RSVPYes:) forControlEvents:UIControlEventTouchUpInside];
        cell.noButton.tag = indexPath.row;
        [cell.noButton addTarget:self action:@selector(RSVPNo:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    } else if ([sectionTitle isEqualToString:@"Events I am Hosting:"]) {
        static NSString *simpleTableIdentifier = @"HostingTableViewCell";
        
        HostingTableViewCell *cell = (HostingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HostingTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSArray *eventsInSection = [events objectForKey:sectionTitle];
        NSString *event = [eventsInSection objectAtIndex:indexPath.row];
        cell.eventName.text = event;
        cell.thumbnailImageView.image = testImage;
        
        cell.editButton.tag = indexPath.row;
        [cell.editButton addTarget:self action:@selector(editEvent:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else if ([sectionTitle isEqualToString:@"My Playbook:"]) {
        static NSString *simpleTableIdentifier = @"PlaybookTableViewCell";
        
        PlaybookTableViewCell *cell = (PlaybookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlaybookTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSArray *eventsInSection = [events objectForKey:sectionTitle];
        NSString *event = [eventsInSection objectAtIndex:indexPath.row];
        cell.eventName.text = event;
        cell.thumbnailImageView.image = testImage;
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSArray *eventsInSection = [events objectForKey:sectionTitle];
        NSString *event = [eventsInSection objectAtIndex:indexPath.row];
        cell.textLabel.text = event;
        return cell;
    }
    
}


-(void) editEvent:(UIButton*)button{
    NSInteger row = button.tag;
    NSString *eventID = [eventsIHostIDs objectAtIndex:row];
    NSString *class = [eventsIHostDict objectForKey:eventID];
    Event *event = (Event *)[PFQuery getObjectOfClass:class objectId:eventID];
    EditEventVC *editVC = [[EditEventVC alloc] init];
    editVC.event = event;
    [self presentViewController:editVC animated:YES completion:nil];
}

-(void) RSVPYes:(UIButton*)button{
    NSInteger row = button.tag;
    NSString *eventID = [pendingInvites objectAtIndex:row];
    NSString *class = [pendingInvitesDict objectForKey:eventID];
    [pendingInvitesDict removeObjectForKey:eventID];
    [playbookDict setObject:class forKey:eventID];
    [[PFUser currentUser] setObject:pendingInvitesDict forKey:@"PendingInvites"];
    [[PFUser currentUser] setObject:playbookDict forKey:@"Playbook"];
    
}
-(void) RSVPNo:(UIButton*)button{
    NSInteger row = button.tag;
    NSString *eventID = [pendingInvites objectAtIndex:row];
    [pendingInvitesDict removeObjectForKey:eventID];
    [[PFUser currentUser] setObject:pendingInvitesDict forKey:@"PendingInvites"];
}


@end
