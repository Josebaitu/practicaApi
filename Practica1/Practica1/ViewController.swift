//
//  ViewController.swift
//  Practica1
//
//  Created by Joseba Iturrioz Aguirre on 19/5/23.
//

import UIKit

struct Informacion: Codable{
    let results: [Info]
    let info: [Info]
}
struct Info: Codable {
    let gender: String
    let email: String
    let phone: Int
    let cell: Int
}

class ViewController: UIViewController {

    var informacionMia: [Info] = []
    
    @IBOutlet weak var miTabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miTabla.delegate = self
        miTabla.dataSource = self
        
        buscarInformacion()
    }
    
    func buscarInformacion() {
        let urlString = "https://randomuser.me/api/"
        if let url = URL(string: urlString){
            if let dato = try? Data(contentsOf: url){
                let decodificador = JSONDecoder()
                
                if let datosDecodificados = try? decodificador.decode(Informacion.self, from: dato){
                    
                    informacionMia = datosDecodificados.results
                    miTabla.reloadData()
                }
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return informacionMia.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let celda = miTabla.dequeueReusableCell(withIdentifier: "celdaInfo", for: indexPath)
    //celda.textLabel?.text = informacionMia[indexPath]
    //celda.detailTextLabel?.text = informacionMia[indexPath]
    
    return celda
}


}
