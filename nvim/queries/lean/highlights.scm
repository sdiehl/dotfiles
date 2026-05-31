; Lean 4 highlights for Julian/tree-sitter-lean (pinned revision).
; This file fully replaces lean.nvim's bundled highlights.scm, whose node
; names lag the rewritten grammar. No `; extends` modeline, so config wins.

; Comments
[
  (line_comment)
  (block_comment)
] @comment

[
  (doc_comment)
  (module_doc_comment)
] @comment.documentation

(decl_doc_cmd) @comment.documentation

; Declaration / command keywords
(prelude) @keyword

[
  "import"
  "open"
  "export"
  "namespace"
  "section"
  "end"
  "variable"
  "universe"
  "universes"
  "set_option"
  "attribute"
  "notation"
  "infix"
  "infixl"
  "infixr"
  "prefix"
  "postfix"
  "deriving"
  "extends"
  "where"
  "with"
] @keyword

[
  "def"
  "theorem"
  "lemma"
  "abbrev"
  "axiom"
  "constant"
  "inductive"
  "structure"
  "instance"
  "opaque"
  "example"
] @keyword.function

; Modifiers
[
  "private"
  "protected"
  "scoped"
  "local"
  "noncomputable"
  "unsafe"
  "nonrec"
  "partial"
  "rec"
  "mut"
] @keyword.modifier

[
  (public)
  (meta)
] @keyword.modifier

; Term-level keywords
[
  "fun"
  "forall"
  "exists"
  "let"
  "have"
  "haveI"
  "letI"
  "show"
  "suffices"
  "match"
  "do"
  "by"
  "in"
  "from"
  "obtain"
  "by_cases"
] @keyword

[
  "if"
  "then"
  "else"
] @keyword.conditional

"for" @keyword.repeat

; Hash commands (#check, #eval, ...)
[
  "#check"
  "#check_failure"
  "#eval"
  "#reduce"
  "#print"
  "#print_axioms"
  "#synth"
  "#exit"
  "#version"
] @function.macro

; Sorry / placeholders
(sorry) @keyword.exception
"admit" @keyword.exception

; Builtin sorts and constants
[
  "Type"
  "Sort"
] @type.builtin

[
  (sort_const)
  (type_const)
  (prop_const)
] @type.builtin

[
  (true_const)
  (false_const)
] @boolean

[
  (bot_const)
  (top_const)
  (empty_const)
  (goal_const)
] @constant.builtin

; Declaration names
(def name: (_) @function)
(theorem name: (_) @function)
(abbrev name: (_) @function)
(opaque name: (_) @function)
(constant name: (_) @function)
(axiom name: (_) @function)
(instance name: (_) @function)
(structure name: (_) @type)
(inductive name: (_) @type)
(ctor name: (_) @constructor)

; Namespaces
(namespace name: (identifier) @module)
(section name: (identifier) @module)
(open namespace: (identifier) @module)

; Function application head
(app fn: (identifier) @function.call)

; Field access
(proj field: (_) @property)
(struct_field name: (_) @property)
(field name: (_) @property)

; Binders / parameters
(explicit_binder name: (_) @variable.parameter)
(implicit_binder name: (_) @variable.parameter)
(strict_implicit_binder name: (_) @variable.parameter)
(instance_binder name: (_) @variable.parameter)

; Attributes
(attributes) @attribute

; Literals
(num_lit) @number
(scientific_lit) @number.float
(char_lit) @character
(escape_sequence) @string.escape

[
  (str_lit)
  (raw_string)
] @string

(interpolated_str) @string
(interpolation) @none
(name_lit) @string.special.symbol

; Operators
(binary_op op: _ @operator)
(unary_op op: _ @operator)
(postfix_op op: _ @operator)
(cdot) @operator

[
  ":"
  ":="
  "=>"
  "|"
  "@"
  "←"
  "<-"
] @operator

; Punctuation
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "⟨"
  "⟩"
  "⦃"
  "⦄"
] @punctuation.bracket

[
  ","
  ";"
  "."
] @punctuation.delimiter

; Identifiers (fallback, lowest priority)
(identifier) @variable
(dot_ident) @variable
(hole) @variable.builtin
(named_hole) @variable.builtin
