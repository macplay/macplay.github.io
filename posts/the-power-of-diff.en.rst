.. title: The power of diff
.. slug: the-power-of-diff
.. date: 2019-11-14 22:28:48 UTC+08:00
.. updated: 2019-11-15 08:31:50 UTC+08:00
.. tags: vim, diff, asciinema
.. category: vim
.. link: https://vimways.org/2018/the-power-of-diff/
.. description:
.. type: text
.. nocomments:
.. previewimage:

Lots of people use vimdiff to understand and handle diffs in console mode. While there exist more specialized tools for comparing files, vimdiff has always worked well enough for me.

The inefficiency of the external diff
======================================

However, Vim’s diff mode was seriously lacking. This was basically because it needed to write down temporary files, shell out and run a manual diff command and parse the result back and as one can imagine, this could be slow and was seriously inefficient.

Additionally, this required to have a diff binary available that was able to create `ed like style diff <https://en.wikipedia.org/wiki/Diff#Edit_script>`_, so one could not even fall-back to using git-diff (which is considered to have one of the best tested diff libraries and allows to select different algorithms) for creating those diffs. This lead to the creation of vimscript `plugins <https://github.com/chrisbra/vim-diff-enhanced>`_, that would internally translate a unified diff back into an ed-like diff. Of course this would add an extra performance penalty.

.. TEASER_END

In Windows land, this was also a pain, since Vim had to be distributed with an extra diff binary, since Windows does not come with it out of the box and one would notice the expansive diff call by an ugly command line window flashing by whenever the diff needed to be updated.

Also, since the whole generation of diffs was so ugly, Vim would not always refresh the diff on each and every modification to not slow down too much, causing inaccurate diffs every once in a while.

And finally, before shelling out for the external diff command, Vim would check *every time*  that a diff is actually available by running a hard coded diff against “line1” and “line2” buffer.

Bundling an internal diff library with Vim
===========================================

This problem was well known and can still be found in the well known ``todo.txt`` file (``:h todo.txt``, search for diff). One problem why it wasn’t done earlier, was that there did not exist a good documented and simple to use C library that could be used by Vim.

So I started working on how to improve this `situation <https://github.com/vim/vim/pull/2732>`_ and decided to go with the xdiff library which the git developers finally settled to use. They basically had the same problem when the git vcs system was developed by Linus Torvalds. Back in around 2006 they decided to ship git with the `libxdiff <http://www.xmailserver.org/xdiff-lib.html>`_  library, which over time got heavily modified to fit better the needs of git.

The advantage of using the same library for Vim is that, for one, the library has been tested and proven to be working well over the last 12 years. In addition, is has been tweaked and several new diff algorithms have been added, like the `patience diff algorithm <https://bramcohen.livejournal.com/73318.html>`_, `histogram diff algorithm <https://stackoverflow.com/a/32367597/789222>`_ and the `indent-heuristics <https://hackernoon.com/whats-new-in-git-2-11-64860aea6c4f#892c>`_.

So with `Patch 8.1.360 <https://github.com/vim/vim/commit/e828b7621cf9065a3582be0c4dd1e0e846e335bf>`_ the xdiff code from git has been finally merged into Vim and allows for a much smoother and more efficient diff experience in Vim. In addition, the internal diff algorithm has been made the default, but one can still switch to the old external algorithm, using:

.. code:: vim

    :set diffopt-=internal

Also, Vim can now read and understand the `unified diff format <https://en.wikipedia.org/wiki/Diff#Unified_format>`_ (which seems to be the standard format nowadays), so even when the bundled diff library does not work well enough, one does not need to translate the output back into a ed like diff format anymore.

Some examples
==============

By default, the diff library uses the myers algorithm (also known as `longest common subsequence problem <https://en.wikipedia.org/wiki/Longest_common_subsequence_problem>`_). However, in certain circumstances, one might want to use a different algorithm. One famous example is for the patience algorithm.

Patience algorithm
-------------------

.. container:: ui stackable grid

    .. container:: eight wide column

        Say you have the following file1:

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

        In addition you have the following changed file2 (e.g. from a later revision):

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

The default diff, running ``$ vimdiff file1 file2`` would then look like this:

.. figure:: /images/default_diff.png
    :alt: default diff
    :align: center

However, now you can simply do ``:set diffopt+=algorithm:patience`` and the diff will change to the following:

.. figure:: /images/histogram_diff.png
    :alt: histogram diff
    :align: center

Pretty nice, isn’t it?

Here is an asciicast:

.. raw:: html

   <asciinema-player src="/asciicast/histogram_diff.cast" poster="npt:00:19"></asciinema-player>

Indent heuristics
------------------

Here is an example where the indent heuristics might come handy.

.. container:: ui stackable grid

    .. container:: eight wide column

        Say you have the following file:

        .. code:: ruby

            def finalize(values)

              values.each do |v|
                v.finalize
              end

    .. container:: eight wide column

        And later the file has been changed to the following:

        .. code:: ruby

            def finalize(values)

              values.each do |v|
                v.prepare
              end

              values.each do |v|
                v.finalize
              end

The default diff, running ``$ vimdiff file1.rb file2.rb`` would then look like this:

.. figure:: /images/ruby_default.png
    :alt: ruby default
    :align: center

Now, type ``:set diffopt+=indent-heuristic`` and see how the diff changes to the following:

.. figure:: /images/ruby_indent_heuristics.png
    :alt: ruby indent heuristics
    :align: center

Now one can clearly see what part has been added.

That is pretty neat.

This is also available as an asciicast:

.. raw:: html

   <asciinema-player src="/asciicast/indent_heuristic.cast" poster="npt:00:19"></asciinema-player>

What is next?
==============

Having included the xdiff library this does not mean improving the diff mode stops. There have been additional patches that fixed small bugs as well as improved the diff mode further. For example the ``DiffUpdate`` autocommand has been included in `Patch 8.1.397 <https://github.com/vim/vim/releases/tag/v8.1.0397>`_ which allows to run commands once the diff mode has been updated.

In addition, there are already requests to provide a VimScript API for creating diffs or update the diff more often. It should also be possible to create better inline diffs.

That hasn’t been done yet, but I am sure some of those improvements will be developed in the future.
