require 'rails_helper'

describe ManagerEmployee do
  before(:each) do
    @user = FactoryGirl.create(:spec_manager)
  end

  it 'does not allow manager to manage himself ' do
    m_e = ManagerEmployee.new(employee: @user, manager: @user)
    expect{m_e.save}.to raise_error
  end

end