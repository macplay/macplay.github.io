.. title: 从 URL 构建行内链接
.. slug: cong-url-gou-jian-xing-nei-lian-jie
.. date: 2018-03-17 19:57:58 UTC+08:00
.. tags: markdown, vim, reST
.. category: markup
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

昨天看到论坛有人谈到 `从 URL 构建 Markdown 行内链接 - Emacs-general - Emacs China <https://emacs-china.org/t/topic/5301>`_ 。其实，这个功能早就存在于 Emmet 插件中。之前个人写 Markdown 文档的时候就用到过，体验非常不错。具体就是：在文档内的链接处按下快捷键，将会自动提取网页标题，并插入 Markdown 风格的行内链接。这样你就不必再额外复制链接标题，甚至个别情况下还得提前在浏览器中打开链接。

实际上，该功能不仅能构建 Markdown 行内链接，还可以在网页文件中使用 ``<a>`` 标签构建 HTML 风格的链接。在 Vim 编辑器中，文件类型是自动识别的，因此并不需要额外做什么设置。

鉴于我个人 `从 Markdown 转向 reStructuredText </posts/cong-markdown-dao-restructuredtext/>`_ 已久，对该功能自然而然就用的不多起来。然而，当写 reStructuredText 文档时，当插入链接时不得不皱着眉，分两次分别复制网页链接和标题，再拼凑成 reStructuredText 风格的行内链接时。我总是不由地想起 Markdown 插入链接时的惬意顺畅。只不过，个人比较懒 - - 一直没采取任何行动，忍受着书写体验下降的情况。

现在经网友这么一提，心思抖起，觉得是时候解决一下这个“小问题”了。

.. TEASER_END

仔细想来：既然 Emmet 插件支持构建 Markdown 风格的行内链接，那应该也可以支持 reStructuredText。至于在 HTML 和 Markdown 文档中表现不同，很可能只是做了下条件判断。那样的话，我们就只需在添加一处判断 reStructuredText 即可。果然，使用 `rg` 命令用 `markdown` 关键词搜索，马上就找到了对应处的代码。简单阅读一下，和之前想的一模一样。心内不由暗喜，然后看了下源码，是使用 `printf` 函数输出并且格式化字符串。我们只需依样画葫芦，把字符串改为 reStructuredText 风格即可。

如此，只需增加两行。修改完毕，重启 Vim 编辑器测试一下。果然正常运行，没问题！其它功能也不受影响。于是，直接向 Emmet 提交 PR，希望尽快合并。前后花费时间不到 5 分钟！可以说解决这个“小问题”，是非常快了。

剩下就简单了：修改下 vimrc 配置，让 Emmet 插件在 reStructuredText 文档中自动启用。前面已经说过，该插件在个人配置中针对 html、md 文件是默认开启的，只需添加 reStructuredText 文件类型 `rst` 即可。

改善 reStructuredText 书写体验的过程，至此就结束了。需要说明的是，整个过程是针对 Vim 及其 Emmet 插件来进行的。但 Emacs 编辑器也有 Emmet 插件，两者的体验应该是差不多的。如果要增加 reStructuredText 文档的支持，则与本文的折腾过程也差不多的。

最后，我一直坚信：文字的表达能力要差于图片、视频。所谓一图胜千言是也。文字阐述再详细，也依然有读者看不懂你遇到什么问题，怎样解决的？如果是对 Vim、Emacs 编辑器没有了解的读者，那则更是完全懵掉了。因此，只要个人有时间，一般都会更进一步：“额外”在文章中配上图片和短视频。

针对 `从 URL 构建行内链接` 这个问题，我同样录制了以下视频片段：

.. raw:: html

   <video src="/videos/url_emmet.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

*视频中的 `:set ft` 命令设置文件类型(filetype)。通常使用 Vim 打开文件时，它会自动识别文件类型，无需像演示视频中那样手动设置。*

欢迎同样爱好的读者一起交流进步！

THE END.
