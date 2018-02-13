.. title: 在 reStructuredText 中实现引用链接的统一管理
.. slug: zai-restructuredtext-zhong-shi-xian-yin-yong-lian-jie-de-tong-yi-guan-li
.. date: 2018-02-13 10:47:00 UTC+08:00
.. tags: markdown, reST, nikola
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
.. include:: posts/abbrs.ref

最近几天又尝试了下 |t_latex|, 发现 Bibliography 的理念很好。它将文档中所有资料引用统一保存到 `.bib` 文件中，然后在正文中以别名的形式插入。如果有需要的话，还可以自定义引用的显示格式。这大大简化了参考文献的管理和使用：平时统一维护所有的参考文献，甚至你一生中只需维护一份 `.bib` 文件；而写作时不必麻烦地复制粘贴，用别名就可以方便地插入参考文献。

.. sidebar:: LibreOffice 的「Navigator」功能

   .. figure:: /images/libreoffice_navigator.thumbnail.png
      :align: center
      :target: /images/libreoffice_navigator.png

如果要在「现代」文档处理软件中寻找对应的话，大约相当于 LibreOffice 的「Navigator」功能或者其它软件的「媒体库」功能。不同之处在于 Bibliography 针对纯文本文件而优化，不止针对单份文档还能在所有文档中依需要载入。

尽管笔者平时写博客时并不用参考资料，但插入链接是很常见的操作。而该操作还是挺麻烦的——通常需要在浏览器中输入网址，等待其打开，然后分两次粘贴网址以及网页标题到 |l_vimr|_ 编辑器中。如果能够使用 Bibliography 的方式管理引用链接，则插入链接会方便许多——仅需麻烦一次，则全站博客均可以别名方式引用，毋需再次打开浏览器。显然这种统一管理有利于写作时的思维连贯性。而且今后如果有额外需求，比如想知道某链接在全站被引用了多少次，直接使用 `ag` 或 `grep` 命令搜索一下即可。

另外一个麻烦点在于：博客的站内链接显然有利于读者快速寻找相关内容并跳转浏览，比如 tags 就是站内链接优化很好的一个点。然而插入 tags 也是个比较麻烦、容易打断思路的事情，。完全可以将博客内的 tags 「封装」一下，在任何文章中都可以随时快速地插入 tag。实际上，也可以不局限于 tags，一些相对固定的链接均可用相同的手法操作。

于是笔者花费了半天的时间试验了一下，发现完全可以使用 |a_rst| 的 `include` 指令实现类似 Bibliography 的功能，对全站所有的链接引用进行统一管理。以下将简单的介绍一下我的做法。

.. TEASER_END

.. contents:: 文章目录

实际操作的一些思考
------------------

如果你对 |a_rst| 的 `include` 指令稍有了解，就知道把文章分为一份文档或者几份独立文档并没有明显区别。照此想来，想要实现引用链接的统一管理，只需把所有链接放到另外的文件中，使用的时候用 `include` 指令引入进来不就好了？事实上，还真就是这么简单！不过，在具体操作的时候需要注意几点：

1. 我们希望链接文件仅在被 `include` 时，才参与静态博客的生成。因此，在文件命名上应避开 `.rst` ， `.txt` , `.md` 等等这些扩展名，以避免混淆和干扰。具体在此处，我使用了 `.ref` 的扩展名。

2. 应该对链接文件进行简单的分组。比如分为 `links.ref` ——外部链接引用， `tags.ref` ——博客 tags 引用， `media.ref` ——媒体资讯引用，还有医学、化学、材料学引用……等等。这样就不必把所有链接全部塞到一份文件中，使用时需要哪一组或几组链接，再 `include` 进来即可。这样分组，也将大大简化链接文件的维护工作。

3. 缩略词其实也可以统一管理。有利于在全站范围内保持某些术语的一致性。我们可以使用 `abbrs.ref` 这样的文件名。当然，纠错词理论上也可以（比如，你经常把 `Matplotlib` 错写成 `matplot` ，就可以用 `abbrs.ref` 全部给纠正过来）。不过，一般我们不鼓励这么做——我们希望你第一次就把它写对，然后借助编辑器的自动补全或拼写检查功能保证正确。而不是把错误一直延伸到博客里面，再专门用个补丁文件把它纠正过来。

