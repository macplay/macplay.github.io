.. title: Emacs 的 Font Lock 性能问题
.. slug: emacs-de-font-lock-xing-neng-wen-ti
.. date: 2017-11-24 11:53:52 UTC+08:00
.. tags: vim, emacs, regex
.. category: emacs
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

之前使用 Emacs 总是有点慢，没有 Vim 那种爽冽干脆的感觉。但多半是归咎于臃肿的 spacemacs 配置，不会轻易怀疑 Emacs 本身有什么问题。最近基本上是接近裸状态使用 Emacs 了，不安装第三方插件，也不搞乱七八糟的配置。不过两天前我又遇到了状况，翻来覆去尝试半天，感觉很有可能是 Emacs 的 Font Lock 性能有问题。

.. TEASER_END

.. raw:: html

   <video src="/videos/font_lock.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

以上截图是我使用正则搜索 `.` （即匹配所有字符）的情况，未经任何后期处理， **肉眼可见** 匹配项有个逐渐的着色过程。有人可能会说：是不是你文件太大，匹配项太多以至于 Emacs **肉眼可见的慢** ？还真不是，这个文件正如截图中呈现的那样，就是那么短，就只有那么多字符。

.. code:: text

   Col 1 of 115; Line 2 of 22; Word 1 of 116; Char 2 of 1001; Byte 2 of 1003

仅仅 1001 个字符的着色就已经如此之慢！真是有点跌破了我对 Emacs 的认知。要知道 Font Lock 机制被广泛应用于 Emacs 主题、语法高亮、字体样式等等，而且这些样式随着文本编辑、语法检查等操作是时时更新的，如果 1001 个字符着色就能导致 **肉眼可见的慢** ，那同时打开多个文件，后台再跑一些导致 buffer 时不时刷新的任务，那么感觉 Emacs 运行慢也就是必然的结果了。

这个简单的测试录屏时，就只打开了这一个文件。Emacs 安装的插件就只有 5 个： `org which-key undo-tree atom-one-dark-theme magit` 。如果感兴趣的话，可以到 `这里`_ 看我的 `.emacs` 配置文件。

.. _`这里`: https://github.com/ashfinal/spacemacs-private/blob/master/.emacs

这么来看的话，Emacs 支持花样繁多的样式，带来的性能问题还真不小。目前我并没有深入了解 Emacs 的 Font Lock 机制以及正则匹配，以对该问题做专业测试和剖析。如果你对此有了解的话，欢迎在评论区予以指教。
