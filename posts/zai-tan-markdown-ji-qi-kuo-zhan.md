<!--
.. title: 再谈 Markdown 及其扩展
.. slug: zai-tan-markdown-ji-qi-kuo-zhan
.. date: 2017-10-27 22:36:07 UTC+08:00
.. tags: markdown, python, mermaid
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:
-->

尽管笔者专门写了一个文章系列 [《从 Markdown 到 reStructuredText》][use_rst]，推荐在日常文档写作中更多地使用 reStructuredText。不过平心而论，Markdown 标记语言其实还是不错的，再加上一堆漂亮好用的客户端，使其作为博客写作语言相当合适。静态博客 Nikola 本身也对 Markdown 开箱提供了完整支持，Markdown 与 reStructuredText 一样都是“一等公民”。

[use_rst]:/posts/cong-markdown-dao-restructuredtext/ "/posts/cong-markdown-dao-restructuredtext/"

Nikola 中使用的语法与主流 Markdown 语法，可以说是一模一样的。同时，还以扩展的形式 [^1] 额外提供了一些：

<!-- TEASER_END -->

Extension                            | "Name"
------------------------------------ | ---------------
[Extra]                              | `markdown.extensions.extra`
&nbsp; &nbsp; [Abbreviations][]      | `markdown.extensions.abbr`
&nbsp; &nbsp; [Attribute Lists][]    | `markdown.extensions.attr_list`
&nbsp; &nbsp; [Definition Lists][]   | `markdown.extensions.def_list`
&nbsp; &nbsp; [Fenced Code Blocks][] | `markdown.extensions.fenced_code`
&nbsp; &nbsp; [Footnotes][]          | `markdown.extensions.footnotes`
&nbsp; &nbsp; [Tables][]             | `markdown.extensions.tables`
&nbsp; &nbsp; [Smart Strong][]       | `markdown.extensions.smart_strong`
[Admonition][]                       | `markdown.extensions.admonition`
[CodeHilite][]                       | `markdown.extensions.codehilite`
[HeaderId]                           | `markdown.extensions.headerid`
[Meta-Data]                          | `markdown.extensions.meta`
[New Line to Break]                  | `markdown.extensions.nl2br`
[Sane Lists]                         | `markdown.extensions.sane_lists`
[SmartyPants]                        | `markdown.extensions.smarty`
[Table of Contents]                  | `markdown.extensions.toc`
[WikiLinks]                          | `markdown.extensions.wikilinks`

[Extra]: https://pythonhosted.org/Markdown/extensions/extra.html
[Abbreviations]: https://pythonhosted.org/Markdown/extensions/abbreviations.html
[Attribute Lists]: https://pythonhosted.org/Markdown/extensions/attr_list.html
[Definition Lists]: https://pythonhosted.org/Markdown/extensions/definition_lists.html
[Fenced Code Blocks]: https://pythonhosted.org/Markdown/extensions/fenced_code_blocks.html
[Footnotes]: https://pythonhosted.org/Markdown/extensions/footnotes.html
[Tables]: https://pythonhosted.org/Markdown/extensions/tables.html
[Smart Strong]: https://pythonhosted.org/Markdown/extensions/smart_strong.html
[Admonition]: https://pythonhosted.org/Markdown/extensions/admonition.html
[CodeHilite]: https://pythonhosted.org/Markdown/extensions/code_hilite.html
[HeaderId]: https://pythonhosted.org/Markdown/extensions/header_id.html
[Meta-Data]: https://pythonhosted.org/Markdown/extensions/meta_data.html
[New Line to Break]: https://pythonhosted.org/Markdown/extensions/nl2br.html
[Sane Lists]: https://pythonhosted.org/Markdown/extensions/sane_lists.html
[SmartyPants]: https://pythonhosted.org/Markdown/extensions/smarty.html
[Table of Contents]: https://pythonhosted.org/Markdown/extensions/toc.html
[WikiLinks]: https://pythonhosted.org/Markdown/extensions/wikilinks.html

使用前注意到 `conf.py` 配置文件中开启相应选项，比如本博客的设置为：

