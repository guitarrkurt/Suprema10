//
//  ComprasViewController.swift
//  Suprema Salsa
//
//  Created by guitarrkurt on 08/11/15.
//  Copyright © 2015 miguel mexicano. All rights reserved.
//

import UIKit
import AVFoundation
import Social

class CartaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ComprasDelegated{
//, IngredientesExtraDelegate {
    // MARK: - Propertys
    /*Arrays*/
    
    var internet = Internet()
    var arrayQuery     : NSMutableArray!
    var producto       : productos!
    var arrayFavoritos : [String]!// Persistencia favoritos
    var marrProductData: NSMutableArray!// Almacena la consulta ModelManager.getInstance().getAllData()
    var arrayCompra    = [Int]()
    /*Variables*/
    var EnvioIdentificador      = 0
    var formatoURLImage: NSURL!
    let paths          : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let fileManager             = NSFileManager.defaultManager()
    var arrayIngreExtrCompra         = [String]()
    /*Referencias Views - View Principal*/
    @IBOutlet weak var segmentedControl   : ADVSegmentedControl!// Segmented Control
    @IBOutlet var ViewContenedorBack      : UIView!
    @IBOutlet weak var ViewDetailedInfo   : UIView!
    @IBOutlet weak var cartaCollectionView: UICollectionView!
    @IBOutlet weak var menuButton         : UIBarButtonItem!// Slide out menu
    @IBOutlet weak var carritoBarButton   : UIBarButtonItem!{
        didSet{
            carritoBarButtonDidSet("carrito_panel_superior") // Agregamos una animacion y un target a "carritoBarButton"
        }
    }
    /*Size Views - View Principal*/
    let screenSize                            = UIScreen.mainScreen().bounds
    var ViewContenedorBackSizePortraitWidth   : CGFloat!
    var ViewContenedorBackSize                : CGRect!
    /*Referencias a elementos - Vista Detallada Del Producto*/
    @IBOutlet weak var VDSouthImage    : UIImageView!
    @IBOutlet weak var VDPrecio        : UILabel!
    @IBOutlet weak var VDNombreProducto: UILabel!
    @IBOutlet weak var VDExtra  : UIButton!
    
    @IBOutlet weak var VDLeftImage    : UIImageView!
    @IBOutlet weak var VDLogoTiff      : UIImageView!
    @IBOutlet weak var VDFavoritos     : UIButton!
    @IBOutlet weak var VDCompartir     : UIButton!
    
    // MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Inicializacion Propertys*/
        self.arrayQuery             = NSMutableArray()
        self.producto               = productos()
        self.arrayFavoritos         = [String]()
        self.ViewContenedorBackSize = ViewContenedorBack.bounds
        self.formatoURLImage        = NSURL()
        
        
        //Comprobar si hay internet
        if(internet.InternetHer())
        {
            self.ActualizarDB(0)
            cartaCollectionView.reloadData()
        }
        else
        {
            
            self.arrayQuery=[]
            self.arrayQuery=ModelManager.getInstance().getAllData()
            cartaCollectionView.reloadData()
            let alert = UIAlertView()
            alert.title = "Conexion a Internet ⚠️"
            alert.message = "Para Poder Realizar tu Compra 💳 se requiere conexion a internet. Verifica tu conexión a internet activando tus datos moviles o desde Configuración -> WiFi en tu dispositivo 📲"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
        }
        
        self.ViewDetailedInfo.hidden = true// Ocultamos el View Detailed Info para que se vea Carta Collection View
        
