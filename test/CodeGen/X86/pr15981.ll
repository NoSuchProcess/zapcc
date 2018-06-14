; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64

@a = external global i32
@b = external global i32
@c = external global i32

define i32 @fn1(i32, i32) {
; X86-LABEL: fn1:
; X86:       # BB#0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    je .LBB0_2
; X86-NEXT:  # BB#1:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:  .LBB0_2:
; X86-NEXT:    retl
;
; X64-LABEL: fn1:
; X64:       # BB#0:
; X64-NEXT:    testl %esi, %esi
; X64-NEXT:    cmovel %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %3 = icmp ne i32 %1, 0
  %4 = select i1 %3, i32 %0, i32 0
  ret i32 %4
}

define void @fn2() {
; X86-LABEL: fn2:
; X86:       # BB#0:
; X86-NEXT:    movl b, %eax
; X86-NEXT:    decl a
; X86-NEXT:    jne .LBB1_2
; X86-NEXT:  # BB#1:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:  .LBB1_2:
; X86-NEXT:    movl %eax, c
; X86-NEXT:    retl
;
; X64-LABEL: fn2:
; X64:       # BB#0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    decl {{.*}}(%rip)
; X64-NEXT:    cmovnel {{.*}}(%rip), %eax
; X64-NEXT:    movl %eax, {{.*}}(%rip)
; X64-NEXT:    retq
  %1 = load volatile i32, i32* @b, align 4
  %2 = load i32, i32* @a, align 4
  %3 = add nsw i32 %2, -1
  store i32 %3, i32* @a, align 4
  %4 = icmp ne i32 %3, 0
  %5 = select i1 %4, i32 %1, i32 0
  store i32 %5, i32* @c, align 4
  ret void
}
