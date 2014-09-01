//
//  SnapViewController.swift
//  UIDynamicsDemo
//
//  Created by Bruno Koga on 9/1/14.
//  Copyright (c) 2014 Bruno Koga. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController {

    //a view que vai ser anexada aos botões pelo snapBehavior
    @IBOutlet weak var dynamicView: UILabel!
    
    //label do damping
    @IBOutlet weak var dampingLabel: UILabel!
    
    //slider do damping
    @IBOutlet weak var dampingSlider: UISlider!
    
    //animator e o snap behavior
    var animator: UIDynamicAnimator!
    var snapBehavior: UISnapBehavior!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        //criamos o animator passando a nossa view para as animações
        self.animator = UIDynamicAnimator(referenceView: self.view)
    }

    @IBAction func snap(sender: UIButton) {
        //removemos qualquer snap behavios que tenha sido adicionado, para garantir que não haverão conflitos
        self.animator.removeAllBehaviors()
        
        //criamos o novo snap behavior que vai dar o snap para o centro do botão tocado
        self.snapBehavior = UISnapBehavior(item: self.dynamicView, snapToPoint: sender.center)
        
        //ajustamos o damping conforme o valor do slider
        self.snapBehavior.damping = CGFloat(self.dampingSlider.value)
        
        //adicionamos o behavior no animator. O behavior acontecerá instantaneamente
        self.animator.addBehavior(self.snapBehavior)
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        //ajustamos o damping de acordo com o slider
        self.snapBehavior.damping = CGFloat(sender.value)
        
        //atualizamos o texto
        self.dampingLabel.text = String(format: "damping: %.2f", sender.value)
    }
}