        //Slide Out Menu
        if(self.revealViewController() != nil){
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //Mexi ⚠️
       
        self.FavoritoOFF(1)
        
        /*Diseno Layout*/
        self.automaticallyAdjustsScrollViewInsets = false// Esta linea de codigo se pone porque xcode mueve nuestro UICollectionViewCell
        cartaCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "costillasBackGroundCollectionView.jpg")!)// Cambiamos el background de nuestra Carta Collection View
        
        let topNB = UIImage(named: "logo_top_navigationbar_120x35px.png")// 1 Agregamos el logo de la suprema en el top navigation bar
        let topNBView = UIImageView(image: topNB)// 2 Agregamos el logo de la suprema en el top navigation bar
        self.navigationController?.navigationBar.topItem?.titleView = topNBView// 3 Agregamos el logo de la suprema en el top navigation bar
        ViewContenedorBack.backgroundColor = UIColor(patternImage: UIImage(named: "launch_screen_ipad_1536x2048.jpg")!)//Principalmente se refleja en el background(fondo) del segmented
    
    }
    
    // MARK: - SEGMENTED CONTROL
    @IBAction func segmentedControlAction(sender: ADVSegmentedControl) {
        if(sender.selectedIndex == 0){// Todo 🍴
            self.arrayQuery=[]
            self.arrayQuery=ModelManager.getInstance().getAllData()
            cartaCollectionView.reloadData()
            if(self.ViewDetailedInfo.hidden == false){ self.ViewDetailedInfo.hidden = true}
        }
        else if(sender.selectedIndex == 1){// Pastor 🌮
           self.arrayQuery=[]
        self.arrayQuery=ModelManager.getInstance().getPastor()
            cartaCollectionView.reloadData()
            if(self.ViewDetailedInfo.hidden == false){ self.ViewDetailedInfo.hidden = true}
        }
        else if(sender.selectedIndex == 2){// Arabe 🌯
             self.arrayQuery=[]
            self.arrayQuery=ModelManager.getInstance().getArabe()
            cartaCollectionView.reloadData()
            if(self.ViewDetailedInfo.hidden == false){ self.ViewDetailedInfo.hidden = true}
        }
        else if(sender.selectedIndex == 3){//Bebida 🍻
           self.arrayQuery=[]
           self.arrayQuery=ModelManager.getInstance().getBebida()
            cartaCollectionView.reloadData()
            if(self.ViewDetailedInfo.hidden == false){ self.ViewDetailedInfo.hidden = true}
        }
        else if(sender.selectedIndex == 4){// Promo o Paquetes 📦
            self.arrayQuery=[]
            self.arrayQuery=ModelManager.getInstance().getPaquete()
            cartaCollectionView.reloadData()
            if(self.ViewDetailedInfo.hidden == false){ self.ViewDetailedInfo.hidden = true}
        }
        else if(sender.selectedIndex == 5){//Favoritos ⭐️
            self.arrayQuery=[]
            self.arrayQuery=ModelManager.getInstance().getFavoritos()
            cartaCollectionView.reloadData()
            if(self.ViewDetailedInfo.hidden == false){ self.ViewDetailedInfo.hidden = true}
        }

    }
