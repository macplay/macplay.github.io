.. title: 使用 Latexmk 编译 tex 文件
.. slug: shi-yong-latexmk-bian-yi-tex-wen-jian
.. date: 2018-01-13 19:19:48 UTC+08:00
.. tags: latex, shell
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

尽管老早以前就听说过 Latexmk，但是一直没有用起来。昨天折腾的心思又蠢蠢欲动，于是翻阅了下 Latexmk 手册，最终将其配置为理想状态，于是便有了这篇分享文章。

如果你还不了解 Latexmk 是什么东东，这里简单的介绍一下：LaTeX 要生成最终的 PDF 文档，如果含有交叉引用、BibTeX、术语表等等，通常需要多次编译才行。而使用 Latexmk 则只需运行一次，它会自动帮你做好其它所有事情。通常情况下，你安装的 LaTeX 发行版已经包含了 Latexmk，我们并不需要手动安装它。[#]_

因为之前对 Latexmk 有一定了解，翻阅手册前确定了基本的目标：

1. Latexmk 有文件监测的机制。它应该可以做到只需运行一次，然后每次文件保存动作后，自动重新编译。

2. 它应该最终生成 PDF 文件并预览。之前折腾 LaTeX 的过程中，我发现有时生成的是 xdv 文件。

3. 最好能直接调用 xelatex 引擎。默认调用 pdflatex 太糟糕了，使用万国码是个很常见的需求。

4. 修改 Vim 编辑器中的相应配置。个人使用的是 `vimtex <https://github.com/lervag/vimtex>`_ 插件，记得它是支持 Latexmk 的，但可能需要配置一下。

.. TEASER_END

最终折腾结果：以上提到的目标均已达到，但花费时间比预想的久的多。开始以为肯定要写个复杂的 `.latexmkrc` 配置文件，才能实现以上目标。然而把 `.latexmkrc` 折腾完后才发现，这个配置文件并不复杂，而且使用 Latexmk 的命令行参数就可实现所有目标。当然 `.latexmkrc` 也不算白折腾，Latexmk 允许每个工程文件夹下各含有一个 `.latexmkrc` 配置，那这样的话我们把 tex 源文件分发给别人，他们就可以直接在该文件夹下运行 `latexmk` 命令来生成最终文件。

另外一个坑，个人深度怀疑是 `vimr <https://github.com/qvacua/vimr/>`_ 编辑器的 bug，修改试验 `.latexmkrc` 配置以及 vimtex 插件的过程中，经常发现某项配置有时起作用，有时失效。直到后来，笔者换用终端下的 vim/nvim 编辑器后一切正常，才发现 vimr 的文件监测机制有问题，保存文件后它并不会触发重新编译，这个可能的 bug 仍有待进一步验证。

扯远了。不管折腾过程怎样，一旦我们熟悉 Latexmk 之后，会发现它的使用异常简单。接下来简单介绍下个人认为的 Latexmk 使用最佳实践：

.. contents::

终端中直接敲 latexmk 命令
-------------------------

Latexmk 本身是个 perl 命令行脚本，直接在终端中敲 `latexmk` 命令加上参数，即可实现我们以上提到的目标。

.. code:: bash

   latexmk -pvc -xelatex file.tex

这将会使用 xelatex 引擎编译 `file.tex` 文件，并在 PDF 阅读器中打开预览。 `-pvc` 参数的含义是在 PDF 阅读器中进行预览，并持续更新文件。当然，它也会监测文件保存动作，并自动重新编译。

.. code:: text

   6453 bytes written
   Latexmk: All targets (new.pdf new.xdv) are up-to-date
   Latexmk: I have not found a previewer that is already running.
      So I will start it for 'new.pdf'
   ------------
   For rule 'view', running '&if_source(  )' ...
   ------------
   Running 'start open "new.pdf"'
   ------------

   === Watching for updated files. Use ctrl/C to stop ...

可以看出 Latexmk 监测文件变动，这样我们只管在编辑器中写 tex 文件，想看预览则直接按下保存按钮，然后到 PDF 阅读器即可查看。至于 PDF 阅读器，macOS 平台下个人推荐使用 `Skim <http://skim-app.sourceforge.net>`_ 。它可以监测 PDF 文件变动，并自动重载，记得到设置里开启相关选项即可。

.. figure:: /images/skim_settings.thumbnail.png
   :align: center
   :target: /images/skim_settings.png

   开启监测文件变动和自动重载功能

当然，图中提到的 PDF-TeX Sync 功能也是支持的。在 Skim 阅读器中按下 `cmd` + `shift` 键，并点击 PDF 文档某处，则会自动跳转到编辑器中 tex 源文件的对应处。Skim 预置了一些编辑器的配置，当然你也可以自行定义。

写完 tex 文件之后，检查 PDF 预览无误，即可在终端中按下 `ctrl` + `c` 终止 `latexmk` 命令。PDF 编译过程中可能生成了一些中间文件，我们并不需要这些，仅保留 tex 文件及最终的 PDF 文档就行。终端中敲下 `latexmk -c` 命令即可清除这些讨厌的中间文件。

基本上，这便是使用 Latexmk 写 latex 的基本流程。了解 Latexmk 的功能和操作之后，其它一些使用场景和编辑器配置应该就不在话下了。

在工程文件夹下添加 .latexmkrc 文件
----------------------------------

前面提到 `.latexmkrc` 这种全局配置文件其实是不必要的——命令行参数即可实现全部目标。但查阅 Latexmk 手册的过程中，笔者发现其实 Latexmk 会检测工程文件夹下是否存在 `.latexmkrc` 文件，并读取里面的配置来编译 PDF 文档。这样的话，如果你有分发 tex 源文件的需求，而且非常为他人着想，希望减轻受众的认知负担。则只需在工程文件夹下添加 `.latexmkrc` 文件，然后告诉他们运行下 `latexmk` 命令，就可以得到最终的 PDF 文件啦！

我这里整理了个简单的 `.latexmkrc` 配置模版。如果你有进一步定制的需求，可以去翻下 Latexmk 手册的相应部分。

.. code:: text

   # .latexmkrc starts
   # $pdf_previewer = 'open -a Skim';
   $pdflatex = "xelatex -synctex=1 -interaction=nonstopmode";
   # @generated_exts = (@generated_exts, 'synctex.gz');
   # $cleanup_mode = 1;
   # $preview_continuous_mode = 1;
   # @default_files = ('main.tex');
   # .latexmkrc ends

简单解释下：第 2 行说明使用 Skim 阅读器来预览 PDF；第 3 行指定使用 xelatex 引擎编译文件，并打开同步对照跳转功能；分发给别人的时候，通常只需要编译一次，因此需把持续预览模式关闭（第 6 行）；如果你希望编译完成后清理无关的中间文件，则注意把清理模式打开（第 5 行）。

.. warning::

   关于 tex 工程文件分发以及 `.latexmkrc` 配置，个人并没有严格测试。如果你在实际使用过程中发现问题，欢迎反馈到本文章的评论区。

与 Vim 的 vimtex 插件配合使用
-----------------------------

作为 Vim 编辑器的忠实拥趸，笔者平时的绝大部分文本编辑工作都是在 `vimr <https://github.com/qvacua/vimr/>`_ （neovim GUI 前端）中完成的，写 tex 当然也不例外。而 vimtex 可能是 Vim 编辑器下最好的 tex 插件，开始折腾前我已经知道该插件支持 Latexmk，我们只需要找到 vimtex 插件中的设置。经过一番查找和试验之后，只需要在 `.vimrc` 配置中添加以下行即可。

.. code:: vim

   let g:vimtex_compiler_latexmk = {
       \ 'options' : [
       \   '-xelatex',
       \   '-verbose',
       \   '-file-line-error',
       \   '-synctex=1',
       \   '-interaction=nonstopmode',
       \ ],
       \}

这样我们只需要在 tex 文件 buffer 中运行 `:VimtexCompile` 命令或者按下其默认按键绑定 `<leader>` + `ll` 即可。这将会编译 tex 文件并打开 PDF 预览，并持续监测文件变动。如果文件编译过程中出现错误，则会将错误提示和文件行数显示在 Vim 的 QuickFix 窗口中，在 QuickFix 窗口中按下回车键，即可跳转到文件语法错误处进行快速修复。如果想停止持续编译，则再次运行 `:VimtexCompile` 命令即可。vimtex 插件还有很多其它方面的功能，这里就不再继续介绍了。

我的 `.vimrc` 配置文件可以在这里找到： https://github.com/ashfinal/vimrc-config

简单总结
--------

笔者仍然是一名 LaTeX 初学者，但是有了 Latexmk 和 vimtex 之后，觉得 LaTeX 的书写过程轻松了许多。过段时间，大概会写文章介绍一下个人的 LaTeX 写作实践，敬请期待。如果你也在学习 LaTeX，欢迎分享你的学习体会，与笔者进行交流。:)

.. [#] https://mg.readthedocs.io/latexmk.html
