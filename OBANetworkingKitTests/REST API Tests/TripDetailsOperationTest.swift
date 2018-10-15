//
//  TripDetailsOperationTest.swift
//  OBANetworkingKitTests
//
//  Created by Aaron Brethorst on 10/10/18.
//  Copyright © 2018 OneBusAway. All rights reserved.
//

import XCTest
import Nimble
import OHHTTPStubs
@testable import OBANetworkingKit

class TripDetailsOperationTest: OBATestCase {
    func testStopsForRouteAPIPath() {
        expect(TripDetailsOperation.buildAPIPath(tripID: "Hello/World")) == "/api/where/trip-details/Hello%2FWorld.json"
    }

    func testSuccessfulStopsForRouteRequest() {
        let tripID = "1_18196913"
        let vehicleID = "1_1234"
        let serviceDate = Int64(1343631600000)

        let expectedParams = [
            "vehicleId": vehicleID,
            "serviceDate": "1343631600000"
        ]

        let apiPath = TripDetailsOperation.buildAPIPath(tripID: tripID)

        stub(condition: isHost(self.host) &&
                        isPath(apiPath) &&
                        containsQueryParams(expectedParams)
        ) { _ in
            return self.JSONFile(named: "trip_details_1_18196913.json")
        }

        waitUntil { done in
            self.builder.getTrip(tripID: tripID, vehicleID: vehicleID, serviceDate: serviceDate) { op in
                expect(op.entries?.count) == 1

                let entry = op.entries!.first! as [AnyHashable: Any]
                expect(entry["schedule"]).toNot(beNil())

                let stops = op.references!["stops"] as! [Any]
                expect(stops.count) == 53

                done()
            }
        }
    }
}