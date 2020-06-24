//
//  ViewController.swift
//  mapsAssignment
//
//  Created by Shree Marella on 2020-06-23.
//  Copyright © 2020 Shree Marella. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    var myAnnotations = [CLLocation]()
        var lat : Double?
        var long : Double?
        var city : String?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
         
            let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
            tap.numberOfTapsRequired = 1
            view.addGestureRecognizer(tap)
               mapView.delegate = self
        }
        
        
        @objc func Tapped(tapges: UIGestureRecognizer ) {
             // do something here
              if(self.myAnnotations.count < 3){
              let touchPoint = tapges.location(in: mapView)
              let touchLocation = mapView.convert(touchPoint, toCoordinateFrom: mapView)
               let location = CLLocation(latitude: touchLocation.latitude, longitude: touchLocation.longitude)
               let myAnnotation = MKPointAnnotation()
                myAnnotation.coordinate = touchLocation
                
                myAnnotations.append(location)
              mapView.addAnnotation(myAnnotation)
                
                lat = myAnnotation.coordinate.latitude
                long = myAnnotation.coordinate.longitude
                myAnnotation.title = "\( getAddress(ann: myAnnotation))"
                
               
            
              }else if(self.myAnnotations.count == 3){
                let touchPoint = tapges.location(in: mapView)
                        let touchLocation = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                         let location = CLLocation(latitude: touchLocation.latitude, longitude: touchLocation.longitude)
                         let myAnnotation = MKPointAnnotation()
                          myAnnotation.coordinate = touchLocation
                          
                          myAnnotations.append(location)
                        mapView.addAnnotation(myAnnotation)
                            lat = myAnnotation.coordinate.latitude
                           long = myAnnotation.coordinate.longitude
                           myAnnotation.title = "\( getAddress(ann: myAnnotation))"
                self.createPolyline(mapView: self.mapView)
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        
             
         }
         func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                
                let id = MKMapViewDefaultAnnotationViewReuseIdentifier
                if let design = mapView.dequeueReusableAnnotationView(withIdentifier: id, for: annotation) as? MKMarkerAnnotationView{
                    design.titleVisibility = .visible
                    design.markerTintColor = .brown
        //            design.glyphText = titles[count]
                    design.glyphTintColor = .white
             
                    return design
                }
                 return nil
                
            }
        @IBAction func searchButton(_ sender: Any) {
            
            let searchcontroller = UISearchController(searchResultsController: nil)
            searchcontroller.searchBar.delegate = self
            present(searchcontroller, animated: true, completion: nil)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            
            
            //Activity Indicator
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = UIActivityIndicatorView.Style.medium
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            
            //Hide search bar
            searchBar.resignFirstResponder()
            dismiss(animated: true, completion: nil)
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchBar.text
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            
            activeSearch.start { (response, error ) in
                
                activityIndicator.stopAnimating()
                
                
                if response  == nil {
                    print("error")
                }else{
                    
                      if(self.myAnnotations.count < 3){
                        
                         let latitude = response?.boundingRegion.center.latitude
                         let longitude = response?.boundingRegion.center.longitude
                         
                         let annotation = MKPointAnnotation()
                        self.lat = annotation.coordinate.latitude
                        self.long = annotation.coordinate.longitude
                        annotation.title = "\( self.getAddress(ann: annotation))"
    //                     annotation.title = searchBar.text
                         annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!,longitude: longitude!)
                        let poly = CLLocation(latitude: latitude!,longitude: longitude!)
                         self.mapView.addAnnotation(annotation)
                         self.myAnnotations.append(poly)
                         let newp = CLLocationCoordinate2D(latitude: latitude! ,longitude: longitude!)
                         let latDelta: CLLocationDegrees = 0.60
                         let longDelta: CLLocationDegrees = 0.60
                            
                            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)

                            let regionSpan =   MKCoordinateRegion(center: newp , span: span )
                           
                         self.mapView.setRegion(regionSpan, animated: true)
                         }else if(self.myAnnotations.count == 3){

                              let latitude = response?.boundingRegion.center.latitude
                              let longitude = response?.boundingRegion.center.longitude
                              
                              let annotation = MKPointAnnotation()
                        self.lat = annotation.coordinate.latitude
                                           self.long = annotation.coordinate.longitude
                                           annotation.title = "\( self.getAddress(ann: annotation))"
    //                          annotation.title = searchBar.text
                              annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!,longitude: longitude!)
                             let poly = CLLocation(latitude: latitude!,longitude: longitude!)
                              self.mapView.addAnnotation(annotation)
                              self.myAnnotations.append(poly)
                              let newp = CLLocationCoordinate2D(latitude: latitude! ,longitude: longitude!)
                              let latDelta: CLLocationDegrees = 0.60
                              let longDelta: CLLocationDegrees = 0.60
                                 
                                 let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)

                                 let regionSpan =   MKCoordinateRegion(center: newp , span: span )
                                
                                 self.mapView.setRegion(regionSpan, animated: true)
                                 self.createPolyline(mapView: self.mapView)
                             self.navigationItem.rightBarButtonItem?.isEnabled = false
                             
                         }
                         
                    
                    
                }
            }
            
            
            
            
        }
        
        
        func createPolyline(mapView: MKMapView) {
            let point1 = CLLocationCoordinate2DMake( myAnnotations[0].coordinate.latitude, myAnnotations[0].coordinate.longitude);
            let point2 = CLLocationCoordinate2DMake( myAnnotations[1].coordinate.latitude, myAnnotations[1].coordinate.longitude);
            let point3 = CLLocationCoordinate2DMake( myAnnotations[2].coordinate.latitude, myAnnotations[2].coordinate.longitude);
            let point4 = CLLocationCoordinate2DMake( myAnnotations[3].coordinate.latitude, myAnnotations[3].coordinate.longitude);
           // let point5 = CLLocationCoordinate2DMake( myAnnotations[4].coordinate.latitude, myAnnotations[4].coordinate.longitude);
            let point6 = CLLocationCoordinate2DMake( myAnnotations[0].coordinate.latitude, myAnnotations[0].coordinate.longitude);
            
            let points: [CLLocationCoordinate2D]
            points = [point1, point2,point3, point4,point6]
            
            let geodesic = MKPolygon(coordinates: points, count: 5)
            mapView.addOverlay(geodesic)
            
            
        }
        func mapView(_ mapView: MKMapView,
                     rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let overlay = overlay as? MKPolygon {
                let r = MKPolygonRenderer(polygon:overlay)
                r.fillColor = UIColor.yellow.withAlphaComponent(0.3)
                r.strokeColor = UIColor.green.withAlphaComponent(1)
                r.lineWidth = 2
                return r }
            return MKOverlayRenderer()
            
            
            
        }
        func getAddress( ann: MKPointAnnotation) {
              let location = CLLocation(latitude: lat!, longitude: long!)
              
             
              
              CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                  if let error = error {
                      print(error)
                  } else {
                      if let placemark = placemarks?[0] {

                          var address = ""
                          if placemark.subThoroughfare != nil {
                              address += placemark.subThoroughfare! + " "
                              
                              
                          }

                          if placemark.thoroughfare != nil {
                              address += placemark.thoroughfare!
                              
                              ann.title = address
                      
                             
                              address = ""
                          }

                          if placemark.subLocality != nil {
                              address += placemark.subLocality! + " "
                          }

                          if placemark.subAdministrativeArea != nil {
                              address += placemark.subAdministrativeArea! + " "
                              self.city = address
                          }

                          if placemark.postalCode != nil {
                              address += placemark.postalCode! + " "
                          }

                          if placemark.country != nil {
                              address += placemark.country!
                              
                              ann.subtitle = address
                        
                          }

                      
                      }
                  }


              }
          }
        
        func distances(){
            let point01 = CLLocation( latitude: myAnnotations[0].coordinate.latitude, longitude: myAnnotations[0].coordinate.longitude);
            let point02 = CLLocation( latitude: myAnnotations[1].coordinate.latitude, longitude: myAnnotations[1].coordinate.longitude);
            let point03 = CLLocation( latitude: myAnnotations[2].coordinate.latitude, longitude: myAnnotations[2].coordinate.longitude);
            let point04 = CLLocation( latitude: myAnnotations[3].coordinate.latitude, longitude: myAnnotations[3].coordinate.longitude);
            let point06 = CLLocation( latitude: myAnnotations[0].coordinate.latitude, longitude: myAnnotations[0].coordinate.longitude);
                 
             let distanceInMeters = point01.distance(from: point02)
              let distanceInMeters1 = point02.distance(from: point03)
              let distanceInMeters2 = point02.distance(from: point04)
              let distanceInMeters3 = point04.distance(from: point06)
            let distanceInMeters4 = point06.distance(from: point01)
            
        }
        
    }
