//
//  MapViewController.swift
//  Proximity
//
//  Created by Matthias Delbar on 24/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var locationController = LocationController()
    var userController = UserController()
    var usersModel: UsersModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register for user model updates
        NSNotificationCenter.defaultCenter().addObserverForName("UsersModelUpdated", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleUserModelUpdatedNotification)
        
        // Register for location updates and start tracking location
        NSNotificationCenter.defaultCenter().addObserverForName("MyLocationUpdated", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleMyLocationUpdatedNotification)
        locationController.startTrackingLocation()
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        // Clear the map, then request new data from the server
        clearMap(map: mapView)
        
        fetchUsersNearMe()
    }
    
    private func fetchUsersNearMe() {
        userController.fetchUsersNear(user: usersModel!.me)
    }
    
    // MARK: - Notification handlers
    
    private func handleMyLocationUpdatedNotification(notification: NSNotification!) {
        logger.verbose("Handling notification [\(notification.name)]")
        
        // Remove self as observer again
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MyLocationUpdated", object: nil)
        
        // Fetch users from server
        fetchUsersNearMe()
    }
    
    private func handleUserModelUpdatedNotification(notification: NSNotification!) {
        logger.verbose("Handling notification [\(notification.name)]")
        logger.debug("Users model was updated, refreshing view")
        
        // Refresh map view
        updateMap(users: usersModel!.users, me: usersModel!.me)
    }
    
    // MARK: - Map update logic
    
    private func updateMap(#users: [User], me: User) {
        // Clear map of existing annotations first
        clearMap(map: mapView)
        
        // Add all users to the map
        // At the same time, calculate the top left and bottom right coordinates
        var (topLeftLat, topLeftLong, bottomRightLat, bottomRightLong) = (-90.0, 180.0, 90.0, -180.0)
        for user in users {
            let userAnnotation = UserAnnotation(user: user)
            mapView.addAnnotation(userAnnotation)
            
            topLeftLat = max(user.lat!, topLeftLat)
            topLeftLong = min(user.long!, topLeftLong)
            bottomRightLat = min(user.lat!, bottomRightLat)
            bottomRightLong = max(user.long!, bottomRightLong)
        }
        // Also take the own user's location into account for the topLeft/bottomRight calculations
        topLeftLat = max(me.lat!, topLeftLat)
        topLeftLong = min(me.long!, topLeftLong)
        bottomRightLat = min(me.lat!, bottomRightLat)
        bottomRightLong = max(me.long!, bottomRightLong)
        
        // Zoom map to fit the square made by topLeft and bottomRight
        // Make region to show on map
        let regionCenterLat = topLeftLat - (topLeftLat - bottomRightLat) * 0.5
        let regionCenterLong = bottomRightLong - (bottomRightLong - topLeftLong) * 0.5
        // Add a little extra space (25 %) on the sides
        let regionSpanLatDelta = abs(topLeftLat - bottomRightLat) * 1.25;
        let regionSpanLongDelta = abs(bottomRightLong - topLeftLong) * 1.25;
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: regionCenterLat, longitude: regionCenterLong), span: MKCoordinateSpan(latitudeDelta: regionSpanLatDelta, longitudeDelta: regionSpanLongDelta))
        
        // Get region that fits on map and display it
        let regionThatFits = mapView.regionThatFits(region)
        mapView.setRegion(regionThatFits, animated: true)
    }
    
    private func clearMap(#map: MKMapView) {
        for annotation in map.annotations {
            map.removeAnnotation(annotation as MKAnnotation)
        }
    }
    
    
    
    
/*
    - (void) updateLocationsOnMap {
    for (id<MKAnnotation> annotation in friendsMap.annotations) {
        if ([annotation isKindOfClass:[OWLFriend class]]) {
            [friendsMap removeAnnotation:annotation];
        }
    }
    
    NSDictionary *locationDict = [[OWLLocationHelper sharedInstance] getLocationAsNumbersDict];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[locationDict valueForKey:@"lat"] doubleValue];
    zoomLocation.longitude= [[locationDict valueForKey:@"lon"] doubleValue];

    
    NSArray* friends = [[[OWLFriendsModel sharedInstance] friends] allValues];
    NSMutableArray* friendsCheckedIn = [NSMutableArray array];
    for (OWLFriend* friend in friends){
        if (friend.venue_id && friend.venue_id != (id) [NSNull null]) {
            [friendsCheckedIn addObject:friend];
            NSLog(@"Coordinate of %@: %f - %f", friend.first_name, friend.coordinate.latitude, friend.coordinate.longitude);
        }
    }
    [friendsMap addAnnotations: friendsCheckedIn];
    [self zoomToFitMapAnnotations:friendsMap];
    
}
    
    
-(void)zoomToFitMapAnnotations:(MKMapView*)mapView {
    if(mapView.annotations.count == 0) {
        return;
    }
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id <MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 10; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 10; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
    selectedAnnotation = nil;
}

- (MKCoordinateRegion) coordinateRegionForCoordinates:(CLLocationCoordinate2D*)coords :(NSUInteger)coordCount {
    MKMapRect r = MKMapRectNull;
    for (NSUInteger i=0; i < coordCount; ++i) {
        MKMapPoint p = MKMapPointForCoordinate(coords[i]);
        r = MKMapRectUnion(r, MKMapRectMake(p.x, p.y, 0, 0));
    }
    return MKCoordinateRegionForMapRect(r);
}

    
*/
    
    
    
    
    
    
    
    
    
}