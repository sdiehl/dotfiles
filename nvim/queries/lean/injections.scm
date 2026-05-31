; Inject markdown into doc comments. Replaces lean.nvim's injections.scm,
; which targets the old grammar's `(comment)` node (now line_comment /
; block_comment / doc_comment). Offsets strip the `/-` ... `-/` delimiters.

((doc_comment) @injection.content
  (#set! injection.language "markdown")
  (#offset! @injection.content 0 3 0 -2))

((module_doc_comment) @injection.content
  (#set! injection.language "markdown")
  (#offset! @injection.content 0 3 0 -2))

((block_comment) @injection.content
  (#set! injection.language "markdown")
  (#offset! @injection.content 0 2 0 -2))
