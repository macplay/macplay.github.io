.. title: 给 Nikola 博客添加 mermaid 支持
.. slug: gei-nikola-bo-ke-tian-jia-mermaid-zhi-chi
.. date: 2017-10-27 14:29:49 UTC+08:00
.. tags: mermaid, chart
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

还是给博客集成了 mermaid_ [#]_ 图表功能，尽管目前用的很少……与 mathjax 一样，使用的时候给文章添加 `mermaid` 标签，然后在文章中给描述文本指定 `mermaid` class 即可。就像这样：

.. _mermaid: https://mermaidjs.github.io

.. code:: rst

   .. container:: mermaid

      graph TD
      A[Christmas] -->|Get money| B(Go shopping)
      B --> C{Let me think}
      C -->|One| D[Laptop]
      C -->|Two| E[iPhone]
      C -->|Three| F[Car]

.. [#] mermaid_ 使用 javascript 从纯文本描述产生流程图、序列图、甘特图等图表类型。

.. TEASER_END

渲染结果：

.. container:: ui center aligned mermaid

   graph TD
   A[Christmas] -->|Get money| B(Go shopping)
   B --> C{Let me think}
   C -->|One| D[Laptop]
   C -->|Two| E[iPhone]
   C -->|Three| F[Car]

Markdown 文档写作应该也可以用。整个 mermaid_ 功能的集成只需在博客模板里添加 4 行：

.. code:: html+jinja

   {% if "mermaid" in post.tags %}
       <script type="text/javascript" src="/assets/js/mermaid.min.js"></script>
       <script>mermaid.initialize({startOnLoad: true, theme: 'forest'});</script>
   {% endif %}

使用 if 条件判断是为了仅在必要时才加载 `mermaid` js 文件，因为其即使压缩后也有 825 KB 的体积，可能会拖慢页面打开速度。mathjax 的情况与此类似，使用频率较低，但据说其完整加载要达到 200 MB 以上。

序列图：

.. container:: mermaid

   sequenceDiagram
   participant Alice
   participant Bob
   Alice->John: Hello John, how are you?
   Note right of John: Rational thoughts <br/>prevail...
   John-->Alice: Great!
   John->Bob: How about you?
   Bob-->John: Jolly good!

甘特图：

.. container:: mermaid

   gantt
   dateFormat  YYYY-MM-DD
   title Adding GANTT diagram functionality to mermaid
   section A section
   Completed task            :done,    des1, 2014-01-06,2014-01-08
   Active task               :active,  des2, 2014-01-09, 3d
   Future task               :         des3, after des2, 5d
   Future task2               :         des4, after des3, 5d
   section Critical tasks
   Completed task in the critical line :crit, done, 2014-01-06,24h
   Implement parser and jison          :crit, done, after des1, 2d
   Create tests for parser             :crit, active, 3d
   Future task in critical line        :crit, 5d
   Create tests for renderer           :2d
   Add to mermaid                      :1d

.. warning::

   很奇怪序列图的 loop 语法不工作，但是使用 `raw` 指令却可以显示……有空再看看。

.. raw:: html

   <div class="mermaid">
   sequenceDiagram
   loop every day
       Alice->>John: Hello John, how are you?
       John-->>Alice: Great!
   end
   </div>
