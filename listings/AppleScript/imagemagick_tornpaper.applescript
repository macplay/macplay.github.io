(*
    简介：Torn!.app — 给图片添加撕纸效果
    使用方法：将(多张)图片拖动到Torn!图标即可
    注意事项：依赖于ImageMagick命令行(功能强大的图片处理库)，推荐使用brew安装。
    当然目前Torn!功能比较简单，后续视时间和精力增加功能。

                                                by ashfinal 2015.02.16
*)

property exec_path : "/usr/local/bin/" -- ImageMagick 路径
property resize_span : 640 -- 高于该值的图片会被resize
property all_corner : false -- 左上边角是否也添加撕纸效果？
property intensity : 80 -- 撕边强度，单位为像素(px)
property has_shadow : true -- 是否加上阴影？

on open filelist
    tell application "Finder"
        set file_pool to {}
        repeat with i in filelist
            set file_type to name extension of i as string
            set lower_type to do shell script "echo " & quoted form of (file_type) & " | tr A-Z a-z"
            if lower_type is in {"tiff", "png", "jpg", "jpeg"} then
                copy i to the end of file_pool
            end if
        end repeat
        if (count of file_pool) > 0 then
            do shell script "[[ -d ~/Desktop/IM-Out ]] || mkdir ~/Desktop/IM-Out"
            if all_corner is false then
                set extend_width to intensity
            else
                set extend_width to 0
            end if
            repeat with j in file_pool
                set file_name to name of j
                set file_ext to name extension of j
                set name_len to (length of file_name) - (length of file_ext) - 1
                set pure_name to text 1 through name_len of file_name
                set satisfy_name to findandreplace(" ", "\\ ", pure_name) of me
                set file_path to POSIX path of j
                set satisfy_path to findandreplace(" ", "\\ ", file_path) of me
                try
                    --set width_x to do shell script exec_path & "identify -format '%w' " & satisfy_path
                    --set height_y to do shell script exec_path & "identify -format '%h' " & satisfy_path
                    --set pic_res to do shell script exec_path & "identify -format '%wx%h' " & satisfy_path
                    set resize_opt to " -resize " & "x" & resize_span & "\\>"
                    do shell script exec_path & "convert " & satisfy_path & resize_opt & " -gravity northwest -splice " & extend_width & "x" & extend_width & "+0+0 \\( +clone -alpha extract -virtual-pixel black -spread " & intensity & " -blur 0x3 -threshold 50% -spread 1 -blur 0x.7 \\) -alpha off -compose copy_opacity -composite -gravity northwest -chop " & extend_width & "x" & extend_width & " ~/Desktop/IM-Out/" & satisfy_name & "-tp.png"
                    if has_shadow is true then
                        do shell script exec_path & "convert ~/Desktop/IM-Out/" & satisfy_name & "-tp.png" & " \\( +clone -background black -shadow 60x4+4+4 \\) +swap -background white -layers merge +repage" & " ~/Desktop/IM-Out/" & satisfy_name & "-tp.png"
                    end if
                on error eText number eNum
                    display dialog "错误代码：" & eNum & " 详情：" & eText & return & "请确认ImageMagick已安装并正确配置，如仍有问题请联系：ashfinal@sina.cn" & " 微博：敢和蜗牛赛跑" buttons {"OK"} default button 1 with title "出现错误   （；￣ェ￣）" with icon note
                    exit repeat
                end try
            end repeat
            do shell script "open ~/Desktop/IM-Out"
        end if
    end tell
end open

on run
    display dialog "简介：Torn!.app — 给图片添加撕纸效果
使用方法：将(多张)图片拖动到Torn!图标即可
注意事项：依赖于ImageMagick命令行，推荐使用brew安装。" buttons {"OK"} default button 1 with title "关于" with icon note
end run

on findandreplace(toFind, replaceWith, theText)
    set tid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to toFind
    set textItems to theText's text items
    set AppleScript's text item delimiters to replaceWith
    set editedText to textItems as text
    set AppleScript's text item delimiters to tid
    return editedText
end findandreplace
