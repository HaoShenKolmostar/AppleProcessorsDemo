import Foundation

public class Runner {
    public func run() {
        RunCompareMPSBLAS()
        RunOpenCLSample()
    }

    private func RunCompareMPSBLAS() {
        CompareMPSBLAS(rowsA: 1024, rowsB: 1, columnsB: 1024)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1, columnsB: 2048)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1, columnsB: 4096)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1, columnsB: 8192)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1, columnsB: 16384)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1, columnsB: 32768)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1, columnsB: 65536)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1, columnsB: 131072)
    }

    private func CompareMPSBLAS(rowsA: Int, rowsB: Int, columnsB: Int) {
        let matrixGroup = MatrixGroup(rowsA: rowsA, rowsB: rowsB, columnsB: columnsB)
        let mps = MPSMultiplication(matrixGroup: matrixGroup)
        let interval_mps: CFTimeInterval = mps.run()
        print(String(format: "MPS  %5d*%5d*%5d took %.6f seconds",
              rowsA, rowsB, columnsB, interval_mps))
        let blas: BLAS = BLAS(matrixGroup: matrixGroup)
        let interval_blas: CFTimeInterval = blas.run()
        print(String(format: "BLAS %5d*%5d*%5d took %.6f seconds",
                     rowsA, rowsB, columnsB, interval_blas))
    }
    
    private func RunOpenCLSample(){
        CompareMPSBLAS(rowsA: 256, rowsB: 1, columnsB: 4)
        opencltime = gmatrix(256, 1, 4);
        print(String(format: "OPCL took %.6f seconds",
                     opencltime))
    }
}
