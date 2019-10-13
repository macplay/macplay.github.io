augroup last_modified
    autocmd!
    autocmd BufWritePre,FileWritePre */macplay\.github\.io/posts/*.rst\|md call LastModified()
augroup END

function! LastModified()
    let s:str = ".. updated: " . strftime("%Y-%m-%d %T UTC+08:00")
    let s:l = line(".")
    let s:c = col(".")
    call cursor(1,1)
    let s:updated = search("^.. updated:", "W", 20)
    if s:updated
        call setline(s:updated, s:str)
    else
        let s:date = search("^.. date:", "W", 20)
        if s:date
            call append(s:date, s:str)
        endif
    endif
    call cursor(s:l, s:c)
endfunction
