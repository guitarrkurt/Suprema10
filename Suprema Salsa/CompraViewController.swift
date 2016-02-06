//
//  CarritoViewController.swift
//  Suprema Salsa
//
//  Created by Miguel Angel on 11/01/16.
//  Copyright © 2016 miguel mexicano. All rights reserved.
//

import UIKit
protocol ComprasDelegated{
    func UpdateArrayCompra(newArrayCompra: [Int])
}

class CompraViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, CuponesDelegated {
    @IBOutlet weak var totalLabel: UILabel!
   //Animacion
    @IBOutlet weak var animacionBackground: UIView!
    @IBOutlet weak var animacionFigure: UIImageView!
    
    @IBOutlet weak var animacionCross: UIButton!
    @IBOutlet weak var agregarCupon: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var arrayCompra    = [Int]()
    var imageList = [UIImage]()
    let fileManager             = NSFileManager.defaultManager()
    var compras: NSMutableArray!
    var producto       : productos!
    let paths          : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var receivedData: NSMutableData!
    var esclavo: ComprasDelegated? = nil
    var cupon: Cupones = Cupones()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receivedData = NSMutableData(capacity: 0)

        //Agregamos el logo de la suprema en el top navigation bar
        let topNB = UIImage(named: "logo_top_navigationbar_120x35px.png")
        let topNBView = UIImageView(image: topNB)
        self.navigationItem.titleView = topNBView
        
        //Ocultamos los objetos de animacion
        ocultarObjetosAnimacion()
        //Transparencia de la table
        tableView.backgroundColor = UIColor.clearColor()

        compras = ModelManager.getInstance().getProductos(arrayCompra)

        
//        //FROM NewsTableViewController (CUPONES)
//        cupon.Imagen != nil{
//        
//        }
//        if arrayCuponInfo.count != 0 {
//            println("entra arrayCupon")
//            //Boton Cupon
//            var imagen = arrayCuponInfo.objectAtIndex(0) as! UIImage
//            botonCupon.setImage(imagen, forState: .Normal)
//            //Etiqueta total
//            var precioConCupon = total - (arrayCuponInfo.objectAtIndex(2) as! NSString).floatValue
//            etiquetaTotal.text = "Antes: $ \(total) - Cupon: \' \(arrayCuponInfo.objectAtIndex(1) as! String) \'\nTotal: $ \(precioConCupon) "
//            //Precio From Cupon
//            
//            arrayCuponInfo = []
//        }
        
        self.totalLabel.text = "Total: \(calcularPrecioTotal())"
        
