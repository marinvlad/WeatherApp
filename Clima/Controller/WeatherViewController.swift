import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            return true
        } else {
            textField.placeholder = "Insert a city name"
            return false
        }
    }
    
    @IBAction func searchedPressed(_ sender: UIButton) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(forCity: city)
            
        }
        searchTextField.endEditing(true)
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel) {
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.temperatureString
               self.cityLabel.text = weather.cityName
               self.conditionImageView.image = UIImage(systemName: weather.coditionName)
           }
       }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(forLat: lat, forLon: lon)
        }
      }
      
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print(error)
      }
}
