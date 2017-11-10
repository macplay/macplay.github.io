.. title: 不一样的 Git 客户端——GitUp
.. slug: bu-yi-yang-de-git-ke-hu-duan-gitup
.. date: 2017-11-08 16:54:09 UTC+08:00
.. updated: 2017-11-10 22:08:56 UTC+08:00
.. tags: git, vc, macos
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage: /images/gitup_overview.png

尽管平时基本不使用 Git 客户端（偶尔用用 Tig_ ），不过看到 GitUp_ 的特性介绍，笔者还是产生了浓厚的兴趣。下载下来尝试了一下，感觉与其它 Git 客户端的确有些不一样。官方宣传声称 GitUp_ 就是“你朝思暮想的 Git 客户端”（The Git interface you've been missing）；使用 GitUp_ 以后，再也“不必头痛 Git 版本管理”（without headaches）。那么， GitUp_ 究竟表现如何？接下来，随笔者一起来看看这个不一样的 Git 客户端吧。

.. figure:: /images/gitup_overview.thumbnail.png
   :align: center
   :target: /images/gitup_overview.png

.. _Tig: https://jonas.github.io/tig/

.. _GitUp: http://gitup.co

.. TEASER_END

.. contents:: 文章目录

优点
====

直接操作 Git 数据库
-------------------

而不像其它客户端一样使用 Git 命令行。这恐怕是 GitUp_ **最与众不同的地方** 。

目前绝大多数的 Git 客户端，无论界面美观、功能强大与否，其背后真正的功臣实际上是 Git 命令行。当你点击漂亮界面上的 pull、push 等按钮时，客户端们实际上在后台另起炉灶——在另一个进程里使用 Git 命令行完成指定的操作，然后把执行结果在 GUI 界面上绘制出来。

.. figure:: /images/tower_git.thumbnail.png
   :align: center
   :target: /images/tower_git.png

   Tower 等客户端使用 Git 命令行完成操作

真正起作用的还是 Git 命令行，客户端不过是 Git 命令行的 wrapper 而已！这就使得市面上的 Git 客户端基本不可能脱离 Git 命令行的桎梏，做出什么令人眼前一亮的新功能来。事实情况是：将用户友好度排除在外，Git 客户端能完成的操作，Git 命令行基本都能完成；但是 Git 命令能完成的一些非常规性操作，在 Git 客户端中却不一定得到全部实现。

Git 客户端的现状，其产生原因是显而易见的——Git 基本上覆盖了版本管理的全部命令，那直接使用它，将更多精力放到界面设计、用户交互等方面。这是个再自然不过的决定。

然而， GitUp_ 的出现，让我们看到了另外一种可能。 它竟然能直接读写磁盘上的 Git 数据库（即 `.git` 文件夹）！有没有嗅到那么一点“黑科技”的味道？ :)

事实上， GitUp_ 的其它优点多少都与这一特性有点关系。牢记这一点，我们接着往下看。

实时更新、可交互的仓库图谱（map）
---------------------------------

对 Git 稍微有些了解的人可能都知道，Git 代码仓库实际上很像一棵有诸多枝桠、不断延伸的“树”。我们日常的所有操作，比如提交更改、创建分支、合并分支等等，都是围绕这棵“树”做修修剪剪的工作。而 GitUp_ 则将这棵“树”以可视化、可交互的方式呈现了出来（见本文图一）。无论你对代码仓库做何种更改，大的小的更改，甚至是其它程序做的更改，都可以在仓库图谱（map）中实时呈现出来。毋需刷新，毋需等待。

以往我们是以 commit 为单位进行操作，而现在则可以通过鼠标点击以可视化的方式来“修剪枝桠”。GitUp_ 这种以图谱（map）为中心的操作逻辑，即便是 Git 初学者，也能通过图谱直观地了解到自己的操作对代码“树”产生怎样的影响。将 GitUp_ 用作新手教学，想必是极好的。

但这并不意味着 GitUp_ 不足以满足专业级用户的需要。事实上，GitUp_ 提供的菜单命令要比大多数 Git 客户端还要多。右键单击图谱（map）上的枝桠节点，就可以访问到大多数菜单命令。GitUp_ 甚至还包装了一些命令，使得它们更加方便直观。比如提交代码时写错了 commit message，现在想更改过来。很简单的操作，对不对？然而要做到这一点，恐怕你得 Google 一番：啊，原来需要执行 `git rebase` 命令，再更改对应 commit id 的 `reword` 。而使用 GitUp_ 这点就超乎寻常的简单：只需右键单击对应节点，选择“Edit Message”即可！同理，想要删除一个错误的代码提交，则是右键单击选择“Delete”。

