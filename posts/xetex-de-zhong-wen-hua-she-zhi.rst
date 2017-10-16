.. title: XeTeX 的中文化设置
.. slug: xetex-de-zhong-wen-hua-she-zhi
.. date: 2017-10-16 17:07:37 UTC+08:00
.. tags: xetex, reST
.. category: latex
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

看过一些文章得出结论：即使用 XeTeX 编译中文，也需要额外添加 `xeCJK` 包设置下字体。笔者也一直是这么做的。

刚尝试了下，这一步其实是不必要的。直接用 `fontspec` 设置中文字体，不必引入额外的包：

.. code:: latex
   :number-lines:

   %! TEX program = xelatex

   \usepackage{fontspec}
   \setmainfont{PingFang SC}
   \setsansfont{Hiragino Sans GB}
   \setmonofont[Scale=0.9]{PingFang SC}

   \usepackage{indentfirst}
   \setlength{\parindent}{2em}

   \XeTeXlinebreaklocale "zh"
   \XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt

第 1 行指定编译引擎 `xelatex` 。不成文的规范，LaTeX 客户端或编辑器插件不一定会遵守。

第 3-6 行使用苹方和冬青黑体，macOS 上的默认字体。

第 8-9 行分别设置首行缩进和缩进间隔。

第 11 行使用中文断行方式，否则段落会合并成一行。

第 12 行还不清楚啥意思，不过好多文章都有，暂时不删除。

这几行精简的配置，足以应付 macOS 上绝大部分编译场景。如果是其它操作系统，注意替换中文字体。通过 `rst2xetex.py` 命令转换过来的 tex 文件，添加以上几行，就能顺利编译。
