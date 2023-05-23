//
//  ViewController.swift
//  Practica1
//
//  Created by Joseba Iturrioz Aguirre on 19/5/23.
//

import UIKit

struct Informacion: Codable {
    let results: [Result]
}

struct Result: Codable {
    let gender: String
    let email: String
    let phone: String // fíjate que la respuesta de la api es un string, no un Int
    let cell: String // fíjate que la respuesta de la api es un string, no un Int
}

class ViewController: UIViewController {

    var informacionMia: [Result] = []
    
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
                let decodedData = self.decodeData(data)
                self.informacionMia = decodedData.results
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

    func decodeData(_ data: Data) -> Informacion {
        do {
            let decodedData = try JSONDecoder().decode(Informacion.self, from: data)
            return decodedData
        } catch let error {
            // Si la ejecución entra aquí significa que nos hemos equivocado a la hora de
            // definir la estructura de "Informacion" y los datos no se pueden decodificar
            // correctamente. Normalmente yo miraría la respuesta del servidor y comprobaría
            // que los tipos de datos concuerdan con lo que estoy diciendo en mi código.
            // En este caso, habías cometido el error de decir que el número de teléfono y
            // la variable "cell" eran de tipo Int, cuando si miras el JSON de la respuesta
            // son de tipo String
            fatalError(error.localizedDescription)
        }
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
