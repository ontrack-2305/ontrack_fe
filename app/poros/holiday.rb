class Holiday
  attr_reader :name, :date

  def initialize(params)
    @name = params[:name]
    @date = params[:date]
  end
end