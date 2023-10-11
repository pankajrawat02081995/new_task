//

import Foundation

var kUserData:UserBasicDetails?{
    set{
        UserDefaults.set(encoder: newValue, forKey: kUserDataKey)
    }
    get{
        return UserDefaults.get(decoder: UserBasicDetails.self, forKey: kUserDataKey)
    }
}

var kAccessToken:String?{
    set{
        guard  newValue != nil else{
            UserDefaults.removeObject(forKey: kAuthTokenKey)
            return
        }
        
        UserDefaults.set(archivedObject: newValue, forKey: kAuthTokenKey)
    }
    get{
        return UserDefaults.getString(forKey: kAuthTokenKey)
    }
}


