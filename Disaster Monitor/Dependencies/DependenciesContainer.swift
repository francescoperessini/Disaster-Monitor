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

final class APIManager{
    func getEvent() -> Promise<JSON> {
        return Promise<JSON>(in: .background) { resolve, reject, status in
            Alamofire.request("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson").responseJSON { response in
                if let data = response.data{
                    if let json = try? JSON(data: data){
                        resolve(json)
                    }
                }
            }
        }
    }


/*Alamofire.request(url).responseJSON { response in
        if let data = response.data {
            if let json = try? JSON(data: data) {
                for item in json["books"].arrayValue {
                    var outputString: String
                    //print(item["author"])
                    outputString = item["author"].stringValue
                    //urlOfProjectAsset.append(outputString)
                    self.authors.append(outputString)
                    //print("authors.count: \(self.authors.count)")
                }
            self.getAuthorsCount() // I added this line of code.
            }
        }*/
}
