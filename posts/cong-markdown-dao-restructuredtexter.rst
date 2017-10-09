.. title: 从 Markdown 到 reStructuredText（二）
.. slug: cong-markdown-dao-restructuredtexter
.. date: 2017-10-08 14:45:54 UTC+08:00
.. tags:
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

:Author: ashfinal
:Contact: ashfinal@sina.cn
:Revision: 1008
:Date: 2017-10-08
:Copyright: `CC BY-NC-SA 3.0`_

.. _`CC BY-NC-SA 3.0`: https://creativecommons.org/licenses/by-nc-sa/3.0/deed.zh

本文是《从 Markdown 到 reStructuredText》系列文章的第二篇。和 Markdown 一样，reStructuredText 也是一种易读易写的纯文本标记语言，不过功能上更加强大（而且标准统一）。如果想了解其对应于 Markdown 的基本语法，请阅读 `上一篇文章`_ 。本文主要从文档写作需求出发，聊一聊 reStructuredText 相对于 Markdown 的超集部分。

.. TEASER_END

.. _`上一篇文章`: ../cong-markdown-dao-restructuredtext/

.. contents:: 文章目录

Line Blocks
===========

.. code:: rst

   | 这是第一个段落。
   | 这是一个长段落，没有续行。除了行首的竖线与空格外，与 reStructuredText 最常用的基础语法——以空行分割的段落没有任何区别。继续随便写点什么，填满屏幕保证软换行。继续随便写点什么，填满屏幕保证软换行。
   | 这是第三个段落，使用了续行。
     这行也属于第三段。这个续行应保持与上一行相同的缩进水平。
   |
   |
   | 以上是两个空白段落。
   |     可以继续缩进段落和解析 **行内标记** 。
   | 然后反缩进。

渲染结果：

| 这是第一个段落。
| 这是一个长段落，没有续行。除了行首的竖线与空格外，与 reStructuredText 最常用的基础语法——以空行分割的段落没有任何区别。继续随便写点什么，填满屏幕保证软换行。继续随便写点什么，填满屏幕保证软换行。
| 这是第三个段落，使用了续行。
  这行也属于第三段。这个续行应保持与上一行相同的缩进水平。
|
|
| 以上是两个空白段落。
|     可以继续缩进段落和解析 **行内标记** 。
| 然后反缩进。

以上语法结构称之为 `Line Blocks（行区块）` ，使用手册推荐用来写地址簿、诗句、歌词等“短小精悍”的段落。但正如以上例子所示，它可以用来做很多别的事情。如果你不习惯使用空白行分段，想让文档显得更紧凑些，或者想将文档的行字符数限制在 80 个以内，或者想产生空白段落（一般不建议）……都可以使用 `Line Blocks` 。因其与空行段落有功能重叠，笔者干脆给其加了条 CSS 规则： ``text-indent: 2em;`` ，这样实际上首行缩进也可以使用 `Line Blocks` （注意到上面渲染结果的首行缩进效果了吗？）。

Literal Blocks
==============

至于 `Literal Blocks（原样区块）` ，初看用来显示代码区块不错。不过代码区块已经有 `code` 指令实现。那么 `Literal Blocks` 因其默认启用等宽字体，则用来实现“分列”效果：

.. code:: rst

   ::

       Turkey has suspended all visa services          "Recent events have forced the Turkish
       at its diplomatic facilities in the             Government to reassess the commitment
       United States, the Turkish Embassy in           of the Government of the U.S. to the
       Washington announced late Sunday, shortly       security of Turkish Mission facilities
       after a similar U.S. move.                      and personnel," the Turkish Embassy in
                                                       Washington said in a statement issued
       The tit-for-tat travel services suspensions     late Sunday. "In order to minimize the
       between the two NATO partners exposed a         number of visitors to our diplomatic
       deepening diplomatic rift inflamed by the       and consular missions in the U.S.
       arrest of a Turkish employee at the U.S.        while this assessment proceeds,
       consulate in Istanbul.                          effective immediately we have
                                                       suspended all visa services regarding
                                                       the U.S. citizens at our diplomatic
                                                       and consular missions in the U.S.,"
                                                       read the statement.

渲染结果：

::

    Turkey has suspended all visa services          "Recent events have forced the Turkish
    at its diplomatic facilities in the             Government to reassess the commitment
    United States, the Turkish Embassy in           of the Government of the U.S. to the
    Washington announced late Sunday, shortly       security of Turkish Mission facilities
    after a similar U.S. move.                      and personnel," the Turkish Embassy in
                                                    Washington said in a statement issued
    The tit-for-tat travel services suspensions     late Sunday. "In order to minimize the
    between the two NATO partners exposed a         number of visitors to our diplomatic
    deepening diplomatic rift inflamed by the       and consular missions in the U.S.
    arrest of a Turkish employee at the U.S.        while this assessment proceeds,
    consulate in Istanbul.                          effective immediately we have
                                                    suspended all visa services regarding
                                                    the U.S. citizens at our diplomatic
                                                    and consular missions in the U.S.,"
                                                    read the statement.

