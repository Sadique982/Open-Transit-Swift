//
//  TripArrivalDepartureOperation.swift
//  OBAKit
//
//  Created by Aaron Brethorst on 10/6/18.
//  Copyright © 2018 OneBusAway. All rights reserved.
//

import Foundation

/// The operation for loading the `/api/where/arrival-and-departure-for-stop/{id}.json` endpoint.
public class TripArrivalDepartureOperation: RESTAPIOperation {

    // MARK: - API Call and URL Construction

    private static let apiPath = "/api/where/arrival-and-departure-for-stop/%@.json"

    public class func buildAPIPath(stopID: StopID) -> String {
        return String(format: apiPath, NetworkHelpers.escapePathVariable(stopID))
    }

    public class func buildURL(
        stopID: StopID,
        tripID: String,
        serviceDate: Date,
        vehicleID: String?,
        stopSequence: Int,
        baseURL: URL,
        defaultQueryItems: [URLQueryItem]
    ) -> URL {
        var args: [String: Any] = [
            "serviceDate": Int64(serviceDate.timeIntervalSince1970 * 1000),
            "tripId": tripID
        ]

        if let vehicleID = vehicleID {
            args["vehicleId"] = vehicleID
        }

        if stopSequence > 0 {
            args["stopSequence"] = stopSequence
        }

        let builder = RESTAPIURLBuilder(baseURL: baseURL, defaultQueryItems: defaultQueryItems)
        return builder.generateURL(path: buildAPIPath(stopID: stopID), params: args)
    }
}
