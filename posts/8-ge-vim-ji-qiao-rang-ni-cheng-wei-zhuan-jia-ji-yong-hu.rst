.. title: 【译】8 个 Vim 技巧让你成为专家级用户
.. slug: 8-ge-vim-ji-qiao-rang-ni-cheng-wei-zhuan-jia-ji-yong-hu
.. date: 2017-11-02 20:44:53 UTC+08:00
.. tags: vim, terminal, translation
.. category:
.. link: https://itsfoss.com/pro-vim-tips/
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage: /images/vim-tips-tricks.jpg

**提要** ：在这篇文章里，我将用实际例子向你展示一些我最喜爱的 **Vim 技巧** 。如果你不使用 Vim，这些技巧并不会给你多少理由让你想使用它。但是，如果你已经在使用，那本文无疑会让你成为更专业的 Vim 用户。

即便最近开始，我越来越多地使用 Atom_ ，然而不使用 Vim_ 却让我一天也过不下去。并不是因为我不得不使用它，而是这样做让我感到很舒适。

.. _Atom: https://atom.io/
.. _Vim: http://www.vim.org/

是的，舒适。当谈及 Vi 编辑器或任何它的变种时，这是个太奇怪的词语，对不对？的确，我承认，Vi 不是那个最符合直觉的文本编辑器。

但是，经过一些实践及记忆训练后，你可以通过仅仅几次击键，就能完成看似复杂的编辑任务，使用一些别的命令行编辑器无法实现的功能。

尽管如此，今天我并不想写“Vi 入门介绍”，我想通过个人常用的技巧——一些在其它编辑器中我梦寐以求的技巧，向你展示 Vi(m) 编辑器的真正威力。我并不会对这些技巧做全面的阐释，但我强烈推荐你反复试验，直到你理解它们是如何工作的。

如果你喜欢 Vim 并想完全掌握它，你也可以参与由 Linux Training Academy 提供的 Vim 在线课程。

.. TEASER_END

.. figure:: /images/vim-tips-tricks.jpg
   :align: center

我再重申一遍 ：强烈推荐你自行尝试一下这些例子。糟糕的是，WordPress 在精确展示例子和命令方面做得并不好——特别是空行和引用。所以，为了便宜行事，你可以从以下链接下载本文使用的样本 ：

.. class:: fluid ui small basic blue button

   `下载练习用的 Vim 例子 <https://github.com/YesIKnowIT/VIM01>`_

每个例子均附带有原文本（.orig）和执行 Vim 命令 的 Bash 脚本（.sh）。

.. contents:: 文档目录
   :local:

.. section-numbering::

.. role:: strike
.. role:: amend

改变单词大小写
--------------

难道只有我觉得该功能特别好用？又或者我命中注定与这些家伙们一起工作——他们全都相信单词大写这事很酷？

不管怎样，当编写代码时，添加版权声明时，甚至拷贝粘贴时，通常仍然需要改变单词大小写。而在这一点上，Vim 编辑器要比 Vi 高明的多。每天我都十万分感激 Bram Moolenaar 的卓越工作 ：

**原文本** ：

.. code:: text

   copyright (c) <year> by <copyright holder>
   Usage of the works is permitted provided that this instrument is retained with the works, so that any entity that uses the works is notified of this instrument.
   Disclaimer: the works are without warranty.

**命令** ：

+----------------+-----------------------------------------+
| ``~``          | 切换大小写                              |
+----------------+-----------------------------------------+
| ``:$norm gUU`` | 将最后一行的单词转换为大写（Vi 不适用） |
+----------------+-----------------------------------------+

**修改后的文本** ：

.. parsed-literal::

   :amend:`C`\ opyright (c) <year> by <copyright holder>
   Usage of the works is permitted provided that this instrument is retained with the works, so that any entity that uses the works is notified of this instrument.
   :amend:`DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.`

.. figure:: /images/changing-capitalization.png
   :align: center

Vim 搜索和替换
--------------

我每天都在使用。为何其它文本编辑器没有该功能？当然，它们多数有所谓的搜索替换，但是有多少拥有正则匹配替换的功能呢？诚然，正则替换要比基本的字符替换要复杂些，但是没有这一功能我简直无法想象。有时候我不得不从某些 GUI 编辑器中拷贝/粘贴到终端，运行 `sed` 命令处理后再拷贝/粘贴回来。而 Vi 编辑器在大约 40 年前就有这一功能了。

**原文本** ：

.. code:: text

   Does a boy get a chance to paint black a fence every day? That put the thing in a new light. Ben Rogers stopped nibbling his apple. Tom swept his brush daintily back and forth–stepped back to note the effect–added a touch here and there–criticised the effect again–Ben watching every move and getting more and more interested, more and more absorbed.

**命令** ：

