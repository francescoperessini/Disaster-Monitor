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
    func getEvent() -> Promise<String> {
        return Promise { fulfill, reject in
            asyncTask { result, error in
                if result != nil {
                    fulfill(result)
                } else {
                    reject(error.invalidResult)
                }
            }
        }
    }
    
    func asyncTask(fulfill, reject){
        Alamofire.request("http://jsonplaceholder.typicode.com/posts").responseData().then { data -> Void in

            let json = try JSON(data: data)
            print(json)
            
        }.catch { error -> Void in
            print("Error: \(error)")
        }
    }
}
