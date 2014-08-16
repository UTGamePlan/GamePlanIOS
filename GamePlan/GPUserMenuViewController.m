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
#import "Tailgate.h"
#import "WatchParty.h"
#import "AfterParty.h"

@interface GPUserMenuViewController (){
    NSDictionary *events;
    NSArray *sectionTitles;
    NSMutableArray *eventsIHost;
    NSMutableArray *pendingInvites;
    NSMutableArray *playbook;
}

@end

@implementation GPUserMenuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    [self queryTableData];
    
    sectionTitles = @[@"Events I am Hosting:", @"Pending Invites:", @"My Playbook:"];

}

- (void) queryTableData{
    
    eventsIHost = [[NSMutableArray alloc] init];
    pendingInvites = [[NSMutableArray alloc] init];
    playbook = [[NSMutableArray alloc] init];
    
    PFQuery *qryTG = [PFQuery queryWithClassName:@"Tailgate"];
    [qryTG findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( error ) {
            NSLog(@"Error getting event: %@",error);
        } else {
            for (Tailgate *tg in objects) {
                if ([tg.ownerId isEqual:[[PFUser currentUser] objectId]]) {
                    [eventsIHost addObject:tg];
                } else if ([tg.pendingInvites containsObject:[[PFUser currentUser] objectId]]){
                    [pendingInvites addObject:tg];
                } else if ([tg.confirmedInvites containsObject:[[PFUser currentUser] objectId]]){
                    [playbook addObject:tg];
                }
            }
            [self.tableView reloadData];
        }
    }];
    
    PFQuery *qryWP = [PFQuery queryWithClassName:@"WatchParty"];
    [qryWP findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( error ) {
            NSLog(@"Error getting event: %@",error);
        } else {
            for (WatchParty *wp in objects) {
                if ([wp.ownerId isEqual:[[PFUser currentUser] objectId]]) {
                    [eventsIHost addObject:wp];
                } else if ([wp.pendingInvites containsObject:[[PFUser currentUser] objectId]]){
                    [pendingInvites addObject:wp];
                } else if ([wp.confirmedInvites containsObject:[[PFUser currentUser] objectId]]){
                    [playbook addObject:wp];
                }
            }
            [self.tableView reloadData];
        }
    }];
    
    PFQuery *qryAP = [PFQuery queryWithClassName:@"AfterParty"];
    [qryAP findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( error ) {
            NSLog(@"Error getting event: %@",error);
        } else {
            for (AfterParty *ap in objects) {
                if ([ap.ownerId isEqual:[[PFUser currentUser] objectId]]) {
                    [eventsIHost addObject:ap];
                } else if ([ap.pendingInvites containsObject:[[PFUser currentUser] objectId]]){
                    [pendingInvites addObject:ap];
                } else if ([ap.confirmedInvites containsObject:[[PFUser currentUser] objectId]]){
                    [playbook addObject:ap];
                }
            }
            [self.tableView reloadData];
        }
    }];
    
    
    events = @{
               @"Events I am Hosting:" : eventsIHost,
               @"Pending Invites:" : pendingInvites,
               @"My Playbook:" : playbook
           };

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
    Event *thisEvent;
    if (indexPath.section == 0) {
        thisEvent = [eventsIHost objectAtIndex:indexPath.row];
    } else if(indexPath.section == 1){
        thisEvent = [pendingInvites objectAtIndex:indexPath.row];
    } else {
        thisEvent = [playbook objectAtIndex:indexPath.row];
    }
    
    //set up event view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GPEventDetailViewController *eventDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"event-details"];
    eventDetailViewController.event = thisEvent;
    
    id<PFSubclassing> sc = (id<PFSubclassing>)thisEvent;
    
    if ( [[sc parseClassName] isEqualToString:@"Tailgate"] ) {
        eventDetailViewController.eventType = @"tailgate";
        
    }
    if ( [[sc parseClassName] isEqualToString:@"WatchParty"] ) {
        eventDetailViewController.eventType = @"watchparty";
    }
    if ( [[sc parseClassName] isEqualToString:@"AfterParty"] ) {
        eventDetailViewController.eventType = @"afterparty";
    }
    
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
    
    

    
    if ([sectionTitle isEqualToString:@"Pending Invites:"]) {
        static NSString *simpleTableIdentifier = @"PendingInvitesTableCell";
        
        PendingInvitesTableViewCell *cell = (PendingInvitesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PendingInvitesTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSArray *eventsInSection = [events objectForKey:sectionTitle];
        Event *event = [eventsInSection objectAtIndex:indexPath.row];
        cell.eventName.text = event.name;
        
        id<PFSubclassing> sc = (id<PFSubclassing>)event;
        if ( [[sc parseClassName] isEqualToString:@"Tailgate"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"tailgate.png"];
        }
        if ( [[sc parseClassName] isEqualToString:@"WatchParty"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"watchParty.png"];
        }
        if ( [[sc parseClassName] isEqualToString:@"AfterParty"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"afterparty.png"];
        }
        
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
        Event *event = [eventsInSection objectAtIndex:indexPath.row];
        cell.eventName.text = event.name;
        id<PFSubclassing> sc = (id<PFSubclassing>)event;
        if ( [[sc parseClassName] isEqualToString:@"Tailgate"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"tailgate.png"];
        }
        if ( [[sc parseClassName] isEqualToString:@"WatchParty"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"watchParty.png"];
        }
        if ( [[sc parseClassName] isEqualToString:@"AfterParty"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"afterparty.png"];
        }
        
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
        Event *event = [eventsInSection objectAtIndex:indexPath.row];
        cell.eventName.text = event.name;
        id<PFSubclassing> sc = (id<PFSubclassing>)event;
        if ( [[sc parseClassName] isEqualToString:@"Tailgate"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"tailgate.png"];
        }
        if ( [[sc parseClassName] isEqualToString:@"WatchParty"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"watchParty.png"];
        }
        if ( [[sc parseClassName] isEqualToString:@"AfterParty"] ) {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"afterparty.png"];
        }
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
    Event *thisEvent = [eventsIHost objectAtIndex:row];
    EditEventVC *editVC = [[EditEventVC alloc] init];
    editVC.event = thisEvent;
    [self presentViewController:editVC animated:YES completion:nil];
}

-(void) RSVPYes:(UIButton*)button{
    NSInteger row = button.tag;
    Event *thisEvent = [pendingInvites objectAtIndex:row];
    NSArray *arr = thisEvent.pendingInvites;
    for(NSString *userId in arr){
        if ([userId isEqualToString:[[PFUser currentUser] objectId]]){
            [thisEvent.pendingInvites removeObject:userId];
            [thisEvent saveInBackground];
        }
    }
    
    [thisEvent.confirmedInvites addObject:[[PFUser currentUser] objectId]];
    [thisEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self queryTableData];
    }];
    UIAlertView *rsvpYesMessage = [[UIAlertView alloc]
                               initWithTitle:@"" message:@"Great! See you there!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [rsvpYesMessage show];
}

-(void) RSVPNo:(UIButton*)button{
    NSInteger row = button.tag;
    Event *thisEvent = [pendingInvites objectAtIndex:row];
    NSArray *arr = thisEvent.pendingInvites;
    for(NSString *userId in arr){
        if ([userId isEqualToString:[[PFUser currentUser] objectId]]){
            [thisEvent.pendingInvites removeObject:userId];
            [thisEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self queryTableData];
            }];
            UIAlertView *rsvpNoMessage = [[UIAlertView alloc]
                                       initWithTitle:@"" message:@"Too bad! Maybe next time!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [rsvpNoMessage show];
        }
    }
}


@end
