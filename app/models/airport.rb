class Airport < ActiveRecord::Base
  def as_json(options={})
    super(:except => [:id])
  end
end
