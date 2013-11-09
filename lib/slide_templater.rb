class SlideTemplater
  attr_reader :slide_template, :page_template_string, :shortname

  def initialize(slide_template_string, page_template_string, shortname)
    @slide_template = slide_template_string
    @page_template = page_template_string
    @shortname = shortname
  end

  def process_keynote(keynote_obj)
    process_page(keynote_obj)
  end

  def process_slides(keynote_obj)
    # take the keynote obj, template up each slide, stick them in an array.
    output = []
    keynote_obj.slides.each_with_index do |s, i|
      eruby = Erubis::Eruby.new(@slide_template)
      notes = s.formatted_notes
      index = i
      shortname = @shortname
      templated = eruby.evaluate(:notes => s.formatted_notes,
                                 :index => i,
                                 :shortname => @shortname)
      output << templated 
    end
    # return the entire html
    output
  end

  def process_page(keynote_obj)
    all_slides = process_slides(keynote_obj).join("\n")
    eruby = Erubis::Eruby.new(@page_template)
    eruby.evaluate(:all_slides => all_slides)
  end
end