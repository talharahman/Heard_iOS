
import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirebaseRepository {
    
    private let auth = Auth.auth()
    private let database = Firestore.firestore()
    private let profiles: CollectionReference
    private let artists: CollectionReference
    
    init() {
        profiles = database.collection(C.profiles)
        artists = database.collection(C.artists)
    }

    func verifyLogin(with email: String, with password: String) {
        auth.signIn(withEmail: email, password: password) {
             authResult, error in
             if let e = error { print(e.localizedDescription) }
        }
    }
    
    
    
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
}
