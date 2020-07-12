// Copyright (c) Sarah Kaiser. All rights reserved.
// Licensed under the MIT License.

namespace ManningLive.DeutschJozsa {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;

    operation ApplyZeroOracle(control : Qubit, target : Qubit) : Unit {
    }

    operation ApplyOneOracle(control : Qubit, target : Qubit) : Unit {
        X(target);
    }

    operation ApplyIdOracle(control : Qubit, target : Qubit) : Unit {
        CNOT(control, target);
    }

    operation ApplyNotOracle(control : Qubit, target : Qubit) : Unit {
        X(control);
        CNOT(control, target);
        X(control);
    }

    operation CheckIfOracleIsBalanced(
            oracle : ((Qubit, Qubit) => Unit)              
    ) : Bool {
        using ((control, target) = (Qubit(), Qubit())) {   
            H(control);                                    
            X(target);
            H(target);

            oracle(control, target);                       

            H(target);                                     
            X(target);

            return MResetX(control) == One;                
        }
    }

    operation RunDeutschJozsaAlgorithm(verbose : Bool) : Unit {
        Fact(not CheckIfOracleIsBalanced(ApplyZeroOracle), "Test failed for zero oracle."); 
        if (verbose) {
            Message($"The ZeroOracle is Balanced: {CheckIfOracleIsBalanced(ApplyZeroOracle)}");
        }

        Fact(not CheckIfOracleIsBalanced(ApplyOneOracle), "Test failed for one oracle.");  
        if (verbose) {
            Message($"The OneOracle is Balanced: {CheckIfOracleIsBalanced(ApplyOneOracle)}");
        } 

        Fact(CheckIfOracleIsBalanced(ApplyIdOracle), "Test failed for id oracle.");
        if (verbose) {
            Message($"The IdOracle is Balanced: {CheckIfOracleIsBalanced(ApplyIdOracle)}");
        }
        
        Fact(CheckIfOracleIsBalanced(ApplyNotOracle), "Test failed for not oracle.");
        if (verbose) {
            Message($"The NotOracle is Balanced: {CheckIfOracleIsBalanced(ApplyNotOracle)}");
        }

        Message("All tests passed!");                                           
    }
}