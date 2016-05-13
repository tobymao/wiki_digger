require './spec/spec_helper'

describe Extractor::Page do
  let(:xml) { Ox.parse <<~XML
      <page>
        <title>AccessibleComputing</title>
        <ns>0</ns>
        <id>10</id>
        <redirect title="Computer accessibility" />
        <revision>
          <text xml:space="preserve">#REDIRECT [[Computer accessibility]]</text>
        </revision>
      </page>
    XML
  }

  describe '#extract_title' do
    it 'should find redirect' do
      title = subject.extract_title xml
      expect(title).to eq('computer accessibility')
    end
  end
end
