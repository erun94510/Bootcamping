//
//  DiaryAddView.swift
//  BootCamping
//
//  Created by 박성민 on 2023/01/18.
//

import SwiftUI
import PhotosUI
import Firebase
import Photos

//TODO: 텍스트 필드 입력할 때 화면 따라가기,,,
struct DiaryAddView: View {
    
    
    
    @Binding var isNavigationGoFirstView: Bool

    
    @State private var diaryTitle: String = ""
    @State private var locationInfo: String = ""
    @State private var visitDate: String = ""
    @State private var diaryIsPrivate: Bool = false //false가 공개
    @State private var diaryContent: String = ""
    
    @EnvironmentObject var diaryStore: DiaryStore
    @EnvironmentObject var wholeAuthStore: WholeAuthStore
    @Environment(\.dismiss) private var dismiss
    
    //키보드 dismiss 변수
    @FocusState private var inputFocused: Bool
    
    @State private var campingSpotItem: Item = CampingSpotStore().campingSpot
    @State private var campingSpot: String = ""
    
    //글 작성 유저 닉네임 변수
    var userNickName: String? {
        get {
            for user in wholeAuthStore.userList {
                if user.id == Auth.auth().currentUser?.uid {
                    return user.nickName
                }
            }
            return nil
        }
    }
    
    //MARK: - DatePicker 변수
    @State private var selectedDate: Date = .now
    
    //이미지 피커
    @State private var imagePickerPresented = false // 이미지 피커를 띄울 변수
    @State private var selectedImages: [UIImage]?   // 이미지 피커에서 선택한 이미지저장.
    @State private var diaryImages: [Data]?         // selectedImages를 [Data] 타입으로 저장
    
    var images: [UIImage] = [UIImage()]
    
    var body: some View {
        VStack {
            
//            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    imagePicker
//                    addViewTitle
                    Divider()
                    addViewLocationInfo
                    Divider()

                    addViewVisitDate
                    Divider()

                    addViewIsPrivate
                    Spacer()
                    nextButton
//                    addViewDiaryContent
//                    addViewAddButton
                }
//            }
            //MARK: - 키보드 옵션입니다.
//            .disableAutocorrection(true) //자동 수정 비활성화
//            .textInputAutocapitalization(.never) //첫 글자 대문자 비활성화
            //            .toolbar {
            //                ToolbarItemGroup(placement: .keyboard) {
            //                    Spacer()
            //
            //                    Button(action: resignKeyboard) {
            //                        Text("Done")
            //                    }
            //                }
            //            }
            //            .onSubmit(of: .text, submit) //done 누르면 submit 함수가 실행됨
            
        }
        .padding(.horizontal, UIScreen.screenWidth*0.03)
        .navigationTitle(Text("캠핑 일기 쓰기"))
        .onTapGesture {
            dismissKeyboard()
        }
        .task {
            campingSpot = campingSpotItem.facltNm
            locationInfo = campingSpotItem.contentId
        }
    }
}


private extension DiaryAddView {
    
    //MARK: 이미지 피커
    private var imagePicker: some View {
        HStack{
            Button(action: {
                imagePickerPresented.toggle()
//                checkAlbumPermission()
            }, label: {
                ZStack {
                    Image(systemName: "plus")
                    VStack{
                        Spacer()
                        Text("\(diaryImages?.count ?? 0) / 10")
                            .padding(.bottom, 5)
                    }
                }
                .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenWidth * 0.2)
                .background {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .stroke(.gray, lineWidth: 1)
                }
                .padding(UIScreen.screenWidth * 0.005)
                
            })
            .sheet(isPresented: $imagePickerPresented,
                   onDismiss:
                    {
//                   DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                loadData()
//            }
                   }
                   ,
                   content: { PhotoPicker(images: $selectedImages, selectionLimit: 10) })
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    if diaryImages == nil {
                        
                        Text(diaryImages?.isEmpty ?? true ? "사진을 추가해주세요" : "")
                            .foregroundColor(.secondary)
                            .opacity(0.5)
                            .padding(.leading, UIScreen.screenWidth * 0.05)
                        
                    } else{
                        ForEach(Array(zip(0..<(diaryImages?.count ?? 0), diaryImages ?? [Data()])), id: \.0) { index, image in
                            Image(uiImage: UIImage(data: image)!)
                                .resizeImageData(data: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenWidth * 0.2)
                                .clipped()
                                .overlay(alignment: .topLeading) {
                                    ZStack{
                                        Image(systemName: "bookmark.fill")
                                            .foregroundColor(.bcGreen)
                                            .font(.title3)
                                            .offset(x: 0, y: -3)
                                        Image(systemName: "bookmark")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                            .offset(x: 0, y: -3)

                                    }
                                        .opacity(index == 0 ? 1 : 0)
                                }
                        }
                    }
                }
            }
        }
