//
//  ViewController.swift
//  projrct10
//
//  Created by Tigran on 12/7/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))

    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        let ac = UIAlertController(title: "Delete or Rename name?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }
        let rename = UIAlertAction(title: "Rename Person", style: .default) {
            [weak self] _ in
            
            let newAc = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
            newAc.addTextField()
            
            newAc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            newAc.addAction(UIAlertAction(title: "OK", style: .default){
                [weak self, weak newAc] _ in
                guard let newName = newAc?.textFields?[0].text else { return }
                person.name = newName
                
                self?.collectionView.reloadData()
            })
            
            self?.present(newAc,animated: true)
        }
        
        ac.addAction(delete)
        ac.addAction(rename)
        
        present(ac,animated: true)
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else { fatalError("Unable") }
    
        let person = people[indexPath.item]
        let path = getDocumetsDirectory().appendingPathComponent(person.image)
        cell.name.text = person.name
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
    
        
        
        return cell
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumetsDirectory().appendingPathComponent(imageName)
        
        if let jpegImage = image.jpegData(compressionQuality: 0.8) {
            try? jpegImage.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumetsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
