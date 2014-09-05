//
//  ContinuousPushViewController.swift
//  UIDynamicsDemo
//
//  Created by Bruno Koga on 9/1/14.
//  Copyright (c) 2014 Bruno Koga. All rights reserved.
//

import UIKit

class ContinuousPushViewController: UIViewController {
    
    //Animator responsavel por aplicar o comportamento
    var animator: UIDynamicAnimator!
    //Comportamento que sera atrelado às views
    var continuousPushBehavior: UIPushBehavior!
    
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
    
    //Switch para ativar/desativar o push
    @IBOutlet weak var activeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instancia o animator
        animator = UIDynamicAnimator(referenceView: self.view);
        
        //Configura o comportamento (push, modo contínuo)
        continuousPushBehavior = UIPushBehavior(items: [self.smallView, self.largeView], mode: .Continuous);
        
        //Adiciona o comportamento ao animator
        self.animator.addBehavior(continuousPushBehavior);
        
        self.largeViewSnapBehavior = UISnapBehavior(item: self.largeView, snapToPoint: self.largeView.center);
        
        self.smallViewSnapBehavior = UISnapBehavior(item: self.smallView, snapToPoint: self.smallView.center);
        
        self.reset(self);
    }
    
    @IBAction func updatePushBehavior() {
        //Atualiza os valores da direção da força
        self.continuousPushBehavior.pushDirection = CGVectorMake(CGFloat(self.dxSlider.value), CGFloat(self.dySlider.value));
        
        //Atualiza os valores dos labels
        self.dxLabel.text = String(format: "%.1f", self.dxSlider.value);
        self.dyLabel.text = String(format: "%.1f", self.dySlider.value);
    }
    
    @IBAction func reset(sender: AnyObject) {
        //Desativa a força que empurra as views
        self.continuousPushBehavior.active = false;
        self.activeSwitch.on = false;
        
        //Faz as views voltarem às suas posições originais
        self.animator?.addBehavior(self.largeViewSnapBehavior);
        self.animator?.addBehavior(self.smallViewSnapBehavior);
        
        //Seta os valores iniciais de direção da força
        self.dxSlider.value = 0.0;
        self.dySlider.value = 0.0;
        
        //Atualiza a direção da força e os valores dos labels
        self.updatePushBehavior();
    }
    
    @IBAction func toggleForce() {
        //Se vamos aplicar uma força, removemos o snap behavior
        if (self.activeSwitch.on) {
            self.animator.removeBehavior(self.smallViewSnapBehavior);
            self.animator.removeBehavior(self.largeViewSnapBehavior);
        }
        
        //A força será aplicada enquanto o switch estiver ligado
        self.continuousPushBehavior.active = self.activeSwitch.on;
    }
}
