//
//  CuponesViewController.swift
//  Suprema Salsa
//
//  Created by guitarrkurt on 08/11/15.
//  Copyright © 2015 miguel mexicano. All rights reserved.
//
import UIKit

protocol CuponesDelegated{
    func cargarCuponCompras(newCupon: Cupones, newImagen: UIImage)
}

class CuponesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var esclavoCupones: CuponesDelegated? = nil
    
    var arrayCompra    = [Int]()
    var receivedData: NSMutableData!
    var arrayCupones: NSMutableArray!
    var cupon: Cupones = Cupones()
    var bandOcultarSlideOutMenu = false
        
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receivedData = NSMutableData(capacity: 0)

        print("band vale: \(bandOcultarSlideOutMenu)")

        if bandOcultarSlideOutMenu == true{
            navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        }else{
            if self.revealViewController() != nil{
                menuButton.target = self.revealViewController()
                menuButton.action = "revealToggle:"
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
        
        let topNB = UIImage(named: "logo_top_navigationbar_120x35px.png")// 1 Agregamos el logo de la suprema en el top navigation bar
        let topNBView = UIImageView(image: topNB)// 2 Agregamos el logo de la suprema en el top navigation bar
        self.navigationController?.navigationBar.topItem?.titleView = topNBView// 3 Agregamos el logo de la suprema en el top navigation bar

        self.arrayCupones = NSMutableArray()
        self.arrayCupones = []
            
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.activity.startAnimating()
        self.recibirDatos()
    }
    
    func recibirDatos()
    {
        let url = NSURL(string: "http://supremasalsa.azurewebsites.net/movil/EnviarCupones.php");
        let request = NSMutableURLRequest(URL: url!)
            
        request.HTTPMethod = "POST"
            
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            
            //let bodyData="json=\(cadena)"
            
            // print(bodyData)
            //request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let con = NSURLConnection(request: request, delegate: self)
        con?.start()
    }
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        receivedData.length=0
            
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        receivedData.appendData(data)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("Error: \(error.localizedDescription): \(error.userInfo)")
    }
    func connectionDidFinishLoading(connection: NSURLConnection) {
        //self.activity.startAnimating()
        do {
            // Try parsing some valid JSON
            let jsonData = try NSJSONSerialization.JSONObjectWithData(receivedData, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                
            //let cuponesjson = jsonData.objectAtIndex(0) as! NSArray
                
            arrayCupones=[]
                
            for index in 0..<jsonData.count
            {
                let request = jsonData.objectAtIndex(index) as! NSDictionary
                print(request)
                let newCupones = Cupones()
                    
                newCupones.idPromocion = Int(request.valueForKey("idCupon") as! String)!
                //newCupones.Imagen = request.valueForKey("Imagen") as! String
                newCupones.Titulo = request.valueForKey("Titulo") as! String
                newCupones.Descripcion = request.valueForKey("Descripcion") as! String
                newCupones.Precio = Double(request.valueForKey("Precio") as! String)!
                    
                let urlImagen = request.valueForKey("Imagen") as! String
                newCupones.Imagen = "http://supremasalsa.azurewebsites.net" + (urlImagen as NSString).substringFromIndex(2)
                    
                arrayCupones.addObject(newCupones)
            }
            self.mostrarCupones()
                
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
            
        self.tableView.reloadData()
        self.activity.stopAnimating()
        self.activity.hidden = true
    }
        
    func mostrarCupones()
    {
            
        for i in 0..<arrayCupones.count
        {
            let mostcupones = arrayCupones[i] as! Cupones
                
            print("idCupon: \(mostcupones.idPromocion)")
            print("Imagen: \(mostcupones.Imagen)")
            print("Titulo: \(mostcupones.Titulo)")
            print("Descripcion: \(mostcupones.Descripcion)")
            //Ver ⚠️ lo uni que hay que hacer es poner en precio en en front-end 0.25
            //y ese se le va a multiplicar al precio total
            //precio*0.25= 25% de descuento
            print("Descuento: \(mostcupones.Precio)")
            print("")
                
        }
    }
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayCupones.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CuponesIdentifier", forIndexPath: indexPath) as! CuponesTableViewCell
            
        let cupon = arrayCupones[indexPath.row] as! Cupones
        
        cell.label.text = cupon.Titulo
        
        //IMAGEN
        let formatoURLImage = NSURL(string: cupon.Imagen)!
        let imageData = NSData(contentsOfURL: formatoURLImage)!
        cell.figura.image = UIImage(data: imageData)

        return cell
    }
    // MARK: - TableView DELEGATE
    internal func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
            
        let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        cell.backgroundColor = color
    }
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CuponesTableViewCell
        
        if (esclavoCupones != nil){
            self.cupon = self.arrayCupones[indexPath.row] as! Cupones
            
            esclavoCupones!.cargarCuponCompras(self.cupon, newImagen: cell.figura.image!)

            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    
    
    
    // MARK: - Navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

