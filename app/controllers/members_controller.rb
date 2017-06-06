class MembersController < ApplicationController

  def total
    render json: MemberCount.json_for_total
  end

  def worklounge
  end

  def fixed
  end

  def flex
  end
end
