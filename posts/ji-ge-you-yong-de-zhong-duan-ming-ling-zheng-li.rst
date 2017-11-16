.. title: 有用的终端命令整理
.. slug: ji-ge-you-yong-de-zhong-duan-ming-ling-zheng-li
.. date: 2017-09-28 21:47:01 UTC+08:00
.. tags: shell, terminal, bash
.. category:
.. password:
.. previewimage:

使用 zsh 之后，就养成了不整理终端命令的“坏”习惯。可能当时遇到问题折腾好半天才解决，但却从没有写个日志（哪怕片段）记录下来的想法。因为 zsh 默认保存上万条历史让这一做法显得没有必要，要再次调用的话直接 fzf 搜索，简单修改下回车执行就行。

最近两天抹盘安装了 High Sierra 系统，装完后把之前的 `.zsh_history` 文件拷贝回 home 目录，继续老习惯接着用就成。不过还是有点不放心，一方面担心使用频率超低（但有用）的命令可能会被冲掉，另一方面万一某一天 history 文件损坏就悲剧了，更重要的是有时会到别的电脑上执行命令。所以，还是整理下为好，该命令列表应该会不定期更新。

.. TEASER_END

#. 查找并删除 `.DS_Store` 文件

   `find . -type f -name ".DS_Store" -delete`

   `.DS_Store` 文件有时会引起麻烦，用以上命令清掉就好。 `.DS_Store` 只是举个例子，文件名称可以随便填，可用通配符。还有 `-depth 1` 可用来指定递归深度，比如删除掉 `Downloads` 目录最外面一层所有的 `jpg` 图片。

#. find 也可以用正则表达式

   当然只是有限的正则表达式。比如把符合条件的所有图片移动到桌面。

   ``find . -regex ".*/[a-z0-9]\{32\}\.jpg" -exec mv {} ~/Desktop/ \;``

#. 分别统计文件行数

   `find ~/.hammerspoon -type f -name "*.lua" -print0 | xargs -0 wc -l`

#. 配合 chmod 使用

   ``find . -type f -exec chmod 644 {} \;``

   ``find . -type d -exec chmod 744 {} \;``

   最近的 find 应用案例。把移动硬盘上备份的 repo 复制回新安装的系统，结果提示一大堆文件已更改，真是莫名其妙。`git diff` 一看，文件权限全变成了 755。这才想起老早老早以前把移动硬盘格成了 exFAT 格式，文件权限全丢了。利用以上两行命令，文件全改成 644，文件夹全改成 744，搞完后 repo 恢复正常。

#. 推出所有 dmg 磁盘

   `osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true)'`

   有时候尝试完一堆新软件，懒得一个个点推出。执行一下这个就好。见过别人电脑上差不多 10 个未推出的 dmg 镜像，问干嘛用完不推呢，答曰刚使用 macOS 没这习惯……

#. 重置 LaunchPad

   `defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock`

   如果你习惯让系统内置应用单独一页，同时不想让应用没布满一页就挤到下一页。执行该命令将会重置 LaunchPad。

#. 重置 QuickLook 服务

   `qlmanage -r`

   QuickLook 就是按空格预览的那个。如果你复制了新的预览器（如 markdown、压缩包等）到 `~/Library/QuickLook` 目录，可能需要执行下该命令。

#. 加载新服务

   `launchctl load -w ~/Library/LaunchAgents/com.github.aria2.plist`

   让 aria2 开机后台运行，launchctl 常用命令还有 unload、start、stop 等。

#. 指定内核启动 jupyter

   `jupyter-qtconsole --kernel=python2`

   jupyter console 和 Qt 前端均可用该方式指定启动时的内核。有了 jupyter console ， ipython 以后减少使用为好。 `jupyter-kernelspec list` 列出当前可用的内核。

#. 升级系统 vim

   `brew install vim --with-override-system-vi --with-lua`

   High Sierra 自带 vim 版本已经是 8.0，但编译缺了三个重要特性：clipboard、conceal、lua。用以上命令重新编译个倒也不费劲，时间还很快。不过，更好的选择是直接用 neovim 。

#. neovim 配置位置

   `~/.config/nvim/init.vim` 。我的 vim 配置和 neovim 是共用的，所以执行下 `ln ~/.vimrc ~/.config/nvim/init.vim` 就好。

