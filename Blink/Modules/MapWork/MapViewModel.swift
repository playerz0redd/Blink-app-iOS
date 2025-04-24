//
//  ViewModle.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import Foundation
import MapKit
import Combine
import SwiftUI

// MARK: - friends view has viewmodel, viewmodel has init from friends info array, use tabView, backend add recommended request

class MapViewModel : ObservableObject {
    @Published var friendsInfoArray : [PeopleInfoResult] = []
    @Published var isShowingSheet : Bool = false
    @Published var requestName : String = ""
    @Published var friendStatus : FriendsInfoSend.Status = .request
    @Published var friendsLocation : [UserLocation] = []
    @Published var peopleVisited : Int = 0
    @Published var selectedFriend : UserLocation? = nil
    @Published var address : String = ""
    @Published var region = MKCoordinateRegion(center: .init(), span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @Published var showBackground = true
    @Published var place : String = ""
    @Published var mapStyle = MapStyle.standard
    @Published var isPresentedFriendsSheet: Bool = false
    
    private var lastRequestDate: Date = Date.now
    private let timeInterval : TimeInterval = 1
    
    private var model : MapWorkModel
    var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    
    init(model: MapWorkModel) {
        self.model = model
        print("created")
        Task {
            try? await updateMyLocation()
            model.$locationUpdate
                .compactMap { $0 }
                .sink { [weak self] newLocation in
                    print("-")
                    if let self = self,
                       let index = self.friendsLocation.firstIndex(where: { $0.username == newLocation.username }) {
                        print("+")
                        let existingFriend = self.friendsLocation[index]
                        
                        self.friendsLocation[index] = UserLocation(
                            username: newLocation.username,
                            friendsSince: existingFriend.friendsSince!,
                            friendAmount: existingFriend.friendAmount!,
                            location: CLLocationCoordinate2D(
                                latitude: newLocation.location.latitude,
                                longitude: newLocation.location.longitude
                            )
                        )
                    }
                    
                }
                .store(in: &cancellables)
        }
    }
    
    @MainActor func getFriendsLocation() async throws {
        let locationArray = try await model.getFriendsLocation()
        guard let locations = locationArray else { return }
        
        var array : [UserLocation] = []
        for item in locations {
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
    
    @MainActor func updateMyLocation() async throws {
        if abs(region.center.latitude) < 0.01 && abs(region.center.longitude) < 0.01 {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: locationManager.location?.latitude ?? 0, longitude: locationManager.location?.longitude ?? 0),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
        }
        
        locationManager.$location
            .compactMap({ $0 })
            .throttle(for: .seconds(5), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] newLocation in
            Task {
                try await self?.model.updateMyLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
            }
        }.store(in: &cancellables)
    }
    
    @MainActor func getPeopleAmount() async throws {
        self.peopleVisited = try await model.getPeopleVisited(name: self.selectedFriend?.username ?? "", method: .get)
    }
    
    @MainActor func getRegion() async {
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
    
    func selectFriend(_ friend: UserLocation) {
        self.selectedFriend = friend
    }
    
    func connectLocationSocket() async throws {
        try await model.connectLocationSocket(to: ApiURL.locationSocket)
    }
    
    func didUpdateFriendsLocation() async throws(ApiError) {
 
    }
    
    private let mapStyles : [MapStyle] = [.standard, .imagery, .hybrid]
    private var currentIndex = 0
    
    func changeMapStyle() {
        currentIndex += 1
        currentIndex %= self.mapStyles.count
        self.mapStyle = self.mapStyles[currentIndex]
    }
    
}

