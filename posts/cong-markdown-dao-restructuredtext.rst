.. title: 从 Markdown 到 reStructuredText
.. slug: cong-markdown-dao-restructuredtext
.. date: 2017-10-04 16:20:05 UTC+08:00
.. tags: mathjax, reST, markup
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

如果你正在使用 Markdown 尚嫌其功能不足，本文提供了平滑过渡到 reStructuredText 的语法指导。从来没有接触过任何标记语言的读者，以及正在使用其它标记语言的读者，也可以通过阅读本文了解到 reStructuredText 的基本用法。文章结构基本上借鉴 `Markdown 语法说明`_ ，相对 Markdown 的超集部分仅会简单提及——这些部分将会在其它文章中着重讲解。

.. _`Markdown 语法说明`: http://wowubuntu.com/markdown/

.. TEASER_END

.. contents:: 文档目录

概述
====

宗旨
----

    reStructuredText 是一种易于阅读、所见即所得的纯文本标记语言，常被用于编写行内文档（譬如 Python [#]_ ），快速创建简单网页，或者作为独立文档存在。——David Goodger [#]_

.. [#] Python 官方文档生成器 Sphinx_ 基于 reStructuredText 。
.. [#] reStructuredText 标记语言主要贡献者之一。

.. _Sphinx: http://www.sphinx-doc.org/en/stable/

reStructuredText 的最初目标是定义一种可被 Python 文档和其它格式使用的标记语法，这种语法应该做到既简单易读，同时又功能强大可满足其它专业需要。 reStructuredText 的预期目标是：

- 建立一套通用标准，使得纯文本发挥强大的表达能力

- 如有必要，纯文本可被转换为其它格式的结构化文档

兼容 HTML 语法
--------------

reStructuredText 开箱支持转换为其它多种格式，其被设计为“Output-format-neutral（输出格式中性）”，即：并不会明确“偏袒”于哪种输出格式。

.. figure:: https://github.com/ashfinal/bindata/raw/master/rst_outputs.png
   :align: center

   *rst 转换为其它格式*

理所当然地，reStructuredText 提供了混合书写 HTML 语言的能力：

.. code:: html

   .. raw:: html

       <div class="ui steps">
           <div class="step">撰写 markup 文件</div>
           <div class="active step">添加 meta 信息</div>
           <div class="disabled step">提交 GitHub</div>
       </div>

输出结果为：

.. raw:: html

    <div class="ui steps">
        <div class="step">撰写 markup 文件</div>
        <div class="active step">添加 meta 信息</div>
        <div class="disabled step">提交 GitHub</div>
    </div>

特殊字符转换
------------

和 Markdown 一样，对于特殊字符 reStructuredText 会自动处理。你只需像正常字符那样书写就行。比如 4 < 5，版权所有 ©，Bill & Jobs……

区块元素
========

段落和换行
----------

和 Markdown 一样，reStructuredText 段落是由一个或多个连续的文本行组成。它的前后应该有一个以上的空行。

*如果你有首行缩进、强行断行、段落空行等需求，可以查看 reStructuredText 的 “Line Blocks” 部分。*

标题
----

reStructuredText 中的“标题”被称为“Sections”，一般在文字下方加特殊字符 [#]_ 以示区别：

.. code:: restructuredtext

   Section Title H1
   ================

   Section Title H2
   ----------------

   Section Title H3
   ````````````````

.. [#] 推荐使用的字符：`= - ` : . ' " ~ ^ _ * + #`

特殊字符的重复长度应该大于等于标题（Sections）的长度。需要说明的是： reStructuredText 并不像 Markdown 那样，限定某一字符只表示特定的标题层级（比如 `=` 固定表示 `H1` )。而是解析器将遇到的第一个特殊字符渲染为 `H1` ，第二个其它特殊字符渲染为 `H2` ……以此类推。

.. admonition:: 为何这样设计？

   这样的设计更方便调整标题层级。想象一下：你正在写《三国演义》，写到一半想把前 50 回总括为一章，接下来 30 回总括为第二章……如果你使用 Markdown，到第一回前面直接插入 `## 第一章：枭雄的崛起` 是不行的，因为所有的回数用的都是 `## 第一回：桃源三结义` 这样的二级标题，你还需要将 50 回，哦不，至少 80 回的所有标题都降级为三级标题……要修改 80 处是个烦人但可以接受的任务，而如果你维护的是 Python 文档库这样庞大繁杂的项目，仅仅是看似简单地调整下标题，对大多数人来说也是一场灾难。幸好有先见之明的维护者们选用了 reStructuredText ，这样只需选择一个没被占用的特殊字符配合总括标题就可以——文档的其它部分根本就不必修改。

当然，在 reStructuredText 的日常使用中，仍然建议养成习惯使用固定的特殊符号，方便别人一看到 `=` 就知道这是一级标题。 除了 “Sections”外， reStructuredText 还支持“Title”和“SubTitle”，它们可以被配置为不在文档中出现。其实际作用更类似于“书名”，如《钢铁是怎样炼成的——保尔柯察金自传》。语法如下：

.. code:: restructuredtext

   ==================
    钢铁是怎样炼成的
   ==================

   ----------------
    保尔柯察金自传
   ----------------

区块引用
--------

reStructuredText 的区块引用使用空格或制表符的方式，一般是 4 个空格。

.. code:: restructuredtext

   Amet omnis animi doloribus.
   Consectetur culpa veniam earum provident tempora saepe adipisci!
   Ipsum quidem adipisci ab officia sed blanditiis, eum non. Eos dignissimos odit.

       当然嵌套也是可以的（中间加空行）：
       Consectetur assumenda eveniet nihil nemo recusandae, voluptas id, voluptates voluptatibus, quod harum recusandae cumque labore non?

渲染效果：

    Amet omnis animi doloribus.
    Consectetur culpa veniam earum provident tempora saepe adipisci!
    Ipsum quidem adipisci ab officia sed blanditiis, eum non. Eos dignissimos odit.

        当然嵌套也是可以的（中间加空行）：
        Consectetur assumenda eveniet nihil nemo recusandae, voluptas id, voluptates voluptatibus, quod harum recusandae cumque labore non?

列表
----

reStructuredText 支持有序列表和无序列表，语法与 Markdown 基本一致：

有序列表
````````

.. code:: restructuredtext

   2. Consectetur est iure.
   3. Adipisicing velit ad laborum libero.
      第二行
   4. Sit atque atque aliquid assumenda voluptates.

      试着分段
      Libero provident quia temporibus deleniti quam.

渲染结果：

2. Consectetur est iure.
3. Adipisicing velit ad laborum libero.
   第二行
4. Sit atque atque aliquid assumenda voluptates.

   试着分段
   Libero provident quia temporibus deleniti quam.

*注意到有序列表的起始数可以从非 1 的数字开始。*

无序列表
````````

与 Markdown 没有什么差别：

.. code:: restructuredtext

   - Amet sit magnam!
   - Consectetur cum hic deserunt laudantium.
   - Adipisicing impedit nulla aspernatur nam illo eos.

渲染结果：

- Amet sit magnam!
- Consectetur cum hic deserunt laudantium.
- Adipisicing impedit nulla aspernatur nam illo eos.

代码区块
--------

与 Markdown 的 "Fenced Code Blocks" 非常相似，reStructuredText 将调用 pygments 进行语法高亮：

.. code:: restructuredtext

   .. code:: python

      import sys
      print(sys.version)

渲染结果：

.. code:: python

   import sys
   print(sys.version)

分割线
------

与 Markdown 语法基本一致：

.. code:: restructuredtext

   -----------------

渲染结果：

--------------------------------------------------------------------------------

区段元素
========

链接
----

reStructuredText 的链接语法大体上也可以分为两类： **行内式** 和 **参考式** 。一般推荐做法是：为了增强可读性尽量使用参考式，如果在一篇文档中多次引用该链接，则更是推荐使用参考式。

参考式链接
``````````

常见语法：

.. code:: restructuredtext

   欢迎访问 reStructuredText_ 官方主页。

   .. _reStructuredText: http://docutils.sf.net/

渲染结果：

欢迎访问 reStructuredText_ 官方主页。

.. _reStructuredText: http://docutils.sf.net/

如果是多个词组或者中文链接文本，则使用 ````` 将其括住，就像这样：

.. code:: restructuredtext

   欢迎访问 `reStructuredText 结构化文本`_ 官方主页。

   .. _`reStructuredText 结构化文本`: http://docutils.sf.net/

如果文档中多个链接指向的其实是同一地址，可以简略点只写一次：

.. code:: restructuredtext

   Python_ 是 `我最喜欢的编程语言`_ 。用英语来说，就是 `my favorite programming language`_ 。

   .. _Python:
   .. _`最喜欢的编程语言`:
   .. _`my favorite programming language`: http://www.python.org/

渲染结果：

Python_ 是 `我最喜欢的编程语言`_ 。用英语来说，就是 `my favorite programming language`_ 。

.. _Python:
.. _`我最喜欢的编程语言`:
.. _`my favorite programming language`: http://www.python.org/

行内式链接
``````````

当然在文档中使用行内式链接也是可以的。直接在文档中插入简单链接： http://docutils.sf.net/ 。如果 URL 地址中含有特殊字符甚至是中文，则使用尖括号将其括住：

.. code:: restructuredtext

   <http://docutils.sf.net/>

也可以自定义链接文本：

.. code:: restructuredtext

   `Python 编程语言 <http://www.python.org/>`_ 其实也有一些缺陷。

渲染结果：

`Python 编程语言 <http://www.python.org/>`_ 其实也有一些缺陷。

自动标题链接
````````````

reStructuredText 文档的各级标题（Sections）会自动生成链接，就像 GFM 风格的 Markdown 标记语言一样。这在 reStructuredText 语法手册中被称为“隐式链接（Implicit Hyperlink）”。无论名称为何，我们将可以在文档中快速跳转到其它小节（Sections）：

.. code:: restructuredtext

   本小节内容应该与 `行内标记`_ 结合学习。

渲染结果：

本小节内容应该与 `行内标记`_ 结合学习。

.. attention::

   **使用中英文混合书写 reStructuredText 过程中注意添加空格。**

强调
----

与 Markdown 语法基本相同。参看 `行内标记`_ 。

图片
----

reStructuredText 使用指令（Directives)的方式来插入图片。指令（Directives）作为 reStructuredText 语言的一种扩展机制，允许快速添加新的文档结构而无需对底层语法进行更改。reStructuredText 开箱已经内置了一批常用指令，上文中使用的 `raw` 和 `code` 其实就是指令。指令的重要功能之一是可以添加选项以控制解析器对该元素的渲染方式，譬如让图片以两倍高宽居中进行展示：

.. code:: restructuredtext

   .. image:: /images/nikola.png
      :align: center
      :width: 236px
      :height: 100px

渲染结果：

.. image:: /images/nikola.png
   :align: center
   :width: 236px
   :height: 100px

插入图片的另一种方法是使用 `figure` 指令。该指令与 `image` 基本一样，不过可以为图片添加标题和说明文字。两个指令共有的一个选项为 `target` ，可以为图片添加可点击的链接，甚至链接到另一张图片。那么结合 Nikola 博客的特定主题，就可以实现点击缩略图查看原图的效果：

.. code:: restructuredtext

   .. figure:: https://github.com/ashfinal/bindata/raw/master/icarus.thumbnail.jpg
      :align: center
      :target: https://github.com/ashfinal/bindata/raw/master/icarus.jpg

      *飞向太阳*

渲染结果：

.. figure:: https://github.com/ashfinal/bindata/raw/master/icarus.thumbnail.jpg
   :align: center
   :target: https://github.com/ashfinal/bindata/raw/master/icarus.jpg

   *飞向太阳*

其它
====

行内标记
--------

+-----------------------------+-------------------------+-------------------------------------+
| 文本                        | 结果                    | 说明                                |
+=============================+=========================+=====================================+
| ``*强调*``                  | *强调*                  | 一般被渲染为斜体                    |
+-----------------------------+-------------------------+-------------------------------------+
| ``**着重强调**``            | **着重强调**            | 一般被渲染为加粗                    |
+-----------------------------+-------------------------+-------------------------------------+
| ```解释文本```              | `解释文本`              | 一般用于专用名词、\                 |
|                             |                         | 文本引用、说明性文字等              |
+-----------------------------+-------------------------+-------------------------------------+
| ````原样文本````            | ``原样文本``            | 与上面的区别在于：不会被转义。\     |
|                             |                         | 可用于行内代码书写。                |
+-----------------------------+-------------------------+-------------------------------------+
| ``http://docutils.sf.net/`` | http://docutils.sf.net/ | 最简单的链接。如果怕链接\           |
|                             |                         | 文本断裂，用尖括号包住。            |
+-----------------------------+-------------------------+-------------------------------------+
| ``reference_``              | reference_              | 简单的一个单词的链接。\             |
|                             |                         | 与 Markdown 的参考型链接非常\       |
|                             |                         | 相似。具体参看下文 `链接`_ 。       |
+-----------------------------+-------------------------+-------------------------------------+
| ```词组链接`_``             | `词组链接`_             | 与上面基本相似。如果是词组或\       |
|                             |                         | 中文，则把链接文本用 ````` 括起来。 |
+-----------------------------+-------------------------+-------------------------------------+
| ``|TMD|``                   | |TMD|                   | 替换语法。\                         |
|                             |                         | 可与文本、图片、链接等配合使用。    |
+-----------------------------+-------------------------+-------------------------------------+
| ``脚注 [#]_``               | 脚注 [#]_               | 参看下文 `脚注（Footnotes）`_ 。    |
+-----------------------------+-------------------------+-------------------------------------+
| ``引文 [CIT2002]_``         | 引文 [CIT2002]_         | 与上面的脚注基本相同。\             |
|                             |                         | 不过可以自定义引文文本。            |
+-----------------------------+-------------------------+-------------------------------------+

.. _reference: http://docutils.sf.net/

.. _`词组链接`: http://docutils.sf.net/

.. [#] 这是一个脚注，但是不一定要放到文章结尾。

.. [CIT2002] 这是一个引文，当然你也可以添加 `链接`_ 。

.. |TMD| replace:: 战区导弹防御系统

交叉参考
--------

脚注（Footnotes）
`````````````````

.. code:: restructuredtext

   就像这样创建一个脚注 [#]_ 。

   .. [#] 这里是 **脚注** 的 *文本* 。

渲染结果：

就像这样创建一个脚注 [#]_ 。

脚注内容在文档的任何位置定义都可以，脚注也不一定必须得放到文档末尾。使用 ``#`` 则是让脚注自动编号，使用自动编号时注意保持脚注和脚注内容的相对位置。当然你也可以直接指定使用特定数字，就像这样： ``[1]_`` 。

引文（Citations)
````````````````

如果给脚注指定标签，则被解析为引文（Citations）：

.. code:: restructuredtext

   请参阅我们去年发表在《自然》期刊上的文章 [NT202329]_

   .. [NT202329] `用流体力学来研究猫究竟是固态的还是液态的 <https://www.invalid.org/somelink/>`_

渲染结果：

请参阅我们去年发表在《自然》期刊上的文章 [NT202329]_

Tables of Contents(TOC)
-----------------------

文档目录生成则使用了 reStructuredText 的指令（Directives） `contents` 。

.. code:: restructuredtext

   .. contents:: 文档目录

渲染结果具体查看文档开头。 ``::`` 后面的 `文档目录` 被用来指定目录块的标题，为空的话则默认为 `Contents` 。另外该指令可使用 `depth` 选项指定目录生成层级， `local` 指定仅生成本节及下层的目录列表。

表格（table）
-------------

.. code:: restructuredtext

   +------------------------+------------+----------+----------+
   | Header row, column 1   | Header 2   | Header 3 | Header 4 |
   | (header rows optional) |            |          |          |
   +========================+============+==========+==========+
   | body row 1, column 1   | column 2   | column 3 | column 4 |
   +------------------------+------------+----------+----------+
   | body row 2             | Cells may span columns.          |
   +------------------------+------------+---------------------+
   | body row 3             | Cells may  | - Table cells       |
   +------------------------+ span rows. | - contain           |
   | body row 4             |            | - body elements.    |
   +------------------------+------------+---------------------+

渲染结果：

+------------------------+------------+----------+----------+
| Header row, column 1   | Header 2   | Header 3 | Header 4 |
| (header rows optional) |            |          |          |
+========================+============+==========+==========+
| body row 1, column 1   | column 2   | column 3 | column 4 |
+------------------------+------------+----------+----------+
| body row 2             | Cells may span columns.          |
+------------------------+------------+---------------------+
| body row 3             | Cells may  | - Table cells       |
+------------------------+ span rows. | - contain           |
| body row 4             |            | - body elements.    |
+------------------------+------------+---------------------+

这种表格语法被称为 `Grid Tables` 。如上所见， `Grid Tables` 支持跨行跨列。如果你使用的编辑器创建该表格有困难，reStructuredText 还提供 `Simple Tables` 表格语法：

.. code:: restructuredtext

   =====  =====  ======
      Inputs     Output
   ------------  ------
     A      B    A or B
   =====  =====  ======
   False  False  False
   True   True   True
   =====  =====  ======

渲染结果：

=====  =====  ======
   Inputs     Output
------------  ------
  A      B    A or B
=====  =====  ======
False  False  False
True   True   True
=====  =====  ======

此外，reStructuredText 还有两种表格指令（Directives）： `list-table` 和 `csv-table` 。分别以无序列表和 csv 数据（一般逗号分割）的方式创建表格，这里就不继续展开了。总体上来说，4 种表格的“纯手工”书写难度逐次降低。

数学公式
--------

reStructuredText 的数学公式书写通过指令（Directives）： `math` 完成。如需网页上显示的话，则和其它所有标记语言一样需要引入 MathJax_ 或 KaTex_ js 库。

.. _MathJax: https://www.mathjax.org/
.. _KaTex: https://github.com/Khan/KaTeX

.. code:: restructuredtext

   .. math::

      \alpha _t(i) = P(O_1, O_2, \ldots  O_t, q_t = S_i \lambda )

.. math::

   \alpha _t(i) = P(O_1, O_2, \ldots  O_t, q_t = S_i \lambda )

**行内数学公式** 则是通过 `math role` 实现的：

.. code:: restructuredtext

   该圆的面积为 :math:`A_\text{c} = (\pi/4) d^2`.

渲染结果：

该圆的面积为 :math:`A_\text{c} = (\pi/4) d^2`.

reStructuredText 编辑器
=======================

很遗憾的是，相对于 Markdown “预览器”百花齐放争奇斗艳的盛况， reStructuredText 上可用的“预览器”则很寥寥。不过根据本人之前使用 Markdown 的经历，一旦度过了学习上手阶段，对“预览器”的需求就会大幅下降——书写时有语法高亮就基本可以应付。以下为部分工具推荐：

- `Online reStructuredText editor`_

  网页版的 reST 编辑器。

- rstpad_

  跨平台的 reST 本地客户端。

- GitHub_

  GitHub 支持 Markdown、reST、org 等在线编辑和预览。

- Nikola_

  支持 reST 文档的静态博客程序。

- Vim_

  编辑器之神

- Emacs_

  神之编辑器

- `Sublime Text`_

  性感的编辑器

.. _`Online reStructuredText editor`: http://rst.ninjs.org/
.. _rstpad: https://github.com/ShiraNai7/rstpad
.. _GitHub: https://github.com/
.. _Nikola: https://getnikola.com/
.. _Vim: https://github.com/vim/vim
.. _Emacs: http://www.gnu.org/software/emacs/
.. _`Sublime Text`: https://www.sublimetext.com/

总结
====

通过本文的介绍，有没有发现 reST 的语法其实与 Markdown 很相似，而且也很简单呢？ :) 文章基本上覆盖了 Markdown （及其扩展）的主要功能，可以看出 reST 满足日常使用是没有问题的，而读者们也清楚了 reST 的一些基本用法。

前面已经提过 reST 某种程度上可以看作是 Markdown 的超集，接下来的文章将会继续讲 reST 的一些高级扩展语法，敬请期待～

--------------------------------------------------------------------------------

.. [#] 这里是 **脚注** 的 *文本* 。

.. [NT202329] `用流体力学来研究猫究竟是固态的还是液态的 <https://www.invalid.org/somelink/>`_

   如果想查看该文章，请先确定你已经进化为气态人 :)
