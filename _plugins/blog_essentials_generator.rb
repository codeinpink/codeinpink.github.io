module Jekyll
    class CategoryPage < Page
        def initialize(site, base, dir, category)
            @site = site
            @base = base
            @dir = dir
            @name = 'index.html'

            self.process(@name)
            self.read_yaml(File.join(base, '_layouts'), 'category.html')

            self.data['category'] = category
            self.data['title'] = "Category: #{category.capitalize}"
        end
    end

    class TagPage < Page
        def initialize(site, base, dir, tag)
            @site = site
            @base = base
            @dir = dir
            @name = 'index.html'

            self.process(@name)
            self.read_yaml(File.join(base, '_layouts'), 'tag.html')

            self.data['tag'] = tag
            self.data['title'] = "Tag: #{tag.capitalize}"
        end
    end

    class CategoryPageGenerator < Generator
        def generate(site)
            site.categories.each_key do |category|
                category_slug = category.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
                site.pages << CategoryPage.new(site, site.source, File.join('blog/categories', category_slug), category)
            end
        end

    end

    class TagPageGenerator < Generator
        def generate(site)
            site.tags.each_key do |tag|
                tag_slug = tag.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

                site.pages << TagPage.new(site, site.source, File.join('blog/tagged', tag_slug), tag)
            end
        end
    end

    module RegexFilter
        def replace_regex(input, reg_str, repl_str)
        re = Regexp.new reg_str

        # This will be returned
        input.gsub re, repl_str
        end
    end
end

Liquid::Template.register_filter(Jekyll::RegexFilter)
