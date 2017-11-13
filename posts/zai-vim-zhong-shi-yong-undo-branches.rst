.. title: 【译】在 Vim 中使用 undo branches
.. slug: zai-vim-zhong-shi-yong-undo-branches
.. date: 2017-11-13 11:14:24 UTC+08:00
.. tags: vim, translation
.. category:
.. link: http://vim.wikia.com/wiki/Using_undo_branches
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

Vim 支持标准的 `撤销和重做`_ ，同时还支持 `undo branches` 。这允许你撤销一些更改，然后再做新的更改，而在此过程中 **所有** 的更改都在 `undo tree` 中得到保留。你甚至还能把撤销（undo）记录保存到文件中，下次编辑同一文件时恢复这些记录。本文将向你初步展示如何在 Vim 中使用 `undo branches` 。

.. _`撤销和重做`: http://vim.wikia.com/wiki/Undo_and_Redo

.. TEASER_END

.. contents:: 文章目录

什么是 undo branches
====================

Vim 7.0 及更高版本支持 `undo branches` 。该特性使得即便你返回到文本的更早状态，并从那个状态点开始编辑，也完全不会丢失历史更改记录。

此处的 **更改** 指的是你在 `insert mode` 下所做的全部编辑操作，或者在 `normal mode` 或 `command-line mode` 下执行的单次编辑命令。一旦你离开 `insert mode` ，一个新的 **更改** 将会被记录。因此，如要创建一个新的能回滚的 **更改** ，离开 `insert mode` 是非常重要的。否则的话，你在 `insert mode` 下所做的所有 **更改** 都会被认为是 **同一更改** 。在 `insert mode` 下，你也可以按 `Ctrl-G` 然后 `u` 打断 undo 序列，并开始记录一个新的 **更改** 。事实上，在某些场景下自动化这一过程可能是个很好的主意。比如，你可以 `一次撤销一行插入的文本`_ ， `按下 Ctrl-U 后又改变主意在 normal mode 恢复文本`_ ，或者 `在 normal mode 下执行不小心在 insert mode 输入的命令`_ 。注意：某些命令（ `Ctrl-G u` 就是其中之一）会将你在 `insert mode` 下的编辑操作打散为多次更改。更多请参考 `:help ins-special-special`_ 。

.. _`一次撤销一行插入的文本`: http://vim.wikia.com/wiki/VimTip86
.. _`按下 Ctrl-U 后又改变主意在 normal mode 恢复文本`: http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
.. _`在 normal mode 下执行不小心在 insert mode 输入的命令`: http://vim.wikia.com/wiki/Execute_accidentally_inserted_commands
.. _`:help ins-special-special`: http://vimdoc.sourceforge.net/cgi-bin/help?tag=ins-special-special

你可以将 `undo branches` 想象为一棵树，它将你对文本所做的第一个更改作为顶层节点。任何时候撤销一些更改并做新的更改时，你都创建了一个新的节点。

在 `normal mode` 下按 `u` 将会撤销你的最后一个更改，同时向上移动一个层级。相反的，重做（Ctrl-R）将会在这棵树上向下移动一个层级。这一点与 Vim 7.0 之前的版本是一样的，也与其它 Vi 克隆版是向下兼容的。

但是，你也可以按 **更改** 创建的时间顺序来随意移动。比如， `g-` 命令会移动到前一个更改，而不用理会它究竟在 `undo tree` 的哪个位置。更进一步的说，使用 `g-` 会按时间顺序将你移动到上一个更改。 `g-` 在 `undo tree` 上向后移动，而 `g+` 则是向前移动，直到恢复到文本的初始状态。

除了 `g+` 和 `g-` 命令外，你也可以使用 `ex-command` 命令： `:earlier` 和 `:later` 。这两个命令均可以选择性地接收一个数字或者你想移动到的时间。比如：

.. code:: vim

   :earlier 10

将会在 `undo tree` 中向前移动 10 个更改。

.. code:: vim

   :earlier 1h

将会恢复到 1 小时前的文本状态（秒数则使用 `s` ，分钟 `m` ，小时 `h` ）。

.. code:: vim

   :later 10

或者

.. code:: vim

   :later 1h

将会向后移动直到恢复文本缓冲区到最新的状态。

Vim 7.3 版本中添加了新的 `Persistent undo`_ ，以上的 `ex-command` 命令也相应提供了方便回滚到上一次保存状态（如 2 次保存前，3 次保存前）的能力。命令如下： `:earlier 1f` 。

举例说明
========

假设你开始一次新的更改：

进入 `insert mode` 并输入 `1` ，然后离开 `insert mode` 。现在再次进入 `insert mode` 输入 `2` ，离开 `insert mode` 。最后进入 `insert mode` 输入 `3` ，并再次离开。你的文本缓冲区现在看起来是这样：

