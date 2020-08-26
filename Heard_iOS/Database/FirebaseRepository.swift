
import UIKit
import FirebaseAuth
import FirebaseFirestore
import RxFirebase
import RxSwift

class FirebaseRepository {
    
    let auth = Auth.auth()
    let database = Firestore.firestore()
    let profiles: CollectionReference
    let artists: CollectionReference
    var fetchUser: FetchUserDelegate?
    var fetchArtists: FetchArtistDelegate?
    let disposeBag = DisposeBag()
    var currentUser: UserData?
    
    init() {
        profiles = database.collection(C.profiles)
        artists = database.collection(C.artists)
    }
    
    func createUser(with email: String, password: String, and username: String) {
        auth.rx
            .createUser(withEmail: email, password: password)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { authResult in
                self.createUserDoc(username, email)
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func createUserDoc(_ username: String, _ email: String) {
        profiles
            .document(email)
            .rx
            .setData([C.userName : username])
            .subscribe(onNext: {
                self.initUserData()
            }, onError: { error in
                print("Error setting data: \(error)")
            }).disposed(by: disposeBag)
    }

    func verifyLogin(with email: String, and password: String) {
        auth.rx
            .signIn(withEmail: email, password: password)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { authResult in
                self.initUserData()
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func initUserData() {
        profiles
            .document((auth.currentUser?.email)!)
            .rx
            .getDocument()
            .compactMap({$0.data()})
            .map({UserData(values: $0)})
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { userData in
                self.currentUser = userData
                self.fetchUser?.onUserReceived(userData)
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
        
    
    func updateFollowedArtists(with artist: ArtistData) {
        profiles
            .document((auth.currentUser?.email)!)
            .rx
            .setData([C.followedArtists : FieldValue.arrayUnion([artist.artistName])
            ], merge: true)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { _ in
                print("successfully add artist to follow")
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)

        artists
            .document(artist.artistName)
            .rx
            .setData([C.artistName : artist.artistName,
                      C.artistImage : artist.artworkUrl100,
                      C.artistFollowers : FieldValue.arrayUnion([auth.currentUser?.email as Any])
                      ], merge: true)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print("successfully add follower for artist")
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)

    }
    
    func fetchFollowedArtists() {
        var artistList: [ArtistData] = []
        artists
            .whereField(C.artistFollowers, arrayContains: auth.currentUser?.email! as Any)
            .rx
            .getDocuments()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { snapshot in
                snapshot.documents.forEach { doc in
                    let data = doc.data()
                    if let name = data[C.artistName] as? String,
                        let image = data[C.artistImage] as? String {
                        let newArtist = ArtistData(name, image)
                        artistList.append(newArtist)

                        DispatchQueue.main.async {
                            self.fetchArtists?.myArtistsReceived(artistList)
                        }
                    }
                }
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        }
    }

// MARK: - Fetch User Protocol
protocol FetchUserDelegate {
    func onUserReceived(_ userData: UserData)
}


// MARK: - Fetch Artists Protocol
protocol FetchArtistDelegate {    
    func myArtistsReceived(_ myArtists: [ArtistData])
}
