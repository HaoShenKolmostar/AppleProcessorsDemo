import Foundation
import Accelerate


public class BLAS {
    public var Matrices: MatrixGroup!
    init(matrixGroup: MatrixGroup) {
        self.Matrices = matrixGroup
    }

    public func run() -> CFTimeInterval {
        let interval = TimeInterval {
            self.Matrices.MatrixA.withUnsafeBufferPointer { ptrA in
                self.Matrices.MatrixB.withUnsafeBufferPointer { ptrB in
                    self.Matrices.MatrixC.withUnsafeMutableBufferPointer { ptrC in
                        cblas_sgemm(
                            CblasRowMajor,
                            CblasNoTrans,
                            CblasNoTrans,
                            Int32(self.Matrices.RowsA),
                            Int32(self.Matrices.ColumnsB),
                            Int32(self.Matrices.ColumnsA),
                            1,
                            ptrA.baseAddress,
                            Int32(self.Matrices.ColumnsA),
                            ptrB.baseAddress,
                            Int32(self.Matrices.ColumnsB),
                            0,
                            ptrC.baseAddress,
                            Int32(self.Matrices.ColumnsC))
                    }
                }
            }
        }
        return interval
    }
}
