//
//  MCALifeGraphSelectionViewController.swift
//  Mass Class App
//
//  Created by Christian Flanders on 4/21/18.
//  Copyright © 2018 Origin Valley. All rights reserved.
//

import UIKit

class MCALifeGraphSelectionViewController: UIViewController {

    
    @IBOutlet weak var addIconButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var changeBackgroundButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    enum ButtonOptions {
        case addIcon, addImage, addNote,changeBackground, cancel
    }
    
    var buttonSelected: ButtonOptions!
    
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setCosmetics()
    }

    
    func setCosmetics() {
        addIconButton.drawCornerRadius(Constants.buttonCornerRadius)
        addNoteButton.drawCornerRadius(Constants.buttonCornerRadius)
        addImageButton.drawCornerRadius(Constants.buttonCornerRadius)
        changeBackgroundButton.drawCornerRadius(Constants.buttonCornerRadius)
    }
    
    @IBAction func addIconButtonPressed(_ sender: UIButton) {
        buttonSelected = .addIcon
        performSegue(withIdentifier: Constants.returnToGraphIdentifier, sender: self)
    }
    
    @IBAction func addNoteButtonPressed(_ sender: UIButton) {
        buttonSelected = .addNote
        performSegue(withIdentifier: Constants.returnToGraphIdentifier, sender: self)

    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        buttonSelected = .addImage
        importPicture()
    }
    
    @IBAction func changeBackgroundButtonPressed(_ sender: UIButton) {
        buttonSelected = .changeBackground
        performSegue(withIdentifier: Constants.returnToGraphIdentifier, sender: self)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        buttonSelected = .cancel
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.returnToGraphIdentifier {
            guard let selection = buttonSelected else { return }
             let source = segue.destination as! MCALifeGraphViewController
            switch selection {
            case .addIcon :
                print("1")
                source.addNewGenericIcon()
            case .addImage:
                guard let image = selectedImage else { return }
                source.addImageIcon(image:image)
                print("2")
            case .addNote:
                source.addNoteIcon()
                print("note")
            case .changeBackground:
                print("background")
            case .cancel:
                print("Cancel")
            }
        }
    }
    
    func addImageIcon(with image: UIImage) {
        
    }
    func importPicture() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true) {
//            self.performSegue(withIdentifier: Constants.returnToGraphIdentifier, sender: self)
        }
    }
}


extension MCALifeGraphSelectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
//        dismiss(animated: true)
        
        selectedImage = image
        
        performSegue(withIdentifier: Constants.returnToGraphIdentifier, sender: self)

    }

    
    
}
