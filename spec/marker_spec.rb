require 'spec_helper'

module Codebreaker
  describe Marker do
    context 'with no matches' do
      let(:marker) { Marker.new('0000', '1234') }
      it { expect(marker.output).to eq('    ') }
      it { expect(marker.success_count).to eq(0) }
    end
    context 'with 1 exact matches' do
      let(:marker) { Marker.new('1000', '1234') }
      it { expect(marker.output).to eq('+   ') }
      it { expect(marker.success_count).to eq(1) }
    end
    context 'with 1 number matches' do
      let(:marker) { Marker.new('0100', '1234') }
      it { expect(marker.output).to eq(' -  ') }
      it { expect(marker.success_count).to eq(0) }
    end
    context 'with 1 exact match and 1 number match' do
      let(:marker) { Marker.new('1020', '1234') }
      it { expect(marker.output).to eq('+ - ') }
      it { expect(marker.success_count).to eq(1) }
    end
    context 'complex situation 1' do
      let(:marker) { Marker.new('2131', '2165') }
      it { expect(marker.output).to eq('++  ') }
      it { expect(marker.success_count).to eq(2) }
    end
    context 'complex situation 2' do
      let(:marker) { Marker.new('2126', '2165') }
      it { expect(marker.output).to eq('++ -') }
      it { expect(marker.success_count).to eq(2) }
    end
    context 'complex situation 3' do
      let(:marker) { Marker.new('1234', '1243') }
      it { expect(marker.output).to eq('++--') }
      it { expect(marker.success_count).to eq(2) }
    end
  end
end
