require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe MembersController do

    it "/members/total" do
      bike = Bike.create! valid_attributes
      get :total
      expect(assigns(:bikes)).to eq([bike])
    end
  end


end
