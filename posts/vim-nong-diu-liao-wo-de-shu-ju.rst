.. title: Vim 弄丢了我的数据！
.. slug: vim-nong-diu-liao-wo-de-shu-ju
.. date: 2017-11-13 19:57:10 UTC+08:00
.. updated: 2017-11-16 14:49:10 UTC+08:00
.. tags: vim, recovery, vimrc
.. category: vim
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

悲剧
====

.. role:: strike
.. role:: amend

昨天（啊不， :strike:`前天` :amend:`大前天` ）在写 `undo branches`_ 那篇文章的时候，VimR_ 编辑器突然毫无征兆的崩溃退出，导致花费好半天翻译过来的几段文字全部丢失。颇具有讽刺意味的是，当时写的文章正是关于在 Vim 编辑器中如何使用 undo branches，避免丢失你宝贵的资料。事情发生时笔者从浏览器中复制了一段文字，然后直接按下 `CMD + V` 粘贴，可能是其中含有一些特殊字符……悲剧就这样发生了。

.. _`undo branches`: /posts/zai-vim-zhong-shi-yong-undo-branches/

.. _VimR: https://github.com/qvacua/vimr

第一反应是去查看 undo 历史，很不幸那几段文字并没有保存其中。于是悲哀地意识到它们是永远也找不回来了：因为 undo branches 其实是保存文件撤销记录，而不是用来应对这种意外灾难的。**真正的灾难应对机制已经被我关闭。**

.. TEASER_END

之前使用终端版 Vim 和 MacVim 时，除了折腾插件外基本没有遇到过崩溃退出的情况。而换用 VimR 之后，几个月内发生了三四次这样的情况。看来，很有可能是 VimR 自身的问题。而且当时翻译文章太过投入，竟然半个多小时都没有按下过一次保存键！

不管怎样，大段文字已经丢失，只能重新来过。再次经历这种事后，我终于意识到将该选项关闭是一个无比错误的决定。

**现在是时候将这一错误纠正过来了。**

错误的配置
==========

这个邪恶的让我后悔半天的配置，只有一句话： ``set noswapfile`` 。事实上，Vim 默认是开启灾难恢复机制的（但是被我用上面的命令关闭掉了！）。如果遇到应用冻结、崩溃退出甚至电脑断电等意外情况，重新打开 Vim 编辑器它会询问你是否恢复文件，选择 OK 则你的宝贝文字就可以回来了。

那这么重要的功能，我为何会傻乎乎地将其关闭？事实上，直到现在，几乎所有流行的 Vim 配置（包括 spf13-vim_ ）都是将该功能关闭的。笔者刚开始学习使用 Vim 时，自然而然地选择了跟随大流。现在看来，隐患不小。

.. _spf13-vim: https://github.com/spf13/spf13-vim

输入 `:h crash` 命令查看 `灾难恢复（crash-recovery）` 小节，里面用大写字母写着：

.. code:: text

   DON'T PANIC!

不要惊慌！即使外星人入侵地球，也不要惊慌！Vim 编辑器会自动将你的文件恢复的。但是！这是建立在你尊重默认设置的基础上的。很显然，我，以及很大一部分使用者，并没有这么做……