+--------------------------------------+-----------------------------------------+
| ``:s/black/white/``                  | 将第一处的 `black` 替换为 `white`       |
+--------------------------------------+-----------------------------------------+
| ``:s/Ben\(Rogers\)\@!/Ben Rogers/g`` | 将每一处 `Ben` 替换为 `Ben Rogers`，\   |
|                                      | 除非 `Rogers` 已经存在                  |
+--------------------------------------+-----------------------------------------+
| ``:s/.*/<p>\r&\r<\/p>/``             | 将该行用 `<p>` 和 `</p>` 包裹起来       |
+--------------------------------------+-----------------------------------------+
| ``:-1s/-/\&mdash;/g``                | 将前一行中的每一处 `-` 替换为 `&mdash;` |
+--------------------------------------+-----------------------------------------+

**修改后的文本** ：

.. parsed-literal::

   :amend:`<p>`
   Does a boy get a chance to paint :amend:`white` a fence every day? That put the thing in a new light. Ben Rogers stopped nibbling his apple. Tom swept his brush daintily back and forth\ :amend:`&mdash;` stepped back to note the effect\ :amend:`&mdash;` added a touch here and there\ :amend:`&mdash;` criticised the effect again\ :amend:`&mdash;Ben Rogers` watching every move and getting more and more interested, more and more absorbed.
   :amend:`</p>`

.. figure:: /images/those-picket-fences-recall-me-of-the-letters-v-i-m.jpg
   :align: center

随意移动跳转
------------

是的，拷贝粘贴和鼠标拖放是不错的功能。只是有时候这样做很让人烦 ：我需要滚动文档找到正确位置以粘贴我的文本，然后再向反方向滚动将光标移回到它的初始位置。

**原文本** ：

.. code:: text

   Pros:
   * Fast
   * Powerfull
   * Reliable
   * Not user-friendly
   Cons:
   * Portable
   * Addictive

**命令** ：

+------------------------+-----------------------------------------+
| ``/Power/``            | 跳转到包含 `Power` 的第一行             |
+------------------------+-----------------------------------------+
| ``ddp``                | 将当前行与下一行互换                    |
+------------------------+-----------------------------------------+
| ``:/user-friendly/m$`` | 将包含 `user-friendly` 的行移到文件末尾 |
+------------------------+-----------------------------------------+
| ``g;``                 | 将光标移动到之前的位置                  |
+------------------------+-----------------------------------------+
| ``/Cons/+1m-2``        | 将包含 `Cons` 的下一行向上移两行        |
+------------------------+-----------------------------------------+

**修改后的文本** ：

.. parsed-literal::

   Pros:
   * Fast
   * Reliable
   :amend:`* Powerfull`
   :amend:`* Portable`
   Cons:
   * Addictive
   :amend:`* Not user-friendly`

.. figure:: /images/moving-things-around-in-no-time.png
   :align: center

指定范围内运行命令
------------------

GUI 编辑器允许你对整个文件运行命令，或者仅针对当前选区。有时候，还可以有更多选项，譬如光标前后。但是 Vi(m) 编辑器允许你对使用命令的范围给出一个更容易理解的描述 ：

**原文本** ：

.. code:: text

   <div>

   <table>

   <tr><td>Pen name</td><td>Real name</td></tr>

   <tr><td>Mark Twain</td><td>Samuel Clemens</td></tr>

   <tr><td>Lewis Carroll</td><td>Charles Dodgson</td></tr>

   <tr><td>Richard Bachman</td><td>Stephen King</td></tr>

   </table>

   <p>Many writers have chosen to write under a pen name.</p>

   </div>

**命令** ：

+----------------------------------+-------------------------------------------+
| ``:/<table>/,/<\/table>/g/^$/d`` | 将 `<table>` 与 `</table>` 之间的空行删除 |
+----------------------------------+-------------------------------------------+
| ``:/^$/;/^$/-1m1``               | 将接下来两个空行之间的文本移到第一行之后  |
+----------------------------------+-------------------------------------------+
| ``:2,$-1>``                      | 缩进第 2 行到倒数第 1 行之间的文本        |
+----------------------------------+-------------------------------------------+

**修改后的文本** ：

.. parsed-literal::

   <div>

   :amend:`<p>Many writers have chosen to write under a pen name.</p>`

   <table>
   <tr><td>Pen name</td><td>Real name</td></tr>
   <tr><td>Mark Twain</td><td>Samuel Clemens</td></tr>
   <tr><td>Lewis Carroll</td><td>Charles Dodgson</td></tr>
   <tr><td>Richard Bachman</td><td>Stephen King</td></tr>
   </table>

   </div>

.. figure:: /images/applying-commands-on-an-address-range.png
   :align: center

Vim 管道命令
------------

这绝对是 Unix 哲学精髓中的“原技巧（meta-trick）”。Vi 允许你使用外部命令对缓冲区中的部分文本进行处理，当你遇到某些在 Vi 中无法做到或者不容易做到的情况时，这是个非常好用的功能。我最喜欢的使用场景是对数据排序——但实际上该功能几乎不受任何限制。

**原文本** ：