```python
MARKDOWN_EXTENSIONS = ['markdown.extensions.toc', 'markdown.extensions.admonition', 'markdown.extensions.fenced_code', 'markdown.extensions.codehilite', 'markdown.extensions.extra']
```

这样设置以后，与市面上绝大多数 Markdown 客户端支持的语法特性就都一样了，譬如：文档目录（TOC）、表格（Tables）、代码区块（Fenced Code Blocks）、脚注（Footnotes）等等。这些完全一样的语法在此就不再赘述，只说一下本博客设置里开启的个人感觉值得关注的两项：告诫（Admonition）和属性列表（Attribute Lists）。

### 告诫（Admonition）### {: #admonition }

`告诫（Admonition）` 语法是从 reStructuredText 标记语言借鉴而来的，包含于标准 Markdown 库中。常用于在文档中给予提示、警告、严重警告等，以引起读者注意。语法如下：

```
!!! warning
    千万不要在家中尝试！
```

渲染结果：

!!! warning
    千万不要在家中尝试！

可以有一个自定义的标题：

```
!!! danger "请勿在森林里生火！"
    可能会引起森林大火，给人身安全和国家财产带来严重威胁。
```

!!! danger "请勿在森林里生火！"
    可能会引起森林大火，给人身安全和国家财产带来严重威胁。

### 属性列表（Attribute Lists）

属性列表（Attribute Lists）的重要性在 [从 Markdown 到 reStructuredText（三）](/posts/cong-markdown-dao-restructuredtextsan/) 一文中已经有所提及：要实现“图片居中”等样式效果，则最好通过 `类选择器` 进行元素定位，以方便套用事先定义好的样式。而 `属性列表` 则可以自定义元素的 class、id 及其它属性等等。其语法如下：

```
{: #someid .someclass somekey='some value' }
```

比如给标题自定义 id 以方便文章别处引用和点击跳转：

```
### 告诫（Admonition） ### {: #admonition }

点击 [此处](#admonition) 跳转到 `告诫（Admonition）` 标题。
```

渲染结果：

点击 [此处](#admonition) 跳转到 `告诫（Admonition）` 标题。

给图片自定义 class 以实现圆形居中：

```
![avatar](/images/avatar.png){: class="ui centered small circular image" }
```

渲染结果：

![avatar](/images/avatar.png){: class="ui centered small circular image" }

原图 `avatar.png` 实际上是一张 800x800 的正方形图片（右键保存查看）。考虑到如此强大的“图片处理”效果，学习属性列表（Attribute Lists）语法是不是显得没那么麻烦了？ :)

自定义属性以利用 [semantic-ui](https://semantic-ui.com) 的 [Popup（气泡提示）](https://semantic-ui.com/modules/popup.html) 功能：

```
鼠标悬停 [此处](#){: data-tooltip="此处应该有气泡提示 O(∩_∩)O~~" } 以查看效果。
```

渲染结果：

鼠标悬停 [此处](#){: data-tooltip="此处应该有气泡提示 O(∩_∩)O~~" } 以查看效果。

在 Markdown 文档中插入 [mermaid](https://mermaidjs.github.io) 图表：

```
sequenceDiagram
loop every day
   Alice->>John: Hello John, how are you?
   John-->>Alice: Great!
end
{: .mermaid }
```

渲染结果：

sequenceDiagram
loop every day
   Alice->>John: Hello John, how are you?
   John-->>Alice: Great!
end
{: .mermaid }

除此之外，`属性列表（Attribute Lists）` 应该还有很多别的玩法，这里就不再继续演示了。

最后，以上介绍的两种语法：告诫（Admonition）和属性列表（Attribute Lists）在绝大多数 Markdown 编辑器中均不受支持。如果你的目标输出格式为静态博客（HTML）等，这点倒是不必担心，只是 Markdown 编辑器缺乏相应的实时预览功能罢了；如果是其它输出格式，则尽量不要使用这两种语法。请根据实际情况自行权衡。

最后的最后，本文以及一些早期文章均使用 Markdown 语法书写，你可以点击文章标题下方的 <i class="github icon"></i> edit 查看源文件。

[^1]:[https://pythonhosted.org/Markdown/extensions/index.html](https://pythonhosted.org/Markdown/extensions/index.html)
