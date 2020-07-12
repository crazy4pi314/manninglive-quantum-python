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
            verbose : Bool,
            oracle : ((Qubit, Qubit) => Unit)              
    ) : Bool {
        using ((control, target) = (Qubit(), Qubit())) {
            // Prepare superposition on the control register.
            H(control);                                   

            // Use the phase kickback technique from Chapter 7
            // to learn a global property of our oracle.
            within {
                X(target);
                H(target);
            } apply {
                if (verbose) {
                    Message("Before oracle call:");
                    DumpMachine();
                }

                oracle(control, target);
                
                if (verbose) {
                    Message("\n\nAfter oracle call:");
                    DumpMachine();
                }
            }

            return MResetX(control) == One;                
        }
    }

    operation RunDeutschJozsaAlgorithm(verbose : Bool) : Unit {
        Fact(not CheckIfOracleIsBalanced(false, ApplyZeroOracle), "Test failed for zero oracle."); 
        if (verbose) {
            Message($"The ZeroOracle is Balanced: {CheckIfOracleIsBalanced(false, ApplyZeroOracle)}");
        }

        Fact(not CheckIfOracleIsBalanced(false, ApplyOneOracle), "Test failed for one oracle.");  
        if (verbose) {
            Message($"The OneOracle is Balanced: {CheckIfOracleIsBalanced(false, ApplyOneOracle)}");
        } 

        Fact(CheckIfOracleIsBalanced(false, ApplyIdOracle), "Test failed for id oracle.");
        if (verbose) {
            Message($"The IdOracle is Balanced: {CheckIfOracleIsBalanced(false, ApplyIdOracle)}");
        }
        
        Fact(CheckIfOracleIsBalanced(false, ApplyNotOracle), "Test failed for not oracle.");
        if (verbose) {
            Message($"The NotOracle is Balanced: {CheckIfOracleIsBalanced(false, ApplyNotOracle)}");
        }

        Message("All tests passed!");                                           
    }
}