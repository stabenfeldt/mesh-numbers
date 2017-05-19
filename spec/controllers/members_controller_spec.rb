require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe MembersController do

    it "/members/total" do
      get :total
			expect(response).to be_success
    end
  end


end
