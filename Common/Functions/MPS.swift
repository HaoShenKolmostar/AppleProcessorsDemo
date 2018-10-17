import Foundation
import MetalPerformanceShaders

public let Device: MTLDevice! = MTLCreateSystemDefaultDevice()

public class MPSMultiplication {
    private var commandQueue: MTLCommandQueue!
    private var matrixMultiplication: MPSMatrixMultiplication!

    public var MPSMatrixA: MPSMatrix
    public var MPSMatrixB: MPSMatrix
    public var MPSMatrixC: MPSMatrix

    private class func ArrayMatrixToMPSMatrix(array_matrix: [Float], rows: Int, columns: Int) -> MPSMatrix {
        let buffer = Device.makeBuffer(bytes: array_matrix, length: rows * columns * MemoryLayout<Float>.stride, options: [])
        let desc = MPSMatrixDescriptor(dimensions: rows, columns: columns, rowBytes: columns * MemoryLayout<Float>.stride, dataType: .float32)
        return MPSMatrix(buffer: buffer, descriptor: desc)
    }

    init(matrixGroup: MatrixGroup) {
        self.commandQueue = Device.makeCommandQueue()
        self.matrixMultiplication = MPSMatrixMultiplication(
            device: Device,
            transposeLeft: false,
            transposeRight: false,
            resultRows: matrixGroup.RowsC,
            resultColumns: matrixGroup.ColumnsC,
            interiorColumns: matrixGroup.ColumnsA,
            alpha: 1,
            beta: 0)
        self.MPSMatrixA = MPSMultiplication.ArrayMatrixToMPSMatrix(
            array_matrix: matrixGroup.MatrixA,
            rows: matrixGroup.RowsA,
            columns: matrixGroup.ColumnsA)
        self.MPSMatrixB = MPSMultiplication.ArrayMatrixToMPSMatrix(
            array_matrix: matrixGroup.MatrixB,
            rows: matrixGroup.RowsB,
            columns: matrixGroup.ColumnsB)
        self.MPSMatrixC = MPSMultiplication.ArrayMatrixToMPSMatrix(
            array_matrix: matrixGroup.MatrixC,
            rows: matrixGroup.RowsC,
            columns: matrixGroup.ColumnsC)
    }

    public func run() -> CFTimeInterval {
        let interval = TimeInterval {
//            guard Device != nil else {
//                fatalError("Error: This device does not support Metal")
//            }
//
//            guard MPSSupportsMTLDevice(Device) else {
//                fatalError("Error: This device does not support Metal Performance Shaders")
//            }
            
            let commandBuffer = self.commandQueue.makeCommandBuffer()
            self.matrixMultiplication.encode(commandBuffer: commandBuffer, leftMatrix: self.MPSMatrixA, rightMatrix: self.MPSMatrixB, resultMatrix: self.MPSMatrixC)
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
        }
        return interval
    }
}