.. code:: text

   tee >(echo $(wc -l) most recent data) << EOT
   Aug, 2016 2.11%
   Sep, 2016 2.23%
   Oct, 2016 2.18%
   Nov, 2016 2.31%
   Dec, 2016 2.21%
   Jan, 2017 2.27%
   Mar, 2016 1.78%
   Apr, 2016 1.65%
   May, 2016 1.79%
   Jun, 2016 2.02%
   Jul, 2016 2.33%
   EOTLinux Market Share on Desktop
   source: https://www.netmarketshare.com

**命令** ：

+----------------------------------------+--------------------------------+
| ``:2,/^EOT/-1!sort -k2n -k1M``         | 根据年份和月份排序数据         |
+----------------------------------------+--------------------------------+
| ``:$r! date "+Data obtained the \%c"`` | 在文件末尾附加 `date` 命令输出 |
+----------------------------------------+--------------------------------+
| ``:1,/^EOT/!bash``                     | 执行内嵌脚本并以结果替换       |
+----------------------------------------+--------------------------------+

**修改后的文本** ：

.. parsed-literal::

   :amend:`Mar, 2016 1.78%`
   :amend:`Apr, 2016 1.65%`
   :amend:`May, 2016 1.79%`
   :amend:`Jun, 2016 2.02%`
   :amend:`Jul, 2016 2.33%`
   Aug, 2016 2.11%
   Sep, 2016 2.23%
   Oct, 2016 2.18%
   Nov, 2016 2.31%
   Dec, 2016 2.21%
   Jan, 2017 2.27%
   :amend:`11 most recent data` Linux Market Share on Desktop
   source: https://www.netmarketshare.com
   :amend:`Data obtained the Thu 09 Feb 2017 11:07:34 PM CET`

.. figure:: /images/piping-commands.png
   :align: center

更少键盘输入
------------

撰写一些正式文档时，总会遇到一些不常用却又不得不重复输入的又长又复杂的专用名词，可能是品牌名称或产品名称，某些地名，版权声明……等等。很显然，这些专用名词每一处都应该正确拼写，还要使用完全相同的大小写和标点符号。这时，就很有必要使用 Vim 的缩略词功能。

**命令** ：

+----------------------------------------------------------+-------------------------------+
| ``:ab apple Apple Computer, Inc.``                       | 定义一个新的缩略词            |
+----------------------------------------------------------+-------------------------------+
| ``i``                                                    | 切换到 `insert` 模式          |
+----------------------------------------------------------+-------------------------------+
| apple was founded in 1977. The apple logo is an apple^V. | 键入文本（^V 指 `control-V`） |
+----------------------------------------------------------+-------------------------------+

**结果** ：

.. parsed-literal::

   :amend:`Apple Computer, Inc.` was founded in 1977.
   The :amend:`Apple Computer, Inc.` logo is an apple.

.. figure:: /images/typing-less.png
   :align: center

Vim 中获取帮助
--------------

好吧，我知道有 internet。但是像我一样使用 `man` 命令的人会更青睐内置的帮助系统，你可以根据标题或者命令获取帮助。当你记不清 Vim 命令的准确用法或选项时，当你不确定你需要的是 `Normal` 命令还是 `ex:` 命令时，总是可以到内置帮助中寻求答案。

**试试这些** ：

+----------------+
| ``:help help`` |
+----------------+
| ``:help m``    |
+----------------+
| ``:help :m``   |
+----------------+

Vim 中使用脚本
--------------

使用 Vi(m) 时，基本上你是在使用另一个底层编辑器 `ex` 的可视化前端，可能你已经注意到以上例子中很多命令均以冒号（:）开头？那是因为他们都是 `ex` 命令。此外，Vi(m) 还有一个相对于很多其它编辑器的优势：你不止可以交互式的使用它，你还可以使用脚本控制它。

为何有人想要这么做？从我自身来说，我发现这是个文本处理自动化的绝好途径。同时，你可以查看来自我硬盘文件的一个典型例子。

这个 `ex` 脚本里面可能有一些看似神秘的命令，不过我可以告诉你，它将会从脚本中移除任何文件头，并替换以从 `NEW.HEADER` 读取的内容——在每个新添加的行前添加 `#` 。毫无疑问地，我本可以使用 `ex` 以外的其它工具来完成这件事。事实上，它甚至是我们之前 Bash 挑战赛的题目之一。但是， `ex` 确实是个很好的选择。

**有多神秘** ：

.. code:: text

   ex some.script << EOT
   0pu_
   1,/^[^#]/-1d
   0r NEW.HEADER
   1,.s/^/# /
   wq
   EOT

就像我开篇说的，本文绝不是一篇教程，也不是 Vi(m) 的入门介绍。仅仅是一些 Vim 技巧，来向你展示为何尽管有那么多时髦的代码编辑器，却仍然有人偏偏喜欢 Vim。某种程度上，今天我给你分享了一些我最喜欢的编辑器魔法。但是遵照魔法界的优良传统，我不会向观众揭秘它们究竟是如何工作的。

所以，学徒们，请在下方的评论栏分享你自己的魔法咒语——或者，如果你足够勇敢的话，向观众们解密这些所谓的魔法！