#. 给 neovim 添加 python 支持

   `pip3 install neovim`

   运行 `:CheckHealth` 可显示 neovim 的状态信息，包括 python2、python3 支持等。如果你使用 pyenv 或 virtualenv 的话，将 `g:python_host_prog` 或 `g:python3_host_prog` 的值设置为虚拟环境中 python 的执行路径。

#. reST 转换为其它格式

   `rst2s5.py ./posts/30-fen-zhong-jian-li-yi-ge-nikola-bo-ke.rst new.html`

   还有其它类似命令： `rst2html5.py` ， `rst2xelex.py` ， `rst2odt.py` 等。

#. you-get 下载视频

   `you-get -i url` 列出可用的视频下载格式； `you-get --format=HD -p mpv url` 指定下载格式，并调用 mpv 播放。

#. 统计文件夹大小

   `du -d1 -h .vim`

   `-d1` 用来指定文件夹层次。

#. 禁用截图阴影

   `defaults write com.apple.screencapture disable-shadow -bool true`

#. 禁用长按输入音调功能

   `defaults write com.github.atom ApplePressAndHoldEnabled -bool false`

   macOS 上长按会弹出音调输入菜单。而如果你某些编辑器使用了 vim 插件，这一行为就显得有些讨厌。以上命令可以指定在某一应用内禁用该功能。

#. 编译 mpv

   `brew install mpv --with-bundle --with-libaacs --with-libarchive --with-libbluray --with-libdvdnav --with-libcaca --with-libdvdread --with-uchardet --with-vapoursynth`

   让 mpv 支持 DVD、蓝光等格式，并打个 bundle 包。

#. 使用 duc 生成磁盘空间图表

   `duc graph --format=png --gradient --palette=greyscale ~/Downloads`

#. 不加载配置启动 Vim

   `vim -u NONE`

#. 指定局域截图

   `screencapture -T5 -R0,776,200,19 ~/Desktop/file5.png`

#. 垂直方向合并多张图

   `convert dock.png clip.png down.png -append test.png`

   如果是 `+append` ，则是水平方向合并。

#. 截掉多余边框

   `convert resize.png -trim tmp.png`

   仅当图像边缘为透明或者纯色时好用。

#. 切图

   `convert resize.png -crop +0+2x195x38 view.png`

#. 叠加图片

   `composite front.png bg.png -gravity center result.png`

#. 按照列表合并多个视频片段

   `ffmpeg -f concat -i new.mp4.txt -c copy new.flv`

#. 从超大图片截取区域部分

   `convert source.png -geometry +113+198 -region 1600x400 tmp.png`

#. 新建一张空白图

   `convert -size 36x660 xc:none -fill "#ffffff" ~/Desktop/new.png`

#. 产生一张黑白对折图

   `convert -size 1275x768 xc:none -fill black -draw "polygon 0,0 0,768 1275,768" -fill white -draw "polygon 0,0 1275,0 1275,768" ~/Desktop/main.png`

#. 对图片应用滤镜

   `convert dark.png mask.png -alpha off -compose CopyOpacity -composite result.png`

#. 扩展图片画布

   `convert youdao.png -background none -gravity center -extent 100x100 ~/Desktop/youdao.png`

#. 把图片指定颜色变为透明

   `convert emoji-evil.jpg -fuzz 1% -transparent "#FDFDFD" new.png`

#. Vim 启动时间 profile

   `nvim --startuptime tmp.txt`

#. 加载 locate 服务

   `sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist`

#. 打印文件额外属性

   `xattr -p LICENSE`

#. 编译 emacs-mac

   `brew install emacs-mac --with-ctags --with-dbus --with-glib --with-gnutls --with-imagemagick --with-spacemacs-icon --with-modules --with-texinfo --with-xml2`

#. 回撤上一个 git 提交

   `git reset --hard HEAD^`

#. 逐帧压缩并缩放 GIF 动图

   `convert Untitled.gif -coalesce -resize 50% -layers OptimizeFrame good.gif`

#. MacTex 自带命令行管理器

   `tlmgr search indentfirst`

   `texdoc tikz` 自带文档查看。

   `sudo tlmgr option repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet/` 更改默认 repo。

   `tlmgr update --all`

#. 磁盘读写查看

   `iostat -d 1`

