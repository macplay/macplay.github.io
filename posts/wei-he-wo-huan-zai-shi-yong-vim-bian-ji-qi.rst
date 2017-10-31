.. title: 【译】为何我还在使用 Vim 编辑器？
.. slug: wei-he-wo-huan-zai-shi-yong-vim-bian-ji-qi
.. date: 2017-10-31 20:45:28 UTC+08:00
.. tags: vim, benchmark, translation
.. category:
.. link: https://medium.com/@caspervonb/why-i-still-use-vim-67afd76b4db6
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage: /images/vim_skin.jpeg

    哦不，并不是因为我不知道怎么退出它。 [#]_

.. figure:: /images/vim_skin.jpeg
   :align: center

.. TEASER_END

我经常被问到一个问题：为何使用 Vim 作为首选编辑器？关于这一点，并没有什么特别的原因，事实是很多年前我全身心转移到 Linux 平台时我才得知它的存在。我最终喜欢上它，是因为我能在我的四核电脑上编辑一些小的代码文件，而不必等待到时间尽头以便文件最终打开。

诚然，Vim 并不是一个糟糕的编辑器，它高度可扩展，它简单易分发，它几乎无处不在。当你通过 ssh 协议连接到某些古怪费解的服务器时，只需输入 vim 或者 vi，就可以愉快地编辑文本了。

但这并不足以说明 Vim 是个多么好的编辑器，只是个人的主观品味罢了。我最终喜欢上它主要是因为，它是一个可扩展的编辑器，一个不会独吞系统所有资源，最终导致电脑死机的编辑器。而使用 Atom 或者 Code 时，我经常会遇到仅仅输入一个字符接下来几分钟内无响应的情况。

你觉得作为一个编辑器，打开以下 C 代码文件需要消耗多少内存？

.. code::

   #include <stdio.h>
   int main() {
     printf("Hello, world!\n");
   }

内存占用
========

答案……有些令人抓狂。

.. figure:: /images/mem_for_small_file.png
   :align: center

   打开一个约 60 B 的 C 代码文件的内存占用（KB）

Code 需要整整 349 MB 内存以打开一个 60 B 的文件，Atom 需要 256 MB。Vim 则“仅仅”需要 5 MB，这仍然有点高，但已经足以代表编辑器们的平均水准了。

我同时还把 Nano 包含进来，以与 Vim 进行纯文本模式编辑器的比较。测试出 Nano 占用的内存不到 1 MB。

那么大文件呢？在 Vim 里打开一个 6 MB 的 XML 文件，消耗大约 12 MB 的内存。Nano 与 Vim 大约在同一水准。Code 需要 392 MB，Atom 则整整需要 845 MB！

.. figure:: /images/mem_for_medium_file.png
   :align: center

   打开一个约 6 MB 的 XML 文件的内存占用（KB）

启动时间
========

打开同一个 XML 文件，并把光标移到文件末尾呢？测试结果与之前差不多。Atom 和 Code 花费了将近 20 秒钟，Vim 大约 4 秒钟，Sublime 则出奇的快——仅仅用了 1 秒钟。

.. figure:: /images/eof_for_medium_file.png
   :align: center

   打开一个约 6 MB 的 XML 文件所花费的时间（秒）

针对同一份 XML 文件做一次 100000 处的单词搜索替换，则得出了一些有点令人惊奇的结果。Nano 和 Atom 令人失望，平均花费了将近 10 分钟的时间才完成。Atom 崩溃了好几次，最终也没给出结果。Code 则大约是 80 秒钟。Sublime 在 6 秒钟内完成。而 Vim 则仅花费了 4 秒钟。

.. figure:: /images/replace_for_medium_file.png
   :align: center

   做一次 100000 处的单词搜索替换所花费的时间（秒）

结论
====

学习 Vim 吧。这个网站 http://vimcasts.org 值得你去看看，它上面有一些 Drew Neil 制作的 Vim 练习、建议以及技巧等等。Drew Neil 同时还写了 `这本非常好的书 <http://amzn.to/2vnBcJX>`_ 。

.. figure:: /images/practical_vim.jpeg
   :align: center

   Practical Vim by Drew Neil

即便不使用 Vim，那 Emacs 也是一个不错的选择。或者，额，只要不是那些伪装成文本编辑器的 web 浏览器就好。

让一个编辑器消耗掉电脑上所有可用的计算资源和内存，这真是太荒谬可笑了。更不用说，该电脑可是一台“现代的”昂贵的笔记本。而这一切本可以不必发生。

以上基准测试使用的文件从 `这个仓库 <https://github.com/jhallen/joes-sandbox/tree/master/editor-perf>`_ 取得，测试结果取该仓库数据和个人测试的平均值。

.. [#] 一个流传较广的段子：我使用 Vim 已经两年多了，原因是我不知道怎么退出它。——译者注
