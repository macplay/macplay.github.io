.. title: Oni 0.32 版本释出
.. slug: oni-032-ban-ben-shi-chu
.. date: 2018-04-14 22:55:50 UTC+08:00
.. tags: vim, vimrc, onivim
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage: /images/oni_release.png


.. include:: posts/links.ref
.. include:: posts/interps.ref

.. figure:: /images/oni_release.png
   :align: center

本来对这次版本更新还有些不以为然：为何不把精力放在完善 |l_lsp|_ 支持，而跑去写什么新手教程呢？直到今天尝试了下教程，又看了文字版更新内容，才明白过来：Oni 编辑器正朝着我期待的方向前进！

来看看本次更新的两个重要功能：

.. TEASER_END

Embedded Browser 内嵌浏览器
---------------------------

.. raw:: html

   <video src="/videos/embedded_browser.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

尽管我对「文本编辑器中内嵌浏览器」这种做法，持保留意见（浏览器属于相当重量级的应用了）。不过对 Oni 编辑器引入这一功能，也并没有感到意外。毕竟本身基于 Electron 框架，要实现无非是想不想的问题。

我唯一的担心是：引入浏览器之后，可能因为资源占用，而导致文本编辑体验下降。

不过转念一想：使用内嵌浏览器来完成一些轻量级的工作，比如预览 Markdown、阅读在线文档等等，多半不会导致发热卡顿问题。最差的情况 -- 如果确实影响很大，顶多不使用该功能。甚至完全关闭也可以。

总体上，对内嵌浏览器这一功能好评。

Interactive Tutorial 互动教程
-----------------------------

.. raw:: html

   <video src="/videos/interactive_tutorial.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

这部分是我想说的重点。

很多人看到「互动教程」这一字眼，可能第一反应是：这是针对新手的，完全不屑一顾。相信我，这也是我的第一反应...直到不经意间打开「互动教程」，才恍然发觉：这不正是我对 Neovim 的最初幻想么？

首先，截图中的页面布局、字体样式、动画效果等等，已经足以傲视市面上绝大多数的文本编辑器。除了 Atom、VSCode、LightTable? 等“现代”编辑器之外，恐怕没有其它任何一个能达到以上水平，实现如此赏心悦目的视觉效果和用户交互。

Well，实际上直到今天，还有很多 VSCode 用户抱怨缺乏 `activate-power-mode <https://atom.io/packages/activate-power-mode>`_ 插件，导致其输入文本时没有打游戏那样的快感。:(

但是，鉴于它们同样都是 Electron 框架，以上效果 Atom/VSCode 只要去尝试，还是能（很容易？）做出来的。

接下来，我们将目光聚焦到文本编辑框上。

第一印象，你可能会以为那是用 JavaScript 实现的拟态 Vim 编辑框。 -- 呵呵，又一个拙劣的模仿者！

但是，慢着！Oni 本身就有 Neovim 做后端，完全没必要再去实现一个”Vim“。除非...另有玄机？！

是的！经过我的初步验证，该”文本编辑框“实际上是 **Neovim 的一个完整实例** ！

而这，意味着 Vim/Neovim 的所有功能都能在该“文本编辑框”中使用，包括 marks、registers、undotree、jumplist、global、autocompletion... 等等，甚至包括所有 Vim/Neovim 插件！

明白这一层之后，再回头看看那似曾相识的 Vim 互动教程。“文本编辑框”中的那些文本渲染、用户交互、事件触发...竟然与 Electron 框架融合的如此和谐，如此天衣无缝...如此于平凡处见惊奇！

The Big Picture 最初幻想
------------------------

|l_neovim|_ 项目最重要的创新之一，是将编辑器内核与前端界面彻底分离。允许用世界上的所有流行语言轻松与其内核进行交互。

曾经有那么一天，我幻想着：这一举动意味着任何有文本编辑需求的地方，都可以嵌入 Neovim 来实现 undotree、jumplist、autocompletion 等高级编辑器才有的功能，而自身专注于前端呈现和业务逻辑等其它方面。

换句话说， **Neovim 将成为开源世界的「标准组件」** 。

它出现在任何有文本编辑需求的地方，它将无处不在，随处可用。

曾经，Vim 按键绑定影响了开源世界，包括闭源世界的一大批软件和用户；而如今通过 Neovim 项目，这些用户终于有机会与 Neovim/Vim 的完整体验肌肤相亲了！

也许 Neovim 这个名字将渐渐被人淡忘，但是其自身早已化为灵与肉，滋润万物。Neovim/Vim 将获得永生！Vim 党终于要实现统治世界的“邪恶计划”！

这个过程其中的一大顾虑是：现有的软件大多已有自身的编辑器实现，指望它们短期内改弦更张恐怕不易。但是新近诞生的软件，还是有很大几率采用 Neovim 组件的。这是一个缓慢而长期的过程。

因此，Vim 党统治世界的“阴谋”，时间上肯定要延后。但走对了方向，就不怕路远不是？ :)

作为一个 |l_vimr|_ 用户，我曾希望 VimR 能往这个方向努力。因为之前使用 Electron 应用的不愉快体验，让我对 VimR 这种原生代码的实现抱有很大的痴迷。然而没想到，Oni 给了我一个情理之中又预料之外的惊喜！

想象一下：“文本编辑器”中所有编辑框，都不过是 Neovim 的一个视图/buffer，而其它视觉呈现、用户交互等等均由 CSS/JavaScript 来完成！与此同时，Neovim/Vim 的所有按键绑定和插件都能无缝衔接和使用！对了，还有 |l_lsp| 这个重量级特性的完整支持！

哦，不要想象。最初幻想的“文本编辑器”，现在已经近在咫尺，触手可及了！

Well done! Oni.

Footprint 资源占用
------------------

谈到 Electron 应用，其资源占用不可不察。

.. figure:: /images/oni_footprint.png
   :align: center

   Oni 资源占用

从图中看到，Oni 的内存占用很低。

相较于 Atom/VSCode 动辄 500M 的起跳，一个不错的开始。

Roadmap 路线图
--------------

原文照录：https://github.com/onivim/oni/wiki/Roadmap

Upcoming
^^^^^^^^

- 0.4.0 - `10/2 <https://www.patreon.com/onivim>`_ - Goals:

  - Improved on-boarding (#2020)

    - Minimal config

  - Plugin Management

    - Install plugins via plugins configuration setting

      - Oni plugins from NPM

      - Vim plugins from Github

    - Template for creating a plugin

    - Youtube video on plugin creation

    - Enabling / disabling plugins from the sidebar

On-deck
^^^^^^^

- Additional tutorials

  - 'Challenges'

  - Split-window tutorial

  - Sneak-mode tutorial

  - Auto completion tutorial

  - Menu tutorial

  - Preview work

- Generalized preview

  - Generalize preview API

  - JS live preview

  - React live preview

  - Unit testing live preview

- Embedded browser

  - Neovim as editor

- Markdown LSP

- Additional LSP support

  - Go automation

- Support yode integration

- Documentation / Education

  - youtube videos for customization

Summary 总结
------------

诚然，Oni 还有些功能不太完善。

在 |l_lsp| 体验方面还有改进空间，还需要花费时间细细打磨。但大体框架已经搭的不错，初见端倪。

而通过「交互教程」showcase，充分展现了 Oni 编辑器的能力和未来潜力。

做的不错！现在是时候去给 Oni 点个赞了！

`GitHub - onivim/oni: Oni: Modern Modal Editing - powered by Neovim <https://github.com/onivim/oni>`_
