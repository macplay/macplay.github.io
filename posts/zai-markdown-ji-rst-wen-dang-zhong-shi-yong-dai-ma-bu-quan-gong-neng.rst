.. title: 在 Markdown 及 rst 文档中使用代码补全功能
.. slug: zai-markdown-ji-rst-wen-dang-zhong-shi-yong-dai-ma-bu-quan-gong-neng
.. date: 2017-10-12 15:45:30 UTC+08:00
.. tags: vim, markup
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

大家都知道，写 Markdown 文档时可以使用代码区块（Code Blocks)。给代码片段指定语言类型，就有漂亮的语法高亮效果。那有没有想过，直接在代码区块中写 Python 代码呢？

这个事情还真可以做到，方法是使用 Neovim + ncm。ncm_ 全称 “nvim-completion-manager”，是针对 Neovim_ 编辑器的一款异步补全框架（插件）。笔者从 Vim_ 转到 Neovim_ ，重新搜寻补全插件的过程中，经过与 deoplete_ [#]_ 的比较，迅速入了 ncm_ 的坑。;-)

.. _ncm: https://github.com/roxma/nvim-completion-manager
.. _Vim: https://www.vim.org
.. _Neovim: https://github.com/neovim/neovim
.. _deoplete: https://github.com/Shougo/deoplete.nvim
.. _Shougo: https://github.com/Shougo
.. [#] 另一款异步补全插件，由 Vim 大神 Shougo_ 开发。

.. TEASER_END

.. raw:: html

   <video src="https://cdn.rawgit.com/ashfinal/bindata/15102854/videos/ncm_scope.mp4" loop autoplay>
       Your browser does not support the video tag.
   </video>

从上图中可以看到 ncm_ 的一项特色功能： `Scoping` 。 `Scoping` 允许你直接在某 `作用域（Scope）` 内补全 Python、JavaScript、Go……等等，即 ncm_ 框架下的所有语言。笔者接触到 ncm_ 时已有 Markdown 支持，两天前寻思增加 reStructuredText 应该也不会太难，就尝试着提了个 issue 请求。结果 ncm_ 作者反应异常迅速，当天就增加了对 reStructuredText 代码区块的支持。考虑到大部分受众恐怕还在使用 Markdown，上图录屏中仍采用了 Markdown 文档来做示范，以让读者有最直观的感受。

`Scoping` 的另一个使用场景：编写 HTML 时在 `script` 标签中补全 JavaScript 代码，在 `style` 标签中补全 CSS 代码。这个也是 ncm_ 开箱支持的，有没有感觉很贴心？ :) 最后的最后， ncm_ 作者是中国人，童鞋们可以去点赞了。
