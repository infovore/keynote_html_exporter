keynote_dump.rb
===============

`keynote_dump.rb` is a script to quickly and dynamically export Keynote presentations - and, specifically, the notes on each slide - to templated HTML pages. It exports one presentation to one page (at the moment).

Dependencies
------------

Dependencies are handled via bundler. `bundle` should install everything you need. If you'd like more details:

keynote_dump.rb uses rb-appscript [http://appscript.sourceforge.net/rb-appscript/index.html] to talk to Keynote, and uses Erubis [http://www.kuwata-lab.com/erubis/] for its templating.

In addition, if you wish to dynamically resize slide images, Minimagick/RMagick [https://github.com/minimagick/minimagick] are used.

Note that `keynote_dump.rb` is for **Keynote '09**; it has **not** been verified to work with Keynote 2013; given the commentary on Applescript support for Keynote 2013, it feels unlikely it'll work.

Usage
-----

From your commandline:

	keynote_dump.rb shortname_for_slides slide_template_file page_template_file [imagemagick_resize_ratio]

...which is a bit cryptic. It's best explained with a walkthrough.

Firstly, to **just export the slides to an HTML template**

1. Make sure you have a suitable ERB template for your presentation page in the keynote_dump.rb directory; use `sample-page-template.html.erb` as a guideline. This represents the whole page.
1. Then, make a template for an _individual slide_. Use
   `sample-slide-template.html.erb` as an example.
2. Decided on a shortname for your presentation - for instance, "my_presentation"
3. Make a directory inside your keynote_dump.rb directory called my_presentation
4. Open Keynote, and make sure the presentation you wish to export is the only presentation open.
5. Open terminal, navigate to your keynote_dump.rb directory, and run `ruby keynote_dump.rb my_presentation sample-slide-template.html.erb sample-page-template.html.erb` (or whatever your template files are called).
6. When the script has completed, your presentation page will be at `my_presentation/my_presentation.html`

**To export the slides and resize them**, the process is a little more complex:

1. Make sure you have a suitable ERB template for your presentation page in the keynote_dump.rb directory; use `sample-template.html.erb` as a guideline.
2. Decided on a shortname for your presentation - for instance, "my_presentation"
3. Make a directory inside your keynote_dump.rb directory called my_presentation
4. Open Keynote, and make sure the presentation you wish to export is the only presentation open.
5. Go to File->Export...
6. Choose "Images", "All", "PNG", and click "Next"
7. Navigate to the `my_presentation` directory you created. Create a new folder called `img` and enter that. Enter `my_presentation` as the name to Save As. This will output a series of PNGs with names like `my_presentation.001.png` to `my_presentation/`
8. Open terminal, navigate to your keynote_dump.rb directory, and run `ruby keynote_dump.rb my_presentation sample-template.html.erb 300x225`, substituting your template file's name, and the `width`x`height` you would like your slides to be resized to. (Valid `mogrify` aspect ratios, such as `500x`, will also work).
9. When the script has completed, your presentation page will be at `my_presentation/my_presentation.html`; all the slides in that directory will be resized.