#. 视频轨道查看

   `ffprobe Homeland.S06E02.720p.HEVC.x265-MeGusta.mkv`

#. Markdown 文件转换为 epub 电子书

   `pandoc file.md -f markdown -t epub -o new.epub`

#. 使用 curl 上传一张图片

   `curl -X POST -d "smfile=/Users/ashfinal/2.png" https://sm.ms/api/upload`

#. 指定 curl 访问 UA

   `curl --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36" https://www.bing.com/az/hprichbg/rb/BMXTunnel_ZH-CN11405649743_1920x1080.jpg -O`

#. man 转换为 PDF 并打开

   `man -t rsync | open -f -a Preview.app`

#. 请求 GitHub Trend 数据

   ``curl -G https://api.github.com/search/repositories --data-urlencode "sort=stars" --data-urlencode "order=desc" --data-urlencode "q=language:java"  --data-urlencode "q=created:>`date -v-7d '+%Y-%m-%d'`" > tmp.json``

#. 生成目录层级报告

   ``tree --charset utf8 -H file:///Users/ashfinal/Downloads ~/Downloads -o ~/tmp.html``

#. 指定进程列头

   `ps -A -ro pid,user,pcpu,pmem,command`

#. 指定命令行代理

   `proxychains4 brew upgrade weechat`

#. 返回 mac 地址

   ``ifconfig en0 | grep ether | awk {'print $2'}``

#. macOS 计算机名相关

   .. code:: shell

      sudo scutil --set HostName "iMBP"
      sudo scutil --set ComputerName "iMBP"
      sudo scutil --set LocalHostName "iMBP"
      sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "iMBP"

#. curl 下载文件显示进度条

   `curl -# http://www.andre-simon.de/zip/highlight-3.36.dmg -O`

#. 调用 curl 下载文件列表

   ``ROW=0; for URL in `cat url.txt`; do ROW=$(($ROW+1)); curl -# $URL -o $ROW; done``

#. pygments 语法高亮文件

   `pygmentize -l python tmp.py -o tmp.html`

#. 上传一个文件

   `curl -F c=@- https://ptpb.pw/ < 9ku.py`

#. 命令行版的 gist

   .. code:: shell

      gist --login
      gist
      gist selenium0.py
      gist -l ashfinal
      gist -d "aria2 launchagent for macOS" com.github.aria2.plist

#. 用各种语音说“Hello World”

   ``for i in `say -v '?' | cut -d ' ' -f 1`; do echo $i && say -v "$i" 'Hello World';done``

#. 列出压缩包文件名

   `unzip -l ZeroNet-mac-dist.zip`

#. 从 html 文件下载图片

   ``lynx -dump http://rom.ligux.com/wallpaper/ | egrep -o "http:.*jpg" | xargs -n1 wget``

#. 烧录系统镜像到 U 盘

   `sudo dd if=Desktop/openSUSE-Tumbleweed-KDE-Live-x86_64-Snapshot20161109-Media.iso of=/dev/disk2 bs=512 conv=noerror,sync`

#. git rebase

   `git rebase -i 6e9ddc5`

#. 从 git 历史中删除二进制文件

   .. code:: shell

      git filter-branch --force --index-filter \\
      'git rm --cached --ignore-unmatch resources/watchbg.png' \\
      --prune-empty --tag-name-filter cat -- --all

   后面还需要三个命令：

   .. code:: shell

      git reflog expire --expire=now --all
      git gc --prune=now
      git gc --aggressive --prune=now

#. 列出中文字体

   ``fc-list :lang=zh-cn | fzf``

#. 文件夹比较报告

   ``diffoscope /usr/local/lib/python3.6/site-packages/jedi Downloads/jedi-0.10.2/jedi-0.10.2/jedi/ --html tmp.html``

#. Nikola 指定新建文件的 jupyter notebook 内核

   `nikola new_post -f ipynb@python2`

#. Atom 安装插件

   `apm install --verbose atom-beautify autocomplete-python git-time-machine file-icons code-peek pigments advanced-open-file atom-ternjs autoprefixer hydrogen script regex-railroad-diagram linter-proselint color-picker platformio-ide-terminal merge-conflicts activate-power-mode atom-latex autocomplete-paths`

#. 生成简短的中文字体列表

   ``fc-list -f "%{family}\n" :lang=zh  > zhfont.txt``