//        .padding(.bottom)
        .padding(.vertical)
    }
    // selectedImage: UIImage 타입을 Data타입으로 저장하는 함수
    func loadData() {
        var arr = [Data]()
        guard let selectedImages = selectedImages else { return }
        print("!!!!!!!!!!!!!!!!!!!!!!arr: \(selectedImages.count)")
        for selectedImage in selectedImages {
            arr.append((selectedImage.jpegData(compressionQuality: 0.2)!))
        }
        print("!!!!!!!!!!!!!!!!!!!!!!arr: \(arr.count)")
        diaryImages = arr
        print("!!!!!!!!!!!!!!!!!!!!!!diaryImages\(diaryImages!.count)")
    }
    
    //MARK: - 제목 작성
    var addViewTitle: some View {
        Section {
            //            KitTextField (
            //                label: "제목을 입력해주세요(최대 20자)",
            //                text: $diaryTitle,
            //                focusable: $fieldFocus,
            //                returnKeyType: .next,
            //                tag: 0
            //            )
            //            .padding(6)
            //            .background {
            //                RoundedRectangle(cornerRadius: 2, style: .continuous)
            //                    .stroke(.gray, lineWidth: 1)
            //            }
            //            .padding( UIScreen.screenWidth * 0.005)
            //            .padding(.bottom)
            //            .submitLabel(.done) //작성 완료하면 키보드 return 버튼이 파란색 done으로 바뀜
            //            .onChange(of: diaryTitle) { newValue in
            //                if newValue.count > 20 {
            //                    diaryTitle = String(newValue.prefix(20))
            //                }
            //            }
            
            
            TextField("제목을 입력해주세요(최대 20자)", text: $diaryTitle)
                .padding(6)
                .background {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .stroke(.gray, lineWidth: 1)
                }
                .padding( UIScreen.screenWidth * 0.005)
                .padding(.bottom)
                .submitLabel(.next) //작성 완료하면 키보드 return 버튼이 파란색 done으로 바뀜
                .onChange(of: diaryTitle) { newValue in             // 제목 20글자까지 가능
                    if newValue.count > 20 {
                        diaryTitle = String(newValue.prefix(20))
                    }
                }
            
        } header: {
            Text("제목")
        }
        .focused($inputFocused)
    }
    
    //MARK: - 위치 등록하기
    //TODO: - 캠핑장 연동하기
    var addViewLocationInfo: some View {
//        Section {
//            TextField("위치를 등록해주세요", text: $locationInfo)
//                .padding(6)
//                .background {
//                    RoundedRectangle(cornerRadius: 2, style: .continuous)
//                        .stroke(.gray, lineWidth: 1)
//                }
//                .padding( UIScreen.screenWidth * 0.005)
//                .padding(.bottom)
//                .submitLabel(.done) //작성 완료하면 키보드 return 버튼이 파란색 done으로 바뀜
//
//        } header: {
//            Text("위치 등록하기")
//        }

        VStack {
            if campingSpot == "" {
                NavigationLink {
                    SearchByCampingSpotNameView(campingSpot: $campingSpotItem)
                } label: {
                    HStack{
                        Text("방문한 캠핑장 등록하러 가기")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.padding(.vertical)
                }
                .focused($inputFocused)
            } else {
                HStack {
                    Text("\(campingSpot)")
                        .lineLimit(1)
                    Spacer()
                    Button {
                        campingSpot = ""
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.bcBlack)
                    }
                }
            }
        }
    }
    
    //MARK: - 방문일자 등록하기
    var addViewVisitDate: some View {
        Section {
            DatePicker("방문일자 등록하기",
                       selection: $selectedDate,
                       displayedComponents: [.date])
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .environment(\.calendar, Calendar(identifier: .gregorian))
            .environment(\.timeZone, TimeZone(abbreviation: "KST")!)
            .padding(.vertical)
        }
    }
    
    //MARK: - 글 공개 여부
    var addViewIsPrivate: some View {
        HStack {
            Text("공개설정")
            Spacer()
            Button {
                diaryIsPrivate.toggle()
            } label: {
                VStack {
                    Image(systemName: diaryIsPrivate ? "lock" : "lock.open" )
                        .animation(.none)
                        .padding(.trailing, diaryIsPrivate ? 1.5 : 0)
                        .opacity(0)
                
                    
                    Text(diaryIsPrivate ? "비공개": "공개")
                        .animation(.none)
                        .font(.caption2)
                        .padding(.trailing, diaryIsPrivate ? 0 : 5)
                    
                }

            }
            .foregroundColor(.bcBlack)
            .overlay{
                Image(systemName: diaryIsPrivate ? "lock" : "lock.open" )
                    .animation(.none)
                    .padding(.trailing, diaryIsPrivate ? 1.5 : 0)
                    .padding(.bottom, 15)
            }
        }
//        .padding(.bottom)
        .padding(.vertical)

    }
    
    //MARK: - 일기 작성 뷰
    var addViewDiaryContent: some View {
        VStack {
            //            TextEditor(text: $diaryContent)
            //                .multilineTextAlignment(.leading)
            //                .frame(minHeight: 180)
            //                .focused($inputFocused)
            //            Text(diaryContent == "" ? "일기를 작성해주세요" : "")
            //                .foregroundColor(.secondary)
            //                .opacity(0.5)
            //                .position(x: 73, y: 19)
            
            //            KitTextField (
            //                label: "일기를 작성해주세요",
            //                text: $diaryContent,
            //                focusable: $fieldFocus,
            //                returnKeyType: .done,
            //                tag: 1
            //            )
            //            .padding(.bottom, 100)
            
            TextField("일기를 작성해주세요", text: $diaryContent, axis: .vertical)
                .padding(.bottom, 100)
            
            
        }
    }
    
    //MARK: - 추가버튼
    //TODO: - disable 시 회색버튼으로 만들기
    var addViewAddButton: some View {
        HStack {
            Spacer()
            Button {
                diaryStore.createDiaryCombine(diary: Diary(id: UUID().uuidString, uid: Auth.auth().currentUser?.uid ?? "", diaryUserNickName: userNickName ?? "닉네임", diaryTitle: diaryTitle, diaryAddress: campingSpotItem.contentId, diaryContent: diaryContent, diaryImageNames: [], diaryImageURLs: [], diaryCreatedDate: Timestamp(), diaryVisitedDate: selectedDate, diaryLike: [], diaryIsPrivate: diaryIsPrivate), images: diaryImages ?? [Data()])
                dismiss()
            } label: {
                Text(diaryImages?.isEmpty ?? true ? "사진을 추가해주세요" : "일기 쓰기")
            }
            .font(.headline)
            .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.07)
            .foregroundColor(.white)
            .background(diaryImages?.isEmpty ?? true ? .secondary : Color.bcGreen)
            .cornerRadius(10)
            .disabled(diaryImages?.isEmpty ?? true)
            Spacer()
            
        }
    }
    
    // MARK: 다음 버튼
    var nextButton: some View {
        HStack{
            Spacer()
            NavigationLink {
                DiaryAddContentView(isNavigationGoFirstView: $isNavigationGoFirstView, locationInfo: $locationInfo, visitDate: $visitDate, diaryIsPrivate: $diaryIsPrivate, selectedDate: $selectedDate, diaryImages: $diaryImages)
            } label: {
                Text(diaryImages?.isEmpty ?? true ? "사진을 추가해주세요" : "다음")
                    .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.07) // 이거 밖에 있으면 글씨 부분만 버튼 적용됨
            }
            .font(.headline)
            .foregroundColor(.white)
            .background(diaryImages?.isEmpty ?? true ? .secondary : Color.bcGreen)
            .cornerRadius(10)
            .disabled(diaryImages?.isEmpty ?? true)
            Spacer()
            
        }
    }
    
    //MARK: - 키보드 dismiss 함수입니다.
    func submit() {
        resignKeyboard()
    }
    //iOS 15 아래버전은 유킷연동 함수 사용
    func resignKeyboard() {
        if #available(iOS 15, *) {
            inputFocused = false
        } else {
            dismissKeyboard()
        }
    }
    
    // MARK: 앨범 접근 권한 함수.
    func checkAlbumPermission(){
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                case .authorized:
                    print("Album: 권한 허용")
                case .denied:
                    print("Album: 권한 거부")
                case .restricted, .notDetermined:
                    print("Album: 선택하지 않음")
                default:
                    break
                }
            })
        }

}


