import Foundation
import Katana
import Tempura
import Hydra
import Alamofire
import SwiftyJSON 

final class DependenciesContainer: NavigationProvider {
    let promisableDispatch: PromisableStoreDispatch
    var getAppState: () -> AppState
    var navigator: Navigator = Navigator()
    let ApiManager = APIManager()
    
    var getState: () -> State {
        return self.getAppState
    }

    init(dispatch: @escaping PromisableStoreDispatch, getAppState: @escaping () -> AppState) {
        self.promisableDispatch = dispatch
        self.getAppState = getAppState
    }
    
    convenience init(dispatch: @escaping PromisableStoreDispatch, getState: @escaping GetState) {
        let getAppState: () -> AppState = {
            guard let state = getState() as? AppState else {
                fatalError("Wrong State Type")
            }
            return state
        }
        self.init(dispatch: dispatch, getAppState: getAppState)
    }
}

final class APIManager {
    
    // Get all the events
    func getEvents() -> Promise<JSON> {
        return Promise<JSON>(in: .background) { resolve, reject, status in
            AF.request("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson").responseJSON { response in
                if let data = response.data {
                    if let json = try? JSON(data: data) {
                        resolve(json)
                    }
                }
            }
        }
    }
    
    // Get the event corresponding to passed id
    func getDetailedEvent(id: String) -> Promise<JSON> {
        return Promise<JSON>(in: .background) { resolve, reject, status in
            AF.request("https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&eventid=" + id).responseJSON { response in
                print(response.response!.statusCode)
                if let data = response.data {
                    if let json = try? JSON(data: data) {
                        resolve(json)
                    }
                }
            }
        }
    }
        
}
