//
//  SnapshotterCache.swift
//  RunKipper
//
//  Created by Дмитрий on 2/8/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import CoreLocation

class SnapshotterCache {
    
    // MARK: -
    // MARK: - Vars
    
    private var mapsShapshot: UIImage!
    
    typealias imageCompletionHandler = ((UIImage?) -> ())
    
    fileprivate enum Constant {
        static let mapSize = CGSize(width: 600, height: 300)
    }
    
    // MARK: -
    // MARK: - Public Methods
    
    init() {}
    
    public func getMapShaphsotAtWorkout(routes: [CLLocation], result: @escaping imageCompletionHandler) {
        if routes.count > 0 {
            self.getMapSnapshot(routes: routes) { snapshot in
            result(snapshot)
        }
        }else {
        result(nil)
        }
    }
}

// MARK: -
// MARK: - Private methods
// MARK: - Map snapshot

fileprivate extension SnapshotterCache {
    
    func getMapSnapshot(routes: [CLLocation], result: @escaping imageCompletionHandler) {
        if let snapshotImage = getMapSnapshotFromCache() {
            result(snapshotImage)
        } else {
            createMapSnapshot(routes: routes, result: { [weak self] image in
                self?.addMapSnapshotToCache(image: image!)
                result(image)
            })
        }
    }
    
    private func createMapSnapshot(routes: [CLLocation], result: @escaping imageCompletionHandler) {
       let snapShotService = MapSnapshotterService(with: routes, size: Constant.mapSize)
       snapShotService.image { image in
         result(image)
       }
    }
    
    private func getMapSnapshotFromCache() -> UIImage? {
        if let snapshotImage = mapsShapshot {
            return snapshotImage
        } else {
            return nil
        }
    }
    
    private func addMapSnapshotToCache(image: UIImage) {
        mapsShapshot = image
    }
    
}
