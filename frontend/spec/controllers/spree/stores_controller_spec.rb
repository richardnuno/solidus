require 'spec_helper'

describe Spree::StoreController do

  controller(Spree::StoreController) do
    def index
      render text: 'test'
    end
  end

  describe 'disabling frontend' do
    subject do
      request
      response.status
    end

    let(:request) { get :index }

    context 'when enabled' do
      it { should == 200 }
    end

    context 'when disabled' do
      before { Spree::Frontend::Config[:enabled] = false }
      after  { Spree::Frontend::Config[:enabled] = true }

      it { should == 404 }
    end
  end
end
