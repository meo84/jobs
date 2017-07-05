require 'spec_helper'
require 'action'

RSpec.describe Action do

  before(:all) do
    ObjectSpace.garbage_collect
    @driver_action = Action.new(1, :driver, -3000)
    @owner_action = Action.new(1, :owner, 2100)
    @insurance_action = Action.new(1, :insurance, 300)
    @assistance_action = Action.new(1, :assistance, 500)
    @drivy_action = Action.new(1, :drivy, 100)
    @other_action = Action.new(2, :drivy, 300)
  end

  describe '#type' do
    it 'returns debit or credit based on action gain' do
      expect(@driver_action.type).to eq 'debit'
      expect(@owner_action.type).to eq 'credit'
    end
  end

  describe '#summary' do
    it 'summarises one action' do
      summary = {
        who: 'driver',
        type: 'debit',
        amount: 3000
      }
      expect(@driver_action.summary).to eq summary
    end
  end

  describe '.set' do
    it 'returns all actions for one rental' do
      set = [ @driver_action, @owner_action, @insurance_action, @assistance_action, @drivy_action ]
      expect(Action.set(1)).to eq set
    end
  end

  describe '.summary_for' do
    it 'summarises all actions for one rental' do
      summary = [
        @driver_action.summary,
        @owner_action.summary,
        @insurance_action.summary,
        @assistance_action.summary,
        @drivy_action.summary
      ]
      expect(Action.summary_for(1)).to eq summary
    end
  end

  describe '.add_gain' do
    it 'returns the delta between previous and new gain' do
      expect(@driver_action.add_gain(-2000)).to eq 1000
    end
  end
end
