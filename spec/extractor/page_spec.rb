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

  describe '#title_map' do
    it 'should map title to redirect title' do
      title = subject.title_map xml
      expect(title).to eq([10, 'accessible computing', 'computer accessibility'])
    end
  end
end
