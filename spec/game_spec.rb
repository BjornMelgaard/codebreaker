require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) { Game.new }

    describe '#secret_code' do
      subject { game.instance_variable_get :@secret }
      it { expect(subject).to be_a_kind_of(String) }
      it { expect(subject.length).to eq(4) }
    end

    describe '#guess' do
      before do
        game.instance_variable_set(:@secret, '1111')
      end

      it 'don\'t execute if no attempts left' do
        game.instance_variable_set(:@attempts_left, 0)
        expect(game.guess('0000')).to be_nil
      end
    end
  end
end