//    override func viewWillAppear(animated: Bool) {// Mexi
//        super.viewWillAppear(animated);
////        self.cartaCollectionView.reloadData()
//    }
    
    // MARK: - Actions
    /*Actions Vista Detallada*/
    @IBAction func VDFAvoritosAction(sender: UIButton) {
        print("id 😼: \(producto.idProductos)")
        if(ModelManager.getInstance().isFavorito(producto.idProductos)){
            sender.setImage(UIImage(named: "favoritos.png"), forState: .Normal)
            self.FavoritoOFF(producto.idProductos)
            
        }else{
            sender.setImage(UIImage(named: "star.png"), forState: .Normal)
            self.FavoritoON(producto.idProductos)
        }
    }
    @IBAction func VDExtraAction(sender: UIButton) {
        print("VDExtraAction")
        performSegueWithIdentifier("ExtraIdentifier", sender: self)
        
    }
    @IBAction func VDCompartirAction(sender: UIButton) {
        print("id 😼: \(producto.idProductos)")
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Comparte", message: "Que te gustaria compartir", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // facebook action button
        let facebookAction = UIAlertAction(title: "FaceBook", style: UIAlertActionStyle.Default) { (action) in
            print("facebook action button tapped")
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                self.presentViewController(fbShare, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        // twitter action button
        let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default) { (action) in
            print("twitter action button tapped")
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                
                let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                self.presentViewController(tweetShare, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) in
            print("Cancel action button tapped")
        }
        
        // add action buttons to action sheet
        myActionSheet.addAction(facebookAction)
        myActionSheet.addAction(twitterAction)
        myActionSheet.addAction(cancelAction)
        
        // support iPads (popover view)
        myActionSheet.popoverPresentationController?.sourceView = self.VDCompartir
        myActionSheet.popoverPresentationController?.sourceRect = self.VDCompartir.bounds
        
        // present the action sheet
        self.presentViewController(myActionSheet, animated: true, completion: nil)
    }

    @IBAction func VDCarritoAction(sender: UIButton) {// Agregar carrito action
        print("producto.NombreP: \(producto.NombreP)")
        self.arrayCompra.append(self.producto.idProductos)
        print(arrayCompra)

        switch self.arrayCompra.count{
        case 0:
            carritoBarButtonDidSet("carrito_panel_superior.png")
        case 1:
            carritoBarButtonDidSet("carrito_panel_superior_1.png")
        case 2:
            carritoBarButtonDidSet("carrito_panel_superior_2.png")
        case 3:
            carritoBarButtonDidSet("carrito_panel_superior_3.png")
        case 4:
            carritoBarButtonDidSet("carrito_panel_superior_4.png")
        case 5:
            carritoBarButtonDidSet("carrito_panel_superior_5.png")
        case 6:
            carritoBarButtonDidSet("carrito_panel_superior_6.png")
        case 7:
            carritoBarButtonDidSet("carrito_panel_superior_7.png")
        case 8:
            carritoBarButtonDidSet("carrito_panel_superior_8.png")
        case 9:
            carritoBarButtonDidSet("carrito_panel_superior_9.png")
        default:
            carritoBarButtonDidSet("carrito_panel_superior_Mas.png")
        }
        carritoBarButton_SonidoYAnimacion()
        arrayIngreExtrCompra = []
        //ocultarVistaDetallada1_3Segundos()
    }
    
    @IBAction func ocultarVistaDetallada(sender: UIButton) {
        arrayIngreExtrCompra = []
        ocultarVistaDetallada0_3Segundos()
    }
    
    func touchUpInsideCarritoBarButon_Compras(){
        if(self.arrayCompra.count != 0){
            performSegueWithIdentifier("compraIdentifier", sender: self)
            self.ViewDetailedInfo.hidden = true
        }else{
            let alert = UIAlertView()
            alert.title = "Carrito Vacio🍴"
            alert.message = "Por favor añada algo al carrito"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    // MARK: - Data Source Collection View
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrayQuery.count
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let CellCarta = collectionView.dequeueReusableCellWithReuseIdentifier("CellCarta", forIndexPath: indexPath) as! CartaCollectionViewCell
        
        producto = arrayQuery[indexPath.item] as! productos
        
        //CellCarta.imageView.image = UIImage(named: producto.ImagenP)
        let getImagePath = (paths as NSString).stringByAppendingPathComponent(producto.ImagenP)
        
        
        if (fileManager.fileExistsAtPath(getImagePath))
        {
            let imageis: UIImage = UIImage(contentsOfFile: getImagePath)!
            CellCarta.imageView.image = imageis
        }
        
        
        CellCarta.label.text = producto.NombreP
        
        CellCarta.favorito.addTarget(self, action: "botonFavoritosAction:", forControlEvents: .TouchUpInside)
        
        if(ModelManager.getInstance().isFavorito(producto.idProductos)){
            
            CellCarta.favorito.setImage(UIImage(named: "star.png"), forState: .Normal)
            
        }else{
            CellCarta.favorito.setImage(UIImage(named: "favoritos.png"), forState: .Normal)
        }
        
        return CellCarta
    }
    
    func botonFavoritosAction(sender: UIButton!){
        let theParentCell = (sender.superview?.superview as! CartaCollectionViewCell)
        let indexPathOfFavoritos = cartaCollectionView.indexPathForCell(theParentCell)
        let auxProducto = arrayQuery[indexPathOfFavoritos!.item] as! productos
        
        if(ModelManager.getInstance().isFavorito(auxProducto.idProductos)){
            sender.setImage(UIImage(named: "favoritos.png"), forState: .Normal)
            self.FavoritoOFF(auxProducto.idProductos)
            if(internet.InternetHer())
            {self.ActualizarDB(5)}
            else
            {
              self.arrayQuery=[]
              self.arrayQuery=ModelManager.getInstance().getFavoritos()
            }
            cartaCollectionView.reloadData()
        }else{
            sender.setImage(UIImage(named: "star.png"), forState: .Normal)
            self.FavoritoON(auxProducto.idProductos)
        }
    }
    
    /*Las Celdas ocupen la mitad de la pantalla*/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //Obtiene Bounds principalmente para el caso de 1/3 de pantalla
        ViewContenedorBackSize                = ViewContenedorBack.bounds//
        ViewContenedorBackSizePortraitWidth   = ViewContenedorBackSize.width//
        
        let width3 = ViewContenedorBackSize.width/3
        let width2 = ViewContenedorBackSize.width/2
        
        //Si esta en Landscape
        if(UIDevice.currentDevice().orientation.isLandscape.boolValue){
            //Si es 1/3 de pantalla
            if(ViewContenedorBackSize.width <= self.screenSize.width/2){
                return CGSize(width: width2, height: width2);
            }
                //Si es iPhone o iPad normal
            else{
                return CGSize(width: width3, height: width3);
            }
        }else{
            //Si esta en Portrait
            //Si es iPad
            if(ViewContenedorBackSizePortraitWidth > 414.0){
                return CGSize(width: width3, height: width3);
                
            }
                //Sino, si es iPhone o es 1/3 de pantalla
            else{
                return CGSize(width: width2, height: width2);
            }
        }
        
    }
    // MARK: - Portrait or Landscape
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        //Es Landscape
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            print("Landscape...")
            
            self.cartaCollectionView.reloadData()
        } else {
            //Es Portrait
            print("Portrait...")
            
            self.cartaCollectionView.reloadData()
        }
    }
    // MARK: - Delegate Collection View
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        producto = arrayQuery[indexPath.item] as! productos
        
        let getImagePath = (paths as NSString).stringByAppendingPathComponent(producto.ImagenP)
        
        if (fileManager.fileExistsAtPath(getImagePath))
        {
            let imageis: UIImage = UIImage(contentsOfFile: getImagePath)!
            self.VDLeftImage.image = imageis
            self.VDSouthImage.image = imageis
        }

        self.VDNombreProducto.text = producto.NombreP
        self.VDPrecio.text = "$\(producto.Precio)"
        
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.3
        self.ViewDetailedInfo.layer.addAnimation(animation, forKey: nil)
        
        self.ViewDetailedInfo.hidden = false
    }
    
    
    func ActualizarDB(segment: Int)
    {
    
         let identificador = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let url = NSURL(string: "http://supremasalsa.azurewebsites.net/movil/Carta2.php");
        
        let request = NSMutableURLRequest(URL: url!)
        
        
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyData="identificador=\(identificador)"
        //let bod
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?
        
        >=nil
        
        do {
            
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            
            do {
                
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSArray
            
                let product = jsonData.objectAtIndex(0) as! NSArray
                
                let eliminados = jsonData.objectAtIndex(1) as! NSArray
                
                if(product.count != 0 || eliminados.count != 0)
                {
                    let alert = UIAlertController(title: "Actualizacion", message: "Se esta actualizando la carta porfavor espere", preferredStyle: UIAlertControllerStyle.Alert)
      
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    for index in 0..<eliminados.count
                        
                    {
                        
                        let requestdelete = eliminados.objectAtIndex(index) as! NSDictionary
                        
                        let ideliminado = requestdelete.valueForKey("eliminado") as! String
                        
                        let eliminar = Int(ideliminado)!
                        
                        print("el id a eliminar es : \(eliminar)")
                        
                        self.EliminarProducto(eliminar)
                        
                    }
                    for index in 0..<product.count
                    {
                        
                        let request = product.objectAtIndex(index) as! NSDictionary
                        
                        let newProduct: productos = productos()
                        
                        let idproducto = request.valueForKey("idProductos") as! String
                        
                        let precio = request.valueForKey("Precio") as! String
                        
                        let idtipopro = request.valueForKey("idTipoPro") as! String
                        
                        let updates = request.valueForKey("Updates") as! String

                        newProduct.idProductos = Int(idproducto)!
                        
                        newProduct.ImagenP=request.valueForKey("ImagenP") as! String
                        
                        newProduct.NombreP=request.valueForKey("NombreP") as! String
                        
                        newProduct.Precio = Double(precio)!
                        
                        newProduct.DescripcionP=request.valueForKey("DescripcionP") as! String
                        
                        newProduct.idTipoPro = Int(idtipopro)!
                        
                        newProduct.Updates = Int(updates)!
                        
                        self.searchProduct(newProduct)
                        
                    }
                }
                self.arrayQuery=[]
                
                switch segment {
                    
                case 0:
                    self.arrayQuery=ModelManager.getInstance().getAllData()
                    
                    break
                    
                case 1:
                    self.arrayQuery=ModelManager.getInstance().getPastor()
                    
                    break
                    
                case 2:
                    self.arrayQuery=ModelManager.getInstance().getArabe()
                    
                    break
                    
                case 3:
                    self.arrayQuery=ModelManager.getInstance().getBebida()
                    
                    break
                case 4:
                    self.arrayQuery=ModelManager.getInstance().getPaquete()
                    
                    break
                case 5:
                    self.arrayQuery=ModelManager.getInstance().getFavoritos()
                    
                    break
                default:
                    
                    break
                    
                }
                self.dismissViewControllerAnimated(true, completion: nil)
                self.ImprimirDatos()
                
            }catch let error as NSError {
                print("Invalid JSON data: \(error.localizedDescription)")
            }
        } catch (let e) {
            print(e)
        }
    }
    
    
    func DownloadImage(cadena:String)->String
    {
        let index = cadena.startIndex.advancedBy(3)
        let cadena = cadena.substringFromIndex(index)
        let index2 = cadena.startIndex.advancedBy(11)
        let nombreimagen = cadena.substringFromIndex(index2)
        formatoURLImage     = NSURL(string: "http://supremasalsa.azurewebsites.net/\(cadena)")!
        let imageData           = NSData(contentsOfURL: formatoURLImage)!
        
        let imagen = UIImage(data: imageData)
        
        let filePathToWrite = "\(self.paths)/\(nombreimagen)"
        
        print("Ruta de la imagen: \(filePathToWrite)")
        // let imageData: NSData = UIImagePNGRepresentation(selectedImage)!
        let jpgImageData = UIImageJPEGRepresentation(imagen!, 1.0)
        self.fileManager.createFileAtPath(filePathToWrite, contents: jpgImageData, attributes: nil)
        return nombreimagen
    }
    
    
    func searchProduct(productDB: productos)
    {
        marrProductData = NSMutableArray()
        marrProductData = ModelManager.getInstance().getAllData()
        var band=0
        
        for index in 0..<marrProductData.count
        {
            let find:productos = marrProductData.objectAtIndex(index) as! productos
            
            if(productDB.idProductos == find.idProductos)
            {
                band=1
                
                productDB.ImagenP = self.DownloadImage(productDB.ImagenP)
                
                print("el producto con id: \(productDB.idProductos) va a ser actualizado")
                self.actualizarProducto(productDB)
                band=1;
                break
            }
            
        }
        
        if(band==0)
        {
            productDB.ImagenP = self.DownloadImage(productDB.ImagenP)
            print("el producto con id: \(productDB.idProductos) va a ser insertado")
            self.AgregarProducto(productDB)
        }
        
        //self.ImprimirDatos()
    }
    func EliminarProducto(idproduct: Int)
    {
        let eliminarProduct: productos = productos()
        eliminarProduct.idProductos=idproduct
        let isDeleted = ModelManager.getInstance().deleteProductData(eliminarProduct)
        if isDeleted {
            // Utility.invokeAlertMethod("", strBody: "Record deleted successfully.", delegate: nil)
        } else {
            //Utility.invokeAlertMethod("", strBody: "Error in deleting record.", delegate: nil)
        }
    }
    func actualizarProducto(updateProduct: productos)
    {
      
        let isUpdated = ModelManager.getInstance().updateProductData(updateProduct)
        if isUpdated {
            //Utility.invokeAlertMethod("", strBody: "Record updated successfully.", delegate: nil)
        } else {
            //Utility.invokeAlertMethod("", strBody: "Error in updating record.", delegate: nil)
        }
    }
    func FavoritoON(idproducto: Int)
    {
        let favorito = productos()
        favorito.idProductos = idproducto
        favorito.Favorito = 1
        
        
        let isUpdated = ModelManager.getInstance().updateFavorito(favorito)
        if isUpdated {
            //Utility.invokeAlertMethod("", strBody: "Record updated successfully.", delegate: nil)
        } else {
            //Utility.invokeAlertMethod("", strBody: "Error in updating record.", delegate: nil)
        }
    }
    
    func FavoritoOFF(idproducto: Int)
    {
        print("FavoritoOFF idproducto: \(idproducto)")
        let favorito = productos()
        favorito.idProductos = idproducto
        favorito.Favorito = 0
        
        
        let isUpdated = ModelManager.getInstance().updateFavorito(favorito)
        if isUpdated {
            //Utility.invokeAlertMethod("", strBody: "Record updated successfully.", delegate: nil)
        } else {
            //Utility.invokeAlertMethod("", strBody: "Error in updating record.", delegate: nil)
        }
    }
    
    
    func ImprimirDatos()
    {
        marrProductData = NSMutableArray()
        marrProductData = ModelManager.getInstance().getAllData()
        
        
        for index in 0..<marrProductData.count
        {
            let product:productos = marrProductData.objectAtIndex(index) as! productos
            
            print(product.idProductos)
            print(product.NombreP)
            print(product.ImagenP)
            print(product.Precio)
            print(product.DescripcionP)
            print(product.idTipoPro)
            print(product.Updates)
            print(" ")
        }
    }
    
    
    func AgregarProducto(newProduct: productos)
    {
        let isInserted = ModelManager.getInstance().addProductData(newProduct)
        if isInserted {
            //Utility.invokeAlertMethod("", strBody: "Record Inserted successfully.", delegate: nil)
        } else {
            //Utility.invokeAlertMethod("", strBody: "Error in inserting record.", delegate: nil)
        }
        
    }
    func carritoBarButtonDidSet(imagen: String){
        // using image from asset catalog
        let icon = UIImage(named: imagen)
        // need the icon size for the button
        let iconSize = CGRect(origin: CGPointZero, size: icon!.size)
        // create a button using the icon size
        let iconButton = UIButton(frame: iconSize)
        // set the button image
        iconButton.setBackgroundImage(icon, forState: .Normal)
        // put the button in the right bar button item
        carritoBarButton.customView = iconButton
        // This is to support the initial animation.
        // First stage the button to be microscopic
        carritoBarButton.customView!.transform = CGAffineTransformMakeScale(0, 0)
        
        // animate the button to normal size
        UIView.animateWithDuration(0.5,
            delay: 0.3,
            // between 0.0 and 1.0, this is the brakes applied to the bounciness
            usingSpringWithDamping: 0.5,
            // approximate pixels per second you want to explode the button
            initialSpringVelocity: 10,
            options: .CurveEaseIn,
            animations: {
                // restore the button to original size.
                // it may briefly grow past normal size,
                // depending on how high you set the spring velocity.
                self.carritoBarButton.customView!.transform = CGAffineTransformIdentity
            },
            completion: nil
        )
        
        // custom view breaks the IBAction, so set the target manually
        iconButton.addTarget(self, action: "touchUpInsideCarritoBarButon_Compras", forControlEvents: .TouchUpInside)
    }
    func carritoBarButton_SonidoYAnimacion(){
        let filePath = NSBundle.mainBundle().pathForResource("TriangleSound", ofType: "mp3")
        let fileURL = NSURL(fileURLWithPath: filePath!)
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(fileURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
        carritoBarButton.customView!.transform = CGAffineTransformMakeRotation(CGFloat(0.8))
        UIView.animateWithDuration(0.5) {
            self.carritoBarButton.customView!.transform = CGAffineTransformIdentity
        }
        
    }
    func ocultarVistaDetallada1_3Segundos(){
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 1.3
        self.ViewDetailedInfo.layer.addAnimation(animation, forKey: nil)
        
        self.ViewDetailedInfo.hidden = true
    }
    func ocultarVistaDetallada0_3Segundos(){
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.3
        self.ViewDetailedInfo.layer.addAnimation(animation, forKey: nil)
        
        self.ViewDetailedInfo.hidden = true
    }
    
    func UpdateArrayCompra(newArrayCompra: [Int]) {
        arrayCompra = newArrayCompra
        
        switch self.arrayCompra.count{
        case 0:
            carritoBarButtonDidSet("carrito_panel_superior.png")
        case 1:
            carritoBarButtonDidSet("carrito_panel_superior_1.png")
        case 2:
            carritoBarButtonDidSet("carrito_panel_superior_2.png")
        case 3:
            carritoBarButtonDidSet("carrito_panel_superior_3.png")
        case 4:
            carritoBarButtonDidSet("carrito_panel_superior_4.png")
        case 5:
            carritoBarButtonDidSet("carrito_panel_superior_5.png")
        case 6:
            carritoBarButtonDidSet("carrito_panel_superior_6.png")
        case 7:
            carritoBarButtonDidSet("carrito_panel_superior_7.png")
        case 8:
            carritoBarButtonDidSet("carrito_panel_superior_8.png")
        case 9:
            carritoBarButtonDidSet("carrito_panel_superior_9.png")
        default:
            carritoBarButtonDidSet("carrito_panel_superior_Mas.png")
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "compraIdentifier" {
           let compravc = segue.destinationViewController as! CompraViewController
            compravc.arrayCompra = arrayCompra
            compravc.esclavo = self
            
        }
        if segue.identifier == "ExtraIdentifier"{
            let compravc = segue.destinationViewController as! ExtraViewController
            print("id enviado: \(producto.idProductos)")
            compravc.idProducto = producto.idProductos
            compravc.arrayIngreExtrCompra = arrayIngreExtrCompra
        }
    }
    // Checar Mexi ⚠️
    @IBAction func unwindToCarta(segue: UIStoryboardSegue) {
        if let yellowViewController = segue.sourceViewController as? ExtraViewController {
            arrayIngreExtrCompra = yellowViewController.arrayIngreExtSeleccionados
                    for index in arrayIngreExtrCompra{
                        print(index)
                    }
        }
    }

}
