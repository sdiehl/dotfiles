highlight OverLength ctermbg=red ctermfg=white guibg=#FF3333 guifg=#EEEEEE
let matchOverLength = matchadd("OverLength", "\\%81v.*")

highlight BadWhitespace ctermbg=red guibg=red
let matchBadWhitespace = matchadd("BadWhitespace", "\\s\\+$")

highlight BadTabs ctermbg=red guibg=red
let matchBadTabs = matchadd("BadTabs", "^\\t+")
