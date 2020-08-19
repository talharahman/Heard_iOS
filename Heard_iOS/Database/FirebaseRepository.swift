
import UIKit
import FirebaseAuth
import FirebaseFirestore
import RxFirebase
import RxSwift

class FirebaseRepository {
    
    private let auth = Auth.auth()
    private let database = Firestore.firestore()
    private let profiles: CollectionReference
    private let artists: CollectionReference
    var delegate: FetchArtistDelegate?
    let disposeBag = DisposeBag()
    
    init() {
        profiles = database.collection(C.profiles)
        artists = database.collection(C.artists)
    }

    func verifyLogin(with email: String, and password: String) {
        auth.rx.signIn(withEmail: email, password: password)
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { authResult in
                print("user signed in")
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
//    private var userDocRef: String {
//        set {
//            profiles.rx
//                .addDocument(data: [C.userID : auth.currentUser?.uid])
//                .subscribe(onNext: { ref in
//                    self.userDocRef = ref.documentID
//                }, onError: { error in
//                    print("Error adding document: \(error)")
//                }).disposed(by: disposeBag)
//        }
//        get {
//            return self.userDocRef
//        }
//     }

    func updateFollowedArtists(with artist: ArtistData) {
        profiles.whereField(C.userID, isEqualTo: auth.currentUser!.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let docID = querySnapshot!.documents[0].documentID
                    self.profiles.document(docID).updateData([
                        C.followedArtists: FieldValue.arrayUnion([artist.artistName])
                    ])
                }
        }
        
        
        artists.whereField(C.artistName, isEqualTo: artist.artistName)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                
                if querySnapshot != nil {
                    if !querySnapshot!.documents.isEmpty {
                    let docID = querySnapshot!.documents[0].documentID
                    self.artists.document(docID).updateData([
                        C.artistFollowers : FieldValue.arrayUnion([self.auth.currentUser!.uid])
                    ])
                } else {
                    self.artists.addDocument(data:
                        [C.artistName : artist.artistName,
                        C.artistImage : artist.artworkUrl100,
                        C.artistFollowers : FieldValue.arrayUnion([self.auth.currentUser!.uid])
                        ])
                    }
                }
        }
    }
    
    func fetchFollowedArtists() {
        profiles.order(by: C.artistName)
        .addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                 print("There was an issue retrieving data from Firestore. \(e)")
                self.delegate?.onError(e)
            } else {
//                if let snapshotDocuments = querySnapshot?.documents {
//
//                }
            }
        }
    }
}

// MARK: - Fetch Artists Protocol
protocol FetchArtistDelegate {
    
    func myArtistsReceived(_ myArtists: [ArtistData])
    
    func onError(_ error: Error)
}
