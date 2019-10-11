.. title: 使用 targets.vim 改进和扩展文本对象
.. slug: improve-and-extend-your-text-objects-with-targetsvim
.. date: 2019-10-11 17:05:40 UTC+08:00
.. tags: vim, translation
.. category: vim
.. link: https://www.barbarianmeetscoding.com/blog/2019/08/11/exploring-vim-plugins-improve-and-extend-your-text-objects-with-targets-vim
.. description:
.. type: text
.. nocomments:
.. previewimage: /images/become-1-percent-better.jpg

欢迎回到 `探索 Vim 插件系列 <https://www.barbarianmeetscoding.com/blog/categories/exploring-vim-plugins>`_ ！在本系列中，你将学习如何发现很棒的 Vim 插件以及如何掌握它们，从而每天提高工作效率。而今天，轮到我的最爱之一了： `targets.vim`_ 。

.. figure:: /images/become-1-percent-better.jpg
   :alt: become 1 percent better
   :align: center

.. TEASER_END

.. contents:: 文档目录
   :depth: 1

`targets.vim`_ 是诸多，通过增强 Vim 最基本的功能之一： **文本对象** ，从而有效提高工作效率的插件之一。

Vim 的文本对象
================

Vim 最棒的事情之一，就是它允许你高精度地编辑文本。键入 `daw` ，Vim 执行你的命令：删除（ **d** elete）一个单词（ **w** ord）。键入 `ci'` ，Vim 帮助你更改（ **c** hange）单引号之内（ **i** n）的文本。Vim 能够提供这种高精度，得益于操作符（删除、更改、复制等）与动作主体的结合，其中最强大的就是 **文本对象** 。

**文本对象** 描述了文档的各个部分：单词，句子，段落，引号内的文本，代码块，HTML 标记等。在前面的例子中， `daw` 与 `ci'` 中的 `aw` 和 `i'` 都是文本对象：

- `aw` 代表 **一个单词**
- `i'` 代表 **单引号内**

通过将操作符与文本对象结合使用，Vim 可以为你提供精细的粒度和强大的功能，来编辑基于文本的文档和代码。

所以，如果 **文本对象这么酷，我们还需要一个插件来做什么？** 好吧，还有什么比文本对象更酷的？ **更多的** 文本对象！

更多文本对象！！！
===================

**你是否曾经想在逗号之间更改文本** ？现在可以了！假设我们有如下一段话：

.. code:: ReST

   I think, most of the time, therefore I am.

键入 `ci` ，其次是 `all of the time` 然后 `<ESC>` 。瞧瞧！

.. code:: ReST

   I think, all of the time, therefore I am.

**你是否曾经想编辑函数的形参和实参** ？现在你也可以！

想象一下，我们有 **obliterate** 这样一个函数，可以对游戏中的敌人造成极大的伤害：

.. code:: javascript

   function obliterate(target, mana) {
     const damage = mana*1d20() + 1d100();
     target.hp -= damage;
     console.log(`${target} is obliterated with a ray of dark energy`);
   }

我们希望 `mana` 参数是可选的，并赋以默认值。使用 `targets.vim`_ **参数** 文本对象，我们可以直接编辑 `mana` 参数，如下所示：

1. `c2ina` 更改下个（ **n** ext）/第二个参数（ **a** rgument）内部（ **i** nside）
2. `{mana=20}={}<ESC>` 使该参数为可选并提供默认值 `20`

**是不是很酷** ？

`targets.vim`_ 附带了许多新的文本对象，这些新对象在使用 Vim 时为你带来了全新的精度，控制，可重复性和编辑速度：

- 分隔符如 ``,.;:+-=~_*#/|\&$``
- 函数内的形参和实参
- 同时使用多个文本对象。 `b` 可在任何 block (`{([`) 上操作，而 `q` 则是在任何引号。

等等，还有更多！统一和改善搜索行为
=====================================

`targets.vim`_ 并没有仅止步于添加新的操作符，它同时还改善了所有文本对象的用户体验和可用性。

在文本对象上使用操作符时，你可能已经注意到的一个不一致之处是，引用文本对象的行为表现略有不同。与其它文本对象不同，引用支持向前搜索，因此操作时光标无需处于文本对象上。可以通过一个示例更好地说明这一点，假设你有如下字符串：

.. code:: javascript

   const greeting = "Hello Oh Mighty Wizard! I salute you!"
   ^

光标位于第一个字母之上，由 `^` 符号表示。使用 `ci"` 可以更改字符串的内容，即使我们并没有在引号范围之内。

这种搜索行为非常棒，这意味着我们可以节省将光标定位到引号上方所需的击键。但是，其它文本对象则没有搜索行为。

检查以下功能：

.. code:: javascript

   const salute = (name) => `Hello Oh Mighty ${name}! I salute you`
   ^

现在，我们要更改 `name` 参数的名称。你觉得键入 `ci(` 可以让你立即更改 `name` 参数？事实并非如此。

