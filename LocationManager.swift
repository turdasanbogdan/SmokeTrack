import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locations: [CLLocationCoordinate2D]
    private var locationManager: CLLocationManager?

    static let shared = LocationManager()

    override init() {
        self.locations = [
            CLLocationCoordinate2D(latitude: 55.6761, longitude: 12.5683),  // Central Copenhagen
            CLLocationCoordinate2D(latitude: 55.6763, longitude: 12.5711),
                        CLLocationCoordinate2D(latitude: 55.6750, longitude: 12.5690),
                        CLLocationCoordinate2D(latitude: 55.6770, longitude: 12.5750),
                        CLLocationCoordinate2D(latitude: 55.6745, longitude: 12.5710),
                        CLLocationCoordinate2D(latitude: 55.6780, longitude: 12.5790),
                        CLLocationCoordinate2D(latitude: 55.6720, longitude: 12.5770),
                        CLLocationCoordinate2D(latitude: 55.6800, longitude: 12.5830),
                        CLLocationCoordinate2D(latitude: 55.6790, longitude: 12.5750),
                        CLLocationCoordinate2D(latitude: 55.6765, longitude: 12.5800)
        ]
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization() 
    }

    func appendLocation(_ location: CLLocationCoordinate2D) {
        locations.append(location)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        let newCoordinate = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        DispatchQueue.main.async {
            self.appendLocation(newCoordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
}
