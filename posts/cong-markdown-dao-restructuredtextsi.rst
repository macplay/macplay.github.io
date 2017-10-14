.. title: 从 Markdown 到 reStructuredText（四）
.. slug: cong-markdown-dao-restructuredtextsi
.. date: 2017-10-14 18:37:28 UTC+08:00
.. tags: markup, reST, pdf
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

本文是《从 Markdown 到 reStructuredText》系列文章的第四篇。和 Markdown 一样，reStructuredText 也是一种易读易写的纯文本标记语言，不过功能上更加强大（而且标准统一）。如果想了解其对应于 Markdown 的基本语法，请阅读 `第一篇文章`_ 。本文继续 `上一篇文章`_ 的话题，试用和探索一下 reStructuredText 导出为其它格式的功能。

.. _`第一篇文章`: ../cong-markdown-dao-restructuredtext/
.. _`上一篇文章`: ../cong-markdown-dao-restructuredtextersan/

reStructuredText 安装包 docutils_ [#]_ 额外包含了一些 Python 脚本，以支持导出到其它格式。这里只谈一谈比较关心的 HTML、S5 Slides、Office 文档、PDF 等格式的支持情况。

.. TEASER_END

.. figure:: /images/rst_outputs.png
   :align: center

   docutils 命令

.. _docutils: http://docutils.sourceforge.net
.. [#] 通过 ``pip install docutils`` 安装；或者 ``pip install Nikola`` 将会自动安装该依赖。

HTML 导出
=========

因为已经在使用 Nikola 静态博客，笔者对 HTML 导出的功能并不十分看重——需要时在浏览器中直接点击 `文件` - `另存为` ，将会把相关的 HTML、CSS、JS 等等保存到同一文件夹中。然后就可以随时离线浏览，其显示样式与在线浏览基本没有差别。

如果你没在使用 Nikola，则建议使用 ``rst2html.py`` 等命令，不过实测这些命令导出 HTML 文档时，基本上没有任何样式。如果需要进一步美化，建议到网络上搜寻一些样式模板。

S5 Slides
=========

S5_ 是基于 XHTML、CSS 和 JavaScript 的演示文稿。你可以使用 reStructuredText 写文档，通过 ``rst2s5.py`` 命令将其转换为 S5_ 格式，然后在浏览器中进行演示。也可以将静态文件上传到网络空间，方便随时访问。实测 rst 转 S5_ 的效果非常好：

.. figure:: /images/s5_output.thumbnail.png
   :align: center
   :target: /images/s5_output.png

注意右下角的工具栏图标，点击 `Ø` 在纯 HTML 文件 和 S5 Slides 之间切换，点击下拉列表跳转到演示文稿的其它页面。

.. _S5: http://meyerweb.com/eric/tools/s5/

用 reStructuredText 书写时注意 `标题（Sections）` 内容不要过长，可能会被截断。转换时可以使用 ``--theme`` 指定 S5 主题，如果系统中安装有 Pygments_ ，将会调用其进行代码高亮。

另一个官方提供的 `S5 例子 <http://meyerweb.com/eric/tools/s5/s5-intro.html>`_ 。

.. _Pygments: http://pygments.org

Office 文档导出
================

reStructuredText 提供了导出到 LibreOffice 文档的功能，转换命令为 ``rst2odt.py`` 。经实际测试，基本样式区分正确，文档目录、脚注、代码区块等等也进行了转换，不过样式可能还需要进一步调整。

.. figure:: /images/odt_output.thumbnail.png
   :align: center
   :target: /images/odt_output.png

至于 MS Office 文档 `.docx` 格式， docutils_ 并没有提供相应的转换命令。需要使用 pandoc_ 这个万能格式转换器： ``pandoc posts/cong-markdown-dao-restructuredtextsan.rst -f rst -t docx -o newfile.docx`` 。相对 LibreOffice 的 `.odt` 格式， `.docx` 情况要略微好一些，令人惊喜的是，代码区块中的语法高亮完整地保存了下来。如果你的文档中包含有大量的代码区块，使用 `.docx` 格式是个不错的选择。

.. _pandoc: http://pandoc.org/

PDF 格式导出
============

如果你像我一样使用 Nikola 静态博客，则直接在浏览器中选择打印，输出到 PDF 格式即可。此方法对样式的保留程度可以说是 100%，操作也非常简单，唯一缺陷是需要特定的 Nikola 博客主题。

.. figure:: /images/print2pdf.thumbnail.png
   :align: center
   :target: /images/print2pdf.png

   HTML 样式完整保留， `查看样张 </documents/print_output.pdf>`_ 。

第二种方法是通过 docutils_ 提供的 ``rst2xetex.py`` 命令，先将 rst 文件转为 tex 文件，再通过 ``xelatex file.tex`` 命令将其编译为 PDF 文档。你的系统需安装有 TexLive 等发行版，另外使用 xelatex 编译中文需要一些额外设置。

如果你对 LaTeX 比较熟悉，可以在转换完的 tex 源文件上继续编辑，实现高度自定义的排版效果。笔者 LaTeX 水平仅仅是入门阶段，只简单地修复了图片地址及缩放等小问题。

感兴趣的话，这里可以找到 `源文件 </documents/xetex_output.tex>`_ 和 `PDF 样张 </documents/xetex_output.pdf>`_ 。

总结
====

总体上来说，reStructuredText 的导出功能令人满意，至少与 Markdown 等其它标记语言处在同一水平。如果你对文章内容有疑问或者有更好的建议，欢迎在评论区进行探讨。

至此，《从 Markdown 到 reStructuredText》系列文章暂时告一段落。我们通过四篇文章，分别了解到 reStructuredText 的核心语法、超集扩展、HTML 样式以及文档导出等。希望通过笔者的文章，你也能发现 reStructuredText 这门标记语言的功能强大，统一优美之处。

:)
