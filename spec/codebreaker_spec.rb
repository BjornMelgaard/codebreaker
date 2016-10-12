require 'spec_helper'

module Codebreaker
  describe Game do
    let(:output) { double('output').as_null_object }
    let(:input)  { double('stdin').as_null_object }
    let(:game)   { Game.new(input, output) }

    describe '#secret_code' do
      subject { game.method :secret_code }
      it { expect(subject.call).to be_a_kind_of(String) }
      it { expect(subject.call.length).to eq(4) }
    end

    describe '#mark' do
      subject { game.method :mark }
      before { game.instance_variable_set(:@secret_code, '1234') }
      context 'with no matches' do
        let(:guess) { '0000' }
        it { expect(subject.call(guess).uncolorize).to eq('    ') }
      end
      context 'with 1 exact matches' do
        let(:guess) { '1000' }
        it { expect(subject.call(guess).uncolorize).to eq('+   ') }
      end
      context 'with 1 number matches' do
        let(:guess) { '0100' }
        it { expect(subject.call(guess).uncolorize).to eq(' -  ') }
      end
      context 'with 1 exact match and 1 number match' do
        let(:guess) { '1020' }
        it { expect(subject.call(guess).uncolorize).to eq('+ - ') }
      end
      context 'complex situation 1' do
        before { game.instance_variable_set(:@secret_code, '2165') }
        let(:guess) { '2131' }
        it { expect(subject.call(guess).uncolorize).to eq('++  ') }
      end
      context 'complex situation 2' do
        before { game.instance_variable_set(:@secret_code, '2165') }
        let(:guess) { '2126' }
        it { expect(subject.call(guess).uncolorize).to eq('++ -') }
      end
    end
  end
end
