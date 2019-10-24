.. title: 在浏览器中运行 Vim 编辑器
.. slug: run-vim-editor-on-browsers
.. date: 2019-10-23 21:29:00 UTC+08:00
.. updated: 2019-10-24 15:46:28 UTC+08:00
.. tags: vim
.. category: vim
.. link:
.. description:
.. type: text
.. nocomments:
.. previewimage: /images/chrome_vim_wasm.thumbnail.png

有人将 Vim 编辑器移植到了 WebAssembly (Wasm) 格式： `vim.wasm: Vim Ported to WebAssembly <https://github.com/rhysd/vim.wasm>`_ 。 `Wasm <https://webassembly.org/>`_ 是一种底层的二进制指令格式，理论上能实现接近 C/C++/Rust 等编译性语言的执行速度，目前已经在主流浏览器 Chrome/Safari/Firefox/Edge 中得到支持。所以现在，你可以在浏览器上体验原汁原味的 Vim 了！

.. figure:: /images/chrome_vim_wasm.png
   :alt: vim.wasm on chrome
   :align: center

.. TEASER_END

在线体验地址： http://rhysd.github.io/vim.wasm

事实上，我很早就关注了该项目，只不过那时它还只是仅仅能运行。现在，它已经包含了一些引人注目的特性：

1. 编译的是 Normal 版本，这意味着几乎所有的 Vim 特性，如语法高亮、Vim script、文本对象... 包括 popup window（浮动窗口）等都可以正常运行。

2. 支持读取外部 `vimrc` 配置，以及持久化的文件目录存储，默认为 ``~/.vim`` 。

3. 系统剪贴板支持、文件拖放支持、文件导出功能 ... 等等

   ...

经过我的简单尝试，如上图，发现 vim.wasm 还包含了 netrw，matchit 等插件--这意味着：其它 Vim script 编写的外部插件也可以运行。稍微探索一番，就可以使用原汁原味又个性化十足的 Vim 编辑器了--在浏览器中！

你可以将我的 `单文件 vimrc <https://github.com/ashfinal/vimrc-config>`_ 作为开始，打造一份用于轻量级场景或初中级 Vim 教学的配置。

当然，该项目还有很多不足，相信你会注意到 :) Wasm 标准和生态尚未成型，也会带来很多未知与挑战。但无论怎样，它证明了一个精简高效的“内核”所具有的持久生命力。作为新兴技术的探索者，vim.wasm 也是一个值得长期关注的项目。

最后，Happy Viming！
