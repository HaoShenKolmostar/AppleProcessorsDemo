//
//  Runner.swift
//  DemoOSX
//
//  Created by 沈皓 on 10/11/18.
//

import Foundation

public class Runner {
    public func run() {
        RunCompareMPSBLAS()
    }

    private func RunCompareMPSBLAS() {
        CompareMPSBLAS(rowsA: 1024, rowsB: 1024, columnsB: 1024)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1024, columnsB: 2048)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1024, columnsB: 4096)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1024, columnsB: 8192)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1024, columnsB: 16384)
        CompareMPSBLAS(rowsA: 1024, rowsB: 1024, columnsB: 32768)
    }

    private func CompareMPSBLAS(rowsA: Int, rowsB: Int, columnsB: Int) {
        let matrixGroup = MatrixGroup(rowsA: rowsA, rowsB: rowsB, columnsB: columnsB)
        let mps = MPSMultiplication(matrixGroup: matrixGroup)
        let interval_mps: CFTimeInterval = mps.run()
        print(String(format: "MPS  %5d*%5d*%5d took %.4f seconds",
              rowsA, rowsB, columnsB, interval_mps))
        let blas: BLAS = BLAS(matrixGroup: matrixGroup)
        let interval_blas: CFTimeInterval = blas.run()
        print(String(format: "BLAS %5d*%5d*%5d took %.4f seconds",
                     rowsA, rowsB, columnsB, interval_blas))
    }
}