该 `(` 文本对象并不支持向前查找，因此你需要分两步进行更改。

首先，使用 `f(` 来移动光标：

.. code:: javascript

   const salute = (name) => `Hello Oh Mighty ${name}! I salute you`
                  ^

然后，你就可以使用 `ci(` 更改 `name` 了。因为此时 `(` 对象位于光标之下。

**搜索行为明显更加高级，因为它允许你用更少击键做更多的事情，并且使用 `.` 命令重复更改更加容易** 。不幸的是，我们的好运到此为止了。原生的 Vim 仅引用对象有这样的行为表现。

如果现在，我告诉你 `targets.vim`_ 将该搜索行为统一并扩展到所有文本对象上呢？这样一来前面的示例中能使用 `ci(` 来立即更改该参数呢？

是的！那将是一个了不起的特性。但是 `targets.vim`_ 并不满足于此。 `targets.vim`_ **为你提供跨越多行向前和向后搜索的能力** 。

这是搜索行为工作方式的简化版本：

1. 如果光标位于文本对象上，则操作符应用于该文本对象
2. 否则在一行内向前搜索
3. 如果向前没有找到文本对象，它将在下一行中向后搜索
4. 如果该行中没有找到，则向前搜索
5. 如果该行中没有找到且接下来的行中也没有找到，则它将向后搜索。

很棒，对吧？这意味着你可以节省更多的击键，更快地编辑文本。万岁！

但是，如果你不想更改下一个出现的文本对象怎么办？如果想要更改上一个怎么办？这是否意味着你需要先将光标移到那里？不需要。 `targets.vim`_ 的创造者们高瞻远瞩，允许你通过 `n` ( **n** ext) 和 `l` ( **l** ast) 显式地指定文本对象。输入：

- `cin[` 更改下一方括号内的内容（其行为与 `ci[` 相同）
- `cil[` 将更改前一个方括号的内容

这些命令也可以与 **数字** 结合使用，以对远处的文本对象进行操作：

- `c2in[` 使你可以更改第二对下一个方括号的内容，以此类推。

难道这一切不是酷毙了吗？

再等等！还有更多！ A, In, Around and Inside
============================================

使用原生 Vim，对文本对象进行操作时你可以使用两个修饰符： `a` 和 `i` 。

- `a"` 表示 **引用的字符串** ，它包括引号字符串的所有字符，包括引号
- `i"` 表示 **引用字符串内部** ，它包括引号字符串的所有字符，减去引号

`targets.vim`_ 提供了两个新的修饰符，使你更加准确： `A` 和 `I` 。

- `A"` 表示 **围绕引号字符串** ，除了包括引号的整个字符串外，还包括一个尾随空格
- `I"` 表示 **在引号字符串内** ，并且包括引号字符串内的内容（不包括引号和任何内部尾随空格）。如果要保留引号，块内等的空格，这很有用。

.. figure:: /images/targets-vim-modifiers.jpg
   :alt: targets vim modifiers
   :align: center

开始使用 targets.vim
=====================

1. 使用你喜欢的插件管理器安装。你可以在本文中找到 `有关插件管理器以及如何安装插件的更多信息 <https://www.barbarianmeetscoding.com/blog/2019/05/31/exploring-vim-plugins-a-methodology-to-become-1-percent-better-every-week>`_ 。
2. 开始练习。

`targets.vim`_ 属于无缝学习和实践的那类插件之一，因为它们非常适合 Vim 的哲学。鉴于它扩展了 Vim 的核心功能（文本对象），对于有经验的 Vim 用户而言，使用新的分隔符或参数文本对象是自然而然的。实际上如此自然，以至于你可能在想为何这些文本对象没有从一开始就内建于 Vim 之中。

从我的个人经验来看，需要刻意训练的是，那些在原生 Vim 体验中不存在的显式搜索行为：

0. 开始使用新的分隔符（很自然，我觉得无需刻意练习）
1. 直接从光标处使用文本对象，而不是首先移动到文本对象，充分利用搜索行为的优势。这将使你更快，并使得更改可重复（使用 `.` 操作符）。
2. 练习显式搜索修饰符 `n` 和 `l` 。
3. 使用 `A` 代替 `a` ，用 `I` 代替 `i` ，并注意其中的区别。

了解更多
=========

该 Vim 插件的 `文档 <https://github.com/wellle/targets.vim>`_ 确实非常 **出色** ，非常详尽，并且附有很多有用的图表。因此，记得到 `GitHub <https://github.com/wellle/targets.vim>`_ 或者通过 `:help targets` 命令查阅帮助。

另外， `targets.vim 速查表 <https://github.com/wellle/targets.vim/blob/master/cheatsheet.md>`_ 也是非常有用的摘要参考，针对随时查询提供有效辅助。

.. _`targets.vim`: https://github.com/wellle/targets.vim
