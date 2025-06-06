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


class MapViewModel : ObservableObject {
    @Published var isButtonRotating = false
    @Published var isShowingSheet : Bool = false
    @Published var requestName : String = ""
    @Published var friendStatus : FriendsInfoSend.Status = .request
    @Published var friendsLocation : [UserLocation] = []
    @Published var peopleVisited : Int = 0
    @Published var selectedFriend : UserLocation?
    @Published var address : String = ""
    @Published var region = MKCoordinateRegion(center: .init(), span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @Published var showBackground = true
    @Published var place : String = ""
    @Published var mapStyle = MapStyle.standard
    @Published var isPresentedFriendsSheet: Bool = false
    @Published var isPresentedChats: Bool = false
    @Published var isPresentedSettings = false
    var name: String = ""
    @Published var myUsername: String?
    @Binding var isLogedIn: Bool
    var currentStyleIndex = 0
    @Published var errorState = ErrorState()
    var myLocation: CLLocationCoordinate2D? {
        locationManager.location
    }
    
    private var lastRequestDate: Date = Date.now
    private let timeInterval : TimeInterval = 1
    
    var model : MapWorkModel
    var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    
    init(model: MapWorkModel, isLogedIn: Binding<Bool>) {
        self._isLogedIn = isLogedIn
        self.model = model
        self.myUsername = model.getMyUsername()
        print("created")
        Task {
            await updateMyLocation()
            model.$locationUpdate
                .compactMap { $0 }
                .sink { [weak self] newLocation in
                    if let self = self,
                       let index = self.friendsLocation.firstIndex(where: { $0.username == newLocation.username }) {
                        let existingFriend = self.friendsLocation[index]
                        
                        self.friendsLocation[index] = UserLocation(
                            username: newLocation.username,
                            friendsSince: existingFriend.friendsSince!,
                            friendAmount: existingFriend.friendAmount!,
                            location: CLLocationCoordinate2D(
                                latitude: newLocation.location.latitude,
                                longitude: newLocation.location.longitude
                            ), peopleVisited: newLocation.peopleVisited ?? 0,
                            status: newLocation.status
                        )
                    }
                    
                }
                .store(in: &cancellables)
        }
    }
    
    @MainActor func getFriendsLocation() async {
        var locations : [Location]?
        do {
            let locationArray = try await model.getFriendsLocation()
            locations = locationArray
        } catch let error {
            self.errorState.setError(error: error)
            return
        }
        
        guard locations != nil else { return }
        
        var array : [UserLocation] = []
        for item in locations! {
            array.append(UserLocation(
                username: item.friend_name,
                friendsSince: item.friends_since,
                friendAmount: item.friend_amount,
                location: CLLocationCoordinate2D(latitude: item.lat, longitude: item.lng),
                peopleVisited: item.people_visited,
                status: item.status)
            )
        }
        self.friendsLocation = array
    }
    
    @MainActor func updateMyLocation() async {
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
    
    @MainActor func getPeopleAmount() async {
        do {
            self.peopleVisited = try await model.getPeopleVisited(name: self.selectedFriend?.username ?? "", method: .get)
        } catch let error {
            self.errorState.setError(error: error)
        }
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
        default: self.place = "Земля"
        }
    }
    
    func selectFriend(_ friend: UserLocation) {
        self.name = friend.username
        self.selectedFriend = friend
    }
    
    @MainActor func connectLocationSocket() async {
        do {
            try await model.connectLocationSocket(to: ApiURL.locationSocket)
        } catch let error {
            self.errorState.setError(error: error)
            return
        }
        self.errorState.clearError()
    }
    
    private let mapStyles : [MapStyle] = [.standard, .imagery, .hybrid]
    private var currentIndex = 0
    
    func changeMapStyle() {
        currentIndex += 1
        currentIndex %= self.mapStyles.count
        self.mapStyle = self.mapStyles[currentIndex]
    }
    
}

