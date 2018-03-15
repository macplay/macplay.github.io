.. title: 迁移到 onivim
.. slug: qian-yi-dao-onivim
.. date: 2018-03-15 18:08:03 UTC+08:00
.. tags: linux, manjaro, macos, vim, vimrc, onivim
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

.. include:: posts/tags.ref
.. include:: posts/links.ref
.. include:: posts/interps.ref

关注 |l_onivim|_ 有一段时间了。根据主页描述，Oni 是个基于 Electron 技术实现的 Neovim 前端，对 |l_lsp|_ 支持很全面。不过，之前使用 |l_vimr|_ 还算舒心，而 Oni 则起步较晚，一些功能还不完善。因此并没有动迁移的念头。

不过最近几天在折腾 |t_manjaro| ，当寻找 Linux 下的 Neovim 前端时，试用了一圈竟然没有一个好用的！或多或少都存在一些问题。于是，无奈之下，我在 U 盘的 manjaro 操作系统上尝试了“臃肿”的 Electron 编辑器。其结果是出乎我意料之外的：Oni 已经达到了日常堪用的水平，而且与我之前的 vimrc 配置协作良好。

.. TEASER_END

配置 Oni 编辑器
---------------

打开 Oni 编辑器时，我对它的一些设计和做法并不太满意。比如，Fuzzy Finder。作为已经习惯更强大的 CtrlP 插件的用户，看到 Fuzzy Finder 多少有些尴尬。如果可能的话，肯定要关闭该组件。还有 Status Bar 状态栏，Oni 追求视觉效果更丰富，无法响应鼠标事件的 Airline 插件，肯定不能继续用。但是，Oni 的状态栏还只有最基本的功能！因此，能关闭也要关闭掉。还有侧边栏，只有基本的文件浏览功能，得关闭掉。还有，曾以为无法更改 commandline 位置（太遗憾了！），结果翻遍官方 wiki 手册后，发现也能改到习惯的最下角。还有其它一些小细节，等等。

事实上，折腾 Oni 配置的过程中，我不小心安装了过时的版本。这个版本存在的小 bug 与繁杂的 wiki、配置交织到一起，一度让人崩溃（因为要不断反复试验，才能知道是 Oni 的 bug 还是自己的配置问题）。但好在最后，我还是确定了两处明显的 bug，并且把配置也修改到了心理预期。

但！高潮在后面，第二天软件管理器提示有更新。升级之后，Oni 那几处明显的 bug 都不见了！Github 上看到新版是在好几天前发布的，下游可能花了点时间才打包好。- - 这事告诉我们：折腾比较新潮的东西时，一定要和官方的最新版保持高度一致！

不管怎样，因为已经大致读懂了官方的 wiki 手册。整个事情一下子感觉通畅起来，配置 Oni 也变得容易。整个的配置文件仅有 30 多行，把我之前的不满意基本全部消除掉了。

配置文件在 `这里 </listings/manjaro/oni_config.js.html>`_ 。参考资料： [1]_  [2]_

.. [1] https://github.com/onivim/oni/wiki/Features
.. [2] https://github.com/onivim/oni/wiki/Configuration

迁移 vimrc 配置
---------------

如果能把我之前的 vimrc 配置，包括按键绑定、插件等，都迁移到 Oni 上就更好了！挺早时候我曾尝试过一次 Oni，发现它有加载 Neovim 配置 `init.vim` 的选项，不过当时开启后并不好用，浅尝辄止后就放弃了。这次仔细看完官方 wiki 后，发现其 `内置的插件 <https://github.com/onivim/oni/wiki/Plugins>`_ `targets.vim` 等和我的配置并不冲突。事实上，目前仅发现一处与我的 20 多个插件按键绑定相同。这一定程度上说明我 vimrc 配置比较短小精悍，方便快速融入到新的编辑器潮流中 :)

另外，真正值得关注的是编辑器的自动补全功能，以及 Quick Info 功能。这两个功能是个人折腾 Oni 的原动力，绝对要保证正常工作。这样的话，说明基于 |l_lsp|_ 的所有功能/语言都可以在 Oni 编辑器上正常运行，才有较大的想象空间。

经过阅读手册和简单试验，发现受影响的只有 vimrc 配置里的补全插件。在我看来 Oni 自行实现了补全机制：与 vimrc 配置的补全插件一样，监听光标移动来弹出下拉列表。而这将会产生冲突，解决方案是配置文件里判断是否为 Oni 编辑器，把之前的补全插件禁用即可。这样的话，就可以做到 macOS、Linux、Window 平台仅需一份 vimrc 配置，Vim、Neovim、GVim、VimR、Oni... 等等也仅需这一份 vimrc 配置！真正需要更改的地方特别少，以前的操作习惯也完全不用改变！

参考资料： [3]_ 。

.. [3] https://github.com/onivim/oni/wiki/How-To:-Make-Oni-closer-to-bare-Vim-experience

另外，我的 vimrc 配置文件在这里： |l_vimrc|_

最终效果
--------

真正折腾的时间，其实是在 Oni 的 `config.tsx` 配置文件上。不过，考虑到对 |l_lsp|_ 最新标准的全面靠拢，以及可能带来的未来潜在收益，这些折腾是完全值得的。

经过一天的非重度使用，发现 Oni 应付日常使用是足够的，虽然它在主页上说直到 1.0 版本一切都是不稳定的（当前是 0.3.1 版本）。已发现体验下降的地方一处：写 |t_latex| 文档时，补全列表不会自动弹出来，得手动按键触发才行（Vim 默认绑定 `Ctrl+x, Ctrl+o`）。其它暂时没有明显感觉。但整体上，还算可以接受吧。

另外，我的这篇文章就是在 Oni 编辑器中完成的。说起来，这也是我第一次在 |t_manjaro| 下更新 Nikola 博客 :) 如果有时间的话，我也会尽快写一篇文章，介绍下我最近在尝试的 manjaro 发行版。

其它
----

写这篇文章前，考虑到对 Vim 并不太熟悉的读者，我录制了三个简短的视频片段，来说明编辑器重要功能之一：自动补全的使用体验变迁。不过真正写文章的时候，才发现并没有合适的地方放这些视频片段 - -

那就放到文章末尾吧。我会配以简短的文字说明，感兴趣的读者可以下载我的 vimrc 配置自行体会。

**Vim + neocomplete 插件**

.. raw:: html

   <video src="/videos/vim_nc.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

可以看出，对第三方模块不提供补全支持。

通过安装 jedi-vim 插件可以解决，不过鉴于个人已转到 Neovim，没有在配置里加该插件。

**Neovim + nvim-completion-manager 插件**

.. raw:: html

   <video src="/videos/nvim_ncm.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

有参数补全，日常使用差不多足够。

**Oni + LSP**

.. raw:: html

   <video src="/videos/oni_lsp.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

支持 |l_lsp|_ ，依据编程语言不同，还有跳转定义、重命名、语法检查等功能。

更多 LSP 支持请参看 Oni 的 wiki 页面： https://github.com/onivim/oni/wiki/Language-Support

--------------------------------------------------------------------------------

THE END.
