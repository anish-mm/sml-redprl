structure NominalLcfOperatorData =
struct
  (* We use symbols/atoms to index into the context. *)
  type intro_params =
    {rule : int option}

  type eq_params =
    {rule : int option}


  datatype 'i script_operator =
      SEQ of int
    | ALL | EACH | FOCUS of int
    | REC
    | INTRO of intro_params
    | EQ of eq_params
    | ELIM of 'i * Sort.t | HYP of 'i * Sort.t | UNHIDE of 'i * Sort.t
    | ID | FAIL | TRACE of Sort.t
    | CSTEP of int | CEVAL | CSYM
    | REWRITE_GOAL of Sort.t | EVAL_GOAL
end

structure NominalLcfOperator : OPERATOR =
struct
  open NominalLcfOperatorData SortData

  structure Arity = Arity

  type 'i t = 'i script_operator

  local
    fun op* (a, b) = (a, b) (* symbols sorts, variable sorts *)
    fun op<> (a, b) = (a, b) (* valence *)
    fun op->> (a, b) = (a, b) (* arity *)
    fun op^ (x, n) = List.tabulate (n, fn _ => x)
    infix 5 <> ->>
    infix 6 * ^
  in
    fun arity (SEQ n) =
          [ [] * [] <> TAC
          , (EXP ^ n) * [] <> MTAC
          ] ->> TAC
      | arity ALL =
          [ [] * [] <> TAC
          ] ->> MTAC
      | arity EACH =
          [ [] * [] <> VEC TAC
          ] ->> MTAC
      | arity (FOCUS i) =
          [ [] * [] <> TAC
          ] ->> MTAC
      | arity (INTRO _) =
          [] ->> TAC
      | arity (EQ _) =
          [] ->> TAC
      | arity (ELIM _) =
          [] ->> TAC
      | arity (HYP _) =
          [] ->> TAC
      | arity (UNHIDE _) =
          [] ->> TAC
      | arity ID =
          [] ->> TAC
      | arity FAIL =
          [] ->> TAC
      | arity (TRACE tau) =
          [ [] * [] <> tau
          ] ->> TAC
      | arity REC =
          [ [] * [TAC] <> TAC
          ] ->> TAC
      | arity (CSTEP _) =
          [] ->> TAC
      | arity CSYM =
          [] ->> TAC
      | arity CEVAL =
          [] ->> TAC
      | arity (REWRITE_GOAL tau) =
          [ [] * [] <> tau
          ] ->> TAC
      | arity EVAL_GOAL =
          [] ->> TAC
  end

  fun support (ELIM (target, tau)) = [(target, tau)]
    | support (HYP (target, tau)) = [(target, tau)]
    | support (UNHIDE (target, tau)) = [(target, tau)]
    | support _ = []

  fun map f =
    fn SEQ n => SEQ n
     | ALL => ALL
     | EACH => EACH
     | FOCUS i => FOCUS i
     | INTRO p => INTRO p
     | EQ p => EQ p
     | ELIM (target, tau) => ELIM (f target, tau)
     | HYP (target, tau) => HYP (f target, tau)
     | UNHIDE (target, tau) => UNHIDE (f target, tau)
     | ID => ID
     | FAIL => FAIL
     | TRACE tau => TRACE tau
     | REC => REC
     | CSTEP i => CSTEP i
     | CSYM => CSYM
     | CEVAL => CEVAL
     | REWRITE_GOAL tau => REWRITE_GOAL tau
     | EVAL_GOAL => EVAL_GOAL

  fun eq f =
    fn (SEQ n1, SEQ n2) => n1 = n2
     | (ALL, ALL) => true
     | (EACH, EACH) => true
     | (FOCUS i1, FOCUS i2) => i1 = i2
     | (ELIM (u, sigma), ELIM (v, tau)) => f (u, v) andalso sigma = tau
     | (HYP (u, sigma), HYP (v, tau)) => f (u, v) andalso sigma = tau
     | (UNHIDE (u, sigma), UNHIDE (v, tau)) => f (u, v) andalso sigma = tau
     | (ID, ID) => true
     | (FAIL, FAIL) => true
     | (TRACE tau1, TRACE tau2) => tau1 = tau2
     | (REC, REC) => true
     | (CSTEP n1, CSTEP n2) => n1 = n2
     | (CSYM, CSYM) => true
     | (CEVAL, CEVAL) => true
     | (REWRITE_GOAL tau1, REWRITE_GOAL tau2) => tau1 = tau2
     | (EVAL_GOAL, EVAL_GOAL) => true
     | _ => false

  fun toString f =
    fn (SEQ _) => "seq"
     | ALL => "all"
     | EACH => "each"
     | FOCUS i => "some{" ^ Int.toString i ^ "}"
     | INTRO {rule} => "intro" ^ (case rule of NONE => "" | SOME i => "{" ^ Int.toString i ^ "}")
     | EQ {rule} => "eq" ^ (case rule of NONE => "" | SOME i => "{" ^ Int.toString i ^ "}")
     | ELIM (target,tau) => "elim[" ^ f target ^ " : " ^ Sort.toString tau ^ "]"
     | HYP (target, tau) => "hyp[" ^ f target ^ " : " ^ Sort.toString tau ^ "]"
     | UNHIDE (target, tau) => "unhide[" ^ f target ^ " : " ^ Sort.toString tau ^ "]"
     | ID => "id"
     | FAIL => "fail"
     | TRACE tau => "trace{" ^ Sort.toString tau ^ "}"
     | REC => "rec"
     | CSTEP n => "cstep{" ^ Int.toString n ^ "}"
     | CSYM => "csym"
     | CEVAL => "ceval"
     | REWRITE_GOAL tau => "rewrite-goal{" ^ Sort.toString tau ^ "}"
     | EVAL_GOAL => "eval-goal"
end
