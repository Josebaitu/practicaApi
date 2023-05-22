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
        // usamos "!" porque sabemos que esta URL está bien formada
        let url = URL(string: "https://randomuser.me/api/")!
        let request = URLRequest(url: url)
        // definimos la query y le decimos que hacer cuando se complete (todavía no estamos ejecutándola)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            // Este trozo de código se está ejecutando en un hilo secundario para dejar el hilo principal libre
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                guard let datosDecodificados = try? JSONDecoder().decode(Informacion.self, from: data) else {
                    fatalError("algo estás haciendo mal en la decodificación :)")
                }
                self.informacionMia = datosDecodificados.results
                // Refresca la interfaz de usuario en el hilo principal
                DispatchQueue.main.async {
                    // El hilo principal es un núcleo del procesador del móvil que se encarga de actualizar la pantalla,
                    // recoger la interacción del usuario, y otras tareas que siempre tienen que responder al momento.
                    // Si intentas hacer una operación compleja en el hilo principal (como una petición de red o una
                    // operación matemática complicada), el hilo principal va a estar ocupado haciendo esa operación
                    // y la pantalla se va a congelar. Apple nunca permite eso, y de hecho si intentas publicar una app
                    // así te la rechazará. Es por eso que Xcode te avisa de que estás haciéndolo mal
                    self.miTabla.reloadData()
                }
            }
        }
        // le decimos a la query que se ejecute
        dataTask.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return informacionMia.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let celda = miTabla.dequeueReusableCell(withIdentifier: "celdaInfo", for: indexPath)
    let info = informacionMia[indexPath.row]
    celda.textLabel?.text = info.email
    celda.detailTextLabel?.text = info.gender
    
    return celda
}


}
