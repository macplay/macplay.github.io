.. title: 【译】强大的文件差异比较
.. slug: the-power-of-diff
.. date: 2019-11-14 22:28:48 UTC+08:00
.. updated: 2019-11-15 08:44:21 UTC+08:00
.. tags: vim, diff, asciinema
.. category: vim
.. link: https://vimways.org/2018/the-power-of-diff/
.. description:
.. type: text
.. nocomments:
.. previewimage:

.. role:: raw-html(raw)
   :format: html

很多人在终端模式下使用 vimdiff 来查看和处理 diff 差异，此外，还有很多专业的文件差异比较 diff 工具。然而，vimdiff 于我来说已然足够。

低效的外部 diff
===============

严格来说，Vim 的 diff 模式也有不足。基本上，它需要写入临时文件，切到 shell 运行 diff 命令，再将结果解析出来。你可以想象，这个过程会很慢，一点也不高效。

除此之外，它还需要一个二进制 diff 程序以创建 `ed 风格的 diff <https://en.wikipedia.org/wiki/Diff#Edit_script>`_ 。所以，想要使用 git-diff 命令（被认为是最好的 diff 库，可选择不同的 diff 算法）也是不行的。这导致某些 vimscript `插件 <https://github.com/chrisbra/vim-diff-enhanced>`_ 的诞生，该插件在内部将 unified diff 转换为 ed diff。当然，这将增加额外的性能损失。

.. TEASER_END

在 Windows 领域，这也是个痛点。出厂时 Windows 并没有自带 diff，因此 Vim 必须随之再额外分发一个 diff 程序。而且，每当更新文件 diff 时，你都能注意到 diff 调用引起的一闪而过的丑陋的命令行窗口。

此外，鉴于整个 diff 生成很丑陋，Vim 并不总是在每次文件修改时都刷新 diff，以免减慢速度，从而偶尔造成不准确的 diff。

最后，\ *每次*\ 执行外部 diff 前，Vim 都要对“line1”和“line2”缓冲区进行硬编码的 diff 来检查是否确实有 diff。

随 Vim 捆绑 diff 库
======================

这个方案不是没有人想过，在知名的 ``todo.txt`` 文件中可以找到（ ``:h todo.txt`` 搜索 diff）。为何之前没有人做？原因是没有一个良好注释的、易于使用的 C 库可供 Vim 使用。

因此，我开始研究如何改善 `这种情况 <https://github.com/vim/vim/pull/2732>`_ ，并最终决定使用与 git 相同的 xdiff 库。当 Linus Torvalds 开发 git 版本控制系统时，他们基本上面临相同的问题。早在 2006 年左右，他们就决定将 git 与 `libxdiff <http://www.xmailserver.org/xdiff-lib.html>`_  库一起提供，随着时间的流逝，该库经过了大量更改，以更好地满足 git 的需求。

对 Vim 来说，使用相同的库，优势之一是该库已经过测试，在过去的 12 年中运行良好。另一原因是，已对其进行过优化调整，并添加了一些新的 diff 算法，例如 :raw-html:`<ruby><a href="https://bramcohen.livejournal.com/73318.html" target="_blank">耐心差异算法</a><rt>patience diff algorithm</rt></ruby>` ，:raw-html:`<ruby><a href="https://stackoverflow.com/a/32367597/789222" target="_blank">直方图差异算法</a><rt>histogram diff algorithm</rt></ruby>` 以及 :raw-html:`<ruby><a href="https://hackernoon.com/whats-new-in-git-2-11-64860aea6c4f#892c" target="_blank">缩进启发式算法</a><rt>indent-heuristics</rt></ruby>` 。

于是，在 `补丁 8.1.360 <https://github.com/vim/vim/commit/e828b7621cf9065a3582be0c4dd1e0e846e335bf>`_ 中，来自 git 的 xdiff 代码最终被合并到 Vim，以提供更加流畅和高效的 diff 体验。另外，该内部 diff 实现已被设为默认值，你仍然可以使用以下方法切换到旧的外部算法：

.. code:: vim

    :set diffopt-=internal

并且，现在 Vim 可以读取和理解 `unified diff 格式 <https://en.wikipedia.org/wiki/Diff#Unified_format>`_ （目前看来已成为标准），因此即便捆绑的 diff 库不能很好地工作，你也不必将输出结果转换回 ed diff 格式了。

