.. title: 使用 Vim 在 Markdown 及 rst 文档中创建表格
.. slug: shi-yong-vim-zai-markdown-ji-rst-wen-dang-zhong-chuang-jian-biao-ge
.. date: 2017-10-10 21:15:21 UTC+08:00
.. tags: vim, reST, markdown
.. category: markup
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

之前提到过 reStructuredText 的表格类型 `Grid Tables`_ 书写困难，普通编辑器难以胜任，可能有人好奇笔者是如何做的。对于 Vim、Emacs 两大编辑器来说，表格创建任务非常简单：

.. _`Grid Tables`: ../cong-markdown-dao-restructuredtext/#table

.. raw:: html

   <video src="https://raw.githubusercontent.com/ashfinal/bindata/master/videos/vim_table.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

笔者平时使用较多的是 Vim 编辑器，借助强大的 `vim-table-mode`_ 插件，只需正常输入表格内容和竖线符号 ``|`` 就可以，其它事情如填充和对齐等等插件会自动处理。笔者针对 `vim-table-mode`_ 插件做了几行配置，使其支持 Markdown、rst、org 表格的创建（org 表格在上图中没有展示），如果有人感兴趣的话，可以看一下个人 `vimrc 配置`_ 的相应部分。

.. _`vim-table-mode`: https://github.com/dhruvasagar/vim-table-mode
.. _`vimrc 配置`: https://github.com/ashfinal/vimrc-config/blob/0cba64e3a384fc78483a431b45b65a50daba34dd/.vimrc#L750

PS：发现录屏如果使用 GIF 格式，无论怎样压缩都达不到理想的画质和文件大小。最后使用 MP4 格式，1 分 53 秒时长的 720P 视频，压缩后仅仅 836 KB！感觉以后文章中插入动图可以抛弃 GIF 格式了。

读者们注意到上面录屏其实是视频而不是图片吗？ :)
