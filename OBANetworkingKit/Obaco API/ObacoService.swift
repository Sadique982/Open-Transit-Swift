//
//  ObacoService.swift
//  OBANetworkingKit
//
//  Created by Aaron Brethorst on 10/11/18.
//  Copyright © 2018 OneBusAway. All rights reserved.
//

import Foundation

public typealias WeatherCompletionBlock = (_ operation: WeatherOperation) -> Void
public typealias CreateAlarmCompletionBlock = (_ operation: CreateAlarmOperation) -> Void
public typealias DeleteAlarmCompletionBlock = (_ operation: NetworkOperation) -> Void
public typealias VehiclesCompletionBlock = (_ operation: MatchingVehiclesOperation) -> Void

@objc(OBAObacoService)
public class ObacoService: APIService {

    private let regionID: String

    @objc public init(baseURL: URL, apiKey: String, uuid: String, appVersion: String, regionID: String, networkQueue: OperationQueue) {
        self.regionID = regionID
        super.init(baseURL: baseURL, apiKey: apiKey, uuid: uuid, appVersion: appVersion, networkQueue: networkQueue)
    }

    // MARK: - Weather

    @discardableResult @objc
    public func getWeather(regionID: String, completion: WeatherCompletionBlock?) -> WeatherOperation {
        let url = WeatherOperation.buildURL(regionID: regionID, baseURL: baseURL, queryItems: defaultQueryItems)
        let operation = WeatherOperation(url: url)
        operation.completionBlock = { [weak operation] in
            if let operation = operation { completion?(operation) }
        }

        networkQueue.addOperation(operation)

        return operation
    }

    // MARK: - Alarms

    @discardableResult @objc
    public func postAlarm(secondsBefore: TimeInterval, stopID: String, tripID: String, serviceDate: Int64, vehicleID: String, stopSequence: Int, userPushID: String, completion: CreateAlarmCompletionBlock?) -> CreateAlarmOperation {
        let request = CreateAlarmOperation.buildURLRequest(secondsBefore: secondsBefore, stopID: stopID, tripID: tripID, serviceDate: serviceDate, vehicleID: vehicleID, stopSequence: stopSequence, userPushID: userPushID, regionID: regionID, baseURL: baseURL, queryItems: defaultQueryItems)
        let operation = CreateAlarmOperation(urlRequest: request)
        operation.completionBlock = { [weak operation] in
            if let operation = operation { completion?(operation) }
        }

        networkQueue.addOperation(operation)

        return operation
    }

    @discardableResult @objc
    public func deleteAlarm(url: URL, completion: DeleteAlarmCompletionBlock?) -> NetworkOperation {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        let op = NetworkOperation(urlRequest: request as URLRequest)
        op.completionBlock = { [weak op] in
            if let op = op { completion?(op) }
        }

        networkQueue.addOperation(op)

        return op
    }

    @discardableResult @objc
    public func getVehicles(matching query: String, completion: VehiclesCompletionBlock?) -> MatchingVehiclesOperation {
        let url = MatchingVehiclesOperation.buildURL(query: query, regionID: regionID, baseURL: baseURL, queryItems: defaultQueryItems)
        let op = MatchingVehiclesOperation(url: url)
        op.completionBlock = { [weak op] in
            if let op = op { completion?(op) }
        }

        networkQueue.addOperation(op)

        return op
    }
}
