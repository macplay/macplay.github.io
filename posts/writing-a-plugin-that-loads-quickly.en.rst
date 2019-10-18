.. title: Writing a plugin that loads quickly
.. slug: writing-a-plugin-that-loads-quickly
.. date: 2019-10-18 14:11:04 UTC+08:00
.. tags: vim, plugin
.. category:  vim
.. link:
.. description:
.. type: text
.. nocomments:
.. previewimage: /images/lazy_loading.jpg

.. figure:: /images/lazy_loading.thumbnail.jpg
   :alt: lazy loading
   :align: center
   :target: /images/lazy_loading.jpg

A plugin may grow and become quite long. The startup delay may become noticeable, while you hardly ever use the plugin. Then it's time for a quickload plugin.

.. TEASER_END

The basic idea is that the plugin is loaded twice. The first time user commands and mappings are defined that offer the functionality. The second time the functions that implement the functionality are defined.

It may sound surprising that quickload means loading a script twice. What we mean is that it loads quickly the first time, postponing the bulk of the script to the second time, which only happens when you actually use it. When you always use the functionality it actually gets slower!

Note that since Vim 7 there is an alternative: use the `autoload <#>`_ functionality `41.15 <#>`_ .

The following example shows how it's done:

.. code:: vim

   " Vim global plugin for demonstrating quick loading
   " Last Change:  2005 Feb 25
   " Maintainer:   Bram Moolenaar <Bram@vim.org>
   " License:  This file is placed in the public domain.

   if !exists("s:did_load")
       command -nargs=* BNRead  call BufNetRead(<f-args>)
       map <F19> :call BufNetWrite('something')<CR>

       let s:did_load = 1
       exe 'au FuncUndefined BufNet* source ' . expand('<sfile>')
       finish
   endif

   function BufNetRead(...)
       echo 'BufNetRead(' . string(a:000) . ')'
       " read functionality here
   endfunction

   function BufNetWrite(...)
       echo 'BufNetWrite(' . string(a:000) . ')'
       " write functionality here
   endfunction

When the script is first loaded "s:did_load" is not set. The commands between the "if" and "endif" will be executed. This ends in a `:finish <#>`_ command, thus the rest of the script is not executed.

The second time the script is loaded "s:did_load" exists and the commands after the "endif" are executed. This defines the (possible long) BufNetRead() and BufNetWrite() functions.

If you drop this script in your plugin directory Vim will execute it on startup. This is the sequence of events that happens:

1. The "BNRead" command is defined and the <F19> key is mapped when the script is sourced at startup. A `FuncUndefined <#>`_ autocommand is defined. The ":finish" command causes the script to terminate early.

2. The user types the BNRead command or presses the <F19> key. The BufNetRead() or BufNetWrite() function will be called.

3. Vim can't find the function and triggers the `FuncUndefined <#>`_ autocommand event. Since the pattern "BufNet*" matches the invoked function, the command "source fname" will be executed. "fname" will be equal to the name of the script, no matter where it is located, because it comes from expanding "<sfile>" (see `expand() <#>`_).

4. The script is sourced again, the "s:did_load" variable exists and the functions are defined.

Notice that the functions that are loaded afterwards match the pattern in the `FuncUndefined <#>`_ autocommand. You must make sure that no other plugin defines functions that match this pattern.

`help usr_41.txt`
