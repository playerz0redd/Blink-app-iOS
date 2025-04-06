//
//  ViewModle.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import Foundation
import MapKit
import Combine

struct UserLocation: Identifiable {
    var id = UUID()
    var username : String
    var friendsSince: Date
    var friendAmount : Int
    var location: CLLocationCoordinate2D
}


class MapViewModel : ObservableObject {
    @Published var friendsInfoArray : [PeopleInfoResult] = []
    @Published var isShowingSheet : Bool = false
    @Published var requestName : String = ""
    @Published var friendStatus : FriendsInfoSend.Status = .request
    @Published var friendsLocation : [UserLocation] = []
    @Published var peopleVisited : Int = 0
    @Published var selectedFriend : UserLocation? = nil
    @Published var address : String = ""
    @Published var myLocation: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.9, longitude: 27.5667),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var place : String = ""
    
    private var lastRequestDate: Date = Date.now
    private let timeInterval : TimeInterval = 1
    
    private var model = MapWorkModel()
    
    func selectFriend(_ friend: UserLocation) {
        self.selectedFriend = friend
    }
    
    @MainActor
    func getFriendsLocation() async throws {
        let undecodedData = try await model.getFriendsLocation()
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let locationArray = try decoder.decode([Location].self, from: undecodedData)
        var array : [UserLocation] = []
        for item in locationArray {
            array.append(UserLocation(username: item.friend_name,
                                      friendsSince: item.friends_since,
                                      friendAmount: item.friend_amount,
                                      location: CLLocationCoordinate2D(latitude: item.lat, longitude: item.lng)))
        }
        self.friendsLocation = array
    }
    
    func getDistanceBetweenDates(from: Date, to: Date) -> Int {
        Calendar.current.dateComponents([.day], from: from, to: to).day ?? 0
    }
    
    private func updateMyLocation() async throws {
        // location data from other manager
        
        // or with location update call this method
        try await model.updateMyLocation(latitude: self.myLocation?.latitude ?? 0, longitude: self.myLocation?.longitude ?? 0)
    }
    
    @MainActor
    func getPostPeopleAmount() async throws {
        self.peopleVisited = try await model.getPeopleVisited(name: self.selectedFriend?.username ?? "", method: .post)
    }
    
    @MainActor
    func getRegion() async {
        guard let location = self.selectedFriend?.location else {
            self.address = ""
            return
        }

        let region = CLLocation(latitude: location.latitude, longitude: location.longitude)
        self.address = await (try? region.getRegion()) ?? ""
    }
    
    @MainActor func getPlace() async {
        guard Date.now.timeIntervalSince(self.lastRequestDate) > timeInterval else { return }
        self.lastRequestDate = Date.now
        
        let region = CLLocation(latitude: self.region.center.latitude, longitude: self.region.center.longitude)
        
        switch self.region.span.latitudeDelta {
        case 0..<0.02: self.place = await (try? region.getStreet()) ?? ""
        case 0.02..<0.5: self.place = await (try? region.getRegion()) ?? ""
        case 0.5..<5: self.place = await (try? region.getArea()) ?? ""
        case 5..<30: self.place = await (try? region.getCountry()) ?? ""
        default: self.place = "earth"
        }
    }
    
}
