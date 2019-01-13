//
//  Icons.swift
//  OBAKit
//
//  Created by Aaron Brethorst on 1/2/19.
//  Copyright © 2019 OneBusAway. All rights reserved.
//

import UIKit

@objc(OBAIcons)
public class Icons: NSObject {

    // MARK: - Heading

    /// A gradient arc image that can be used to show the user's heading.
    public class var userHeading: UIImage {
        return imageNamed("user_heading")
    }

    /// A gradient arc image that can be used to show a vehicle's heading.
    public class var vehicleHeading: UIImage {
        return imageNamed("vehicle_heading")
    }

    // MARK: - Branding

    /// A large 'header'-style version of the OBA icon/logo.
    public class var header: UIImage {
        return imageNamed("header")
    }

    // MARK: - Transport Icons

    /// Generates an appropriate icon from the specified route type.
    ///
    /// - Parameter routeType: The route type from which to generate an image.
    /// - Returns: An image representing the route type.
    public class func transportIcon(from routeType: RouteType) -> UIImage {
        switch routeType {
        case .lightRail: return lightRailTransport
        case .subway: return trainTransport
        case .rail: return trainTransport
        case .bus: return busTransport
        case .ferry: return ferryTransport
        default: return busTransport
        }
    }

    /// A transport icon depicting a bus.
    public class var busTransport: UIImage {
        return imageNamed("busTransport")
    }

    /// A transport icon depicting a ferry.
    public class var ferryTransport: UIImage {
        return imageNamed("ferryTransport")
    }

    /// A transport icon depicting a light rail train.
    public class var lightRailTransport: UIImage {
        return imageNamed("lightRailTransport")
    }

    /// A transport icon depicting a train.
    public class var trainTransport: UIImage {
        return imageNamed("trainTransport")
    }

    /// A transport icon depicting a person walking.
    public class var walkTransport: UIImage {
        return imageNamed("walkTransport")
    }

    private static func imageNamed(_ name: String) -> UIImage {
        return UIImage(named: name, in: Bundle(for: self), compatibleWith: nil)!
    }
}