无限制的撤销和重做
------------------

对大多数人来说，Git 操作出错几乎都无一例外地遇到过。有时一个头脑犯浑的操作，足以让你惊出一身冷汗，然后再花费半天的功夫一阵 Google，试图挽回自己所犯的“愚蠢”的错误。

幸运的是，对这些操作失误，GitUp_ 允许你无限制的撤销（undo）和重做（redo）。甚至包括 rebase 和 merge 等操作。而且撤销/重做也是超乎寻常的简单，只需按下 `cmd + z` 或 `cmd + shift + z` 键。就像是你刚刚不小心输错了两个字符一样！

笔者简单地做了一个测试：使用 Git 命令行提交一个更改，然后回到 GitUp_ 客户端中，直接按 `cmd + z` 键。代码仓库正确撤销了刚才的提交！这一操作对其它 Git 客户端提交的更改应该也适用。

仓库快照（snapshots）
---------------------

GitUp_ 默认会对代码仓库的每一次更改都建立快照（snapshots）。非常类似于 macOS 上的时间机器（Time Machine）。这样，你就可以通过右侧侧边栏，一键点击回滚到之前的状态。

.. figure:: /images/gitup_snapshots.thumbnail.png
   :align: center
   :target: /images/gitup_snapshots.png

   时光机器，一键点击回滚

即时搜索整个代码仓库
--------------------

GitUp_ 可以即时搜索整个代码仓库的分支、tags、commit id/message、作者等等，甚至还能搜索文件内容（需到设置界面开启）。点击即可直接跳转到搜索结果。

如果你想搜索查看一些大仓库某次提交都更改了哪些文件内容，自然会理解这一特性有多重要。

.. figure:: /images/gitup_search.thumbnail.png
   :align: center
   :target: /images/gitup_search.png

   即时搜索整个代码仓库

难以置信的 UI 响应速度
----------------------

笔者使用 Tig_ 的一大原因是：Tig_ 占用资源非常少，却拥有极快的响应速度。作为一个不走寻常路的 Git 客户端，GitUp_ 在这一方面表现也是分外抢眼。笔者使用 hombrew formula 仓库做了个不严谨的测试：

.. figure:: /images/homebrew_core.thumbnail.png
   :align: center
   :target: /images/homebrew_core.png

   加载大仓库无压力

GitUp_ 在 1 秒多点的时间内完成了 100,078 条 commits 的读取和图谱（map）渲染，界面滚动丝毫没有卡顿的感觉。想知道该仓库的第一条 commit 是何时创建？ `cmd + ⇣` 拉到最底，点击节点即可看到。提交了哪些文件？按下空格键切到 diff 视图。而且别忘了，可以从这 10w 条 commits 中即时搜索 commit id/message、作者等。对比某些 Git 客户端仅随滚动“按需加载”，即使这样有时界面依然卡顿，GitUp_ 的做法可显得“任性”多了。

Git 自身都不具备的功能
----------------------

得益于 GitUp_ 直接操作 Git 数据库的特性，它可以做更多事情。比如可视化 commit 分割（visual commit splitter）、统一 reflog 浏览（unified reflog browser）等。

目前笔者还没有找到合适的机会，来体验这两项功能。

缺点
====

当然，GitUp_ 并不是完美无缺的。以下列出了它的一些缺点：

有些代码仓库打开会出错
----------------------

笔者发现如果代码仓库没有完整克隆到磁盘的话，使用 GitUp_ 打开会报错。而其它 Git 客户端打开就没有问题。比如大家广泛使用的 homebrew，其 formula 仓库默认只克隆最近几千条 commits，这时使用 GitUp_ 就无法打开。

.. figure:: /images/gitup_error.thumbnail.png
   :align: center
   :target: /images/gitup_error.png

   打开本地默认的 Homebrew Core 仓库会报错

目前尚不清楚这一局限能否被简单地移除。

仅支持 macOS 和 iOS 平台
------------------------

目前 GitUp_ 仅支持 macOS、iOS 平台（用 Objective-C 语言写成）。作为版本管理协作工具，如果能支持跨平台使用，那无疑是再好不过。目前尚不清楚作者是否有移植到其它平台的计划。

不过好处是，GitUp_ 已经在 `GitHub 开源`_ 。这样的话，即使作者不动，将来也可能会有人 fork 并移植到其它平台。

.. _`GitHub 开源`: https://github.com/git-up/GitUp

最后
====

笔者使用 GitUp_ 也是最近几天才开始。囿于自身 Git 知识水平，对该软件一些功能的体验和介绍可能不到位。如果你有新的发现或者使用技巧，欢迎在评论区指出。 :)
