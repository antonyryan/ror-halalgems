require 'spec_helper'

describe PropertyPhoto do
    before do
      @photo = PropertyPhoto.new(listing_id: 1)
    end

    subject { @photo}

    it { should respond_to(:listing_id) }
    it { should respond_to(:photo_url) }
    it { should respond_to(:order_num) }
end
