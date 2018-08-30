require 'spec_helper'
describe 'soge' do
  context 'with default values for all parameters' do
    it { should contain_class('soge') }
  end
end
