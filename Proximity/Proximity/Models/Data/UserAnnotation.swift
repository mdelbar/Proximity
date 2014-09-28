//
//  UserAnnotation.swift
//  Proximity
//
//  Created by Matthias Delbar on 27/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var mapItem: MKMapItem {
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placeMark)
        return mapItem
    }
    
    init(user: User) {
        coordinate = CLLocationCoordinate2D(latitude: user.lat!, longitude: user.long!)
        super.init()
    }
    
/*
    - (CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D loc;
    if (self.venue_id) {
    if (!venue) {
    venue = [[OWLVenuesModel sharedInstance] findVenueWithId:self.venue_id];
    }
    
    if (venue && (venue.name != nil)) {
    loc.latitude = [[venue latitude] doubleValue];
    loc.longitude= [[venue longitude] doubleValue];
    }
    else{
    [[OWLVenueController sharedInstance] fetchVenueWithId:self.venue_id];
    }
    }
    return loc;
    }
    
    - (NSString *) title {
    return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
    }
    
    - (NSString *) subtitle {
    return [self location];
    }
    
    - (MKMapItem*) mapItem {
    venue = [[OWLVenuesModel sharedInstance] findVenueWithId:[self venue_id]];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[self coordinate] addressDictionary:nil];
    MKMapItem* mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    return mapItem;
    }
*/
}