.. code:: text

   1 2 3

你可以随时使用以下命令检查最近更改数目：

.. code:: vim

   :echo changenr()

这将会输出 `3` ，因为你做了三次更改（总共进入 `insert mode` 三次）。

现在按 `u` 撤销一次更改，再次进入 `insert mode` 将缓冲区变更为以下这样：

.. code:: text

   1 2 4

你现在已经从缓冲区的上一次状态分支出来，创建了一个新的 `undo branches` 。使用

.. code:: vim

   :echo changenr()

将会输出 `4` 。

如果你在 `normal mode` 下按 `u` ，你将回退到

.. code:: text

   1 2

再次按下 `u` 缓冲区将会变为

.. code:: text

   1

如果你最后再按一下 `u` ，你将获得一个空空如也的缓冲区，就像你刚开始输入时的那样。你现在已经回退到第一次更改前，这时

.. code:: vim

   :echo changenr()

将会输出 `0` 。

如果你使用 `Ctrl-R` 重做（redo）的话，你将回退到

.. code:: text

   1

然后

.. code:: text

   1 2

最终是

.. code:: text

   1 2 4

注意，你将永远不会回退到缓冲区包含 `1 2 3` 的第 3 次变更状态。但是，你可以使用 `g-` 和 `:earlier` 命令来移动到那次更改。所以，现在你按下 `g-` 或者 `:earlier` ，你的缓冲区将变成这样：

.. code:: text

   1 2 3

如果已经知道要跳转到的记录数目，你也可以使用 `:undo` 命令直接回滚到指定更改。

输入

.. code:: vim

   :undo 1

会将你的缓冲区恢复到

.. code:: text

   1

Undolevels 选项
===============

记录更改的条数数目由 undolevels_ 控制。这是一个全局性选项，定义了每个缓冲区记录多少条可回退的更改。所以，如果你将其设置为 `25` ，则你最多可以撤销 25 次更改。如果设为 `-1` ，那么你将不能撤销任何更改！

.. _undolevels: http://vimdoc.sourceforge.net/cgi-bin/help?tag=%27undolevels%27

相关插件
========

仅使用内置命令，在 `undo tree` 中导航到你想要找的状态，可能会有些麻烦。这里有几个插件可以使这一过程更容易些。

Mundo
-----

.. figure:: /images/mundo.thumbnail.png
   :target: /images/mundo.png
   :class: ui small right floated image

Mundo_ 插件要求安装有 Python_ 以及 `编译有 Python 支持的 Vim 版本`_ 。Mundo 插件提供了整个 `undo tree` 的可视化树形视图，并包含了已存储的 `persistent undo` 数据。树形视图下方是每次更改的上下文 diff 预览，使得你更容易精确找到想要回退的状态。尽管它并没有提供 Histwin 插件的一些特性（比如，与特定状态的 diff，标记特定文件版本等），但是 Mundo 的树形视图和 diff 预览功能很好用。

Mundo 是 Gundo_ 插件的社区 fork 版本。Mundo 由 Gundo 插件 fork 而来，并在此基础上继续开发。

.. _Mundo: http://simnalamburt.github.io/vim-mundo/dist/
.. _Python: http://www.python.org/
.. _`编译有 Python 支持的 Vim 版本`: http://vim.wikia.com/wiki/Build_Python-enabled_Vim_on_Windows_with_MinGW
.. _Gundo: https://bitbucket.org/sjl/gundo.vim

Histwin
-------

.. figure:: /images/histwin.thumbnail.png
   :target: /images/histwin.png
   :class: ui small right floated image

Histwin_ 插件提供了方便简单的方法，允许你在 undo 历史中跳转到之前的分支。

它提供了一个 `:UB` 命令打开新的窗口，列出所有更改的不同分支。如果在列表中的项目上按下 `Enter` 键，你的缓冲区将会回退到 undo 历史相应的状态。

除此之外，你还可以在列表项上按 `T` 标记某个状态，按下 `D` 打开 diff 窗口，在当前状态和选中状态之间审阅所有更改。另外一个有意思的功能是，你甚至可以让 Vim 从头重放对文件的更改。

安装插件以后，输入 `:help histwin.txt` 查阅它的配置和使用说明。

.. _Histwin: https://vim.sourceforge.io/scripts/script.php?script_id=2932

其它
----

- undotree_ 使用纯 vimscript 编写，提供与 Mundo 相似的树形视图。该插件同时还提供已更改文本的颜色高亮，树形视图的自动刷新，以及 `undo tree` 节点的额外信息标记。

- `Undo Branches Explorer`_

