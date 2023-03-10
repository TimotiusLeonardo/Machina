//
//  DetailMachineViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import UIKit
import OpalImagePicker
import Photos

class DetailMachineViewController: BaseVC {
    private var viewModel: DetailMachineViewModel
    var isTextFieldEnabled = false
    var updateState: DetailMachineViewModel.UpdatedState = .noUpdate {
        didSet {
            configureSaveButton()
        }
    }
    
    lazy var navigationBar: CustomNavigationBar = {
        let navbar = CustomNavigationBar(title: "Details")
        return navbar
    }()
    
    private lazy var statusBarView: UIView = {
        let view = UIView()
        view.layer.zPosition = 10
        view.backgroundColor = navigationBar.backgroundColor
        return view
    }()
    
    private lazy var uuidLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let view = UITextField()
        view.font = .systemFont(ofSize: 16, weight: .heavy)
        view.textColor = .black
        view.addTarget(self, action: #selector(onTextFieldUpdated), for: .editingChanged)
        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(onEditButtonTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var timePickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            pickerView.preferredDatePickerStyle = .wheels
        }
        pickerView.datePickerMode = .date
        pickerView.maximumDate = Date()
        pickerView.addTarget(self, action: #selector(didPickDateFromPicker), for: .valueChanged)
        return pickerView
    }()
    
    private lazy var imageGalleryPicker: OpalImagePickerController = {
        let pickerController = OpalImagePickerController()
        pickerController.delegate = self
        pickerController.maximumSelectionsAllowed = 10
        pickerController.imagePickerDelegate = self
        pickerController.allowedMediaTypes = Set([PHAssetMediaType.image])
        let configuration = OpalImagePickerConfiguration()
        configuration.maximumSelectionsAllowedMessage = NSLocalizedString("You cannot select that many images!", comment: "")
        pickerController.configuration = configuration
        return pickerController
    }()
    
    private lazy var machineImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Machine Image", for: .normal)
        button.addTarget(self, action: #selector(onMachineImageTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.isEnabled = false
        return button
    }()
    
    private lazy var machineImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        // set a standard item size of 60 * 60
        layout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailMachineImageCollectionViewCell.self, forCellWithReuseIdentifier: DetailMachineImageCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var machineTypeSection: DetailListView
    private var machineQrCodeNumberSection: DetailListView
    private var machineLastMaintenanceSection: DetailListView
    
    required init(viewModel: BaseViewModelContract) {
        self.viewModel = viewModel as! DetailMachineViewModel
        machineTypeSection = DetailListView(title: "Type",
                                            description: self.viewModel.viewData.type)
        machineQrCodeNumberSection = DetailListView(title: "QR Number",
                                             description: self.viewModel.viewData.qrCodeNumber)
        machineLastMaintenanceSection = DetailListView(title: "Last Maintanance",
                                                       description: self.viewModel.viewData.lastMaintenanceDate)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.requestDelegate = self
        titleTextField.text = self.viewModel.viewData.name
        uuidLabel.text = self.viewModel.viewData.uuid
        machineTypeSection.delegate = self
        machineLastMaintenanceSection.delegate = self
        machineLastMaintenanceSection.delegate = self
        machineLastMaintenanceSection.descriptionTextfield.inputView = timePickerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        [navigationBar, statusBarView, titleTextField, dividerView, machineTypeSection, machineQrCodeNumberSection, machineLastMaintenanceSection, uuidLabel, machineImageButton, machineImageCollectionView].forEach { view in
            self.view.addSubview(view)
        }
        navigationBar.configureToolbar([editButton])
        navigationBar.layoutIfNeeded()
        toggleTitleTextFieldEnabled(to: false)
        configureConstraints()
    }
    
    func configureConstraints() {
        navigationBar.anchor(top: statusBarView.bottomAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             size: .init(width: 0, height: 56))
        statusBarView.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             size: .init(width: 0, height: UIApplication.statusBarHeight))
        uuidLabel.anchor(top: navigationBar.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 32,
                                        left: 24,
                                        bottom: 0,
                                        right: 24),
                         size: .init(width: 0, height: 0))
        titleTextField.anchor(top: uuidLabel.bottomAnchor,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 8,
                                         left: 24,
                                         bottom: 0,
                                         right: 24),
                          size: .init(width: 0, height: 0))
        dividerView.anchor(top: titleTextField.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: nil,
                           trailing: view.trailingAnchor,
                           padding: .init(top: 4, left: 0, bottom: 0, right: 0),
                           size: .init(width: 0, height: 2))
        machineTypeSection.anchor(top: dividerView.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: nil,
                                  trailing: view.trailingAnchor,
                                  padding: .init(top: 32, left: 24, bottom: 0, right: 24))
        machineTypeSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        machineQrCodeNumberSection.anchor(top: machineTypeSection.bottomAnchor,
                                  leading: machineTypeSection.leadingAnchor,
                                  bottom: nil,
                                  trailing: machineTypeSection.trailingAnchor,
                                  padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        machineQrCodeNumberSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        machineLastMaintenanceSection.anchor(top: machineQrCodeNumberSection.bottomAnchor,
                                          leading: machineQrCodeNumberSection.leadingAnchor,
                                          bottom: nil,
                                          trailing: machineQrCodeNumberSection.trailingAnchor,
                                          padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        machineLastMaintenanceSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        machineImageButton.anchor(top: machineLastMaintenanceSection.bottomAnchor,
                                  leading: machineLastMaintenanceSection.leadingAnchor,
                                  bottom: nil,
                                  trailing: nil,
                                  padding: .init(top: 32, left: 0, bottom: 0, right: 0),
                                  size: .init(width: 0, height: 0))
        machineImageCollectionView.anchor(top: machineImageButton.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          bottom: nil,
                                          trailing: view.trailingAnchor,
                                          padding: .init(top: 32, left: 24, bottom: 0, right: 24),
                                          size: .init(width: 0, height: 100))
        
    }
    
    func saveMachineDetails() {
        guard let type = machineTypeSection.getValue(), !type.isEmpty,
              let maintenanceDate = machineLastMaintenanceSection.getValue(), !maintenanceDate.isEmpty,
              let name = titleTextField.text, !name.isEmpty else {
            Log("One or more field is empty")
            return
        }
        viewModel.saveMachineDetail(name: name, type: type, maintenance: maintenanceDate, onSuccess: { [weak self] in
            if self?.navigationController != nil {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.dismiss(animated: true)
            }
        })
    }
    
    func toggleTitleTextFieldEnabled(to state: Bool) {
        titleTextField.isEnabled = state
        machineImageButton.isEnabled = state
        UIView.animate(withDuration: 0.2,
                       delay: 0) {
            self.titleTextField.textColor = state ? .black : .lightGray
            self.machineImageButton.setTitleColor(state ? .systemBlue : .lightGray, for: .normal)
        }
    }
    
    func configureSaveButton() {
        var title: String {
            if isTextFieldEnabled && updateState == .updated { return "Save"}
            if isTextFieldEnabled && updateState == .noUpdate {
                editButton.setTitleColor(.red, for: .normal)
                return "Cancel"
            }
            return "Edit"
        }
        editButton.setTitleColor(.systemBlue, for: .normal)
        editButton.setTitle(title, for: .normal)
    }
}

