.. title: 【译】Vim 不需要多光标编辑功能
.. slug: vim-bu-xu-yao-duo-guang-biao-bian-ji-gong-neng
.. date: 2017-11-21 18:42:02 UTC+08:00
.. tags: vim, translation
.. category: vim
.. link: https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

Sublime text 首次引入了多光标编辑功能 [#]_ （据我所知），这意味着可以在多个光标位置同时编辑代码。Vim 有个插件（vim-multiple-cursors_ ）模仿这一功能，但是存在一些问题。自动补全功能失效，撤销历史与我想象中的不一样，也无法把文本操作映射到某按键，以便在下次 Vim 会话中使用。还有，很难用眼睛跟踪所有光标，特别是当它们处于不同列的时候。使用该插件一段时间后，我得出结论：没有什么操作场景是 **原生** Vim 特性无法完成的（以个人观点来看，完成的甚至比插件还要好）。

.. [#] 我首次使用多光标编辑，是在 SciTE_ 中。与 Sublime Text 一样，都使用相同的组件 Scintilla。SciTE 出现时间比 Sublime Text 更早，因此作者这一说法不太准确。——译者注

.. _vim-multiple-cursors: https://github.com/terryma/vim-multiple-cursors

.. _SciTE: http://www.scintilla.org/SciTE.html

.. TEASER_END

.. figure:: /images/vim_multiple_cursors_broken.gif
   :align: center

   vim-multiple-cursor 插件（自动补全、撤销历史功能失效）

在 N 个位置修改单词
===================

通常，这是你使用多光标想要解决的最简单的问题。在 Sublime Text 2 或 Atom 中，一般你会搜素一个单词，再手动选择你想修改的每一处，然后一次编辑一个位置。

在 Vim 中，选择和编辑合并为一步，通过 `gn` 文本对象来完成。首先搜索想要修改的单词，再使用 `cgn` 命令修改下一处，然后再使用 Vim 最强大的 `.` 点命令。使用 `.` 你可以将修改应用到下一处，或者使用 `n` 跳过一处到下一个匹配处。

.. figure:: /images/cgn_and_dot.gif
   :align: center

   cgn（自动补全、撤销历史）

和其它文本对象一样， `gn` 可以与所有的命令协同工作。比如，你可以与 `d` 合用删除匹配的单词。

修改可视区域
============

修改看起来很相似的矩形区域，这也是个特别常见的需求。在 Vim 中，visual-block 被用来完成各种修改。与其它编辑器不同的是，如果你修改了区块的第一行文字，那么当结束操作时这些修改也会被应用到其它所有行。

.. figure:: /images/change_visual_block.gif
   :align: center

   visual-block（区块前插入）

基于多行的复杂修改
==================

当同时在不同位置做复杂修改时，我感觉很难跟踪哪个光标在哪个位置。我觉得，记录某一行的修改，再一次性应用到其它所有行，这样更简单一些。开始的时候，你可能会发现创建应用到所有行的宏很难，但是经过一些训练后你会逐渐习惯使用它。

以下是一些达到该目标的技巧：

1. 记录宏的时候，将跳转到行首作为第一个操作。

2. 使用 `f` 或 `t` 跳转到你想更改的位置。

3. 避免使用方向键或 `hjkl` 。并非所有行都是相同宽度，使用 `w` , `e` , `b` 要稍微好一点。

.. figure:: /images/reusable_macro_on_lines.gif
   :align: center

   宏（可复用于不同行）

要将宏应用到所有行，你需要一点我从 `Drew Neil`_ 的书里（ `practical vim`_ ）学到的技巧。添加以下脚本（ `visual-at.vim`_ ）到你的 Vim 配置。这允许你选择一个选区，然后按下 `@` 在所有行上执行一个宏，仅那些匹配的行会被修改。没有这个脚本，遇到那些不匹配的行，运行的宏将会停止。

.. _`Drew Neil`: https://github.com/nelstrom

.. _`practical vim`: https://pragprog.com/book/dnvim/practical-vim

.. _`visual-at.vim`: https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim

整个文件上运行宏
================

你可以在整个文件上针对那些匹配的行运行一个宏。你需要输入 `:` 进入命令行模式（command-mode），然后使用 `global` 命令（缩写 `g` ）。

.. figure:: /images/exec_macro_using_global.gif
   :align: center

   global（执行宏）

保存你的工作
============

Vim 内置的一个超棒功能是，你可以编辑和保存这些宏，以便在下次 Vim 会话中使用，甚至为它们添加一个按键绑定。你可以输入 `"【宏寄存器名称】p` 将它在新的缓冲区粘贴出来（比如使用 `@q` 记录的话，可以用 `"qp` 粘贴）。可以查看以下 GIF 动图，了解如何将宏粘贴到你的 vimrc 文件，添加一个按键绑定以便在所有匹配行上运行。

.. figure:: /images/save_macro_to_file.gif
   :align: center

   保存宏到 .vimrc

还有，如果弄乱了的话，你也可以像这样编辑你的宏（ `thoughtbot/how-to-edit-an-existing-vim-macro`_ ）。

.. _`thoughtbot/how-to-edit-an-existing-vim-macro`: https://robots.thoughtbot.com/how-to-edit-an-existing-vim-macro

结论
====

通过本文，我们了解到如何使用 **原生** Vim 特性来解决问题。在一些简单场景中，文本对象 `gn` 对我们有所帮助，但是如果要显著地提升效率，你应该学习如何使用宏。最近我开始使用 vim-enmasse_ 插件。简单来说，它可以让你将以上提到的技巧同时应用到多个文件。当它在我的工作流程中稳定使用以后，我将会分享一下使用该插件的经验。

.. _vim-enmasse: https://github.com/Olical/vim-enmasse