        for i in 1...72{
            let imageName = "lss_tracker_\(i)"
            imageList.append(UIImage(named: imageName)!)
        }
    }
    func calcularPrecioTotal() -> Double{
        var suma = Double()
        for var i = 0; i < arrayCompra.count; ++i{
            producto = compras[i] as! productos
            suma += producto.Precio
            print("suma: \(suma)")
        }
        return suma
    }
    // MARK: - TableView DATA SOURCE
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayCompra.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellCompra", forIndexPath: indexPath) as! CompraTableViewCell
        
        producto = compras[indexPath.item] as! productos
        
        let getImagePath = (paths as NSString).stringByAppendingPathComponent(producto.ImagenP)
        
        
        if (fileManager.fileExistsAtPath(getImagePath))
        {
            let imageis: UIImage = UIImage(contentsOfFile: getImagePath)!
            cell.figura.image = imageis
        }
        
        cell.producto.text = producto.NombreP
        cell.precio.text = "\(producto.Precio)"
        
        return cell
    }
    // MARK: - TableView DELEGATE
    internal func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
    
        let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        cell.backgroundColor = color
    }
    
    internal func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let button = UITableViewRowAction(style: .Default, title: "Eliminar", handler: {
        (action, indexPath) in
           self.arrayCompra.removeAtIndex(indexPath.row)
            self.compras.removeObjectAtIndex(indexPath.row)
            //delegado
            if self.esclavo != nil {
            self.esclavo?.UpdateArrayCompra(self.arrayCompra)
            }
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.totalLabel.text = "Total: \(self.calcularPrecioTotal())"
        
        })
        
        button.backgroundColor = UIColor.redColor()
        return [button]
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    @IBAction func enviarPedido(sender: UIButton) {
        print("idsCompra: \(arrayCompra)")
      self.enviarDatos()
    
    }
    
    
    
    func enviarDatos()
    {
        var index=0
        let idusuario=4;
            let url = NSURL(string: "http://supremasalsa.azurewebsites.net/movil/RecibirPedido.php");
            let request = NSMutableURLRequest(URL: url!)
       
        var cadena="["
        
        for index = 0; index < arrayCompra.count-1; ++index {
        cadena+="{\"id\":\(arrayCompra[index]),\"usuario\":\(idusuario)},"
        }
        
        cadena+="{\"id\":\(arrayCompra[index]),\"usuario\":\(idusuario)}]"

        
           request.HTTPMethod = "POST"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        
            let bodyData="json=\(cadena)"
            
            print(bodyData)
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
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
            let str = NSString(data: receivedData, encoding: NSASCIIStringEncoding)!
            
            print(str)
            
            // create the alert
            let alert = UIAlertController(title: "Enviado 🔵", message: "Su pedido a sido enviado satisfactoriamente, espere aproximadamente 30 minutos a nuestro repartidor, muchas gracias!!! ✅", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok ☑️", style: UIAlertActionStyle.Default, handler: { action in
                
                self.descoultarObjetosAnimacion()
                self.runAnimacion()
                
            }))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            

            
            
        }

    func ocultarObjetosAnimacion(){
        //Ocultamos los objetos de animacion
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.8
        self.animacionBackground.layer.addAnimation(animation, forKey: nil)
        //self.animacionFigure.layer.addAnimation(animation, forKey: nil)
        //self.animacionCross.layer.addAnimation(animation, forKey: nil)
        
        self.animacionBackground.hidden = true
        self.animacionFigure.hidden = true
        self.animacionCross.hidden = true
    }
    func descoultarObjetosAnimacion(){
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.8
        self.animacionBackground.layer.addAnimation(animation, forKey: nil)
        
        self.animacionBackground.hidden = false
        self.animacionFigure.hidden = false
        self.animacionCross.hidden = false
    }
    func runAnimacion(){
        self.animacionFigure.animationImages = imageList
        //Media Hora
        //let time = 1800.0
        let time =  25.0
        

        self.animacionFigure.animationDuration = time
        self.animacionFigure.animationRepeatCount = 1
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        self.animacionFigure.startAnimating()
        

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
            {
                // do your task...
                var bandTerminoAnimacion = false
                var bandSalirHilo = false
                while(true)
                {
                    if(self.animacionFigure.isAnimating() == false)
                    {
                        bandTerminoAnimacion = true
                        
                        if self.esclavo != nil {
                            self.arrayCompra.removeAll()
                            self.esclavo?.UpdateArrayCompra(self.arrayCompra)
                            //navigationController?.popToRootViewControllerAnimated(true)
                        }
                    }
                    if(bandSalirHilo == true){

                        break
                    }
                    dispatch_async(dispatch_get_main_queue())
                    {
                            if(bandTerminoAnimacion == true)
                            {
                                self.ocultarObjetosAnimacion()
//                                self.navigationItem.setHidesBackButton(false, animated:true)
//                                
//                                self.agregarCupon.setImage(UIImage(named: "cupon_1.png"), forState: .Normal)
//                                self.tableView.reloadData()
                            
                                self.navigationController?.popViewControllerAnimated(true)
                                
                                bandSalirHilo = true
                            }
                    }

                }

        }

    }
    @IBAction func closeAnimation(sender: AnyObject) {
        // create the alert
        let alert = UIAlertController(title: "Salir ⚠️", message: "Al salir el cronometro se cerrara y podra consultar la carta o hacer nuevos pedidos", preferredStyle: UIAlertControllerStyle.Alert)
        // add an action (button)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler: { action in
            self.animacionFigure.stopAnimating()
            //self.ocultarObjetosAnimacion()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))

        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    @IBAction func agregarCupon(sender: UIButton) {
        performSegueWithIdentifier("CuponIdentifier", sender: self)
    }

    func cargarCuponCompras(newCupon: Cupones, newImagen: UIImage){
        //Haz algo con cupon
        print("\(newCupon.Imagen)")
        self.agregarCupon.setImage(newImagen, forState: .Normal)
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CuponIdentifier"){
            let cuponesVC = segue.destinationViewController as! CuponesViewController
            cuponesVC.arrayCompra = arrayCompra
            cuponesVC.bandOcultarSlideOutMenu = true
            cuponesVC.esclavoCupones = self

        }
    }

}
