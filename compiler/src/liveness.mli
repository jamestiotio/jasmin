open Prog

(* Variables live before a write_lvals:
   this is tricky when a variable occurs several times,
   sometimes written, sometimes read;
   this correctly reflects the semantics which writes ℓ-values
   from left to right.
 *)
val dep_lvs : Sv.t -> lval list -> Sv.t

val live_fd : bool -> 'info func -> (Sv.t * Sv.t) func

val liveness : bool -> 'info prog -> (Sv.t * Sv.t) prog

(** [iter_call_sites cb f] runs the [cb] function for all call site in [f] with
    the name of the called function, the ℓ-values, and the set of live variables
    after the call (i.e., arguments not included).

    Requires the function [f] to be annotated with liveness information
*)
val iter_call_sites : (funname -> lvals -> Sv.t -> unit) -> (Sv.t * Sv.t) func -> unit

val pp_info : Format.formatter -> Sv.t * Sv.t -> unit

type conflicts = Sv.t Mv.t

val merge_class : conflicts -> Sv.t -> conflicts

val conflicts : (Sv.t * Sv.t) func -> conflicts

type var_classes

val init_classes : conflicts -> var_classes

val normalize_repr : var_classes -> var Mv.t

exception SetSameConflict

val set_same : var_classes -> var -> var -> var_classes

val get_conflict : var_classes -> var -> Sv.t