如果前面有段落，该语法可以简写：

.. code:: rst

   在前一段落末尾直接写： ::

       “分列”效果在网页排版中用处不大，
       不过在书籍、PDF 格式等中有应用场景。

渲染结果：

在前一段落末尾直接写： ::

    “分列”效果在网页排版中用处不大，
    不过在书籍、PDF 格式等中有应用场景。

Doctest Blocks
==============

最后既然提到代码区块，顺便补充一种语法： `Doctest Blocks` 。

.. code:: rst

   >>> ls -al
       total 35592
       drwxr-xr-x+ 64 ashfinal  staff      2048 Oct  9 00:16 .
       drwxr-xr-x   6 root      admin       192 Sep 26 04:36 ..
       drwx------+  6 ashfinal  staff       192 Oct  8 23:43 Desktop
       drwx------+  3 ashfinal  staff        96 Sep 26 04:29 Documents
       drwx------+ 12 ashfinal  staff       384 Oct  8 22:08 Downloads

渲染结果：

>>> ls -al
    total 35592
    drwxr-xr-x+ 64 ashfinal  staff      2048 Oct  9 00:16 .
    drwxr-xr-x   6 root      admin       192 Sep 26 04:36 ..
    drwx------+  6 ashfinal  staff       192 Oct  8 23:43 Desktop
    drwx------+  3 ashfinal  staff        96 Sep 26 04:29 Documents
    drwx------+ 12 ashfinal  staff       384 Oct  8 22:08 Downloads

与 `code` 指令区别是没有代码高亮，一般用来显示 shell 或 ipython 等的行命令及执行结果。

Field Lists
===========

`Field Lists（字段列表）` 其行为表现是用两列的数据来呈现字段及其对应值：

.. code:: rst

   :Author: ashfinal
   :Contact: ashfinal@sina.cn
   :Revision: 1008
   :Date: 2017-10-08
   :Copyright: `CC BY-NC-SA 3.0`_

渲染结果见文章开头。

如果 `Field Lists` 是文档中出现的第一个元素，则其中的某些字段会被识别为 `bibliographic data` ，比如作者、地址、联系方式、组织机构、文章摘要等等。这些数据可能会引起文档结构的小变动，比如被重新排版到出版物的扉页位置。 `Bibliographic data` 对网页排版基本没有影响。

Admonition
==========

`Admonition（告诫）` 与文档内容的联系不是非常紧密，一般被用作提醒、警告、严重警告等。Markdown 标记语言的 Python 实现通过 `扩展`_ 的方式同样也支持 `Admonition` ，不过具体语法不同。reStructuredText 的支持是通过 `Directives（指令）` 实现的，分为 `Specific Admonitions（特定告诫）` 和 `Generic Admonition（通用告诫）` 两种：

.. _`扩展`: https://pythonhosted.org/Markdown/extensions/index.html

Specific Admonition
-------------------

仅仅是关键词不同而已，可供选择的有 9 种： `attention` ， `caution` ， `danger` ， `error` ， `hint` ， `important` ， `note` ， `tip` ， `warning` 。

.. code:: rst

   .. hint::
      还记得 `Directives（指令）` 的一般格式？ ::

          +-------+-------------------------------+
          | ".. " | directive type "::" directive |
          +-------+ block                         |
                  |                               |
                  +-------------------------------+

渲染结果：

.. hint::
   还记得 `Directives（指令）` 的一般格式？ ::

       +-------+-------------------------------+
       | ".. " | directive type "::" directive |
       +-------+ block                         |
               |                               |
               +-------------------------------+

Generic Admonition
------------------

`Generic Admonition` 的关键词为 `admonition` ，与 `Specific Admonition` 相比，可以有自定义的标题：

.. code:: rst

   .. admonition:: 喔，顺便提醒一下：

      你应该使用 CSS 自定义颜色，以区分告诫的严重程度。

渲染结果：

.. admonition:: 喔，顺便提醒一下：

   你应该使用 CSS 自定义颜色，以区分告诫的严重程度。

CSV Table
=========

上一篇文章曾经提到，除了 `Grid Tables` 和 `Simple Tables` 外，还有两种以 `Directives（指令）` 方式存在的创建表格的方式： `list-table` 和 `csv-table` 。对于大多数人来说，如果不借助 Vim/Emacs 等神级编辑器，创建 `Grid Tables` 异常地困难，我们需要一种既有较好可读性又方便纯手工书写的表格创建方式。对笔者来说，这种方式就是 `csv-table` 指令。

