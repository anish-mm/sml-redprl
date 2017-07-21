
type pos = string -> Coord.t
type svalue = Tokens.svalue
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult = (svalue, pos) token
type arg = string

val pos = ref Coord.init
val eof = fn (fileName : string) => Tokens.EOF (!pos, !pos)

fun incPos n = pos := (Coord.addchar n o (!pos))

fun posTuple n =
  let
    val l = !pos
    val () = incPos n
    val r = !pos
  in
    (l, r)
  end

fun posTupleWith n x =
  let
    val (l, r) = posTuple n
  in
    (x, l, r)
  end

%%
%arg (fileName : string);
%header (functor RedPrlLexFun (structure Tokens : RedPrl_TOKENS));
upper = [A-Z];
lower = [a-z];
digit = [0-9];
identChr = [a-zA-Z0-9\'/-];
whitespace = [\ \t];
%%

\n                 => (pos := (Coord.nextline o (!pos)); continue ());
{whitespace}+      => (incPos (size yytext); continue ());
"-"?{digit}+       => (Tokens.NUMERAL (posTupleWith (size yytext) (valOf (IntInf.fromString yytext))));
"//"[^\n]*         => (continue ());


"<|"               => (Tokens.LANGLE_PIPE (posTuple (size yytext)));
"|>"               => (Tokens.RANGLE_PIPE (posTuple (size yytext)));
"("                => (Tokens.LPAREN (posTuple (size yytext)));
")"                => (Tokens.RPAREN (posTuple (size yytext)));
"<"                => (Tokens.LANGLE (posTuple (size yytext)));
">"                => (Tokens.RANGLE (posTuple (size yytext)));
"{"                => (Tokens.LBRACKET (posTuple (size yytext)));
"}"                => (Tokens.RBRACKET (posTuple (size yytext)));
"["                => (Tokens.LSQUARE (posTuple (size yytext)));
"]"                => (Tokens.RSQUARE (posTuple (size yytext)));
"."                => (Tokens.DOT (posTuple (size yytext)));
","                => (Tokens.COMMA (posTuple (size yytext)));
":"                => (Tokens.COLON (posTuple (size yytext)));
";"                => (Tokens.SEMI (posTuple (size yytext)));
"#"                => (Tokens.HASH (posTuple (size yytext)));
"="                => (Tokens.EQUALS (posTuple (size yytext)));
"~>"               => (Tokens.SQUIGGLE_ARROW (posTuple (size yytext)));
"->"               => (Tokens.RIGHT_ARROW (posTuple (size yytext)));
"=>"               => (Tokens.DOUBLE_RIGHT_ARROW (posTuple (size yytext)));
"==>"              => (Tokens.LONG_RIGHT_ARROW (posTuple (size yytext)));
"<-"               => (Tokens.LEFT_ARROW (posTuple (size yytext)));
"`"                => (Tokens.BACK_TICK (posTuple (size yytext)));
"*"                => (Tokens.TIMES (posTuple (size yytext)));
"!"                => (Tokens.BANG (posTuple (size yytext)));
"@"                => (Tokens.AT_SIGN (posTuple (size yytext)));
"$"                => (Tokens.DOLLAR_SIGN (posTuple (size yytext)));
"||"               => (Tokens.DOUBLE_PIPE (posTuple (size yytext)));
"|"                => (Tokens.PIPE (posTuple (size yytext)));
"%"                => (Tokens.PERCENT (posTuple (size yytext)));
"_"                => (Tokens.UNDER (posTuple (size yytext)));
">>"               => (Tokens.DOUBLE_RANGLE (posTuple (size yytext)));
"?"                => (Tokens.QUESTION (posTuple (size yytext)));

"fcom"             => (Tokens.FCOM (posTuple (size yytext)));
"bool"             => (Tokens.BOOL (posTuple (size yytext)));
"tt"               => (Tokens.TT (posTuple (size yytext)));
"ff"               => (Tokens.FF (posTuple (size yytext)));
"if"               => (Tokens.IF (posTuple (size yytext)));
"wbool"            => (Tokens.WBOOL (posTuple (size yytext)));
"wool"             => (Tokens.WBOOL (posTuple (size yytext)));
"wif"              => (Tokens.WIF (posTuple (size yytext)));
"wbool-rec"        => (Tokens.WIF (posTuple (size yytext)));
"wool-rec"         => (Tokens.WIF (posTuple (size yytext)));
"nat"              => (Tokens.NAT (posTuple (size yytext)));
"zero"             => (Tokens.ZERO (posTuple (size yytext)));
"succ"             => (Tokens.SUCC (posTuple (size yytext)));
"nat-rec"          => (Tokens.NAT_REC (posTuple (size yytext)));
"int"              => (Tokens.INT (posTuple (size yytext)));
"negsucc"          => (Tokens.NEGSUCC (posTuple (size yytext)));
"int-rec"          => (Tokens.INT_REC (posTuple (size yytext)));
"void"             => (Tokens.VOID (posTuple (size yytext)));
"S1"               => (Tokens.S1 (posTuple (size yytext)));
"base"             => (Tokens.BASE (posTuple (size yytext)));
"loop"             => (Tokens.LOOP (posTuple (size yytext)));
"S1-rec"           => (Tokens.S1_REC (posTuple (size yytext)));
"lam"              => (Tokens.LAMBDA (posTuple (size yytext)));
"pair"             => (Tokens.PAIR (posTuple (size yytext)));
"fst"              => (Tokens.FST (posTuple (size yytext)));
"snd"              => (Tokens.SND (posTuple (size yytext)));
"record"           => (Tokens.RECORD (posTuple (size yytext)));
"tuple"            => (Tokens.TUPLE (posTuple (size yytext)));
"path"             => (Tokens.PATHS (posTuple (size yytext)));
"abs"              => (Tokens.ABS (posTuple (size yytext)));
"hcom"             => (Tokens.HCOM (posTuple (size yytext)));
"coe"              => (Tokens.COE (posTuple (size yytext)));

"then"             => (Tokens.THEN (posTuple (size yytext)));
"else"             => (Tokens.ELSE (posTuple (size yytext)));
"let"              => (Tokens.LET (posTuple (size yytext)));
"with"             => (Tokens.WITH (posTuple (size yytext)));
"case"             => (Tokens.CASE (posTuple (size yytext)));
"of"               => (Tokens.OF (posTuple (size yytext)));

"dim"              => (Tokens.DIM (posTuple (size yytext)));
"exn"              => (Tokens.EXN (posTuple (size yytext)));

"exp"              => (Tokens.EXP (posTuple (size yytext)));
"tac"              => (Tokens.TAC (posTuple (size yytext)));
"triv"             => (Tokens.TRIV (posTuple (size yytext)));

"Print"            => (Tokens.CMD_PRINT (posTuple (size yytext)));
"Extract"          => (Tokens.CMD_EXTRACT (posTuple (size yytext)));
"Def"              => (Tokens.DCL_DEF (posTuple (size yytext)));
"Tac"              => (Tokens.DCL_TAC (posTuple (size yytext)));
"Thm"              => (Tokens.DCL_THM (posTuple (size yytext)));
"Rule"             => (Tokens.DCL_RULE (posTuple (size yytext)));
"by"               => (Tokens.BY (posTuple (size yytext)));
"in"               => (Tokens.IN (posTuple (size yytext)));

"fresh"            => (Tokens.FRESH (posTuple (size yytext)));

"rec"              => (Tokens.MTAC_REC (posTuple (size yytext)));
"repeat"           => (Tokens.MTAC_REPEAT (posTuple (size yytext)));
"progress"         => (Tokens.MTAC_PROGRESS (posTuple (size yytext)));
"id"               => (Tokens.RULE_ID (posTuple (size yytext)));
"symmetry"         => (Tokens.RULE_SYMMETRY (posTuple (size yytext)));
"auto-step"        => (Tokens.RULE_AUTO_STEP (posTuple (size yytext)));
"auto"             => (Tokens.MTAC_AUTO (posTuple (size yytext)));
"hyp"              => (Tokens.HYP (posTuple (size yytext)));
"elim"             => (Tokens.RULE_ELIM (posTuple (size yytext)));
"head-expand"      => (Tokens.RULE_HEAD_EXP (posTuple (size yytext)));
"unfold"           => (Tokens.RULE_UNFOLD (posTuple (size yytext)));
"lemma"            => (Tokens.RULE_LEMMA (posTuple (size yytext)));
"cut-lemma"        => (Tokens.RULE_CUT_LEMMA (posTuple (size yytext)));
"rule"             => (Tokens.RULE_LEMMA (posTuple (size yytext)));

"true"             => (Tokens.JDG_TRUE (posTuple (size yytext)));
"type"             => (Tokens.JDG_TYPE (posTuple (size yytext)));
"synth"            => (Tokens.JDG_SYNTH (posTuple (size yytext)));

{lower}{identChr}* => (Tokens.VARNAME (posTupleWith (size yytext) yytext));
{upper}{identChr}* => (Tokens.OPNAME (posTupleWith (size yytext) yytext));

.                  => (RedPrlLog.print RedPrlLog.FAIL (SOME (Pos.pos (!pos yyarg) (!pos yyarg)), Fpp.text ("lexical error: skipping unrecognized character '" ^ yytext ^ "'")); continue ());
