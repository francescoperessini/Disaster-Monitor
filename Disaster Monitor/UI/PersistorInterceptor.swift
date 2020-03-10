//
//  PersistorInterceptor.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 10/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import Foundation
import Katana

struct PersistorInterceptor {
    static func interceptor() -> StoreInterceptor{
        return { context in
            return { next in
                return { dispatchable in
                    try next(dispatchable)
                    DispatchQueue.global(qos: .utility).async {
                        //guard let _ = dispatchable as? Persistable else { return }
                        guard let state = context.getAnyState() as? AppState else { return }
                        let encoder = JSONEncoder()
                        do {
                            let file = "file.json"
                            let data = try encoder.encode(state)
                            
                            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                                let fileURL = dir.appendingPathComponent(file)
                                try data.write(to: fileURL)
                            }
                            
                        } catch {
                            print("Error while encoding JSON")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