.. code:: rst

   .. csv-table:: 学习成绩统计
      :header: "姓名", "学号", "得分", "描述"
      :widths: 15, 10, 10, 30

      "张三", 1234, 60, "On a stick!"
      "李四", 1235, 75, "If we took the bones out, it wouldn't be
      crunchy, now would it?"
      "王武", 1245, 90, "On a stick!"

渲染结果：

.. csv-table:: 学习成绩统计
   :header: "姓名", "学号", "得分", "描述"
   :widths: 15, 10, 10, 30

   "张三", 1234, 60, "On a stick!"
   "李四", 1235, 75, "If we took the bones out, it wouldn't be
   crunchy, now would it?"
   "王武", 1245, 90, "On a stick!"

除了 `header` 、 `widths` 外， `csv-table` 还提供了其它选项以控制其渲染方式。比如使用 `align` 控制其对齐方式， `delim` 指定其数据分割字符， `file` 和 `url` 可以从本地甚至远程 csv 文件加载数据等。

Substitution Definitions
========================

`Substitution Definitions（替换定义）` 允许将某些元素“替换”到段落行内，使得较复杂的结构脱离文档主体，保持文档清晰可读的前提下不丧失功能强大性。最常用的是“文本替换”：

.. code:: rst

   你竟然没有听说过 |rst| ？

   .. |rst| replace:: reStructuredText 结构化文本标记语言

渲染结果：

你竟然没有听说过 |rst| ？

.. |rst| replace:: reStructuredText 结构化文本标记语言

`Substitution Definitions` 还可以与 `image` 指令结合实现“行内图片”功能：

.. code:: rst

   点击 |nikola| 图标进入下一步。

   .. |nikola| image:: /images/nikola.png
      :align: middle
      :width: 118px
      :height: 50px
      :target: https://getnikola.com/

渲染结果：

点击 |nikola| 图标进入下一步。

.. |nikola| image:: /images/nikola.png
   :align: middle
   :width: 118px
   :height: 50px
   :target: https://getnikola.com/

Date
====

`Date（日期）` 指令用于产生当前日期/时间，需与 `Substitution Definitions` 配合使用。

.. code:: rst

   .. |date| date::
   .. |time| date:: %H:%M
   .. |localt| date:: %c %z

   当地时间是 |localt| 。

   本文档最后重建于 |date| |time| 。

渲染结果：

.. |date| date::
.. |time| date:: %H:%M
.. |localt| date:: %c %z

当地时间是 |localt| 。

本文档最后重建于 |date| |time| 。

`Date` 指令的时间格式与 Python 的 ``time.strftime`` 函数参数一致，如果需要更个性化的格式，可以查阅该函数。

Include
=======

`Include` 指令用来引入外部文档片段。默认是包含整个文件，但是你也可以用 `start-line` 和 `end-line` 指定仅包含部分区域。默认是以解析后的文档载入，但是你也可以用 `literal` 或 `code` 让其原样载入或以代码片段载入。 `Include` 指令与 LaTeX 差不多，支持将超长文档按章节拆分为小文件。但是相对 LaTeX 其超强之处在于：可以载入小文件的部分行。比如我们来载入该系列教程 `第一篇文章`_ 的 `宗旨` 部分：

.. _`第一篇文章`: ../cong-markdown-dao-restructuredtext/

.. code:: rst

   .. include:: posts/cong-markdown-dao-restructuredtext.rst
      :start-line: 26
      :end-line: 32

渲染结果：

.. include:: posts/cong-markdown-dao-restructuredtext.rst
   :start-line: 26
   :end-line: 32

Comments
========

reStructuredText 的 `Comments（注释）` 语法非常简单：

.. code:: rst

   .. 这是注释，不会在文档中出现。

有没有发现注释语法与之前介绍过的链接、指令等等非常像？为了避免与这些语法混淆，使用手册推荐想要注释以下元素：替换定义、指令、脚注、引文、超链接等的时候，让其单独成行。就像下面这样：

.. code:: rst

   ..
      _link: https://www.invalid.org/

注意本来应存在于超链接前面的两个点号被“合并”到上一行。 `Comments` 还被静态博客程序 Nikola_ 用来生成文章标签、创建日期等，对比之下 Markdown 则引入了额外的语法 `YAML front matter`_ 来做这件事件。

.. _Nikola: https://getnikola.com/
.. _`YAML front matter`: https://jekyllrb.com/docs/frontmatter/

结语
====

鉴于个人水平有限和使用需求不同，还有部分 reStructuredText 语法和指令未在本文中列出，不过对于写静态博客而言已经足够。如果你对文章有疑问或者有别的方面需求，欢迎在评论区指出。接下来的文章将会分别介绍一下 Markdown 和 reStructuredText 的自定义 `class` 功能，对于一些有附加样式需求的场景比较有用。敬请期待～
