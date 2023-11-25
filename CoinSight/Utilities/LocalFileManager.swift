//
//  LocalFileManager.swift
//  CoinSight
//
//  Created by SinaVN on 9/4/1402 AP.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    private init (){}
    
    func saveImage (image:UIImage , imageName : String , folderName : String){
//        create folder
    createFolderIfNeeded(folderName: folderName)
//        get path for image
        guard
            let data = image.pngData(),
            let url = getUrlForImage(imageName: imageName, folderName: folderName )
            else {return}
//    save iamge
        do{
            try data.write(to: url)
        }catch let error{
            print("error writing image to fileManager\(error) ")
            return
        }
        
    }
    
    func getImage (folderName : String , imageName : String) -> UIImage?{
        guard
            let path = getUrlForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: path.path()) else {
            print("error getting image file path")
            return nil
        }
        return UIImage(contentsOfFile: path.path())
        
                            
        
    }
    
    private func createFolderIfNeeded (folderName:String){
        guard let url = getUrlForFolder(FolderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path() ) {
            do{
                 try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true )
            }catch let error{
                print("error creating directory \(error)")
            }
                
        }
    }
    
//    url for folder
    private func getUrlForFolder (FolderName:String)->URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("error getting url for folder")
            return nil}
        return url.appending(path: FolderName)
//        return url.appendingPathComponent(FolderName)
        
    }
    
//    url for image
    private func getUrlForImage (imageName:String , folderName : String)->URL?{
        guard let FolderUrl = getUrlForFolder(FolderName: folderName) else {
            print("error getting url for image")
            return nil}
        return FolderUrl.appending(path: imageName + ".png")
//        return FolderUrl.appendingPathComponent(imageName + ".png")
    }
    
}
