
module GosuWrapper::Constructors::Window
  def self.new
    Class.new(Gosu::Window) do
      def initialize(width:, height:, caption:)
        super(width, height)
        self.caption = caption
      end
    end
  end
end
