require 'spec_helper'
describe 'takipi' do

  context 'with defaults for all parameters' do
    it { should contain_class('takipi') }
  end
end
