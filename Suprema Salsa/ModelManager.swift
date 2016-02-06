//
//  ModelManager.swift
//  DBSuprema
//
//  Created by miguel mexicano on 26/12/15.
//  Copyright © 2015 ilab. All rights reserved.
//

import UIKit
let sharedInstance = ModelManager()
class ModelManager: NSObject {
    
    var database: FMDatabase? = nil
    
    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Utility.getPath("DBSupremaSalsa.sqlite"))
        }
        return sharedInstance
    }
    func updateProductData(ProductInfo: productos) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Productos SET NombreP=?, ImagenP=?, Precio=?, DescripcionP=?, idTipoPro=?,Updates=? WHERE idProductos=?", withArgumentsInArray: [ProductInfo.NombreP, ProductInfo.ImagenP, ProductInfo.Precio,ProductInfo.DescripcionP, ProductInfo.idTipoPro, ProductInfo.Updates, ProductInfo.idProductos])
        sharedInstance.database!.close()
        return isUpdated
    }
    func updateFavorito(ProductInfo: productos) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Productos SET Favorito=? WHERE idProductos=?", withArgumentsInArray: [ProductInfo.Favorito,ProductInfo.idProductos])
        sharedInstance.database!.close()
        return isUpdated
    }
    func deleteProductData(ProductInfo: productos) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Productos WHERE idProductos=?", withArgumentsInArray: [ProductInfo.idProductos])
        sharedInstance.database!.close()
        return isDeleted
    }
    func addProductData(ProductInfo: productos) -> Bool
    {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Productos(idProductos,ImagenP,NombreP,Precio,DescripcionP,idTipoPro,Updates) VALUES (?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [ProductInfo.idProductos, ProductInfo.ImagenP, ProductInfo.NombreP, ProductInfo.Precio, ProductInfo.DescripcionP, ProductInfo.idTipoPro, ProductInfo.Updates])
        sharedInstance.database!.close()
        return isInserted
    }
    func getAllData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Productos", withArgumentsInArray: nil)
        let marrProductInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let ProductInfo : productos = productos()
                ProductInfo.idProductos = Int(resultSet.intForColumn("idProductos"))
                ProductInfo.NombreP = resultSet.stringForColumn("NombreP")
                ProductInfo.ImagenP = resultSet.stringForColumn("ImagenP")
                ProductInfo.Precio = resultSet.doubleForColumn("Precio")
                ProductInfo.DescripcionP = resultSet.stringForColumn("DescripcionP")
                ProductInfo.idTipoPro = Int(resultSet.intForColumn("idTipoPro"))
                ProductInfo.Updates = Int(resultSet.intForColumn("Updates"))
                marrProductInfo.addObject(ProductInfo)
            }
        }
        sharedInstance.database!.close()
        return marrProductInfo
    }
    func getArabe() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Productos WHERE idTipoPro = 1", withArgumentsInArray: nil)
        let marrProductInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let ProductInfo : productos = productos()
                ProductInfo.idProductos = Int(resultSet.intForColumn("idProductos"))
                ProductInfo.NombreP = resultSet.stringForColumn("NombreP")
                ProductInfo.ImagenP = resultSet.stringForColumn("ImagenP")
                ProductInfo.Precio = resultSet.doubleForColumn("Precio")
                ProductInfo.DescripcionP = resultSet.stringForColumn("DescripcionP")
                ProductInfo.idTipoPro = Int(resultSet.intForColumn("idTipoPro"))
                ProductInfo.Updates = Int(resultSet.intForColumn("Updates"))
                marrProductInfo.addObject(ProductInfo)
            }
        }
        sharedInstance.database!.close()
        return marrProductInfo
    }
    func getPastor() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Productos WHERE idTipoPro = 2", withArgumentsInArray: nil)
        let marrProductInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let ProductInfo : productos = productos()
                ProductInfo.idProductos = Int(resultSet.intForColumn("idProductos"))
                ProductInfo.NombreP = resultSet.stringForColumn("NombreP")
                ProductInfo.ImagenP = resultSet.stringForColumn("ImagenP")
                ProductInfo.Precio = resultSet.doubleForColumn("Precio")
                ProductInfo.DescripcionP = resultSet.stringForColumn("DescripcionP")
                ProductInfo.idTipoPro = Int(resultSet.intForColumn("idTipoPro"))
                ProductInfo.Updates = Int(resultSet.intForColumn("Updates"))
                marrProductInfo.addObject(ProductInfo)
            }
        }
        sharedInstance.database!.close()
        return marrProductInfo
    }
    func isFavorito(idProducto: Int) -> Bool{
        var favorito = false
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Productos WHERE idProductos=\(idProducto)", withArgumentsInArray:nil)
        
        if(resultSet != nil){
            
            resultSet.next()
            if(resultSet.intForColumn("Favorito") == 1){
                
                favorito = true
            }else{
                favorito = false
            }
        }
        sharedInstance.database!.close()
        return favorito
    }
    func getPaquete() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Productos WHERE idTipoPro = 4", withArgumentsInArray: nil)
        let marrProductInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let ProductInfo : productos = productos()
                ProductInfo.idProductos = Int(resultSet.intForColumn("idProductos"))
                ProductInfo.NombreP = resultSet.stringForColumn("NombreP")
                ProductInfo.ImagenP = resultSet.stringForColumn("ImagenP")
                ProductInfo.Precio = resultSet.doubleForColumn("Precio")
                ProductInfo.DescripcionP = resultSet.stringForColumn("DescripcionP")
                ProductInfo.idTipoPro = Int(resultSet.intForColumn("idTipoPro"))
                ProductInfo.Updates = Int(resultSet.intForColumn("Updates"))
                marrProductInfo.addObject(ProductInfo)
            }
        }
        sharedInstance.database!.close()
        return marrProductInfo
    }
    func getFavoritos() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Productos WHERE Favorito = 1", withArgumentsInArray: nil)
        let marrProductInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next(){
                let ProductInfo : productos = productos()
                ProductInfo.idProductos = Int(resultSet.intForColumn("idProductos"))
                ProductInfo.NombreP = resultSet.stringForColumn("NombreP")
                ProductInfo.ImagenP = resultSet.stringForColumn("ImagenP")
                ProductInfo.Precio = resultSet.doubleForColumn("Precio")
                ProductInfo.DescripcionP = resultSet.stringForColumn("DescripcionP")
                ProductInfo.idTipoPro = Int(resultSet.intForColumn("idTipoPro"))
                ProductInfo.Updates = Int(resultSet.intForColumn("Updates"))
                marrProductInfo.addObject(ProductInfo)
            }
        }
        sharedInstance.database!.close()
        return marrProductInfo
    }
    func getBebida() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Productos WHERE idTipoPro = 3", withArgumentsInArray: nil)
        let marrProductInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let ProductInfo : productos = productos()
                ProductInfo.idProductos = Int(resultSet.intForColumn("idProductos"))
                ProductInfo.NombreP = resultSet.stringForColumn("NombreP")
                ProductInfo.ImagenP = resultSet.stringForColumn("ImagenP")
                ProductInfo.Precio = resultSet.doubleForColumn("Precio")
                ProductInfo.DescripcionP = resultSet.stringForColumn("DescripcionP")
                ProductInfo.idTipoPro = Int(resultSet.intForColumn("idTipoPro"))
                ProductInfo.Updates = Int(resultSet.intForColumn("Updates"))
                marrProductInfo.addObject(ProductInfo)
            }
        }
        sharedInstance.database!.close()
        return marrProductInfo
    }
    /*checar ⚠️*/
    func getProductos(arrayProductos: [Int]) -> NSMutableArray{
        sharedInstance.database!.open()
        let marrProductInfo : NSMutableArray = NSMutableArray()
        
        for var i = 0; i < arrayProductos.count; ++i{
            let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Productos WHERE idProductos = \(arrayProductos[i])", withArgumentsInArray: nil)
            
            if (resultSet != nil)
            {
                let ProductInfo : productos = productos()
                while resultSet.next() {
                    
                    ProductInfo.idProductos = Int(resultSet.intForColumn("idProductos"))
                    ProductInfo.NombreP = resultSet.stringForColumn("NombreP")
                    ProductInfo.ImagenP = resultSet.stringForColumn("ImagenP")
                    ProductInfo.Precio = resultSet.doubleForColumn("Precio")
                    ProductInfo.DescripcionP = resultSet.stringForColumn("DescripcionP")
                    ProductInfo.idTipoPro = Int(resultSet.intForColumn("idTipoPro"))
                    ProductInfo.Updates = Int(resultSet.intForColumn("Updates"))
                }
                marrProductInfo.addObject(ProductInfo)
            }
        }
        print("chilaca marr.count: \(marrProductInfo.count)")
        return marrProductInfo
    }
}