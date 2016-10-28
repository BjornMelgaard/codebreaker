require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) { Game.new }

    describe '#guess' do
      before do
        game.instance_variable_set(:@secret, '1234')
      end

      it 'should iterate game' do
        game.guess('1043')
        expect(game.win?).to be   false
        expect(game.loose?).to be false
        expect(game.ended?).to be false
      end

      it 'set win state' do
        game.guess('1234')
        expect(game.win?).to be   true
        expect(game.loose?).to be false
        expect(game.ended?).to be true
      end

      it 'set loose state' do
        game.instance_variable_set(:@attempts_left, 0)
        game.guess('0000')
        expect(game.win?).to be   false
        expect(game.loose?).to be true
        expect(game.ended?).to be true
      end
    end

    it '#secret_code should show secret only if game ended' do
      expect(game.secret_code).to be nil
      allow(game).to receive(:ended?).and_return true
      expect(game.secret_code).to be_a_kind_of(String)
      expect(game.secret_code.length).to eq(4)
    end
  end
end