// MARK: 이미지피커 여러 장 고르기
struct PhotoPicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    
    @Binding var images: [UIImage]?
    var selectionLimit: Int
    var filter: PHPickerFilter?
    var itemProviders: [NSItemProvider] = []
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = self.selectionLimit
        configuration.filter = self.filter
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return PhotoPicker.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
        
        var parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //Dismiss picker
            picker.dismiss(animated: true)
            
            if !results.isEmpty {
                parent.itemProviders = []
                parent.images = []
            }
            
            parent.itemProviders = results.map(\.itemProvider)
            loadImage()
        }
        
        private func loadImage() {
            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    DispatchQueue.global(qos: .background).sync {
                        itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                            if let image = image as? UIImage {
                                self.parent.images?.append(image)
                                print("````````````\(self.parent.images!.count)")
                            } else {
                                print("Could not load image", error?.localizedDescription ?? "")
                            }
                        }
                    }
                }
                
            }
        }
        
    }
}




struct DiaryAddView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryAddView(isNavigationGoFirstView: .constant(false))
            .environmentObject(WholeAuthStore())
            .environmentObject(DiaryStore())
        
        DiaryAddView(isNavigationGoFirstView: .constant(false))
            .environmentObject(WholeAuthStore())
            .environmentObject(DiaryStore())
            .previewDevice("iPhone 11")
        DiaryAddView(isNavigationGoFirstView: .constant(false))
            .environmentObject(WholeAuthStore())
            .environmentObject(DiaryStore())
            .previewDevice("iPhone SE (3rd generation)")
    }
}
