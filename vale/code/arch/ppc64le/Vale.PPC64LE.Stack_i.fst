module Vale.PPC64LE.Stack_i
open FStar.Mul

module BS = Vale.PPC64LE.Semantics_s
open Vale.Arch.MachineHeap
let vale_stack = machine_stack

let valid_src_stack64 i st = BS.valid_src_stack64 i st
let load_stack64 i st = BS.eval_stack i st
let store_stack64 i v h = BS.update_stack64' i v h
let free_stack64 start finish h = BS.free_stack' start finish h

let valid_src_stack128 i st = BS.valid_src_stack128 i st
let load_stack128 i st = BS.eval_stack128 i st
let store_stack128 i v h = BS.update_stack128' i v h
let free_stack128 start finish h = BS.free_stack' start finish h

let init_r1 h = h.initial_r1

(* Lemmas *)
#push-options "--z3rlimit 40"
let lemma_store_stack_same_valid64 ptr v h i =
  reveal_opaque (`%BS.valid_addr64) BS.valid_addr64;
  BS.update_heap64_reveal ()

let lemma_free_stack_same_valid64 start finish ptr h =
  reveal_opaque (`%BS.valid_addr64) BS.valid_addr64;
  let Machine_stack _ mem = h in
  let domain = Map.domain mem in
  Classical.forall_intro (Vale.Lib.Set.remove_between_reveal domain start finish)

let lemma_store_stack_same_valid128 ptr v h i =
  reveal_opaque (`%BS.valid_addr128) BS.valid_addr128;
  BS.update_heap32_reveal ();
  BS.update_heap128_reveal ()

let lemma_free_stack_same_valid128 start finish ptr h =
  reveal_opaque (`%BS.valid_addr128) BS.valid_addr128;
  let Machine_stack _ mem = h in
  let domain = Map.domain mem in
  Classical.forall_intro (Vale.Lib.Set.remove_between_reveal domain start finish)

let lemma_store_new_valid64 ptr v h =
  reveal_opaque (`%BS.valid_addr64) BS.valid_addr64;
  BS.update_heap64_reveal ()

let lemma_store_new_valid128 ptr v h =
  reveal_opaque (`%BS.valid_addr128) BS.valid_addr128;
  BS.update_heap32_reveal ();
  BS.update_heap128_reveal ()
#pop-options

let lemma_correct_store_load_stack64 ptr v h =
  let Machine_stack _ mem = h in
  correct_update_get64 ptr v mem

let lemma_frame_store_load_stack64 ptr v h i =
  let Machine_stack _ mem = h in
  frame_update_heap64 ptr v mem;
  BS.get_heap_val64_reveal ()

let lemma_free_stack_same_load64 start finish ptr h =
  reveal_opaque (`%BS.valid_addr64) BS.valid_addr64;
  let Machine_stack _ mem = h in
  let domain = Map.domain mem in
  Classical.forall_intro (Vale.Lib.Set.remove_between_reveal domain start finish);
  BS.get_heap_val64_reveal ()

let lemma_correct_store_load_stack128 ptr v h =
  let Machine_stack _ mem = h in
  correct_update_get128 ptr v mem

let lemma_frame_store_load_stack128 ptr v h i =
  let Machine_stack _ mem = h in
  frame_update_heap128 ptr v mem;
  BS.get_heap_val32_reveal ();
  BS.get_heap_val128_reveal ()

let lemma_free_stack_same_load128 start finish ptr h =
  reveal_opaque (`%BS.valid_addr128) BS.valid_addr128;
  let Machine_stack _ mem = h in
  let domain = Map.domain mem in
  Classical.forall_intro (Vale.Lib.Set.remove_between_reveal domain start finish);
  BS.get_heap_val32_reveal ();
  BS.get_heap_val128_reveal ()

let lemma_compose_free_stack64 start inter finish h =
  let Machine_stack _ mem = h in
  let domain = Map.domain mem in
  let map_restr = Map.restrict (Vale.Lib.Set.remove_between domain start inter) mem in
  let restrict = Map.domain map_restr in
  let Machine_stack _ mem1 = free_stack64 inter finish (free_stack64 start inter h) in
  let Machine_stack _ mem2 = free_stack64 start finish h in
  let aux (i:int) : Lemma (Map.contains mem1 i = Map.contains mem2 i /\ Map.sel mem1 i = Map.sel mem2 i)
    = Vale.Lib.Set.remove_between_reveal domain start inter i;
      Vale.Lib.Set.remove_between_reveal restrict inter finish i;
      Vale.Lib.Set.remove_between_reveal domain start finish i;
      Vale.Lib.Set.lemma_sel_restrict (Vale.Lib.Set.remove_between domain start inter) mem i;
      Vale.Lib.Set.lemma_sel_restrict (Vale.Lib.Set.remove_between restrict inter finish) map_restr i;
      Vale.Lib.Set.lemma_sel_restrict (Vale.Lib.Set.remove_between domain start finish) mem i
  in Classical.forall_intro aux;
  assert (Map.equal mem1 mem2)

let lemma_same_init_r1_free_stack64 start finish h = ()

let lemma_same_init_r1_store_stack64 ptr v h = ()

let lemma_same_init_r1_free_stack128 start finish h = ()

let lemma_same_init_r1_store_stack128 ptr v h = ()

let valid_taint_stack64 ptr t stackTaint =
  Map.sel stackTaint ptr = t &&
  Map.sel stackTaint (ptr + 1) = t &&
  Map.sel stackTaint (ptr + 2) = t &&
  Map.sel stackTaint (ptr + 3) = t &&
  Map.sel stackTaint (ptr + 4) = t &&
  Map.sel stackTaint (ptr + 5) = t &&
  Map.sel stackTaint (ptr + 6) = t &&
  Map.sel stackTaint (ptr + 7) = t

let valid_taint_stack128 ptr t stackTaint =
  Map.sel stackTaint ptr = t &&
  Map.sel stackTaint (ptr + 1) = t &&
  Map.sel stackTaint (ptr + 2) = t &&
  Map.sel stackTaint (ptr + 3) = t &&
  Map.sel stackTaint (ptr + 4) = t &&
  Map.sel stackTaint (ptr + 5) = t &&
  Map.sel stackTaint (ptr + 6) = t &&
  Map.sel stackTaint (ptr + 7) = t &&
  Map.sel stackTaint (ptr + 8) = t &&
  Map.sel stackTaint (ptr + 9) = t &&
  Map.sel stackTaint (ptr + 10) = t &&
  Map.sel stackTaint (ptr + 11) = t &&
  Map.sel stackTaint (ptr + 12) = t &&
  Map.sel stackTaint (ptr + 13) = t &&
  Map.sel stackTaint (ptr + 14) = t &&
  Map.sel stackTaint (ptr + 15) = t

let store_taint_stack64 ptr t stackTaint = BS.update_n ptr 8 stackTaint t

let store_taint_stack128 ptr t stackTaint = BS.update_n ptr 16 stackTaint t

let lemma_valid_taint_stack64 ptr t stackTaint = ()
let lemma_valid_taint_stack128 ptr t stackTaint = ()

let lemma_valid_taint_stack64_reveal ptr t stackTaint = ()

let lemma_correct_store_load_taint_stack64 ptr t stackTaint = ()

let lemma_frame_store_load_taint_stack64 ptr t stackTaint i t' = ()

let lemma_valid_taint_stack128_reveal ptr t stackTaint = ()

let lemma_correct_store_load_taint_stack128 ptr t stackTaint = ()

let lemma_frame_store_load_taint_stack128 ptr t stackTaint i t' = ()
