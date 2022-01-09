//
//  CodeScannerController.swift
//  InventoryList
//
//  Created by  Paul on 09.01.2022.
//

import UIKit
import AVFoundation

class CodeScannerController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topBar: UIView!
    
    // MARK: - Private vars
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var codeFrameView: UIView?
    private let supportedCodeTypes: [AVMetadataObject.ObjectType] = [.upce,
                                                                     .code39,
                                                                     .code39Mod43,
                                                                     .code93,
                                                                     .code128,
                                                                     .ean8,
                                                                     .ean13,
                                                                     .aztec,
                                                                     .pdf417,
                                                                     .itf14,
                                                                     .dataMatrix,
                                                                     .interleaved2of5,
                                                                     .qr]
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            print(error.localizedDescription)
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer!.videoGravity = .resizeAspectFill
        videoPreviewLayer!.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(topBar)
        
        codeFrameView = UIView()
        
        if let codeFrameView = codeFrameView {
            codeFrameView.layer.borderColor = UIColor.green.cgColor
            codeFrameView.layer.borderWidth = 2
            view.addSubview(codeFrameView)
            view.bringSubviewToFront(codeFrameView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection = videoPreviewLayer?.connection  {
            let orientation = UIDevice.current.orientation
            if connection.isVideoOrientationSupported {
                switch orientation {
                case .portrait:
                    updatePreviewLayer(layer: connection, orientation: .portrait)
                    break
                case .landscapeRight:
                    updatePreviewLayer(layer: connection, orientation: .landscapeLeft)
                    break
                case .landscapeLeft:
                    updatePreviewLayer(layer: connection, orientation: .landscapeRight)
                    break
                case .portraitUpsideDown:
                    updatePreviewLayer(layer: connection, orientation: .portraitUpsideDown)
                    break
                default:
                    updatePreviewLayer(layer: connection, orientation: .portrait)
                    break
                }
            }
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    // MARK: - Private funcs
    
    private func recognized(code: String) {
        
        guard presentedViewController != nil else { return }
        
        captureSession.stopRunning()
        messageLabel.text = code
        
        let alert = UIAlertController(title: "Recognized", message: "Code is: \(code)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "unwindToEditScreen", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.codeFrameView?.frame = CGRect.zero
            self?.messageLabel.text = "No code is detected"
            self?.captureSession.startRunning()
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = view.bounds
    }
    
}

extension CodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            codeFrameView?.frame = .zero
            messageLabel.text = "No code is detected"
            return
        }
        
        if supportedCodeTypes.contains(metadataObj.type) { // Not needed
            if let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) {
                codeFrameView?.frame = barCodeObject.bounds
            }
            
            if let stringValue = metadataObj.stringValue {
                recognized(code: stringValue)
            }
        }
    }
    
}
