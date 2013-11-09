class KeynoteProcessor
  include Appscript
  attr_reader :slides, :app

  def initialize(app_name)
    @app = Appscript.app(app_name)
    @slides = []
  end

  def ingest!
    app.slideshows.get.first.slides.get.each do |s|
      slide = Slide.new(s.notes.get)
      @slides << slide
    end
  end
end