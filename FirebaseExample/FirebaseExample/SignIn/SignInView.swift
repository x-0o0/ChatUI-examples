//
//  SignInView.swift
//  FirebaseExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import AuthenticationServices

struct SignInView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var userID = ""
    @State private var username = ""
    @State private var uiImage: UIImage?
    
    var body: some View {
        VStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .large2
                    .foregroundColor(.secondary)
                    .clipShape(Circle())
            } else {
                Image.person
                    .large
                    .clipShape(Circle())
            }
            PhotosPicker(selection: $selectedItem) {
                Text("Choose profile image")
            }
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SignInWithAppleButton(
                onRequest: { request in },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        // 로그인 성공 처리
                        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                            self.userID = appleIDCredential.user
                            self.saveUserToFirebase(userID, self.username, self.uiImage)
                        }
                        break
                    case .failure:
                        // 로그인 실패 처리
                        break
                    }
                }
            )
            .frame(width: 200, height: 44)
            .cornerRadius(8.0)
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                // Retrive selected asset in the form of Data
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    self.uiImage = UIImage(data: data)
                }
            }
        }
    }
    
    func saveUserToFirebase(_ userID: String, _ username: String, _ uiImage: UIImage?) {
        guard let imageData = uiImage?.jpegData(compressionQuality: 0.5) else {
                print("Failed to convert profile image to data")
                return
            }
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imagesRef = storageRef.child("profile_images/\(userID).jpg")
            imagesRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading profile image: \(error.localizedDescription)")
                } else {
                    print("Profile image uploaded successfully")
                    imagesRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error retrieving profile image URL: \(error.localizedDescription)")
                        } else if let url = url {
                            let data: [String: Any] = [
                                "username": username,
                                "imageURL": url.absoluteString
                            ]
                            let db = Firestore.firestore()
                            db.collection("users").document(userID).setData(data) { error in
                                if let error = error {
                                    print("Error saving user to Firestore: \(error.localizedDescription)")
                                } else {
                                    print("User saved to Firestore successfully")
                                }
                            }
                        }
                    }
                }
            }
        }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
