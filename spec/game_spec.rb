require 'spec_helper'

module Codebreaker
  describe Game do
    let(:ui)    { UI.new }
    let(:store) { Store.new }
    let(:game) { Game.new(ui, store) }
    before do
      allow(ui).to receive(:puts)
    end

    describe '#secret_code' do
      subject { game.method :secret_code }
      it { expect(subject.call).to be_a_kind_of(String) }
      it { expect(subject.call.length).to eq(4) }
    end

    describe '#guess' do
      before do
        allow(game).to receive(:try_again?)
        game.instance_variable_set(:@secret_code, '1111')
      end

      context 'with overflowed attempts count and wrong guess' do
        before { game.instance_variable_set(:@attempts_count, 100) }
        it 'should call loose' do
          expect(game).to receive(:loose)
          game.guess('0000', 0)
        end
      end

      context 'with not overflowed attempts count and right guess' do
        before { game.instance_variable_set(:@attempts_count, 0) }
        it 'should call win' do
          expect(game).to receive(:win)
          game.guess('1111', 0)
        end
      end

      context 'with not overflowed attempts count and wrong guess' do
        before { game.instance_variable_set(:@attempts_count, 0) }
        it 'should change @attempts_count' do
          expect { game.guess('0000', 0) }.to \
            change { game.instance_variable_get(:@attempts_count) }.by(1)
        end
      end
    end
  end
end
