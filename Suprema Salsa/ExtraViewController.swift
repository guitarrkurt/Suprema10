//
//  ExtraViewController.swift
//  Suprema Salsa
//
//  Created by guitarrkurt on 25/01/16.
//  Copyright © 2016 miguel mexicano. All rights reserved.
//

import UIKit

class ExtraViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var idProducto: Int!
    var arrayIngreExt = []
    var arrayIngreExtrCompra         = [String]()
    var arrayIngreExtSeleccionados = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayIngreExt = ModelManager.getInstance().getIngredientesExtra(idProducto)
        tableView.setEditing(true, animated: false)
        tableView.allowsMultipleSelectionDuringEditing = true
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.tableView.backgroundColor = UIColor.clearColor()
    }
    // MARK: - Table View DATA SOURCE
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayIngreExt.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = arrayIngreExt[indexPath.row] as? String
        //cell.accessoryType = .Checkmark
        cell.tintColor = UIColor.whiteColor() // Cambia el color de la palomita de seleccion
        cell.textLabel?.textColor = UIColor.whiteColor()
        

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(patternImage: UIImage(named: "cafeClaro.png")!)
        for var i = 0; i < arrayIngreExtrCompra.count; ++i{
            if(cell.textLabel?.text != ""){
                if(cell.textLabel!.text == arrayIngreExtrCompra[i]){
                    //cell.selected = true
                    cell.setSelected(true, animated: true)

                    print(cell.textLabel?.text)

                    tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)

                    cell.selectedBackgroundView = bgColorView
                    cell.willRemoveSubview(bgColorView)
                    
                    cell.contentView.backgroundColor = UIColor(patternImage: UIImage(named: "cafeClaro.png")!)

                }
            }
        }
        
        
        return cell
    }
    // MARK: - Table View DELEGATE
    
    //Fondo NEGRO de las celdas
    internal func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            cell.backgroundColor = color
    }
    //Fondo CAFE CLARO cuando seleccionas una celda
    internal func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(patternImage: UIImage(named: "cafeClaro.png")!)
        cell!.selectedBackgroundView = bgColorView

        
        return indexPath
    }

    @IBAction func IEGuardarAndBackView(sender: UIButton) {
        var thisPath: NSIndexPath!
        var ingredienteExtra: String!
//        var cell: UITableViewCell!

        if let indexPaths = tableView.indexPathsForSelectedRows{
            for var i = 0; i < indexPaths.count; ++i{
                thisPath = indexPaths[i] as NSIndexPath
//                cell = tableView.cellForRowAtIndexPath(thisPath)
//                if(cell != nil){
//                    if (cell!.accessoryType == UITableViewCellAccessoryType.Checkmark) {
//                        print("Ingrediente Extra Seleccionado: \(cell.textLabel!.text)")
                            ingredienteExtra = arrayIngreExt[thisPath.row] as! String
                            arrayIngreExtSeleccionados.append(ingredienteExtra)
                            print("Ingrediente Extra Seleccionado: \(ingredienteExtra)")
//                    }
//                }
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
