//
//  AttachmentViewController.swift
//  UIDynamicsDemo
//
//  Created by Bruno Koga on 9/1/14.
//  Copyright (c) 2014 Bruno Koga. All rights reserved.
//

import UIKit
import QuartzCore

class AttachmentViewController: UIViewController {

    //o animator responsável pelas animações
    var animator: UIDynamicAnimator!
    //o behavior que irá grudar as views
    var viewsAttachment: UIAttachmentBehavior!
    //o behavior responsável pelo pan
    var panAttachment: UIAttachmentBehavior!
    
    //os snap behaviors para voltar a posição inicial
    var leftViewSnapBehavior: UISnapBehavior!
    var rightViewSnapBehavior: UISnapBehavior!
    
    //os steppers para controlar as configurações do behavior
    @IBOutlet weak var lengthStepper: UIStepper!
    @IBOutlet weak var frequencyStepper: UIStepper!
    @IBOutlet weak var dampingStepper: UIStepper!
    //labels para indicar o valor das configurações do attachment
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dampingLabel: UILabel!
    
    //um layer ("linha") para desenhar o attachment entre as views
    var lineLayer: CAShapeLayer!
    
    //as duas views (no caso, labels)
    @IBOutlet weak var leftView: UILabel!
    @IBOutlet weak var rightView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instancia o animator
        self.animator = UIDynamicAnimator(referenceView: self.view);
        //instancia o attachment behavior, passando as views e adiciona ao animator
        self.viewsAttachment = UIAttachmentBehavior(item: self.leftView, attachedToItem: self.rightView)
        self.animator.addBehavior(self.viewsAttachment)
        
        //criamos um layer para desenhar uma linha entre os centros das views
        self.lineLayer = CAShapeLayer()
        self.view.layer.insertSublayer(self.lineLayer, below: self.rightView.layer)
        
        self.viewsAttachment.action = {
            self.drawAttachmentLine()
        }
        
        //setamos o Snap para o centro original das views (para o reset)
        self.leftViewSnapBehavior = UISnapBehavior(item: self.leftView, snapToPoint: self.leftView.center)
        self.rightViewSnapBehavior = UISnapBehavior(item: self.rightView, snapToPoint: self.rightView.center)
        
        //garatir que iniciamos com os valores iniciais
        self.reset()
    }
    func drawAttachmentLine() {
        //criamos o caminho juntando o centro das nossas views
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(self.leftView.center)
        bezierPath .addLineToPoint(self.rightView.center)
        bezierPath.closePath()
        
        //setamos a aparencia da nossa linha e a mostramos
        self.lineLayer.lineCap = kCALineCapRound
        self.lineLayer.lineJoin = kCALineJoinRound;
        self.lineLayer.lineWidth = 5.0;
        self.lineLayer.strokeColor = UIColor.darkGrayColor().CGColor
        self.lineLayer.path = bezierPath.CGPath;
        self.lineLayer.setNeedsDisplay()
    }
    
    
    @IBAction func handlePanGesture(gesture: UIPanGestureRecognizer) {
        var touchPoint = gesture.locationInView(self.view)
        var draggedView = gesture.view!
        if (gesture.state == UIGestureRecognizerState.Began) {
            self.animator.removeBehavior(self.rightViewSnapBehavior)
            self.animator.removeBehavior(self.leftViewSnapBehavior)
            self.panAttachment = UIAttachmentBehavior(item: draggedView, attachedToAnchor: touchPoint)
            self.animator.addBehavior(self.panAttachment)
            
        } else if (gesture.state == UIGestureRecognizerState.Changed) {
            self.panAttachment.anchorPoint = touchPoint
        } else if (gesture.state == UIGestureRecognizerState.Ended) {
            self.animator.removeBehavior(self.panAttachment)
        }
    }

    @IBAction func updateAttachmentValues(sender: AnyObject) {
        //atualizamos as configurações do attachment de acordo com os valores dos steppers
        self.viewsAttachment.length = CGFloat(self.lengthStepper.value);
        self.viewsAttachment.frequency = CGFloat(self.frequencyStepper.value);
        self.viewsAttachment.damping = CGFloat(self.dampingStepper.value);
        
        // atualizamos os valores dos labels, de acordo com os valores do stepper
        
        self.lengthLabel.text = String(format: "%.1f", Double(self.viewsAttachment.length))
        self.frequencyLabel.text = String(format: "%.1f", Double(self.viewsAttachment.frequency))
        self.dampingLabel.text = String(format: "%.1f", Double(self.viewsAttachment.damping))
        
    }
    
    @IBAction func reset() {
        //removemos o attachment temporariamente (enquanto resetamos)
        self.animator.removeBehavior(self.viewsAttachment)
        self.lengthStepper.value = 150
        self.frequencyStepper.value = 0
        self.dampingStepper.value = 0
        
        self.updateAttachmentValues(self)
        
        //volta as views pra posição inicial delas
        self.animator.addBehavior(self.rightViewSnapBehavior)
        self.animator.addBehavior(self.leftViewSnapBehavior)
        
        //adicionamos o attachment de volta
        self.animator.addBehavior(self.viewsAttachment)
    }

}