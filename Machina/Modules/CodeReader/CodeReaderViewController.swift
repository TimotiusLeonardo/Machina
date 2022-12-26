//
//  CodeReaderViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit
import AVFoundation

class CodeReaderViewController: BaseVC {
    private var viewModel: CodeReaderViewModel
    
    lazy var navigationBar = CustomNavigationBar(text: "Code Reader")
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    required init(viewModel: BaseViewModelContract) {
        self.viewModel = viewModel as! CodeReaderViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.requestDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        createViews()
    }
    
    func createViews() {
        [navigationBar].forEach { view in
            self.view.addSubview(view)
        }
        configureQRCodeScanner()
        configureConstraints()
    }
    
    func configureQRCodeScanner() {
        // Create capture device
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        guard let previewLayer = previewLayer else { return }
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global().async {
            captureSession.startRunning()
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func configureConstraints() {
        navigationBar.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor)
    }
}

extension CodeReaderViewController: RequestProtocol {
    func updateState(with state: ViewState) {
        //
    }
}

extension CodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        Log(code)
        
        if code.contains("x") {
            showFoundCodeAlertView(isError: true)
        } else {
            showFoundCodeAlertView(isError: false)
        }
    }
    
    func showFoundCodeAlertView(isError: Bool) {
        if isError {
            let alertView = viewModel.createAlertView(title: "Error scanned QR",
                                                      message: "This code is not found in your machine's database, please try another QR scan")
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.captureSession?.startRunning()
            }))
            self.present(alertView, animated: true)
        } else {
            // Present new page for available machine detail
        }
    }
}
