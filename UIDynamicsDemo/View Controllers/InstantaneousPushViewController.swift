//
//  InstantaneousPushViewController.swift
//  UIDynamicsDemo
//
//  Created by Bruno Koga on 9/1/14.
//  Copyright (c) 2014 Bruno Koga. All rights reserved.
//

import UIKit

class InstantaneousPushViewController: UIViewController {
    
    //Animator responsavel por aplicar o comportamento
    var animator: UIDynamicAnimator!
    //Comportamento que sera atrelado às views
    var instantaneousPushBehavior: UIPushBehavior!
    
    //Comportamento Snap que será usado para resetar as views
    var largeViewSnapBehavior: UISnapBehavior!
    var smallViewSnapBehavior: UISnapBehavior!
    
    //Views que receberão os pushes
    @IBOutlet weak var largeView: UILabel!
    @IBOutlet weak var smallView: UILabel!
    
    //Sliders para controlar a direção
    @IBOutlet weak var dxSlider: UISlider!
    @IBOutlet weak var dySlider: UISlider!
    @IBOutlet weak var dxLabel: UILabel!
    @IBOutlet weak var dyLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Instancia o animator
        animator = UIDynamicAnimator(referenceView: self.view);
        
        //Configura o comportamento (push, modo contínuo)
        instantaneousPushBehavior = UIPushBehavior(items: [self.smallView, self.largeView], mode: .Instantaneous);
        
        //Adiciona o comportamento ao animator
        self.animator.addBehavior(instantaneousPushBehavior);
        
        self.largeViewSnapBehavior = UISnapBehavior(item: self.largeView, snapToPoint: self.largeView.center);
        
        self.smallViewSnapBehavior = UISnapBehavior(item: self.smallView, snapToPoint: self.smallView.center);
        
        self.reset(self);
    }
    
    @IBAction func applyPush() {
        // in case the snap behaviors are currently applied,
        // remove them so the push will be effective
        self.animator?.removeBehavior(self.smallViewSnapBehavior);
        self.animator?.removeBehavior(self.largeViewSnapBehavior);
        
        // for instantaneous, a force is applied only once when active is switched ON.
        // then, active is toggled back off immediately after the force is applied
        // setting active to YES applies the force again
        
        self.instantaneousPushBehavior.active = true;
    }
    
    @IBAction func updatePushBehavior() {
        //Atualiza os valores da direção da força
        self.instantaneousPushBehavior.pushDirection = CGVectorMake(CGFloat(self.dxSlider.value), CGFloat(self.dySlider.value));
        
        //Atualiza os valores dos labels
        self.dxLabel.text = String(format: "%.1f", self.dxSlider.value);
        self.dyLabel.text = String(format: "%.1f", self.dySlider.value);
    }
    
    @IBAction func reset(sender: AnyObject) {
        
        //Faz as views voltarem às suas posições originais
        self.animator?.addBehavior(self.largeViewSnapBehavior);
        self.animator?.addBehavior(self.smallViewSnapBehavior);
        
        //Seta os valores iniciais de direção da força
        self.dxSlider.value = 0.0;
        self.dySlider.value = 0.0;
        
        //Atualiza a direção da força e os valores dos labels
        self.updatePushBehavior();
    }
    
}
