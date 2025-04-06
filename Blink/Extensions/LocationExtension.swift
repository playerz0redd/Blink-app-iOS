//
//  LocationExtension.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 6.04.25.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    func getRegion() async throws -> String? {
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(self)
            return placemarks.first?.locality
        } catch {
            return nil
        }
    }
    
    func getStreet() async throws -> String? {
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(self)
            return placemarks.first?.thoroughfare
        } catch {
            return nil
        }
    }
    
    func getCountry() async throws -> String? {
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(self)
            return placemarks.first?.country
        } catch {
            return nil
        }
    }
    
    func getArea() async throws -> String? {
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(self)
            return placemarks.first?.administrativeArea
        } catch {
            return nil
        }
    }
}
