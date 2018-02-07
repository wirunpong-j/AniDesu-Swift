import Foundation
import Firebase
import Alamofire

class UserDataService {
    static let instance = UserDataService()
    
    public private(set) var uid = ""
    public private(set) var displayName = ""
    public private(set) var email = ""
    public private(set) var about = ""
    public private(set) var imageUrlProfile = ""
    
    func setUserData(uid: String, displayName: String, email: String, about: String, imageUrlProfile: String) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.about = about
        self.imageUrlProfile = imageUrlProfile
    }
    
    func fetchMyAnimeList(statusType: StatusType, completion: @escaping ([MyAnimeList]?) -> ()) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("list_anime").child(statusType.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            // get my anime list
            let value = snapshot.value as? NSDictionary
            
            var allMyAnimeList = [MyAnimeList]()
            if let allValues = value?.allValues {
                for item in allValues {
                    let myAnime = item as? NSDictionary
                    let animeID = myAnime!["anime_id"] as? Int ?? 0
                    let note = myAnime!["note"] as? String ?? ""
                    let progress = myAnime!["progress"] as? Int ?? 0
                    let score = myAnime!["score"] as? Int ?? 0
                    
                    AniListService.instance.fetchAnimePage(animeID: animeID) { (anime) in
                        let myAnimeList = MyAnimeList(anime_id: animeID, score: score, progress: progress, note: note, anime: anime!)
                        allMyAnimeList.append(myAnimeList)
                        
                        if allMyAnimeList.count >= value!.allValues.count {
                            completion(allMyAnimeList)
                        }
                    }
                }
            } else {
                completion(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
            print("Not Show Data")
            
            completion(nil)
        }
        
    }
    
    func addMyAnimeList(myAnimeList: MyAnimeList, statusType: StatusType, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference()
        let myAnime: [String: Any] = [
            "anime_id": myAnimeList.anime_id,
            "note": myAnimeList.note,
            "progress": myAnimeList.progress,
            "score": myAnimeList.score
        ]
        ref.child("users").child(uid).child("list_anime").child(statusType.rawValue).childByAutoId().setValue(myAnime)
        
        completion(true)
    }
    
    func isAnimeInMyList(animeID: Int, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("list_anime").observeSingleEvent(of: .value, with: { (snapshot) in
            // get my anime list
            let value = snapshot.value as? NSDictionary
            
            for status in (value?.allValues)! {
                let statusValue = status as? NSDictionary
                for item in statusValue! {
                    let myAnime = item.value as? NSDictionary
                    let id = myAnime!["anime_id"] as? Int
                    
                    if animeID == id! {
                        completion(true)
                        return
                    }
                }
            }
            completion(false)
            
        }) { (error) in
            print(error.localizedDescription)
            print("isAnimeInMyList ERROR!")
            
            completion(false)
        }
    }
    
    func logoutUser() {
        uid = ""
        displayName = ""
        email = ""
        about = ""
        imageUrlProfile = ""
        
        AuthService.instance.uid = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.authToken = ""
        AuthService.instance.anilistToken = ""
    }
    
}