4. 最好给别名加上前缀。比如 `t_vim` 代表 |t_vim| 博客 tag，而 `l_vim` 则代表的是外部链接—— |l_vim|_ 的官方网站。加上前缀有利于区分不同的使用场景，而且后续如需扩展也非常方便。

好了，很啰嗦的说了这么多。实际上，这些是我反复实践与比较之后的结果，尽可能地让它投入使用时就接近「最佳实践」。这可能会让人觉得它很复杂并吓退一些人，但实际上它的具体使用很简单。

links.ref 和 interps.ref
------------------------

这两份文件是外部链接。 `links.ref` 里面是网址，而 `interps.ref` 则是对应网址的标题。 `links.ref` 的文件内容：

.. code:: rst

   .. _l_rstintro: http://docutils.sourceforge.net/docs/ref/rst/introduction.html
   .. _l_rstspecs: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
   .. _l_spacemacs: https://github.com/syl20bnr/spacemacs

而 `interps.ref` 的文件内容：

.. code:: rst

   .. |l_rstintro| replace:: An Introduction to reStructuredText
   .. |l_rstspecs| replace:: reStructuredText Markup Specification
   .. |l_spacemacs| replace:: Spacemacs

使用时在文档开头引入这两个文件，就可以在文章里随处用别名插入链接：

.. code:: rst

   .. include:: posts/links.ref
   .. include:: posts/interps.ref

   ...

   引用网址： |l_rstintro|_

渲染结果：

引用网址： |l_rstintro|_

有时候我们不喜欢预定的网址标题，而想自定义标题显示。那就不必引入 `interps.ref` 文件，而在主文档里用类似语法替换一下：

.. code:: rst

   .. include:: posts/links.ref

   ...

   .. |l_rstintro| replace:: 这里
   点击 |l_rstintro|_ 访问 reStructuredText 手册。

渲染结果：

点击 |tmp_rstintro|_ 访问 reStructuredText 手册。

.. _tmp_rstintro: http://docutils.sourceforge.net/docs/ref/rst/introduction.html
.. |tmp_rstintro| replace:: 这里

tags.ref
--------

博客 tags 其实也是引用链接，不过是内部相对链接罢了。而且没有自定义网址标题的需求，那自然没必要分成两个文件。其内容大体如下：

.. code:: rst

   .. _vim: /categories/vim/
   .. |t_vim| replace:: vim_

   .. _`sublime text`: /categories/sublime-text/
   .. |t_sublime_text| replace:: `sublime text`_

   .. _`马克飞象`: /categories/ma-ke-fei-xiang/
   .. |t_马克飞象| replace:: `马克飞象`_

使用时同样也是在文档开头引入，然后用别名访问。

.. code:: rst

   以下是两个标签： |t_sublime_text| 和 |t_马克飞象|

渲染结果：

以下是两个标签： |t_sublime_text| 和 |t_马克飞象|

abbrs.ref
---------

至于 `abbrs.ref` 则并非链接引用，而是统一的缩略词管理。使用的是 `a` 前缀：

.. code:: rst

   .. |a_rst| replace:: reStructuredText

使用效果：

.. code:: rst

   |a_rst| 是易读易写的纯文本标记语言。

渲染结果：

|a_rst| 是易读易写的纯文本标记语言。

简单总结
--------

目前给本博客增加的链接/缩略词文件只有以上四个，以后根据情况需要可能会添加新的分组。但通过以上的介绍我们发现，只需对链接文件进行简单分组和一定约束，就能在博客写作的过程中大大简化链接的管理和引用。只要你愿意，这些链接文件可以有无限个分组和层级。而且一旦建立之后，可以在全站范围内「复用」。更重要的是，你可以与别人分享、交换这些「子文件」，使得你的劳动成果能够被更多人「复用」。

最后的最后，这些别名的输入与编辑器的自动补全功能配合更加方便。比如输入 `t_` 列出博客的所有 tag。

.. raw:: html

   <video src="/videos/rest_citation.mp4" loop autoplay>
   Your browser does not support the video tag.
   </video>

END. :)
