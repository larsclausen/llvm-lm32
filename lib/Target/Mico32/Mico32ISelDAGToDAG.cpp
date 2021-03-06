//===-- Mico32ISelDAGToDAG.cpp - A dag to dag inst selector for Mico32 ----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the Mico32 target.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "mico32-isel"
#include "Mico32.h"
#include "Mico32MachineFunctionInfo.h"
#include "Mico32RegisterInfo.h"
#include "Mico32Subtarget.h"
#include "Mico32TargetMachine.h"
#include "llvm/GlobalValue.h"
#include "llvm/Instructions.h"
#include "llvm/Intrinsics.h"
#include "llvm/Support/CFG.h"
#include "llvm/Type.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

//===----------------------------------------------------------------------===//
// Instruction Selector Implementation
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Mico32DAGToDAGISel - Mico32 specific code to select Mico32 machine
// instructions for SelectionDAG operations.
//===----------------------------------------------------------------------===//
namespace {

class Mico32DAGToDAGISel : public SelectionDAGISel {

  /// TM - Keep a reference to Mico32TargetMachine.
  Mico32TargetMachine &TM;

  /// Subtarget - Keep a pointer to the Mico32Subtarget around so that we can
  /// make the right decision when generating code for different targets.
  const Mico32Subtarget &Subtarget;

public:
  explicit Mico32DAGToDAGISel(Mico32TargetMachine &tm) :
  SelectionDAGISel(tm),
  TM(tm), Subtarget(tm.getSubtarget<Mico32Subtarget>()) {}

  // Pass Name
  virtual const char *getPassName() const {
    return "Mico32 DAG->DAG Pattern Instruction Selection";
  }
private:
  // Include the pieces autogenerated from the target description.
  #include "Mico32GenDAGISel.inc"

  /// getTargetMachine - Return a reference to the TargetMachine, casted
  /// to the target-specific type.
  const Mico32TargetMachine &getTargetMachine() {
    return static_cast<const Mico32TargetMachine &>(TM);
  }

  /// getInstrInfo - Return a reference to the TargetInstrInfo, casted
  /// to the target-specific type.
  const Mico32InstrInfo *getInstrInfo() {
    return getTargetMachine().getInstrInfo();
  }

//  SDNode *getGlobalBaseReg();
  SDNode *Select(SDNode *N);

  // Address Selection
  bool SelectAddrRegImm(SDValue N, SDValue &Disp, SDValue &Base);

  // getI32Imm - Return a target constant with the specified value, of type i32.
  inline SDValue getI32Imm(unsigned Imm) {
    return CurDAG->getTargetConstant(Imm, MVT::i32);
  }


};

}

///
/// This is modeled after SPARC.
/// Note that the initial pattern in MonarchInstrInfo.td only matches
/// frameindex.
/// XCore has a different approach.  It also matches add and defines
/// pseudo-instructions that are eliminated in eliminateFrameIndex.
///
bool Mico32DAGToDAGISel::
SelectAddrRegImm(SDValue Addr, SDValue &Base, SDValue &Offset) {
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), MVT::i32);
    Offset = CurDAG->getTargetConstant(0, MVT::i32);
    return true;
  }
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress)
    return false;  // direct calls.

  // Operand is a result from an ADD
  if (Addr.getOpcode() == ISD::ADD) {
    // If the operand is a constant value that fits in a sign-extended 16bit
    // offset (such that we can just do ADDI R1,4).
    if (ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1))) {
      if (isInt<16>(CN->getSExtValue())) {
        // if the first operand is a frameindex, get the TargetFI node,
        if (FrameIndexSDNode *FIN =
                dyn_cast<FrameIndexSDNode>(Addr.getOperand(0))) {
          //FIXME: why do we change this to a targetFrameIndex?
          Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), MVT::i32);
        } else {
          Base = Addr.getOperand(0);
        }
        Offset = CurDAG->getTargetConstant(CN->getZExtValue(), MVT::i32);
        return true;
      }
    }

    // These are optimizations.  If there's an ADD of a MonarchISD::Lo 
    // (16bit constant) offset it can be incorporated into the ADDri 
    // addressing mode. Note the Hi part must be shifted so it don't work.
    // E.g. (ld (add lo hi) 0) -> (ld (hi) lo)
    // also see LowerGlobalAddress etc. for a similar optimization.
#if 0
// FIXME:  add this back in
    if (Addr.getOperand(0).getOpcode() == MonarchISD::Lo) {
      assert(0 && "FIXME: I don't think this will work since Lo is zero-extended and LD will expected sign-extended\n");
      Base = Addr.getOperand(1);
      Offset = Addr.getOperand(0).getOperand(0);
      return true;
    }
    if (Addr.getOperand(1).getOpcode() == MonarchISD::Lo) {
      assert(0 && "FIXME: I don't think this will work since Lo is zero-extended and LD will expected sign-extended\n");
      Base = Addr.getOperand(0);
      Offset = Addr.getOperand(1).getOperand(0);
      return true;
    }
