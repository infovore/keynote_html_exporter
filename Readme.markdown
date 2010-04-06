keynote_dump.rb
===============

keynote_dump.rb is a script to quickly and dynamically export Keynote presentations to templated HTML. It exports one presentation to one page (at the moment).

Dependencies
------------

keynote_dump.rb requires RubyOSA (http://rubyosa.rubyforge.org/) to talk to Keynote, and uses ERB (http://ruby-doc.org/stdlib/libdoc/erb/rdoc/classes/ERB.html) for its templating.

In addition, if you wish to dynamically resize slide images, you'll need ImageMagick and RMagick (http://rmagick.rubyforge.org/) installed.

Usage
-----

From your commandline:

keynote_dump.rb shortname_for_slides template_file [imagemagick_resize_ratio]

...which is a bit cryptic. It's best explained with a walkthrough.

Firstly, to **just export the slides to an HTML template**

1. Make sure you have a suitable ERB template for your presentation page in the keynote_dump.rb directory; use `sample-template.html.erb` as a guideline.
2. Decided on a shortname for your presentation - for instance, "my_presentation"
3. Make a directory inside your keynote_dump.rb directory called my_presentation
4. Open Keynote, and make sure the presentation you wish to export is the only presentation open.
5. Open terminal, navigate to your keynote_dump.rb directory, and run `ruby keynote_dump.rb my_presentation sample-template.html.erb` (or whatever your template file is called).
6. When the script has completed, your presentation page will be at `my_presentation/my_presentation.html`

**To export the slides and resize them**, the process is a little more complex:

1. Make sure you have a suitable ERB template for your presentation page in the keynote_dump.rb directory; use `sample-template.html.erb` as a guideline.
2. Decided on a shortname for your presentation - for instance, "my_presentation"
3. Make a directory inside your keynote_dump.rb directory called my_presentation
4. Open Keynote, and make sure the presentation you wish to export is the only presentation open.
5. Go to File->Export...
6. Choose "Images", "All", "PNG", and click "Next"
7. Navigate to the `my_presentation` directory you created. Enter `my_presentation` as the name to Save As. This will output a series of PNGs with names like `my_presentation.001.png` to `my_presentation/`
8. Open terminal, navigate to your keynote_dump.rb directory, and run `ruby keynote_dump.rb my_presentation sample-template.html.erb 300x225`, substituting your template file's name, and the `width`x`height` you would like your slides to be resized to.
9. When the script has completed, your presentation page will be at `my_presentation/my_presentation.html`; all the slides in that directory will be resized.