一些例子
========

默认情况下，差异库使用 myers 算法（也称为 :raw-html:`<ruby><a href="https://en.wikipedia.org/wiki/Longest_common_subsequence_problem" target="_blank">最长公共子序列问题</a><rt>longest common subsequence problem</rt></ruby>` ）。但是，在某些情况下你可能想要使用另一种算法。一个著名的例子是 :raw-html:`<ruby>耐心算法<rt>patience algorithm</rt></ruby>` 。

Patience 算法
-------------

.. container:: ui stackable grid

    .. container:: eight wide column

        假设你有以下文件 file1:

        .. code:: cpp

            #include <stdio.h>

            // Frobs foo heartily
            int frobnitz(int foo)
            {
                int i;
                for(i = 0; i < 10; i++)
                {
                    printf("Your answer is: ");
                    printf("%d\n", foo);
                }
            }

            int fact(int n)
            {
                if(n > 1)
                {
                    return fact(n-1) * n;
                }
                return 1;
            }

            int main(int argc, char **argv)
            {
                frobnitz(fact(10));
            }

    .. container:: eight wide column

        还有更改过的文件 file2（来自最近一次修订）：

        .. code:: cpp

            #include <stdio.h>

            int fib(int n)
            {
                if(n > 2)
                {
                    return fib(n-1) + fib(n-2);
                }
                return 1;
            }

            // Frobs foo heartily
            int frobnitz(int foo)
            {
                int i;
                for(i = 0; i < 10; i++)
                {
                    printf("%d\n", foo);
                }
            }

            int main(int argc, char **argv)
            {
                frobnitz(fib(10));
            }

*【译者注】：为方便进行文件差异比较，译者对排版进行了一点小优化。*

运行默认 diff 比较 ``$ vimdiff file1 file2`` ，如下所示：

.. figure:: /images/default_diff.png
    :alt: default diff
    :align: center

现在，执行： ``:set diffopt+=algorithm:patience`` ，文件差异将如下：

.. figure:: /images/histogram_diff.png
    :alt: histogram diff
    :align: center

看起来不错，对吧？

这里是 asciicast 录像：

.. raw:: html

   <asciinema-player src="/asciicast/histogram_diff.cast" poster="npt:00:19"></asciinema-player>

Indent heuristics 算法
----------------------

这里是 :raw-html:`<ruby>缩进启发式算法<rt>indent heuristics</rt></ruby>` 的例子。

.. container:: ui stackable grid

    .. container:: eight wide column

        比如有以下文件：

        .. code:: ruby

            def finalize(values)

              values.each do |v|
                v.finalize
              end

    .. container:: eight wide column

        然后更改为以下内容：

        .. code:: ruby

            def finalize(values)

              values.each do |v|
                v.prepare
              end

              values.each do |v|
                v.finalize
              end

运行默认 diff 比较 ``$ vimdiff file1.rb file2.rb`` 如下所示：

.. figure:: /images/ruby_default.png
    :alt: ruby default
    :align: center

然后，键入 ``:set diffopt+=indent-heuristic`` diff 更新为以下内容：

.. figure:: /images/ruby_indent_heuristics.png
    :alt: ruby indent heuristics
    :align: center

现在，你可以一目了然地看到增加的部分。

相当的不错。

此处也有 asciicast 录像：

.. raw:: html

   <asciinema-player src="/asciicast/indent_heuristic.cast" poster="npt:00:19"></asciinema-player>

接下来做什么？
==============

将 xdiff 库嵌入，并不意味着对 diff 模式的改进停止了。已经有其它一些 patch 修复了小 bug，使得 diff 模式变的更好。例如， :raw-html:`<ruby>自动命令<rt>autocommand</rt></ruby>` ``DiffUpdate`` 已包含在 `补丁 8.1.397 <https://github.com/vim/vim/releases/tag/v8.1.0397>`_ 中，该命令允许文件 diff 更新后运行某些命令。

此外，还有一些特性请求：提供创建 diff 的 VimScript API，或者以更高频率进行 diff 更新，或者创建更易懂的行内 diff。

这些请求尚未被满足，但我相信在未来其中某些将会实现。