#endif
  }
  Base = Addr;
  Offset = CurDAG->getTargetConstant(0, MVT::i32);
  return true;
}


#if 0
//FIXME: No PIC support.
/// getGlobalBaseReg - Output the instructions required to put the
/// GOT address into a register.
SDNode *Mico32DAGToDAGISel::getGlobalBaseReg() {
//FIXME: not ported to MICO32
assert(0 && "getGlobalBaseReg() not supported.");
  unsigned GlobalBaseReg = getInstrInfo()->getGlobalBaseReg(MF);
  return CurDAG->getRegister(GlobalBaseReg, TLI.getPointerTy()).getNode();
}
#endif

/// Select instructions not customized! Used for
/// expanded, promoted and normal instructions
SDNode* Mico32DAGToDAGISel::Select(SDNode *Node) {
//FIXME: not ported to MICO32
  unsigned Opcode = Node->getOpcode();
  DebugLoc dl = Node->getDebugLoc();

  // If we have a custom node, we already have selected!
  if (Node->isMachineOpcode())
    return NULL;

  ///
  // Instruction Selection not handled by the auto-generated
  // tablegen selection should be handled here.
  ///
  switch (Opcode) {
    default: break;

    // Get target GOT address.
    case ISD::GLOBAL_OFFSET_TABLE: {
#if 0
//FIXME: No PIC support.
      return getGlobalBaseReg();
#endif
	assert(0 && "No PIC support.");
        return Node;  // quiet error message
    }

    case ISD::FrameIndex: {
        SDValue imm = CurDAG->getTargetConstant(0, MVT::i32);
        int FI = dyn_cast<FrameIndexSDNode>(Node)->getIndex();
        EVT VT = Node->getValueType(0);
        SDValue TFI = CurDAG->getTargetFrameIndex(FI, VT);
        unsigned Opc = Mico32::ADDI;
        if (Node->hasOneUse())
          return CurDAG->SelectNodeTo(Node, Opc, VT, TFI, imm);
        return CurDAG->getMachineNode(Opc, dl, VT, TFI, imm);
    }


#if 0
    /// Handle direct and indirect calls when using PIC. On PIC, when
    /// GOT is smaller than about 64k (small code) the GA target is
    /// loaded with only one instruction. Otherwise GA's target must
    /// be loaded with 3 instructions.
    case Mico32ISD::JmpLink: {
      if (TM.getRelocationModel() == Reloc::PIC_) {
        SDValue Chain  = Node->getOperand(0);
        SDValue Callee = Node->getOperand(1);
        SDValue R20Reg = CurDAG->getRegister(Mico32::R20, MVT::i32);
        SDValue InFlag(0, 0);

        if ((isa<GlobalAddressSDNode>(Callee)) ||
            (isa<ExternalSymbolSDNode>(Callee)))
        {
          /// Direct call for global addresses and external symbols
          SDValue GPReg = CurDAG->getRegister(Mico32::R15, MVT::i32);

          // Use load to get GOT target
          SDValue Ops[] = { Callee, GPReg, Chain };
          SDValue Load = SDValue(CurDAG->getMachineNode(Mico32::LW, dl,
                                 MVT::i32, MVT::Other, Ops, 3), 0);
          Chain = Load.getValue(1);

          // Call target must be on T9
          Chain = CurDAG->getCopyToReg(Chain, dl, R20Reg, Load, InFlag);
        } else
          /// Indirect call
          Chain = CurDAG->getCopyToReg(Chain, dl, R20Reg, Callee, InFlag);

        // Emit Jump and Link Register
        SDNode *ResNode = CurDAG->getMachineNode(Mico32::BRLID, dl, MVT::Other,
                                                 MVT::Glue, R20Reg, Chain);
        Chain  = SDValue(ResNode, 0);
        InFlag = SDValue(ResNode, 1);
        ReplaceUses(SDValue(Node, 0), Chain);
        ReplaceUses(SDValue(Node, 1), InFlag);
        return ResNode;
      }
    }
#endif
  }

  // Select the default instruction
  SDNode *ResNode = SelectCode(Node);

  DEBUG(errs() << "=> ");
  if (ResNode == NULL || ResNode == Node)
    DEBUG(Node->dump(CurDAG));
  else
    DEBUG(ResNode->dump(CurDAG));
  DEBUG(errs() << "\n");
  return ResNode;
}

/// createMico32ISelDag - This pass converts a legalized DAG into a
/// Mico32-specific DAG, ready for instruction scheduling.
FunctionPass *llvm::createMico32ISelDag(Mico32TargetMachine &TM) {
  return new Mico32DAGToDAGISel(TM);
}
