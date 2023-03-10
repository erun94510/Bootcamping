//
//  UIScreen+Extension.swift
//  BootCamping
//
//  Created by Deokhun KIM on 2023/01/17.
//

import SwiftUI

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

//MARK: - 사용하는 컬러 익스텐션입니다.
extension Color {
    static let bcBlack = Color("BCBlack")
    static let bcGreen = Color("BCGreen")
    static let bcDarkGray = Color("BCDarkGray")
    static let bcYellow = Color("BCYellow")
    static let bcWhite = Color("BCWhite")
    
    // MARK: - 스케줄 모델에 색상 선택시 사용하는 컬러 익스텐션입니다.
    static let taskRed = Color("TaskRed")
    static let taskOrange = Color("TaskOrange")
    static let taskYellow = Color("TaskYellow")
    static let taskGreen = Color("TaskGreen")
    static let taskTeal = Color("TaskTeal")
    static let taskBlue = Color("TaskBlue")
    static let taskPurple = Color("TaskPurple")
    
}

// MARK: - 스케줄 모델에 색상 선택시 사용하는 컬러 익스텐션입니다.
/// Color[colorName]의 형태로 사용하기 위한 extension
extension Color {
    static subscript(name: String) -> Color {
        switch name {
        case "taskRed":
            return Color.taskRed
        case "taskOrange":
            return Color.taskOrange
        case "taskYellow":
            return Color.taskYellow
        case "taskGreen":
            return Color.taskGreen
        case "taskTeal":
            return Color.taskTeal
        case "taskBlue":
            return Color.taskBlue
        case "taskPurple":
            return Color.taskPurple
        default:
            return Color.accentColor
        }
    }
}

//MARK: - 키보드 dismiss extension함수입니다.
extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK: 이미지 크기를 줄이기 위한 extension
extension UIImage {
    
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }

        return renderImage
    }
}

//MARK: 이미지 크기를 줄이기 위한 extension (위의 UIImage로 스케일을 줄여서 사용)
extension Image {
    func resizeImage(imgName: String) -> Image {
        guard let img = UIImage(named: imgName)?.resize(newWidth: UIScreen.screenWidth) else { fatalError("Fail to load image") }
        return Image(uiImage: img)
    }
    func resizeImageData(data: Data) -> Image {
        guard let img = UIImage(data: data)?.resize(newWidth: UIScreen.screenWidth * 1 / 15) else { fatalError("Fail to load image") }
        return Image(uiImage: img)
        
    }
}

//MARK: 일반 텍스트 필드에 x버튼을 추가하는 Modifier
struct TextFieldClearButton: ViewModifier {
    @Binding var fieldText: String

    func body(content: Content) -> some View {
        content
            .overlay {
                if !fieldText.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            fieldText = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}

//MARK: 일반 텍스트 필드에 x버튼을 추가하는 extention
extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(fieldText: text))
    }
}
