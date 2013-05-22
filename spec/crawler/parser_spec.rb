require 'spec_helper'

module Rumba::Crawler
  describe Parser do
    let(:parser) { Parser.new }

    describe '#process' do
      it "invokes parse_multi for Array template" do
        Nokogiri::HTML::Document.stub(parse: :parsed_doc)
        parser.should_receive(:parse_multi).with(:parsed_doc, 'games').and_return([:result])
        parser.process('<html><html>','["games"]').should eq [:result]
      end

      it "invokes parse_node for Object template" do
        Nokogiri::HTML::Document.stub(parse: :parsed_doc)
        parser.should_receive(:parse_node).with(:parsed_doc, {"game" => 123}, 'game').and_return(:result)
        parser.process('<html><html>','{"game": 123}').should eq :result
      end
    end

    describe '#parse_multi' do
      it "creates object for every matching HTML node" do
        parser.stub(get_node: [:node, :node])
        parser.should_receive(:create_object).with(:key, :node, :value).twice.and_return(:result)
        parser.parse_multi(:doc, {key: :value}).should eq [:result, :result]
      end
    end

    describe '#parse_node' do
      it "gets content for template leaf node" do
        parser.stub(get_node: [:node])
        parser.stub(leaf_node?: true)
        parser.should_receive(:get_content).with(:node, :template).and_return('some content')
        parser.parse_node(:doc, :template, :name).should eq 'some content'
      end
      it "creates object for template parent node" do
        parser.stub(get_node: [:node])
        parser.stub(leaf_node?: false)
        parser.should_receive(:create_object).with(:name, :node, :template).and_return(:object)
        parser.parse_node(:doc, :template, :name).should eq :object
      end
    end

    describe "#create_object" do
      it "creates an object" do
        parser.should_receive(:name).and_return(:object)
        parser.create_object(:name, :node, {'css' => 'body'}).should eq :object
      end
      it "invokes a setter with parse_multi method for object attributes with Array value" do
        object = double("object")
        object.should_receive(:name=).with(:result)
        parser.should_receive(:parse_multi).with(:node, 'attr').and_return(:result)
        parser.stub(game: object)
        parser.create_object(:game, :node, {'css' => 'body', 'name' => ['attr']})
      end
      it "invokes a setter with parse_node method for object other attributes" do
        object = double("object")
        object.should_receive(:name=).with(:result)
        parser.should_receive(:parse_node).with(:node, {"attr"=>"value"}, "name").and_return(:result)
        parser.stub(game: object)
        parser.create_object(:game, :node, {'css' => 'body', 'name' => {'attr' => 'value'}})
      end
    end

    describe "#get_content" do
      it "get node content" do
        node = double("node")
        node.should_receive(:content).and_return('some content')
        parser.get_content(node, {}).should eq 'some content'
      end
      it "uses provided regexp to extract content" do
        node = double("node")
        node.should_receive(:content).and_return('content123')
        parser.get_content(node, {'regexp' => '[a-z]+'}).should eq 'content'
      end
    end

    describe "#get_node" do
      it "uses css locator provided" do
        node = double("node")
        node.should_receive(:css).with('locator').and_return(:node)
        parser.get_node(node, {'css' => 'locator'}).should eq :node
      end
      it "uses shortcut css locator" do
        node = double("node")
        node.should_receive(:css).with('locator').and_return(:node)
        parser.get_node(node, 'locator').should eq :node
      end
    end

    describe "#leaf_node?" do
      it "identifies shortcut locator" do
        parser.leaf_node?('locator').should eq true
      end
      it "identifies non-service attributes" do
        parser.leaf_node?({'css' => 'locator'}).should eq true
        parser.leaf_node?({'name' => 'locator'}).should eq false
      end
    end
  end
end