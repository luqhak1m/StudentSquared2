//
//  ScanQR.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 06/02/2024.
//

import SwiftUI
import PhotosUI
import CodeScanner
import AVFoundation // For QR code detection from images

struct ScanQR: View {
    @State private var isPresentingScanner = false
    @State private var isPresentingImagePicker = false
    @State private var scannedCode: String?
    @State private var scannedQRCodeModel: QRCodeModel? = nil
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student{
            VStack {
                Spacer()
                
                Image("ScanQR")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 20)
                
                Button(action: {
                    isPresentingScanner = true
                }) {
                    Text("Scan QR Code")
                        .font(Font.custom("Outfit", size: 18).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(width: 218, height: 45)
                        .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                        .cornerRadius(12)
                }
                .sheet(isPresented: $isPresentingScanner, content: {
                    self.scanner
                })
                
                Button(action: {
                    isPresentingImagePicker = true
                }) {
                    Text("Scan from Library")
                        .font(Font.custom("Outfit", size: 18).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(width: 218, height: 45)
                        .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                        .cornerRadius(12)
                }
                .sheet(isPresented: $isPresentingImagePicker) {
                    ImagePickerView { image in
                        detectQRCode(in: image) { result in
                            switch result {
                            case .success(let code):
                                self.scannedCode = code
                                print("scanned code from lib")
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                            self.isPresentingImagePicker = false
                        }
                    }
                }
                .environmentObject(viewModel)
                if let scannedCode = scannedCode {
                    Button(action: {
                        print(scannedCode)
                       QRCodeModel.matchScannedQRCodeID(with: scannedCode) { result, error in
                           
                           if let qrCodeModel = result {
                               self.scannedQRCodeModel = qrCodeModel
                               print(scannedQRCodeModel?.encodedString ?? "hi")
                               
                               let point = PointModel(
                                amount: qrCodeModel.points,
                                category: .merit,
                                reason: qrCodeModel.category)
                               
                               point.savePointTodb()
                 
                               
                               let merit = Merit(
                                pointID: point.id,
                                studentID: student.studentID,
                                qrcodeID: qrCodeModel.id,
                                dateScanned: Date(),
                                staffID: qrCodeModel.staffID)
                              
                               merit.saveMeritToDb()
                               
                           } else if let error = error {
                               print("Error fetching QR code data: \(error.localizedDescription)")
                           } else {
                               print("No QR code data found for ID: \(scannedCode)")
                           }
                       }
                   }) {
                       Text("Fetch QR Code Details")
                           .font(.title2)
                           .padding()
                           .background(Color.blue)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                   }
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(.white)
        }
        
    }
    
    var scanner: some View {
        CodeScannerView(codeTypes: [.qr], completion: { result in
            if case let .success(code) = result {
                self.scannedCode = code.string
                self.isPresentingScanner = false
            }
        })
    }
    
    func detectQRCode(in image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(.failure(QRCodeError.invalidImage))
            return
        }
        
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        
        let features = detector?.features(in: ciImage)
        
        if let qrFeature = features?.first as? CIQRCodeFeature, let message = qrFeature.messageString {
            completion(.success(message))
        } else {
            completion(.failure(QRCodeError.noQRCodeFound))
        }
    }
}



struct ImagePickerView: UIViewControllerRepresentable {
    var completion: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first else { return }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.completion(image)
                    }
                }
            }
        }
    }
}

enum QRCodeError: Error {
    case invalidImage
    case noQRCodeFound
}


