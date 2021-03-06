module Rumba
  module Crawler
    class Parser
      include Rumba::Crawler::Models
      # Service Keys
      SK = ['css', 'root', 'regexp']

      def process(response, template)
        template = JSON.parse(template)
        @doc = Nokogiri::HTML(response)
        if template.is_a? Array
          parse_multi(@doc, template.first)
        else
          parse_node(@doc, template, template.keys.first)
        end
      end

      def parse_multi(doc, template)
        result = []
        template.each do |key, value|
          get_node(doc, value).each do |node|
            result << create_object(key, node, value)
          end
        end
        return result
      end

      def parse_node(doc, template, name)
        node = get_node(doc, template).first
        if leaf_node?(template)
          get_content(node, template)
        else
          create_object(name, node, template)
        end
      end

      def create_object(name, node, template)
        object = send(name)
        template.reject{|key, _| SK.include?(key)}.each do |key, value|
          if value.is_a? Array
            object.send("#{key}=", parse_multi(node, value.first))
          else
            object.send("#{key}=", parse_node(node, value, key))
          end
        end
        return object
      end

      def get_content(node, template)
        if template['regexp']
          /#{template['regexp']}/i.match(node.content).to_s
        else
          node.content
        end
      end

      def get_node(doc, template)
        if template.is_a?(String)
          doc.css(template)
        elsif template['root']
          @doc.css(template['root']).css(template['css'])
        else
          doc.css(template['css'])
        end
      end

      def leaf_node?(template)
        template.is_a?(String) || template.reject{|key, _| SK.include?(key)}.empty?
      end
    end
  end
end