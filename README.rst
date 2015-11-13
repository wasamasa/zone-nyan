zone-nyan
=========

.. image:: https://raw.github.com/wasamasa/zone-nyan/master/img/screencast.gif

About
-----

A zone program displaying the infamous nyan cat animation.  Best
viewed in a graphical Emacs instance with SVG support.

Installation
------------

Install via ``package.el`` from `Marmalade
<https://marmalade-repo.org/>`_ or `MELPA <https://melpa.org/>`_ or
`MELPA Stable <https://stable.melpa.org>`_.

Usage
-----

Run ``M-x zone-nyan-preview`` for a preview (yes, zone doesn't have a
preview command for checking out its programs).  If you're sure you
want zone to only use this zone program, add ``(setq zone-programs
[zone-nyan])`` to your init file and use either ``M-x zone`` for
instant gratification or ``M-x zone-when-idle`` after loading
``zone.el`` for a screensaver.

Graphical instances use SVG rendering and textual instances ANSI color
escapes on a 256 color palette.  You can alternatively make the GUI
render text by customizing ``zone-nyan-gui-type`` and the terminal
render ASCII art by customizing ``zone-nyan-term-type``.

There's also sound support.  Customize ``zone-nyan-bg-music-program``
to the CLI music player of your choice and ``zone-nyan-bg-music-args``
to a list of additional arguments.  Assuming you're using ``mplayer``
and have downloaded `the original music
<http://www.nyan.cat/music/original.mp3>`_, insert the following in
your init file:

.. code:: elisp

    (setq zone-nyan-bg-music-program "mplayer"
          zone-nyan-bg-music-args
          `("-loop" "0" ,(expand-file-name "~/Downloads/original.mp3")))

Contributing
------------

If you find bugs, have suggestions or any other problems, feel free to
report an issue on the issue tracker or hit me up on IRC, I'm always on
``#emacs``.  Patches are welcome, too, just fork, work on a separate
branch and open a pull request with it.

FAQ
---

Q: Why is there an initial delay?

A: Emacs has `an image cache`_.  The first 12 frames are unique, the
subsequent ones are served from the image cache (until a resize change
happens).  You shouldn't see this though unless you're on a slow
computer or are *not* using the byte-compiled file.

Q: Will there be a widescreen version?

A: I've actually tried out doing such a thing by placing nyan cat
centered, filling the entire background with indigo and extending the
rainbow all the way to the left.  I couldn't figure out a good way to
generate the stars though that would both look good and loop, so I've
dropped support for that version.  Please contact me if you've got an
idea how to do better.

Q: I've found an error, but all Emacs says is that you were zoning out
when writing zone-nyan...

A: I don't know why, but zone bypasses regular Emacs error handling
and displays an useless message instead.  Use ``M-x
toggle-debug-on-error``, then ``M-: (zone-nyan-image 0)`` and paste
the resulting Backtrace on `Gist <https://gist.github.com/>`_.  In the
unlikely case that this doesn't yield a backtrace, switch to a buffer
you don't mind losing and use ``M-: (zone-nyan)`` in it.  Then open a
new bug report with a link to the backtrace plus further information
on your Emacs build, operating system, origin and version of
zone-nyan.

.. _an image cache: https://www.gnu.org/software/emacs/manual/html_node/elisp/Image-Cache.html
.. _nyan-mode: https://github.com/TeMPOraL/nyan-mode
