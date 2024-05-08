import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    @EnvironmentObject var locationManager: LocationManager
    
        
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.setRegion(region, animated: false)
        mapView.delegate = context.coordinator
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        
        return mapView
    }
    

    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        uiView.setRegion(region, animated: true)

        for location in locationManager.locations {
            let circle = MKCircle(center: location, radius: 100 + Double(50))
            uiView.addOverlay(circle)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circleOverlay = overlay as? MKCircle {
                let circleRenderer = MKCircleRenderer(circle: circleOverlay)
                let alpha = CGFloat((500 - circleOverlay.radius + 100) / 600)
                circleRenderer.fillColor = UIColor.red.withAlphaComponent(alpha)
                circleRenderer.strokeColor = UIColor.red.withAlphaComponent(alpha)
                circleRenderer.lineWidth = 1
                return circleRenderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}


struct MapZoomView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.6761, longitude: 12.5683), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    
    var body: some View {
        VStack {
        
            MapView(region: $region)
                .edgesIgnoringSafeArea(.all)
            

        }
    }
    

    func zoomIn() {
        let newSpan = MKCoordinateSpan(latitudeDelta: max(region.span.latitudeDelta / 2.0, 0.005), longitudeDelta: max(region.span.longitudeDelta / 2.0, 0.005))
        region = MKCoordinateRegion(center: region.center, span: newSpan)
    }
    
    func zoomOut() {
        let newSpan = MKCoordinateSpan(latitudeDelta: min(region.span.latitudeDelta * 2.0, 180.0), longitudeDelta: min(region.span.longitudeDelta * 2.0, 180.0))
        region = MKCoordinateRegion(center: region.center, span: newSpan)
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapZoomView()
    }
}


