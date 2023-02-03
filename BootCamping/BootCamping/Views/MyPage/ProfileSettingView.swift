//
//  ProfileSettingView.swift
//  BootCamping
//
//  Created by 이민경 on 2023/01/18.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

// FIXME: 현재 기획한 UserInfo 데이터 모델에 따라서 텍스트 필드 변경 필요
/// 현재 기획 모델 그대로 가면 닉네임이랑 이메일, 비밀번호 변경하는 걸로 바꿔야 할 것 같습니다
struct ProfileSettingView: View {
    var user: User
//    @EnvironmentObject var authStore: AuthStore
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
//    @EnvironmentObject var kakaoAuthStore: KakaoAuthStore
    
    @State private var updateNickname: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.05){
            HStack{
                photoPicker
            }
            updateUserNameTextField
            Spacer()
            editButton
            
        }
        .padding(.vertical, UIScreen.screenHeight * 0.05)
        .padding(.horizontal, UIScreen.screenWidth * 0.1)
    }
    
}

extension ProfileSettingView {
    // MARK: -View : PhotoPicker
    private var photoPicker : some View {
        VStack{
            ZStack{
                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                }
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        ZStack{
                            Image(systemName: "circlebadge.fill")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .colorInvert()
                                .offset(x: 40, y: 40)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "pencil.circle")
                                .font(.title)
                                .foregroundColor(.bcBlack)
                                .offset(x: 40, y: 40)
                                .frame(width: 100, height: 100)
                            
                        }
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
            }
        }
    }
    // MARK: -View : updateNicknameTextField
//    private var updateNicknameTextField : some View {
//        TextField("닉네임을 입력해주세요", text: $updateNickname)
//    }
    
    // MARK: -View : updateUserNameTextField
    private var updateUserNameTextField : some View {
        VStack(alignment: .leading, spacing: 10){
            Text("닉네임")
                .font(.title3)
                .bold()
            TextField("닉네임", text: $updateNickname,prompt: Text("\(user.nickName)"))
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
        }
    }
    
    // MARK: -View : updateUserPhoneNumberTextField
//    private var updateUserPhoneNumberTextField : some View {
//        VStack(alignment: .leading, spacing: 10){
//            Text("휴대폰 번호")
//                .font(.title3)
//                .bold()
////            Text("01012345678")
//            TextField("휴대폰 번호를 입력해주세요", text: <#T##Binding<String>#>)
//
//        }
//    }
    // MARK: -View : editButton
    private var editButton : some View {
        Button {
            // TODO: UserInfo 수정하기
            
        } label: {
            Text("수정")
                .modifier(GreenButtonModifier())
        }
    }

}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingView(user: User(id: "", profileImage: "", nickName: "chasomin", userEmail: "", bookMarkedDiaries: [], bookMarkedSpot: []))
    }
}
