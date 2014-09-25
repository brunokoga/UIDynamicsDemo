//
//  GravityViewController.swift
//  UIDynamicsDemo
//
//  Created by Bruno Koga on 9/1/14.
//  Copyright (c) 2014 Bruno Koga. All rights reserved.
//

import UIKit

class GravityViewController: UIViewController {

    //as nossas views que serão afetadas pelo behavior
    @IBOutlet weak var heavyView: UILabel!
    @IBOutlet weak var lightView: UILabel!
    
    //sliders e labels de força da gravidade e direção
    @IBOutlet weak var dxSlider: UISlider!
    @IBOutlet weak var dySlider: UISlider!
    @IBOutlet weak var dxLabel: UILabel!
    @IBOutlet weak var dyLabel: UILabel!
    
    //ligar e desligar a gravidade
    @IBOutlet weak var gravitySwitch: UISwitch!

    //animator e o gravity behavior
    var animator: UIDynamicAnimator?
    var gravityBehavior: UIGravityBehavior?
    
    //snap behaviors utilizados para reset
    var heavyViewSnapBehavior: UISnapBehavior?
    var lightViewSnapBehavior: UISnapBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //criamos o animator e associamos a view de referência
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        //criamos o behavior de gravidade e passamos um array de views que serão afetadas
        self.gravityBehavior = UIGravityBehavior(items: [self.heavyView, self.lightView])
        
        //criamos dois snap behaviors para o reset
        self.heavyViewSnapBehavior = UISnapBehavior(item: self.heavyView, snapToPoint: self.heavyView.center)
        
        self.lightViewSnapBehavior = UISnapBehavior(item: self.lightView, snapToPoint: self.lightView.center)
        
        self.reset(self)

    }
    
    @IBAction func toggleGravity() {
        //adicionamos gravidade se o switch estiver on. Caso contrários, a removemos.
        if self.gravitySwitch.on {
            self.animator?.addBehavior(self.gravityBehavior)
        } else {
            self.animator?.removeBehavior(self.gravityBehavior)
        }
        self.updateGravityBehavior()
    }

    
    @IBAction func updateGravityBehavior() {
        //se a gravidade estiver sendo ligada, removemos os behaviors de snap
        if self.gravitySwitch.on {
            self.animator?.removeBehavior(self.lightViewSnapBehavior)
            self.animator?.removeBehavior(self.heavyViewSnapBehavior)
        }
        
        //fazemos update da direção da gravidade, baseados nos valores dos sliders
        self.gravityBehavior?.gravityDirection = CGVectorMake(CGFloat(self.dxSlider.value), CGFloat(self.dySlider.value))
        
        //update nos valores dos sliders
        self.dxLabel.text = String(format: "%.1f", self.dxSlider.value)
        self.dyLabel.text = String(format: "%.1f", self.dySlider.value)
    }
    
    @IBAction func reset(sender: AnyObject) {
        //criamos e adicionamos os dois snap behaviors para trazer as views dinâmicas para seus pontos iniciais
        self.animator?.addBehavior(self.heavyViewSnapBehavior)
        self.animator?.addBehavior(self.lightViewSnapBehavior)
        
        //desligamos a gravidade
        self.gravitySwitch.on = false
        
        //removemos o behavior de gravidade, se existir e resetamos os valores iniciais de dx e dy
        self.animator?.removeBehavior(self.gravityBehavior)
        self.dxSlider.value = 0.0
        self.dySlider.value = 0.0
        
        self.updateGravityBehavior()
    }
}