.. _undotree: https://vim.sourceforge.io/scripts/script.php?script_id=4177
.. _`Undo Branches Explorer`: https://vim.sourceforge.io/scripts/script.php?script_id=2141

Persistent undo
===============

Persistent undo（持久化 undo）特性自 Vim 7.3 版本正式可用。Vim 7.3 版本之前（或没有编译 persistent undo 特性的 7.3 版本），当你退出 Vim（或者强制重载缓冲区）时，你将丢失所有的 undo 历史，因此可能会不小心丢失数据。Persistent undo 特性（以 normal、big 和 huge 方式编译的 Vim 应该都有）提供了将 undo 历史永久保存到文件中的可能性，无论何时当你编辑与 undo 历史相关联的文件时，将会从文件重载这些 undo 历史。

要使用这一特性，你需要设置 `undofile` 选项：

.. code:: vim

   :set undofile

然后你就可以使用新命令 `:wundo` 将 undo 历史写入到文件之中，并使用 `:rundo` 来读取 undo 历史了。对于每一个编辑的文件， `undo tree` 都会被保存到同一目录下的单独文件中。文件名形如： `.filename.un~` ，就像 swap 文件一样。如果你想将所有 undo 文件统一保存到一个目录中，你可以设置 `undodir` 选项来指定包含所有 undo 文件的目录。开启 persistent undo 特性以后，当你编辑文件时，被保存的 undo 信息就会自动被读取出来。

除此之外，Vim 7.3 还允许你跳转到文件的前几次保存状态。通过执行 `:earlier <nr>f` 和 `:later <nr>f` 可以做到这一点，此处的 `<nr>` 指的是文件保存数目。文件保存数目可以通过 `:undolist` 命令，在 `saved` 列里面看到。例如， `:earlier 1f` 将会回滚到文件最后一次被保存的状态，而 `:later 1f` 则将移动到 `undo tree` 的下一个更新的文件保存状态。

新增加的选项 `undoreload` 现在可以设置，在缓冲区重载（如 `:e!` 命令）前，是否保存文本状态。缺省值是 10,000，这意味着如果缓冲区不足 10,000 行，则缓冲区内容会被存储到 `undo tree` 。例如，你正在编辑一个简单的文件， `:echo changenr()` 将会输出 `undo tree` 中的当前位置。现在如果使用 `:e!` 命令重载缓冲区，则你会注意到：在 `:echo changenr()` 输出结果中，一个新的更改已被创建（但是仅在缓冲区行数小于 `undoreload` 设置，或者 `undoreload` 值为负值时出现）。

同时，要注意到：如果一个文件被从 Vim 外更改，则当你再次编辑文本时，Vim 将无法读取 undo 历史， `undo tree` 信息将会丢失。没有别的方法可以取回这些数据。

参考资料
========

- `:help usr_32.txt`_

- `:help undo-branches`_

- `:help g+`_

- `:help earlier`_

- `:help i_CTRL-G_u`_

- `:help 'ul'`_

.. _`:help usr_32.txt`: http://vimdoc.sourceforge.net/cgi-bin/help?tag=usr_32.txt
.. _`:help undo-branches`: http://vimdoc.sourceforge.net/cgi-bin/help?tag=undo-branches
.. _`:help g+`: http://vimdoc.sourceforge.net/cgi-bin/help?tag=g%2B
.. _`:help earlier`: http://vimdoc.sourceforge.net/cgi-bin/help?tag=earlier
.. _`:help i_CTRL-G_u`: http://vimdoc.sourceforge.net/cgi-bin/help?tag=i_CTRL-G_u
.. _`:help 'ul'`: http://vimdoc.sourceforge.net/cgi-bin/help?tag=%27ul%27

扩展阅读
========

- `Undo and Redo`_

- `Recover from accidental Ctrl-U`_

.. _`Undo and Redo`: http://vim.wikia.com/wiki/Undo_and_Redo
.. _`Recover from accidental Ctrl-U`: http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U

评论
====

`Persistent undo`_ 小节提到：

    同时，要注意到：如果一个文件被从 Vim 外更改，则当你再次编辑文本时，Vim 将无法读取 undo 历史， `undo tree` 信息将会丢失。没有别的方法可以取回这些数据。

我不认为这一说法在所有情况下均适用。难道你不能关闭缓冲区，恢复文件到之前状态（比如使用版本管理工具），再重载缓冲区，把这些数据取回？还是这一方法太复杂，以至于你在文中懒得提？ --Fritzophrenic 04:26, October 20, 2010 (UTC)

这应该也好使。 --Chrisbra 20:54, October 20, 2010 (UTC)

我在想也许你可以制作一个 FileChangedShell 命令，当它检测到外部变动时，以某种方式保存 undo 信息。 --Fritzophrenic 20:52, January 7, 2011 (UTC)
