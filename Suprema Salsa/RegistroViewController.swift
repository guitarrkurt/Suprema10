//
//  ViewController.swift
//  SSSSSSSS
//
//  Created by Miguel Angel on 15/12/15.
//  Copyright © 2015 Miguel Angel. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
//    @IBOutlet weak var nombrePerfil: UILabel!
//    @IBOutlet weak var apellidosPerfil: UILabel!
    
    var alertController: UIAlertController!
    var okAction: UIAlertAction!
    
    //Clase persona que contiene todos los atributos del REGISTRO
    var p = persona()
    
    //Seleccionar imagenes galeria
    //NOTA: Es diferente IMAGE PICKER vs. DATE PICKER
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var fotoPerfil: UIButton!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var codigoPostal: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Slide Out Menu
        if(self.revealViewController() != nil){
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Cambiamos el color de texto DATE PICKER
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")

        //Seleccionar imagenes galeria
        //NOTA: Es diferente IMAGE PICKER vs. DATE PICKER
        imagePicker.delegate = self

        
        //Poner la imagen redonda y con borde
        fotoPerfil.layer.borderWidth=5.0
        fotoPerfil.layer.masksToBounds = false
        fotoPerfil.layer.borderColor = UIColor(patternImage: UIImage(named: "cafeClaro.png")!).CGColor
        fotoPerfil.layer.cornerRadius = fotoPerfil.frame.size.height/2
        fotoPerfil.clipsToBounds = true

    }

    
    @IBAction func cambiarFotoPerfil(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)

        
    }
    
    //Cuando el valor del DATE PICKER cambie
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.stringFromDate(sender.date)
        
        print("Fecha cumpleaños (strDate): \(strDate)")
        self.p.cumpleanos = strDate
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    internal func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            fotoPerfil.contentMode = .ScaleAspectFill
            fotoPerfil.setImage(pickedImage, forState: .Normal)

        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    internal func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Boton, envia CODIGO SEGURIDAD verificar los datos sean correctos
    @IBAction func codigoSeguridad(sender: UIButton) {
    let cdsTitle = "Código Seguridad 🔓"
    let cdsMessage = "Por favor ingrese un código de seguridad. El cual permite que sus compras tengan mayor protección"
    let difPassTitle = "No coinciden ⚠️"
    let difPassMessage = "Por favor verifica que ambos códigos de seguridad sean identicos."
    let camposObliTitle = "Campos obligatorios ⚠️"
    let camposObliMessage = "Los campos marcados con \'*\' son obligatorios. Por favor completa todos los campos."
        
    //Conseguimos todos los campos
    p.nombre = self.nombre.text
    p.apellidos = self.apellidos.text
    p.correo = self.correo.text
    p.telefono = self.telefono.text
    p.direccion = self.direccion.text
    p.codigoPostal = self.codigoPostal.text
    print("cumple: \(self.p.cumpleanos)")
        
        //Si todos los campos marcados con * estan LLENOS
        if(p.nombre != "" && p.apellidos != "" && p.correo != "" && p.telefono != "" && p.direccion != "" && p.codigoPostal != ""){
            
            //Creamos el ALERT CONTROLLER
            alertController = UIAlertController(title: cdsTitle, message: cdsMessage, preferredStyle: .Alert)

            //Agregamos CAMPOS DE TEXTO[0]
            alertController.addTextFieldWithConfigurationHandler {       // Manejador normal seria:
                (txtPassword) -> Void in                                 // (txtEmail) -> Void in
                txtPassword.secureTextEntry = true                       //
                txtPassword.placeholder = "<Ingresa aquí tu contraseña>" // txtEmail.placeholder = "<Your email here>"
            }
            //Agregamos CAMPO DE TEXTO[1]
            alertController.addTextFieldWithConfigurationHandler {
                (txtPassword) -> Void in
                txtPassword.secureTextEntry = true
                txtPassword.placeholder = "<Confirma tu contraseña>"
            }
            //Agregamos la accion GUARDAR
            okAction = UIAlertAction(title: "Guardar 🔒", style: .Default, handler: {
                (action) -> Void in
                
                //Preguntamos SI las DOS CONTRASENAS son las MISMAS
                if(self.alertController.textFields![0].text == self.alertController.textFields![1].text){
                    
                    let alert = UIAlertController(title: "Datos Guardados Correctamente", message: "Empieza a disfrutar de nuestras promociones ¡Hazte Supremo! 🌮", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "❤️", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                //Sino son LAS MISMAS
                }else{
                    
                    let alert = UIAlertController(title: difPassTitle, message: difPassMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            })
            //Agregamos la ACCION
            alertController.addAction(okAction)
            //Presentamos la ALERTA
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: camposObliTitle, message: camposObliMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }

    
    
}