// MARK: - OBJC functions
extension DetailMachineViewController {
    @objc func onEditButtonTapped() {
        // Toggle textfield enabled
        isTextFieldEnabled.toggle()
        configureSaveButton()
        // if it save button, we will save the updated value
        if updateState == .updated {
            saveMachineDetails()
        }
        
        [machineTypeSection, machineLastMaintenanceSection].forEach { view in
            view.toggleTextFieldEnabled(to: isTextFieldEnabled)
        }
        toggleTitleTextFieldEnabled(to: isTextFieldEnabled)
    }
    
    @objc func onMachineImageTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        present(imageGalleryPicker, animated: true)
    }
    
    @objc func onTextFieldUpdated() {
        updateState = .updated
    }
    
    @objc func didPickDateFromPicker() {
        machineLastMaintenanceSection.descriptionTextfield.text = timePickerView.date.convertToStringFormat()
        updateState = .updated
    }
}

extension DetailMachineViewController: RequestProtocol {
    func updateState(with state: ViewState) {
        switch state {
        case .idle:
            Log("Nothing to do")
        case .loading:
            Log("Nothing to do")
        case .success(let onSuccess):
            onSuccess?()
        case .error(let onError):
            onError?()
        }
    }
}

extension DetailMachineViewController: DetailListViewDelegate {
    func onUpdatedTextFieldValue() {
        updateState = .updated
    }
}

extension DetailMachineViewController: OpalImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        viewModel.saveSelectedImageUrl(assets: assets, onSuccess: { [weak self] in
            // TODO: Show pictures
            self?.updateState = .updated
            self?.machineImageCollectionView.reloadData()
            self?.imageGalleryPicker.dismiss(animated: true)
        })
    }
}

extension DetailMachineViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.viewData.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailMachineImageCollectionViewCell.identifier, for: indexPath) as? DetailMachineImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = viewModel.viewData.images[indexPath.row] as Data
        cell.setup(image: UIImage(data: data))
        
        return cell
    }
}
