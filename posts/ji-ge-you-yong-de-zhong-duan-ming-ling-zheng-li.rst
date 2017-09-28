.. title: 几个有用的终端命令整理
.. slug: ji-ge-you-yong-de-zhong-duan-ming-ling-zheng-li
.. date: 2017-09-28 21:47:01 UTC+08:00
.. tags:
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

使用 zsh 之后，就养成了不整理终端命令的“坏”习惯。可能当时遇到问题折腾好半天才解决，但却从没有写个日志（哪怕片段）记录下来的想法。因为 zsh 默认保存上万条历史记录让这一想法显得没有必要，要再次调用的话直接 fzf 搜索，简单修改下回车执行就行。

最近两天抹盘安装了 High Sierra 系统，装完后把之前的 `.zsh_history` 文件拷贝回 home 目录，保持“坏”习惯继续接着用就成。不过还是有点不放心，一方面担心使用频率超低（但有用）的命令可能会被冲掉，另一方面万一某一天 history 文件损坏就悲剧了，另外有时也会有到别的电脑上执行命令的需求。所以，还是整理下为好，该命令列表应该会不定期更新。

.. TEASER_END

1. 查找并删除 `.DS_Store` 文件

   `find . -type f -name ".DS_Store" -delete`

   `.DS_Store` 文件有时会引起些小麻烦，用以上命令清掉就好。 `.DS_Store` 只是举个例子，文件名称可以随便填，可用通配符。还有 `-depth 1` 可用来指定递归深度，比如删除掉 `Downloads` 目录最外面一层所有的 `jpg` 图片。

2. find 也可以用正则表达式

   当然只是有限的正则表达式。比如把符合条件的所有图片移动到桌面。

   ``find . -regex ".*/[a-z0-9]\{32\}\.jpg" -exec mv {} ~/Desktop/ \;``

3. 分别统计文件行数

   `find ~/.hammerspoon -type f -name "*.lua" -print0 | xargs -0 wc -l`

4. 配合 chmod 使用

   ``find . -type f -exec chmod 644 {} \;``

   ``find . -type d -exec chmod 744 {} \;``

   最近的 find 应用案例。把移动硬盘上备份的 repo 复制回新安装的系统，结果提示一大堆文件已更改，真是莫名其妙。`git diff` 一看，文件权限全变成了 755。这才想起老早老早以前把移动硬盘格成了 exFAT 格式，文件权限全丢了。利用以上两行命令，文件全改成 644，文件夹全改成 744，搞完后 repo 恢复正常。

5. 推出所有 dmg 磁盘

   `osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true)'`

   有时候尝试完一堆新软件，懒得一个个点推出。执行一下这个就好。见过别人电脑上差不多 10 个未推出的 dmg 镜像，问干嘛用完不推呢，答曰刚使用 macOS 没这习惯……

6. 重置 LaunchPad

   `defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock`

   如果你习惯让系统内置应用单独一页，同时不想让应用没布满一页就挤到下一页。执行该命令非常有效。

7. 重置 QuickLook 服务

   `qlmanage -r`

   QuickLook 就是按空格预览的那个东东。如果你复制了新的预览器（如 markdown、压缩包等）到 `~/Library/QuickLook` 目录，可能需要执行下该命令。

8. 加载新服务

   `launchctl load -w ~/Library/LaunchAgents/com.github.aria2.plist`

   让 aria2 开机后台运行，launchctl 常用命令还有 start、stop 等。

9. 指定内核启动 jupyter

   `jupyter-qtconsole --kernel=python2`

   jupyter console 和 Qt 前端均可用该方式指定启动时的内核。有了 jupyter console ， ipython 以后减少使用为好。 `jupyter-kernelspec list` 列出当前可用的内核。

10. 升级系统 vim

    `brew install vim --with-override-system-vi --with-lua`

    High Sierra 自带 vim 版本已经是 8.0，但编译缺了三个重要特性：clipboard、conceal、lua。用以上命令重新编译个倒也不费劲，时间还很快。不过，更好的选择是直接用 neovim 。

11. neovim 配置位置

    `~/.config/nvim/init.vim` 。我的 vim 配置和 neovim 是共用的，所以执行下 `ln ~/.vimrc ~/.config/nvim/init.vim` 就好。

12. 给 neovim 添加 python 支持

    `pip3 install neovim`

    运行 `:CheckHealth` 可显示 neovim 的状态信息，包括 python2、python3 支持等。如果你使用 pyenv 或 virtualenv 的话，将 `g:python_host_prog` 或 `g:python3_host_prog` 的值设置为虚拟环境中 python 的执行路径。

13. reST 转换为其它格式

    `rst2s5.py ./posts/30-fen-zhong-jian-li-yi-ge-nikola-bo-ke.rst new.html`

    还有其它类似命令： `rst2html5.py` ， `rst2xelex.py` ， `rst2odt.py` 等。

14. you-get 下载视频

    `you-get -i url` 列出可用的视频下载格式； `you-get --format=HD -p mpv url` 指定下载格式，并调用 mpv 播放。

15. 统计文件夹大小

    `du -d1 -h .vim`

    `-d1` 用来指定文件夹层次。
