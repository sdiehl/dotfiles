if !has('conceal')
    finish
endif

syntax match pyNiceOperator "\<in\>" conceal cchar=∈
syntax match pyNiceOperator "\<or\>" conceal cchar=∨
syntax match pyNiceOperator "\<and\>" conceal cchar=∧
syntax match pyNiceOperator "||" conceal cchar=∨
syntax match pyNiceOperator "&&" conceal cchar=∧

" include the space after “not” – if present – so that “not a” becomes “¬a”
syntax match pureNiceOperator "\<not\%( \|\>\)" conceal cchar=¬
syntax match pureNiceOperator "<=" conceal cchar=≤
syntax match pureNiceOperator ">=" conceal cchar=≥
syntax match pureNiceOperator "==" conceal cchar=≡
syntax match pureNiceOperator "\~=" conceal cchar=≠
syntax match pureNiceOperator "\<not in\>" conceal cchar=∉

syntax match pureNiceOperator "\\" conceal cchar=λ
syntax match pureNiceOperator "<-" conceal cchar=←
syntax match pureNiceOperator "->" conceal cchar=→
syntax match pureNiceOperator "<=" conceal cchar=≲
syntax match pureNiceOperator ">=" conceal cchar=≳
syntax match pureNiceOperator "==" conceal cchar=≡
syntax match pureNiceOperator "\/=" conceal cchar=≠
syntax match pureNiceOperator "=>" conceal cchar=⇒
syntax match pureNiceOperator ">>" conceal cchar=»
syntax match pureNiceOperator "<<" conceal cchar=«
syntax match pureniceoperator "++" conceal cchar=⧺
syntax match pureNiceOperator "\<forall\>" conceal cchar=∀
syntax match pureNiceOperator "\<pi\>" conceal cchar=π
    
" Only replace the dot, avoid taking spaces around.
syntax match pureNiceOperator /\s\.\s/ms=s+1,me=e-1 conceal cchar=∘
syntax match pureNiceOperator "\.\." conceal cchar=‥

syntax match pureNiceOperator "\<sum\>" conceal cchar=∑
syntax match pureNiceOperator "\<product\>" conceal cchar=∏ 
syntax match pureNiceOperator "\<sqrt\>" conceal cchar=√ 

hi link pureNiceOperator Operator
hi! link Conceal Operator

set conceallevel=0
