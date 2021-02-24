//
//  Polilyne.swift
//  RunKipper
//
//  Created by Дмитрий on 1/5/21.
//  Copyright © 2021 DK. All rights reserved.
//

import Foundation
import GoogleMaps

private struct MapPath : Decodable{
    var routes : [Route]?
}

private struct Route : Decodable{
    var overview_polyline : OverView?
}

private struct OverView : Decodable {
    var points : String?
}

extension GMSMapView {

    //MARK:- Call API for polygon points

    func drawPolygon(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        print(source, destination)
        let session = URLSession.shared
        if let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=walking&key=AIzaSyAdjzvNUOwMTLxz1FzkT3ZP50WfcbALwf4") {
            let task = session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    print(String(bytes: data, encoding: .utf8))
                } else {
                    print("Ne risuet")
                }

    }
    }
    }

    //MARK:- Draw polygon

    private func drawPath(with points : String){

        DispatchQueue.main.async {

            let path = GMSPath(fromEncodedPath: points)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.strokeColor = .red
            polyline.map = self

        }
    }
}
