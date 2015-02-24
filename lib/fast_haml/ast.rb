module FastHaml
  module Ast
    module LineCounter
      def initialize(*)
        super
        @trailing_empty_lines = 0
      end

      def trailing_empty_lines
        @trailing_empty_lines
      end

      def increment_trailing_empty_lines
        @trailing_empty_lines += 1
        nil
      end
    end

    module HasChildren
      def initialize(*)
        super
        self.children ||= []
      end

      def <<(ast)
        self.children << ast
      end
    end

    class Root < Struct.new(:children)
      include LineCounter
      include HasChildren
    end

    class Doctype < Struct.new(:doctype)
      include LineCounter
    end

    class Element < Struct.new(
      :children,
      :tag_name,
      :static_class,
      :static_id,
      :attributes,
      :oneline_child,
      :self_closing,
      :nuke_inner_whitespace,
      :nuke_outer_whitespace,
    )
      include LineCounter
      include HasChildren

      def initialize(*)
        super
        self.static_class ||= ''
        self.static_id ||= ''
        self.attributes ||= ''
        self.self_closing ||= false
        self.nuke_inner_whitespace ||= false
        self.nuke_outer_whitespace ||= false
      end
    end

    class Script < Struct.new(
      :children,
      :script,
      :escape_html,
      :preserve,
      :mid_block_keyword,
    )
      include LineCounter
      include HasChildren

      def initialize(*)
        super
        if self.escape_html.nil?
          self.escape_html = true
        end
        if self.preserve.nil?
          self.preserve = false
        end
        if self.mid_block_keyword.nil?
          self.mid_block_keyword = false
        end
      end
    end

    class SilentScript < Struct.new(:children, :script, :mid_block_keyword)
      include LineCounter
      include HasChildren

      def initialize(*)
        super
        if self.mid_block_keyword.nil?
          self.mid_block_keyword = false
        end
      end
    end

    class HtmlComment < Struct.new(:children, :comment, :conditional)
      include LineCounter
      include HasChildren

      def initialize(*)
        super
        self.comment ||= ''
        self.conditional ||= ''
      end
    end

    class HamlComment < Struct.new(:children)
      include LineCounter
      include HasChildren
    end

    class Text < Struct.new(:text, :escape_html)
      include LineCounter

      def initialize(*)
        super
        if self.escape_html.nil?
          self.escape_html = true
        end
      end
    end

    class Filter < Struct.new(:name, :texts)
      include LineCounter

      def initialize(*)
        super
        self.texts ||= []
      end
    end
  end
end
