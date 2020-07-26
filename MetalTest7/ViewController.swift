//
//  ViewController.swift
//  MetalTest7
//
//  Created by 福山帆士 on 2020/07/26.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    private let device = MTLCreateSystemDefaultDevice()!
    
    private var commandQuere: MTLCommandQueue!
    
    private let vertexData: [Float] = [
        -1, -1, 0, 1,
        1, -1, 0, 1,
        -1, 1, 0, 1,
        1, 1, 0, 1
    ]
    
    private var vertexBuffer: MTLBuffer!
    
    private var renderPipeline: MTLRenderPipelineState!
    
    private var renderPassDescriptor = MTLRenderPassDescriptor()
    
    lazy var myMTKView: MTKView = {
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), device: device)
        return mtkView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(myMTKView)
        
        
        setUp()
        
        dataToBuffer()
        
        createPipeline()
        
        
        myMTKView.enableSetNeedsDisplay = true
        
        myMTKView.setNeedsDisplay()
        
    }
    
    func setUp() {
        
        myMTKView.delegate = self
        commandQuere = device.makeCommandQueue()!
    }
    
    func dataToBuffer() {
        
        let size = vertexData.count * MemoryLayout<Float>.size
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: size)
    }
    
    func createPipeline() {
        
        guard let library = device.makeDefaultLibrary() else { fatalError() }
        
        let renderDescriptor = MTLRenderPipelineDescriptor()
        renderDescriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        renderDescriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        renderDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        renderPipeline = try! device.makeRenderPipelineState(descriptor: renderDescriptor)
    }
    
}

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        
        guard let drawable = view.currentDrawable else { fatalError() }
        
        guard let commandBuffer = commandQuere.makeCommandBuffer() else { fatalError() }
        
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        encoder.setRenderPipelineState(renderPipeline)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangleStrip,
                               vertexStart: 0,
                               vertexCount: 4)
        
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
        
        commandBuffer.waitUntilCompleted()
    }
    
    
}

