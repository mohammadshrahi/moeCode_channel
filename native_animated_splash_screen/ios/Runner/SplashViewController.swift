//
//  SplashViewController.swift
//  Runner
//
//  Created by Mohammad Alshrahi on 12.10.22.
//

import Foundation
import RiveRuntime
class SplashViewController: UIViewController {
    var simpleVM = RiveViewModel(fileName: "splash_v7")
    
    override func viewWillAppear(_ animated: Bool) {
        let riveView = simpleVM.createRiveView()
        view.addSubview(riveView)
        riveView.frame = view.frame
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.2){
            self.startFlutterApp()
         }
        
    }
       func startFlutterApp() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let flutterEngine = appDelegate.flutterEngine
        let flutterViewController =
            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        flutterViewController.modalPresentationStyle = .custom
        flutterViewController.modalTransitionStyle = .crossDissolve
        
        present(flutterViewController, animated: true, completion: nil)
        
    }
}