难怪你会丢失数据！:(

swap-file
=========

Vim 编辑器的灾难恢复是通过 `swap-file` 发挥作用的。简单的说，当你编辑文件时，它会间隔性地将你的输入自动保存到一个缓冲文件中。这个间隔默认为 200 个字符，如果 4000 毫秒内没有任何输入也会自动保存（均可以配置）。这样，当意外情况发生时，就可以从该缓冲文件里恢复。而如果是正常关闭的话，则对应的缓冲文件会自我删除。

那么，这个缓冲文件到底存放于何处呢？默认的，与打开的文件处在同一目录。电脑性能过剩的时代，大多数人恐怕是打开几十个甚至上百个 buffer 的，而且平时也不关闭 Vim 编辑器。这就使得这个缓存文件，很容易“污染”你的目录，将其弄的乱糟糟的。我猜这也是为何相当一部分人选择关闭该灾难恢复机制——相较于越来越低的灾难发生概率，貌似乱糟糟的目录更影响人的心情？

当我查看著名 Vim 配置 `amix/vimrc`_ 时，作者给出关闭该机制的原因是：

.. _`amix/vimrc`: https://github.com/amix/vimrc

.. code:: vim

   " Turn backup off, since most stuff is in SVN, git et.c anyway...
   set nobackup
   set nowb
   set noswapfile

显然，这个理由细想一下是站不住脚的。 SVN、git 等版本管理软件与上面描述的灾难恢复机制考虑的场景是完全不同的： `swap-file` 是针对电脑崩溃，而你的 **文件没有保存** 的情况；而版本管理则是 **文件已经保存** ，并提交给版本管理系统，然后发生意外丢失了这些文件的情况。大多数人撞见前一种情况的几率更高， 而且 `swap-file` 处理的文件粒度更小更精细。

重新调整
========

Anyway，尽管现在硬盘损坏、系统崩溃、突然断电等情况几乎是见不到，但应用冻结/崩溃的情况（就像刚刚发生在我身上的那样）还是挺常见的。考虑到这一情况，笔者决定将这一错误配置纠正过来。操作很简单，只需将 `set noswapfile` 这一行删除掉即可。同时，我也不希望这些缓存文件散落各处，而是希望它们统一存放到一个文件夹。阅读使用手册及一些 `网络`_ `搜索`_ 之后，笔者认为以下几行即可满足要求：

.. code:: vim

   if !isdirectory(expand("~/.vim/swapfiles"))
       call mkdir($HOME . "/.vim/swapfiles", "p")
   endif
   set dir=~/.vim/swapfiles//

.. _`网络`: http://vim.wikia.com/wiki/Remove_swap_and_backup_files_from_your_working_directory

.. _`搜索`: https://coderwall.com/p/sdhfug/vim-swap-backup-and-undo-files

前面三行当文件夹不存在时，创建之。 `mkdir` 是 Vim 的内置函数，避免直接调用 `!mkdir` 外部命令在 Windows 上无法工作。最后一行，将缓存文件目录设置为刚创建的文件夹。最后面的 ``//`` 是让缓存文件名称包含完整路径，避免编辑相同名称的文件时造成冲突。

实践验证
========

保存 `.vimrc` 文件，重启 Vim 编辑器。注意到 `~/.vim/swapfiles` 文件夹已创建，随便编辑一个文件 `test123.txt` ，并输入 `this is a test` ，名为 `%Users%ashfinal%test123.txt.swp` 的缓存文件将会自动产生。在任务管理器里直接杀掉 Vim 进程，模拟软件崩溃。输入 `vim test123.txt` 命令，将会提示你是否恢复该文件：

.. figure:: /images/recover_file_1.thumbnail.png
   :align: center
   :target: /images/recover_file_1.png

   提示是否恢复文件

我们当然选择 `R(ecover)` 啦。

回车之后就会发现，刚才未保存的文本回来了！

当然，你也可以不带参数启动 Vim 之后，再使用 `:recover [file]` 命令来恢复未保存的文件。

总结
====

通过以上介绍，我们发现 `swap-file` 是个很好的灾难恢复机制，而且与 SVN、git 等等是完全不同的使用场景。网络上一些配置和文章推荐将其关闭，实在是太误导人了。如果，你也遇到过和我相同的情况，或者认同我在文中的做法，请检查你的 Vim 配置并确保其打开！

最后，笔者的 Vim 配置已经放到 GitHub_ 上，欢迎试用。如果你有别的 Vim 使用技巧和建议，也欢迎在评论区指出。

.. _GitHub: https://github.com/ashfinal/vimrc-config
