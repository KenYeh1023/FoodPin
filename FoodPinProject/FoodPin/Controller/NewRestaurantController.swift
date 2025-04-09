//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by Ken on 2025/4/5.
//

import UIKit
import SwiftData

class NewRestaurantController: UITableViewController {
    
    var dataStore: RestaurantDataStore?
    
    @IBAction func saveRestaurant(sender: UIBarButtonItem) {
        if nameTextField.text?.isEmpty ?? false ||
            typeTextField.text?.isEmpty ?? false ||
            addressTextField.text?.isEmpty ?? false ||
            phoneTextField.text?.isEmpty ?? false ||
            descriptionTextView.text.isEmpty {
            
            let warningAlertController = UIAlertController(title: "Opps", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            warningAlertController.addAction(okAction)
            
            self.present(warningAlertController, animated: true)
        }
        
        if let restaurant = restaurant {
            restaurant.name = nameTextField.text ?? ""
            restaurant.type = typeTextField.text ?? ""
            restaurant.location = addressTextField.text ?? ""
            restaurant.phone = phoneTextField.text ?? ""
            restaurant.summary = descriptionTextView.text
            restaurant.isFavorite = false
            
            if let image = photoImage.image {
                restaurant.image = image
            }
            RestaurantManager.shared.mainContext.insert(restaurant)
            
            do {
                try RestaurantManager.shared.mainContext.save()
            } catch {
                print(error)
            }
            print("Saving data to database...")
        }
        
        dismiss(animated: true) {
            self.dataStore?.fetchRestaurantData()
        }
    }
    
    @IBOutlet var photoImage: UIImageView! {
        didSet {
            photoImage.layer.cornerRadius = 10.0
            photoImage.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 10.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customize the navigation bar appearance
        if let appearance = navigationController?.navigationBar.standardAppearance {
            if let customFont = UIFont(name: "Nunito-Bold", size: 30.0) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        //取得 super view 的佈局
        let margins = photoImage.superview!.layoutMarginsGuide
        //關閉自動調整大小, 以程式來使用自動佈局
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        //定位 photo image 的 leading 為邊距的 leading
        photoImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        //定位 photo image 的 trailing 為邊距的 trailing
        photoImage.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        //定位 photo image 的 top 為邊距的 top
        photoImage.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        //定位 bottom 為邊距的 bottom
        photoImage.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        //加入關閉 keyboard editing
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        restaurant = Restaurant()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true)
                }
            }
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    
                    self.present(imagePicker, animated: true)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            //iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath){
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            present(photoSourceRequestController, animated: true)
        }
    }
}

// MARK: - UIIMagePickerControllerDelegate
extension NewRestaurantController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImage.image = selectedImage
            photoImage.contentMode = .scaleAspectFill
            photoImage.clipsToBounds = true
        }
        
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NewRestaurantController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
}
