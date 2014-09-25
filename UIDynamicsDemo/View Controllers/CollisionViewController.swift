//
//  CollisionViewController.swift
//  UIDynamicsDemo
//
//  Created by Bruno Koga on 9/1/14.
//  Copyright (c) 2014 Bruno Koga. All rights reserved.
//

import UIKit

class CollisionViewController: UIViewController {

    var animator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    var pushBehavior: UIPushBehavior!
    var itemBehavior: UIDynamicItemBehavior!
    
    //views pretas - colisão
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //criando o animator
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        //criamos o behavior de colisão
        self.collisionBehavior = UICollisionBehavior(items: [])
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true;
        
        //adicionamos as bordas para colisão (de cima ou de baixo)
        
        self.addCollisionBoundaryForTopEdgeOfView(self.topView, withIdentifier: "topViewTopBoundary")
        self.addCollisionBoundaryForTopEdgeOfView(self.bottomView, withIdentifier: "bottomViewTopBoundary")
        
        //descomente as linhas de baixo para adicionar o fundo como boundary também
        
        /*
        self.addCollisionBoundaryForBottomEdgeOfView(self.topView, withIdentifier: "topViewBottomBoundary")
        self.addCollisionBoundaryForBottomEdgeOfView(self.bottomView, withIdentifier: "bottomViewBottomBoundary")
        */
        
        self.animator.addBehavior(self.collisionBehavior)
        
        //cria um item behavior para rodar em cada view que criamos
        //elasticidade = 1 -> loucura!
        
        self.itemBehavior = UIDynamicItemBehavior(items: [])
        self.itemBehavior.elasticity = 1.0
        self.animator.addBehavior(self.itemBehavior)
        
        //criamos um instanteneous push behavior e aplicamso à view para dar um impulso inicial
        
        self.pushBehavior = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
        self.pushBehavior.pushDirection = CGVectorMake(0.5, 0.5)
        self.animator.addBehavior(self.pushBehavior)
    
    }
    
    func addCollisionBoundaryForTopEdgeOfView(view: UIView, withIdentifier identifier: NSString) {

        var origin = view.frame.origin
        var topRightPoint = CGPointMake(origin.x + view.frame.size.width, origin.y)
        
        //usamos os pontos do topo (esquerda e direita) da view para criar o boundary que vai simular a borda de cima da view
        self.collisionBehavior.addBoundaryWithIdentifier(identifier, fromPoint: origin, toPoint: topRightPoint)
        
    }
    
    func addCollisionBoundaryForBottomEdgeOfView(view: UIView, withIdentifier identifier: NSString) {
        var origin = view.frame.origin
        var bottomLeftPoint = CGPointMake(origin.x, origin.y + view.frame.size.height)
        var bottomRightPoint = CGPointMake(origin.x + view.frame.size.width, bottomLeftPoint.y)
        
        //usamos os pontos do fundo (esquerdo e direito) da view para criar um boundary que vai simular a borda de baixo da view
        self.collisionBehavior.addBoundaryWithIdentifier(identifier, fromPoint: bottomLeftPoint, toPoint: bottomRightPoint)
    }
    
    
    @IBAction func addView() {
        //criamos nossa view
        var view = UIView(frame: CGRectMake(0, 0, 30, 30))
        view.center = self.view.center
        view.backgroundColor = UIColor.redColor()
        self.view.addSubview(view)
        
        //view elástica e adicionamos uma força inicial
        self.itemBehavior.addItem(view)
        self.itemBehavior.addLinearVelocity(CGPointMake(-0.5, -0.5), forItem: view)
        
        //empurrãozinho
        self.pushBehavior.addItem(view)
        self.pushBehavior.active = true
        
        //adicionamos nossa view no behavior de colisão
        self.collisionBehavior.addItem(view)
    }

    @IBAction func reset(sender: AnyObject) {
        for item in self.collisionBehavior.items {
            item.removeFromSuperview()
        }
    }

}
