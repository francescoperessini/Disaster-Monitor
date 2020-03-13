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
    func getEventsUSGS() -> Promise<JSON> {
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
    
    func getEventsINGV() -> Promise<JSON> {
        // TO-DO: fare in modo che torni sempre quello dell'ultima settimana concatenando la data di una settimana fa
        return Promise<JSON>(in: .background) { resolve, reject, status in
            AF.request("https://webservices.ingv.it/fdsnws/event/1/query?starttime=2020-02-27T00:00:00&format=geojson").responseJSON { response in
                if let data = response.data {
                    if let json = try? JSON(data: data) {
                        resolve(json)
                    }
                }
            }
        }
    }
}
